################################################################################
# Created on:  June 01, 2006
# Package:     HoneyClient::Agent
# File:        Integrity.pm
# Description: Module for checking the system integrity for possible
#              modifications.
#
# @author knwang, xkovah, ttruong
#
# Copyright (C) 2006 The MITRE Corporation.  All rights reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, using version 2
# of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
################################################################################

=pod

=head1 NAME

HoneyClient::Agent::Integrity - Responsible for performing static integrity 
checks on the filesystem and registry. (Additionally it calls an external module 
which is responsible for performing real-time checking for new processes which
are created.

=head1 VERSION

0.94

=head1 SYNOPSIS

=head2 INITIALIZATION

In order to properly check the system, a snapshot must be taken of a known-good
state.

For the filesystem this means a listing is created which contains 
cryptographic hashes of files in their start state. The only files what are 
checked are those which are explicitly specified in the checklist file (or are 
found in a specified directory) and are not in the exclusion list will be checked.
Initialization of the filesystem is done with the initFileSystem() function, 
described later.

For the registry a similar logic applies in that the only the specified keys are
checked and only if they are not in the exclusion list. The desired registry keys
are exported to a text file via the command line functionality of regedit. This
is done via initRegistry().


=head2 CHECKING

Checking the filesystem entails running mostly the same code as the initialization
piece in order to obtain a snapshot of the current state of the filesystem. At that 
point additional checks are performed to look for additions, deletions, and 
modifications to the filesystem. These checks are done with checkFileSystem().

A speed-optimized check of the registry is performed by first dumping the current
state, again with the command line version of regedit. Then the unix "diff"
utility is used to compare the clean registry dump to the current one. The output
from a diff is in a format which shows the minimum possible changes which can be
done to the first file in order to yield the same content as the second file. 
Therefore this format must be parsed in order to determine what specific additions,
deletions, and modifications were made to the clean registry. Further, because 
the output of diff need not exactly reflect changes (for instance when the same
content would be the first line of the previous value and the last line of the new 
value) this requires some cases to re-consult the original and current state in order 
to disambiguate the changes which were made. These tests are done in checkRegistry().

NOTE: Because these are simple, static, user-space checks, they can fail in the 
presense of even user-space rootkits. Therefore these checks should not be taken as 
definitive proof of the absense of malicious software until they are integrated more
tightly with the system.

=cut

package HoneyClient::Agent::Integrity;

use strict;
use warnings;
use Carp ();

=pod

=begin testing

# Make sure HoneyClient::Agent::Integrity loads.
BEGIN { use_ok('HoneyClient::Agent::Integrity', qw(initAll checkAll initRegistry checkRegistry initFileSystem checkFileSystem)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent::Integrity');
#can_ok('HoneyClient::Agent::Integrity', 'new');
can_ok('HoneyClient::Agent::Integrity', 'initAll');
can_ok('HoneyClient::Agent::Integrity', 'checkAll');
can_ok('HoneyClient::Agent::Integrity', 'initFileSystem');
can_ok('HoneyClient::Agent::Integrity', 'checkFileSystem');
use HoneyClient::Agent::Integrity qw(initAll checkAll initFileSystem checkFileSystem);

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure File::Find loads.
BEGIN { use_ok('File::Find', qw(find)) or diag("Can't load File::Find package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Find');
can_ok('File::Find', 'find');
use File::Find;

# Make sure Digest::MD5 loads.
#BEGIN { use_ok('Digest::MD5', qw(new)) or diag("Can't load Digest::MD5 package.  Check to make sure the package library is correctly listed within the path."); }
#require_ok('Digest::MD5');
#use Digest::MD5;

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(dclone nfreeze thaw)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
use Storable qw(dclone nfreeze thaw);

###Testing Globals###
# Directory where the known-good test files are stored
$test_dir = getVar(name => "test_dir");

# List of files and directories to check during filesystem checking
$file_checklist = getVar(name => "file_checklist");

# List of files or directories to exclude if found in subdirs during
# filesystem check.
$file_exclude = getVar(name => "file_exclude");

# File where found changes are written to
$change_file = getVar(name => "change_file");

=end testing

=cut

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);
use HoneyClient::Agent::Integrity::Registry;
use File::Find qw(find);
#use Win32::TieRegistry;
use Digest::MD5;
use MIME::Base64;
use Storable qw(nfreeze thaw dclone);
$Storable::Deparse = 1;
$Storable::Eval = 1;
use Data::Dumper;
use File::Basename qw(dirname);

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION);

    # Set our package version.
    $VERSION = 0.94;

    @ISA = qw(Exporter);

    # Symbols to export on request
    @EXPORT = qw(new initAll checkAll);

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # Symbols to autoexport (:DEFAULT tag)
    @EXPORT_OK = qw(initAll checkAll);

}
our (@EXPORT_OK, $VERSION);



#####################
# GLOBALS
#####################

# Package Global Variable
our $AUTOLOAD;

# These two hack variables are necessary currently in order to get values back 
# out of the functions used with the find() function from File::Find. I can
# not pass in/out the current object, so these get around that by making a 
# global copy.
my $g_hack;
my $g_ex_hash;

#Used *for now* to signal whether any changes occured (if they == 1)
my $g_fs_changes = 0;

# XXX: All dirs must NEVER end in a trailing slash.
my @default_file_exclude_array = (
    '/cygdrive/c/cygwin/tmp/changes.txt',
    '/cygdrive/c/cygwin/tmp/cleanfile.txt',
    '/cygdrive/c/cygwin/home/Administrator',
    '/cygdrive/c/Documents and Settings/Administrator/Desktop/honeyclient',
    '/cygdrive/c/WINDOWS/Prefetch',
    '/cygdrive/c/WINDOWS/WindowsUpdate.log',
    '/cygdrive/c/WINDOWS/Debug/UserMode/userenv.log',
    '/cygdrive/c/WINDOWS/SoftwareDistribution/DataStore',
    '/cygdrive/c/WINDOWS/SchedLgU.Txt',
    '/cygdrive/c/WINDOWS/SoftwareDistribution/ReportingEvents.log',
    '/cygdrive/c/WINDOWS/system32/config/SysEvent.Evt',
    '/cygdrive/c/WINDOWS/system32/wbem',
    '/cygdrive/c/WINDOWS/PCHEALTH/HELPCTR/DataColl',
    '/cygdrive/c/Documents and Settings/All Users/Application Data/Microsoft/Network/Downloader',
    '/cygdrive/c/Documents and Settings/Administrator/Application Data/Mozilla/Firefox/Profiles',
    '/cygdrive/c/Documents and Settings/Administrator/Local Settings/Application Data/Mozilla/Firefox/Profiles',
    '/cygdrive/c/Documents and Settings/Administrator/Application Data/Talkback/MozillaOrg/Firefox15/Win32/2006050817/permdata.box',
    '/cygdrive/c/Documents and Settings/Administrator/Cookies/index.dat',
    '/cygdrive/c/Documents and Settings/Administrator/Local Settings/History/History.IE5',
    '/cygdrive/c/Documents and Settings/Administrator/Local Settings/Temporary Internet Files/Content.IE5',
    '/cygdrive/c/Documents and Settings/Administrator/Recent',
    '/cygdrive/c/Program Files/Mozilla Firefox/updates',
    '/cygdrive/c/Program Files/Mozilla Firefox/active-update.xml',
    '/cygdrive/c/Program Files/Mozilla Firefox/updates.xml',
    '/cygdrive/c/WINDOWS/SoftwareDistribution/WuRedir',
    '/cygdrive/c/WINDOWS/SYSTEM32/config/SecEvent.Evt',
    '/cygdrive/c/WINDOWS/SYSTEM32/config/SysEvent.Evt',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/INDEX.BTR',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/INDEX.MAP',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/MAPPING.VER',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/MAPPING1.MAP',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/MAPPING2.MAP',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/OBJECTS.DATA',
    '/cygdrive/c/WINDOWS/SYSTEM32/wbem/Repository/FS/OBJECTS.MAP',
);


my %PARAMS = (

    # Contains the Registry object, once initialized.
    _registry => undef,

    # XXX: Clean the rest of these variables up.
    ### Files which are read in only ###
    # List of files and directories to check during filesystem checking
    file_checklist => getVar(name => "file_checklist", namespace => "HoneyClient::Agent::Integrity"),
	
	# List of files or directories to exclude if found in subdirs during
	# filesystem check.
    file_exclude => getVar(name => "file_exclude", namespace => "HoneyClient::Agent::Integrity"),
	
	### Files to write and read ###
	# File to store hashes for files selected during the baseline
    clean_file => getVar(name => "clean_file", namespace => "HoneyClient::Agent::Integrity"),
	
	# File to write any found changes to
    change_file => getVar(name => "change_file", namespace => "HoneyClient::Agent::Integrity"),
	
	#vars
    file_exclude_hash => undef, #hash, holds files to exclude
    file_list => undef,	#list, files to check when checking filesystem
	
	#works exactly like the reg_exclude_array, and is initialized in a similar way
    file_exclude_array => undef,

    changes => undef,	#multi-dimensional array used for holding individual instances of a diff output
);




################################################################################

=pod

=head1 EXPORTED FUNCTIONS

new() : Creates a new Integrity object.

=cut

sub new {
    # - This function takes in an optional hashtable,
    #   that contains various key => 'value' configuration
    #   parameters.
    #
    # - For each parameter given, it overwrites any corresponding
    #   parameters specified within the default hashtable, %PARAMS, 
    #   with custom entries that were given as parameters.
    #
    # - Finally, it returns a blessed instance of the
    #   merged hashtable, as an 'object'.

    # Get the class name.
    my $self = shift;

    # Get the rest of the arguments, as a hashtable.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my %args = @_;

    # Check to see if the class name is inherited or defined.
    my $class = ref($self) || $self;

    # Initialize default parameters.
    $self = { };
    my %params = %{dclone(\%PARAMS)};
    @{$self}{keys %params} = values %params;

    # Now, overwrite any default parameters that were redefined
    # in the supplied arguments.
    @{$self}{keys %args} = values %args;

    # Now, assign our object the appropriate namespace.
    bless $self, $class;

    # Finally, return the blessed object.
    return $self;
}

################################################################################

=pod

=head1 

initAll() : Takes no input, runs all current init functions.

=cut

sub initAll {
    my $self = shift;
    # XXX: initRegistry() MUST be called before initFileSystem, since initRegistry
    # creates new files that must exist to be added to the exclusion list for
    # initFileSystem.
	$self->{'_registry'} = HoneyClient::Agent::Integrity::Registry->new();
	$self->initFileSystem();
}

################################################################################

=pod

=head1 

checkAll() : Takes no input, runs all current check functions.

=cut

sub checkAll {
    my $self = shift;
    my $retval;

	# If at all possible we want the (faster) registry checks to short circut
	# the overall checks so we don't have to do the very slow filesystem checks.
	my $changes = $self->{'_registry'}->check();
    if (scalar(@{$changes})) {
        print "Registry has changed:\n";
        foreach my $change (@{$changes}) {
            print $change->{'key'} . " (" . $change->{'status'} . ")\n";
        }
		open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file}: $!\n";		
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 1;
        print CHANGES Dumper($changes);
        close CHANGES;
        return $changes;
    }
    print "No registry changes have occurred.\n";
    $retval = $self->checkFileSystem();

	return $retval;
}

# TODO: Comment this.
sub serialize {
    my $self = shift;

    if (defined($self->{'_registry'})) {
        $self->{'_registry'}->closeFiles();
    }

    return nfreeze($self);
}

################################################################################

=pod

=head1

initFileSystem() : Takes no input, however it expects certain files to exist. 
In particular it will not run unless there is a file checklist created, 
containing a one-per-line list of files and directories to check. It
will automatically find all files in the specified directories as well as all 
sub-directories. This file should be named as defined by $self->{file_checklist}. 

Optionally there can be specified another file which lists files or subdirectories
which should be excluded from checks (for instance log files which are known to
change frequently). This file should be named as defined by $self->{file_exclude}.

=begin testing

#Testing initFileSystem();

my $ob = HoneyClient::Agent::Integrity->new();

system("mkdir /tmp/hc_test_dir");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/hi.txt > $file_checklist");
system("echo /tmp/hc_test_dir/hi.txt > $file_exclude");
$ob->initFileSystem();
open (FILE, "cleanfile.txt") or die "Can't check the cleanfile.txt\n";
@result = <FILE>;
close FILE;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initFileSystem: Explicit Filesystem Omission');

system("rm $file_exclude");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/hi.txt > $file_checklist");
system("echo /tmp/hc_test_dir/ > $file_exclude");
$ob->initFileSystem();
open (FILE, "cleanfile.txt") or die "Can't check the cleanfile.txt\n";
@result = <FILE>;
close FILE;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initFileSystem: Directory Filesystem Omission');

system("rm $file_exclude");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/hi.txt > $file_checklist");
$ob->initFileSystem();
open (DIFF, "diff $test_dir/fs1.txt cleanfile.txt |") or die "Can't check the cleanfile.txt\n";
@result = <DIFF>;
close DIFF;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initFileSystem: Known-good file hash');

system("rm -rf /tmp/hc_test_dir/");
system("rm $file_checklist");

=end testing

=cut

sub initFileSystem {
	# Get the object state.
	my $self = shift;
	$g_hack = $self->{file_list};
	$g_ex_hash = ();
    my $file;
	
	my @checkdirs = $self->_get_directories_to_check();
	my @exclude_dirs = ();

	
	if(-e $self->{file_exclude}){
		open EXCLUDE, "$self->{file_exclude}" or die "Can't open $self->{file_exclude} in initFileSystem()\n";
		@{$self->{file_exclude_array}} = <EXCLUDE>;
		close EXCLUDE;
	}
	else{
		#use the defaults
		$self->{file_exclude_array} = \@default_file_exclude_array;
	}

    $/ = "\n";
	foreach $file (@{$self->{file_exclude_array}}){
		chomp $file;
		if(-f $file){
			print "excluding $file\n";
			$g_ex_hash->{$file} = 1;	#used in lieu of the $self->file_exclude_hash
								# because you can't get to that in _found()
		}
        elsif(-d $file){
			print "excluding $file\n";
			$g_ex_hash->{$file} = 1;	#used in lieu of the $self->file_exclude_hash
			#find (\&_recursive_exclude, $file);
		}
		else{
			#XXX: Does this case matter(exist?) for pipes for instance?
			print "A file that isn't a file or directory (or just general problem, or the file just isn't there) was found with file: $file\n";
		}
	}

	print "Finding Files in initFileSystem...Be Patient.\n";
	foreach my $checkdir (@checkdirs) {
		find (\&_found, "$checkdir");	#this will populate @{$self->{file_list}}
	}

	$self->{file_list} = $g_hack;
	$self->{file_exclude_hash} = $g_ex_hash;
##	print "file_exclude_hash in init\n" . Dumper($self->{file_exclude_hash}) . "\n";

	print "Hashing Files in initFileSystem...Be Patient\n";
	open CLEANFILE, ">$self->{clean_file}" or die "Cannot open $self->{clean_file}: $!\n";
	foreach $file (@{$self->{file_list}}) {
#		print "hashing $file\n";
		if(open HASHFILE, "$file") {
			my $md5ctx = Digest::MD5->new();
            # If this call fails, an exception will be generated.
			$md5ctx->addfile(*HASHFILE);
			my $md5string = $md5ctx->hexdigest();
			#print "writing $file:$md5string\n";
			print CLEANFILE "$file:$md5string\n";
			close HASHFILE;
		}
		else{
			print "died trying to open $file\n";
		}
	}
	close CLEANFILE;

}

################################################################################

=pod

=head1

checkFileSystem() : Takes no input, but requires the file name by $self->{file_checklist} 
to exist, as well as and optional $self->{file_exclude} if it existed at the time 
initFileSystem() was called. Will detect any additions, deletions, or modifications
which occured in the filesystem.

=begin testing

#Testing that checkFileSystem()

my $ob = HoneyClient::Agent::Integrity->new();
my @result;

#add
system("rm $change_file");
system("mkdir /tmp/hc_test_dir/");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/ > $file_checklist");
$ob->initFileSystem();
system("echo hi > /tmp/hc_test_dir/hi2.txt");
$ob->checkFileSystem();
open(CHECK, "diff $test_dir/fs2.txt $change_file |") or die "There was a problem doing the fs2.txt diff"; 
#XXX Won't the die statement just be masked by the redirection of stdout/stderr?
@result = <CHECK>;
close(CHECK);
is(scalar(@result), 0, "checkFileSystem: Files added");


#delete
system("rm $change_file");
system("rm /tmp/hc_test_dir/hi.txt");
$ob->checkFileSystem();
open(CHECK, "diff $test_dir/fs3.txt $change_file |") or die "There was a problem doing the fs2.txt diff"; 
#XXX Won't the die statement just be masked by the redirection of stdout/stderr?
@result = <CHECK>;
close(CHECK);
is(scalar(@result), 0, "checkFileSystem: Files deleted");

#change
system("rm $change_file");
system("echo again >> /tmp/hc_test_dir/hi.txt");
$ob->checkFileSystem();
open(CHECK, "diff $test_dir/fs4.txt $change_file |") or die "There was a problem doing the fs2.txt diff"; 
#XXX Won't the die statement just be masked by the redirection of stdout/stderr?
@result = <CHECK>;
close(CHECK);
is(scalar(@result), 0, "checkFileSystem: Files changed");

system("rm -rf /tmp/hc_test_dir/");
system("rm $file_checklist");

=end testing

=cut

sub checkFileSystem {

    my $self = shift;	#Object
    %{$self->{clean_file_hash}} = ();
    %{$self->{changed_file_hash}} = ();
    my %current_file_hash = ();
    my %new_file_hash = ();
    my %del_file_hash = ();
    my @checkdirs;
    my $standalone_test = 0;
    my $file;
    my $key;

###	print "file_exclude_hash in check\n" . Dumper($self->{file_exclude_hash}) . "\n";


	if($standalone_test){
		$g_hack = $self->{file_list};
	}
	#open file to create hash of values for clean files
	open CLEANFILE, "$self->{clean_file}" or die "Cannot open $self->{clean_file}: $!\n";
    $/ = "\n";
	while(<CLEANFILE>) {
		my $line = $_;
		chomp($line);
		if($line =~ /(.+):(\w+)/) {
			$self->{clean_file_hash}->{$1} = $2;
		} else {
			print "Malformed line in $self->{clean_file}: $line\n";
		}
	}
	close CLEANFILE;

	@checkdirs = $self->_get_directories_to_check();

	# NOTE: Unfortunately I now believe that because of the nature
	# of some of the directories which we are checking, we need to
	# re-create this list of excluded files each time. This is because
	# otherwise we can not prevent it from thinking that files added
	# to those directories were added, because they did not exist 
	# at the time the exclusion list was created.

	# NOTE: This will hopefully be fixed when we add regular expression
	# support for both checking files and excluding files


	#************ FOR STANDALONE METHOD TESTING ONLY
	if($standalone_test){
		if(-e $self->{file_exclude}){
			open EXCLUDE, "$self->{file_exclude}" or die "Can't open $self->{file_exclude} in initFileSystem()\n";
			@{$self->{file_exclude_array}} = <EXCLUDE>;
			close EXCLUDE;
		}
		else{
			#use the defaults
			$self->{file_exclude_array} = \@default_file_exclude_array;
		}
	
        $/ = "\n";
		foreach $file (@{$self->{file_exclude_array}}){
			chomp $file;
			if(-f $file){
				print "excluding $file\n";
				$g_ex_hash->{$file} = 1;	#used in lieu of the $self->file_exclude_hash
									# because you can't get to that in _found()
			}
			else { if(-d  $file){
					find (\&_recursive_exclude, $file);
				}
				else{
					#XXX: Does this case matter(exist?) for pipes for instance?
					print "A file that isn't a file or directory (or just general problem, or the file just isn't there) was found with file: $file\n";
				}
			}
		}
	}
	#**************

	print "Finding Files in checkFileSystem...Be Patient\n";
	@{$g_hack} = ();
	foreach my $checkdir(@checkdirs) {
		find (\&_found, "$checkdir");
	}
	
	$self->{file_list} = $g_hack;

	#iterate through hash checking current files against previous files
	#also detects new files
	print "Hashing Files in checkFileSystem...Be Patient\n";
	foreach $file (@{$self->{file_list}}) {
		if(open HASHFILE, "$file") {
			my $md5ctx = Digest::MD5->new();
            # If this call fails, an exception will be generated.
			$md5ctx->addfile(*HASHFILE);
			close HASHFILE;
			$current_file_hash{$file} = $md5ctx->hexdigest();
			if($self->{clean_file_hash}->{$file}) {
				if($self->{clean_file_hash}->{$file} ne $current_file_hash{$file}) {
					$self->{changed_file_hash}->{$file} = $current_file_hash{$file};
				}
			} else {
				$new_file_hash{$file} = $current_file_hash{$file};
			}
		}
	}

	#check for deleted files
	foreach $key (keys %{$self->{clean_file_hash}}) {
		if(!($current_file_hash{$key})) {
			$del_file_hash{$key} = $self->{clean_file_hash}->{$key};
		}
	}

	if((scalar(keys %del_file_hash) > 0) ||
		(scalar(keys %new_file_hash) > 0) ||
		(scalar(keys %{$self->{changed_file_hash}}) > 0)) {
		open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file}: $!\n";		

		print CHANGES "Files deleted:\n";
		foreach $key (sort keys %del_file_hash) {
			print CHANGES "$key\n";
		}
		print CHANGES "\n\n";
		print CHANGES "Files added:\n";
		foreach $key (sort keys %new_file_hash) {
			print CHANGES "$key\n";
		}
		print CHANGES "\n\n";
		print CHANGES "Files modified:\n";
		foreach $key (sort keys %{$self->{changed_file_hash}}) {
			print CHANGES "$key\n";
		}
		print CHANGES "\n\n";
		$g_fs_changes = 1;
		close CHANGES;

		print "Changes detected in the filesystem. Written to $self->{change_file}\n";
	}
	else{
		print "No changes detected in the filesystem\n";
	}
	return $g_fs_changes;

}

################################################################################

sub _get_directories_to_check(){
my $self = shift;
my @checkdirs;

	#Sets the VERY hardcoded default for now (late addition for ease of use, not clean code)
    push @checkdirs, "/cygdrive/c/";

	#Can override the default by creating this file (for now, eventually put directly into XML)
	if($self->{file_checklist} ne "none"){
		open CHECK, "$self->{file_checklist}" or 
		die "You need a file named $self->{file_checklist} with fully-qualified " .
		 "file and directory names to check in order to run this program. " .
		 "Please see the POD documentation for more information.\n";
		@checkdirs = ();
        $/ = "\n";
		while(<CHECK>) {
			chomp;
			print "reading in $_ from $self->{file_checklist}\n";
			push @checkdirs, $_;
		}
		close CHECK;
	}
	return @checkdirs;
}

################################################################################

# _found() takes input from $file_checklist, which is a file created by the
# user specifying which directory to baseline and check. As long as the
# directory is not in $file_exclude, then proceed with check.
# Uses the global hash reference hack because
# it's used by find() so can't take in/pass back stuff

sub _found {
		
	my $foundfile = $File::Find::name;
    
	if (-f $foundfile) {
		if (exists($g_ex_hash->{$foundfile})) {
            return;
        }

        my $dir = dirname($foundfile);
        while ($dir ne "/") {
            # XXX: Need to add some sort of logic to account
            # for off-by-one key names (i.e., /dir versus /dir/).
            if (exists($g_ex_hash->{$dir})) {
                return;
            }
            $dir = dirname($dir);
        }

#		if (!exists($g_ex_hash->{$foundfile})) {
			push @{$g_hack}, $foundfile;
#			print "found $foundfile\n";
#			print "@{$g_hack}\n";
#		}
	}
}

################################################################################

# This function is used to delve down into directories and make sure all the
# contained files are excluded. Uses the global hash reference hack because
# it's used by find() so can't take in/pass back stuff

sub _recursive_exclude{
	
   my $foundfile = $File::Find::name;
	if (-f $foundfile) {
		$g_ex_hash->{$foundfile} = 1;
##		print "\t _recursive_exclude()d $foundfile\n";
	}
}

################################################################################

# Helper function designed to programmatically get or set parameters
# within this object, through indirect use of the AUTOLOAD function.
#
# It's best to explain by example:
# Assume we have defined a driver object, like the following.
#
# use HoneyClient::Agent::Driver;
# my $driver = Driver->new(someVar => 'someValue');
#
# What this function allows us to do, is programmatically, get or set
# the 'someVar' parameter, like:
#
# my $value = $driver->someVar();    # Gets the value of 'someVar'.
# my $value = $driver->someVar('2'); # Sets the value of 'someVar' to '2'
#                                    # and returns '2'.
#
# Rather than creating getter/setter functions for every possible parameter,
# the AUTOLOAD function allows us to create these operations in a generic,
# reusable fashion.
#
# See "Autoloaded Data Methods" in perltoot for more details.
# 
# Inputs: set a new value (optional)
# Outputs: the currently set value
sub AUTOLOAD {
    # Get the object.
    my $self = shift;

    # Sanity check: Make sure the supplied value is an object.
    my $type = ref($self) or Carp::croak "Error: $self is not an object!\n";

    # Now, get the name of the function.
    my $name = $AUTOLOAD;

    # Strip the fully-qualified portion of the function name.
    $name =~ s/.*://;

    # Make sure the parameter exists in the object, before we try
    # to get or set it.
    unless (exists $self->{$name}) {
        Carp::croak "Error: Can't access '$name' parameter in class $type!\n";
    }

    if (@_) {
        # If we were given an argument, then set the parameter's value.
        return $self->{$name} = shift;
    } else {
        # Else, just return the existing value.
        return $self->{$name};
    }
}

################################################################################

# Base destructor function.
# Since none of our state data ever contains circular references,
# we can simply leave the garbage collection up to Perl's internal
# mechanism.
#sub DESTROY {
#}
################################################################################


1;

=pod

=head1 BUGS & ASSUMPTIONS

BUG: Can not handle the "hidden" keys which contain null string and can only be 
read/written with special calls to the windows "Native API"
More about this problem referenced here:

BUG: Can't deal with http://www.sysinternals.com/Information/TipsAndTrivia.html#HiddenKeys

BUG: The whitelisting was hacked in at the last minute and is very course-grain

BUG: FIX UNIT TEST 6 (? is it still broken?)

=head1 TODO

Find out what format matt/database wants the output in and then create it instead
of just printing to a file.

Need way to deal with extreme corner ccase of null embeded malicious values (will 
require using Native API)

Hash the clean registry file and keep the hash in memory to make it harder to 
find/modify than it is if you're just dropping a textfile to the disk somewhere.
More generally I think this will be necessary for any file which is used in both an 
init* and check* function, because any of them could be attacked to either evade 
detection or at least cause lots of false positives (for instance deleting the 
whitelists)

future speed hack (assumes blacklisting) = check the given list of registry keys 
for overlap and then do less registry exports by reusing files

test the filesystem check code with soft/hard links

Need to determine how the recursive exclude responds to links and aliases...we don't want
someone to be able to put a link to c:\ in a directory and have it followed and exclude
everything.

If malware can write itself to one of the excluded directories it will go undetected on the filesystem.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

XXX: Fill this in.

=head1 AUTHORS

Kathy Wang, E<lt>knwang@mitre.orgE<gt>

Xeno Kovah, E<lt>xkovah@mitre.orgE<gt>

Thanh Truong, E<lt>ttruong@mitre.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2006 The MITRE Corporation.  All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, using version 2
of the License.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.


=cut

