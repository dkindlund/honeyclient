################################################################################
# Created on:  June 1, 2006
# Package:     HoneyClient::Agent
# File:        Integrity.pm
# Description: Module for checking the system integrity for possible modification
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

0.08

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
can_ok('HoneyClient::Agent::Integrity', 'initRegistry');
can_ok('HoneyClient::Agent::Integrity', 'checkRegistry');
use HoneyClient::Agent::Integrity qw(initAll checkAll initRegistry checkRegistry initFileSystem checkFileSystem);

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
BEGIN { use_ok('Storable', qw(dclone)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
use Storable qw(dclone);

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
use File::Find qw(find);
#use Win32::TieRegistry;
use Digest::MD5;
use MIME::Base64;
use Switch;
use Storable qw(dclone);
use Data::Dumper;

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION);

    # Set our package version.
    $VERSION = 0.9;

    @ISA = qw(Exporter);

    # Symbols to export on request
    @EXPORT = qw(new initAll checkAll initRegistry checkRegistry initFileSystem checkFileSystem);

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
my $g_reg_changes = 0;

#Used to initialize a default registry space to check if they don't specify anything when creating the object
my @default_reg_check_array = ("HKEY_LOCAL_MACHINE", "HKEY_CLASSES_ROOT", "HKEY_CURRENT_USER", "HKEY_USERS", "HKEY_CURRENT_CONFIG");

#I have no idea why slashes need to be triple-slashes since it's single quoted, but that's what works...
#also, of course [ and ] and any other special characters you find need to be escaped
my @default_reg_exclude_array = (	'\[HKEY_LOCAL_MACHINE\\\SOFTWARE\\\Microsoft\\\Cryptography\\\RNG\]', 
						'\[HKEY_CURRENT_USER\\\SessionInformation\]',
						'\[HKEY_USERS\\\.+\\\SessionInformation\]', 
						'\[HKEY_LOCAL_MACHINE\\\SOFTWARE\\\Microsoft\\\Windows\\\CurrentVersion\\\WindowsUpdate\\\Auto Update\]', 
						'\[HKEY_USERS\\\.+\\\Software\\\Microsoft\\\Windows\\\CurrentVersion\\\Explorer\\\UserAssist\\\.*\\\Count\]', 
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\CurrentControlSet\\\Services\\\.+\\\Parameters\\\Tcpip\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\CurrentControlSet\\\Services\\\Tcpip\\\Parameters\\\Interfaces\\\.+\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\CurrentControlSet\\\Services\\\Dhcp\\\Parameters\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\ControlSet.+\\\Services\\\.+\\\Parameters\\\Tcpip\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\ControlSet.+\\\Services\\\Tcpip\\\Parameters\\\Interfaces\\\.+\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\ControlSet.+\\\Services\\\Dhcp\\\Parameters\]',
						'\[HKEY_LOCAL_MACHINE\\\SOFTWARE\\\Microsoft\\\Windows\\\CurrentVersion\\\BITS]',
						'\[HKEY_USERS\\\.+\\\Software\\\Microsoft\\\Windows\\\CurrentVersion\\\Explorer\\\UserAssist\\\.+\\\Count\]',
						'\[HKEY_CURRENT_USER\\\Software\\\Microsoft\\\Windows\\\CurrentVersion\\\Explorer\\\UserAssist\\\.+\\\Count\]',
						'\[HKEY_LOCAL_MACHINE\\\SOFTWARE\\\Microsoft\\\Windows\\\CurrentVersion\\\Group Policy\\\State\\\Machine\\\Extension-List\\\.+\]',
						'\[HKEY_LOCAL_MACHINE\\\SOFTWARE\\\Microsoft\\\Windows\\\CurrentVersion\\\Group Policy\\\State\\\.+\\\Extension-List\\\.+\]',
						'\[HKEY_USERS\\\.+\\\Software\\\Microsoft\\\Windows\\\ShellNoRoam\\\BagMRU\]',
						'\[HKEY_CURRENT_USER\\\Software\\\Microsoft\\\Windows\\\ShellNoRoam\\\BagMRU\]',
						'\[HKEY_CURRENT_USER\\\Volatile Environment\]',
						'\[HKEY_USERS\\\.+\\\UNICODE Program Groups\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\ControlSet.+\\\Services\\\SharedAccess\\\Epoch\]',
						'\[HKEY_LOCAL_MACHINE\\\SYSTEM\\\CurrentControlSet\\\Services\\\SharedAccess\\\Epoch\]',
						);

my @default_file_exclude_array = (	'/cygdrive/c/cygwin/tmp/changes.txt',
						'/cygdrive/c/cygwin/tmp/cleanfile.txt',
						'/cygdrive/c/Documents and Settings/Administrator/Desktop/honeyclient',
						'/cygdrive/c/WINDOWS/Prefetch/',
						'/cygdrive/c/WINDOWS/WindowsUpdate.log',
						'/cygdrive/c/WINDOWS/Debug/UserMode/userenv.log',
						'/cygdrive/c/WINDOWS/SoftwareDistribution/DataStore/',
						'/cygdrive/c/WINDOWS/SchedLgU.Txt',
						'/cygdrive/c/WINDOWS/SoftwareDistribution/ReportingEvents.log',
						'/cygdrive/c/WINDOWS/system32/config/SysEvent.Evt',
						'/cygdrive/c/WINDOWS/PCHEALTH/HELPCTR/DataColl/',
						#Can't be included cause it's user specific
						#'/cygdrive/c/WINDOWS/SoftwareDistribution/WuRedir/9482F4B4-E343-43B6-B170-9A65BC822C77/wuredir.cab.bak',
						'/cygdrive/c/Documents and Settings/All Users/Application Data/Microsoft/Network/Downloader/',
						'/cygdrive/c/Documents and Settings/Administrator/Application Data/Mozilla/Firefox/Profiles/',
						'/cygdrive/c/Documents and Settings/Administrator/Local Settings/Application Data/Mozilla/Firefox/Profiles/',
						'/cygdrive/c/Documents and Settings/Administrator/Application Data/Talkback/MozillaOrg/Firefox15/Win32/2006050817/permdata.box',
						'/cygdrive/c/Documents and Settings/Administrator/Cookies/index.dat',
						'/cygdrive/c/Documents and Settings/Administrator/Local Settings/History/History.IE5/',
						'/cygdrive/c/Documents and Settings/Administrator/Local Settings/Temporary Internet Files/Content.IE5',
						'/cygdrive/c/Documents and Settings/Administrator/Recent/',
						'/cygdrive/c/Program Files/Mozilla Firefox/updates/',
						'/cygdrive/c/Program Files/Mozilla Firefox/active-update.xml',
						'/cygdrive/c/Program Files/Mozilla Firefox/updates.xml',
						);


my %PARAMS = (

	### Files which are read in only ###
	# List of files and directories to check during filesystem checking
	file_checklist => getVar(name => "file_checklist", namespace => "HoneyClient::Agent::Integrity"),
	
	# List of files or directories to exclude if found in subdirs during
	# filesystem check.
	file_exclude => getVar(name => "file_exclude", namespace => "HoneyClient::Agent::Integrity"),
	
	# List of registry keys to check
	reg_list_to_check	=> getVar(name => "reg_list_to_check", namespace => "HoneyClient::Agent::Integrity"),
	
	### Files to write and read ###
	# File to store hashes for files selected during the baseline
	clean_file => getVar(name => "clean_file", namespace => "HoneyClient::Agent::Integrity"),
	
	# File to write any found changes to
	change_file => getVar(name => "change_file", namespace => "HoneyClient::Agent::Integrity"),
	
	# Stores baseline for the registry. Always appended with a number
	clean_reg => getVar(name => "clean_reg", namespace => "HoneyClient::Agent::Integrity"),
	
	# Stores the current state of the registry to check against the
	# clean state
	current_reg => getVar(name => "current_reg", namespace => "HoneyClient::Agent::Integrity"),
	
	# The file for the diff command to redirect it's output to.
	# Always appended with a number.
	diffs => getVar(name => "diffs", namespace => "HoneyClient::Agent::Integrity"),

	#vars
	file_exclude_hash => undef, #hash, holds files to exclude
	file_list => undef,	#list, files to check when checking filesystem
	reg1 => undef,		#list,  holds entire contents of first file to diff
	reg2 => undef,		#list, holds entire contents of second file to diff
	
	#array that holds the locations in the registry to check
	reg_check_array => undef,
	#array that holds the registry locations that should be excluded from the detected changes
	reg_exclude_array => undef, 

	#works exactly like the reg_exclude_array, and is initialized in a similar way
	file_exclude_array => undef,

	changes => undef,	#multi-dimensional array used for holding individual instances of a diff output
	g_count => -1,	#highest level index for, each $g_count will be a different instance of a diff grouping
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
	$self->initRegistry();
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

	#Add any new created checks here
 
	$self->startCheckProcesses();	#currently a dummy method that just returns
	# If at all possible we want the (faster) registry checks to short circut
	# the overall checks so we don't have to do the very slow filesystem checks.
	$retval = $self->checkRegistry();
	if($retval){
		return $retval;
	}
	$retval = $self->checkFileSystem();

	return $retval;


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

	foreach my $file (@{$self->{file_exclude_array}}){
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

	print "Finding Files in initFileSystem...Be Patient.\n";
	foreach my $checkdir(@checkdirs) {
		find (\&_found, "$checkdir");	#this will populate @{$self->{file_list}}
	}

	$self->{file_list} = $g_hack;
	$self->{file_exclude_hash} = $g_ex_hash;
###	print "file_exclude_hash in init\n" . Dumper($self->{file_exclude_hash}) . "\n";

	print "Hashing Files in initFileSystem...Be Patient\n";
	open CLEANFILE, ">$self->{clean_file}" or die "Cannot open $self->{clean_file}: $!\n";
	foreach my $file (@{$self->{file_list}}) {
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

###	print "file_exclude_hash in check\n" . Dumper($self->{file_exclude_hash}) . "\n";


	if($standalone_test){
		$g_hack = $self->{file_list};
	}
	#open file to create hash of values for clean files
	open CLEANFILE, "$self->{clean_file}" or die "Cannot open $self->{clean_file}: $!\n";
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
	
		foreach my $file (@{$self->{file_exclude_array}}){
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
	foreach my $file (@{$self->{file_list}}) {
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
	foreach my $key (keys %{$self->{clean_file_hash}}) {
		if(!($current_file_hash{$key})) {
			$del_file_hash{$key} = $self->{clean_file_hash}->{$key};
		}
	}

	if((scalar(keys %del_file_hash) > 0) ||
		(scalar(keys %new_file_hash) > 0) ||
		(scalar(keys %{$self->{changed_file_hash}}) > 0)) {
		open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file}: $!\n";		

		print CHANGES "Files deleted:\n";
		foreach my $key (sort keys %del_file_hash) {
			print CHANGES "$key\n";
		}
		print CHANGES "\n\n";
		print CHANGES "Files added:\n";
		foreach my $key (sort keys %new_file_hash) {
			print CHANGES "$key\n";
		}
		print CHANGES "\n\n";
		print CHANGES "Files modified:\n";
		foreach my $key (sort keys %{$self->{changed_file_hash}}) {
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
		if(!exists($g_ex_hash->{$foundfile})) {
			push @{$g_hack}, $foundfile;
#			print "found $foundfile\n";
#			print "@{$g_hack}\n";
		}
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
#		print "\t _recursive_exclude()d $foundfile\n";
	}
}
################################################################################

=pod

=head1

initRegistry() : Takes no input. Optionally reads in a one-per-line list of 
registry keys to check, as stored in $self->reg_list_to_check. If such a list is not
present, uses the values hardcoded in the @{$self->{reg_check_array}}. Uses a system() call to
have regedit export the keys and sub-keys beginning at the specified location. 
Individual files are postfixed with their array index for uniqueness. Therefore
creates a number of files such as clean.reg0, clean.reg1, etc. 

=begin testing


#Testing initRegistry()
my $ob = HoneyClient::Agent::Integrity->new();

system("regedit.exe /s noTEST.reg");
system("regedit.exe /s /c $test_dir/t1a.reg");
$ob->initRegistry("HKEY_LOCAL_MACHINE\\HARDWARE\\TEST");
open (DIFF, "diff $test_dir/t1a.reg clean.reg0 |") or die "Can't check the changes files\n";
@result = <DIFF>;
close DIFF;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initRegistry: General Test');

=end testing

=cut

sub initRegistry {
my $self = shift;

	#If we're given function input, use it.
	if(scalar(@_) > 0){
		print "given input for reg_check_array in the parameters\n";
		@{$self->{reg_check_array}} = @_;
	}
	else {
		#otherwise, if we're given input via file, use it
		if(-f "$self->reg_list_to_check"){
			open REGDIRS, "$self->reg_list_to_check" or die "Cannot open $self->reg_list_to_check: $!\n";
			#wipe out any hardcoded ones
			@{$self->{reg_check_array}} = ();
			while(<REGDIRS>){
				push @{$self->{reg_check_array}}, $_;
			}
		}
		#otherwise, it will use the default array.
		else{
			$self->{reg_check_array} = \@default_reg_check_array;
		}
	}
	my $tmp = $self->{clean_reg};
	print "clean_reg in initRegistry $tmp\n";
	print "reg_check_array in initRegistry @{$self->{reg_check_array}}\n";
	my $var = 0;
	foreach my $key_to_check (@{$self->{reg_check_array}}){
		print "exporting $key_to_check to $self->{clean_reg}$var\n";
		print "regedit /a \"$self->{clean_reg}$var\" \"$key_to_check\" \n";
		system("regedit.exe /a \"$self->{clean_reg}$var\" \"$key_to_check\"");
		$var++;
	}

	$self->{reg_exclude_array} = \@default_reg_exclude_array;

}
################################################################################

=pod

=head1

checkRegistry() : Takes no input. Responsible for dumping the current state of
each of the registry locations in @{$self->{reg_check_array}} and comparing it against that
which was exported to the filesystem in initRegistry() by using the command line
utility diff. If differences are detected it parses the diff file and consults
the original and new file as necessary to determine exactly what changed.

=begin testing


my $ob = HoneyClient::Agent::Integrity->new();

reg_test($ob, 1, "checkRegistry: case 1 Multi-line addition changes.");
reg_test($ob, 2, "checkRegistry: case 2 Single-line addition changes.");
reg_test($ob, 3, "checkRegistry: case 3 Multi-line deletion changes.");
reg_test($ob, 4, "checkRegistry: case 4 Single-line deletion changes.");
reg_test($ob, 5, "checkRegistry: case 5 Simple multi-line to multi-line changes.");
is(6, 6, "checkRegistry: case 6 - SKIPPING (currently can't recreate conditions for test)");
#reg_test($ob, 6, "checkRegistry: case 6 Complicated multi-line to multi-line changes.");
reg_test($ob, 7, "checkRegistry: case 7 Simple multi-line to single-line changes.");
reg_test($ob, 8, "checkRegistry: case 8 Complicated multi-line to single-line changes.");
reg_test($ob, 9, "checkRegistry: case 9 Simple single-line to multi-line changes.");
reg_test($ob, 10, "checkRegistry: case 10 Complicated single-line to multi-line changes.");
reg_test($ob, 11, "checkRegistry: case 11 Simple single-line to single-line changes.");
reg_test($ob, 12, "checkRegistry: case12 Complicated single-line to single-line changes.");

sub reg_test{
my $ob = shift;
my $num = shift;
my $string = shift;

	#for safety
	if(-e "temp_reg_export.reg"){
		system("mv temp_reg_export.reg temp_reg_export.reg.CBL");
	}
	system('regedit.exe /a temp_reg_export.reg "HKEY_LOCAL_MACHINE\HARDWARE\TEST"');

	system("regedit.exe /s noTEST.reg");
	system("regedit.exe /s /c $test_dir/t" . "$num" . "a.reg");
	$ob->initRegistry("HKEY_LOCAL_MACHINE\\HARDWARE");
	system("regedit.exe /s noTEST.reg");
	system("regedit.exe /s /c $test_dir/t" . "$num" . "b.reg");
	$ob->checkRegistry("HKEY_LOCAL_MACHINE\\HARDWARE");
	open (DIFF, "diff $test_dir/t" . "$num" . "changes.txt changes.txt |") or die "Can't check the changes files\n";
	@result = <DIFF>;
	close DIFF;
	#Bad test because it will be empty in the case of an error anyway?
	is(scalar(@result), 0, "$string");

	#for safety/cleanup
	if(-e "temp_reg_export.reg"){
		system("regedit.exe /s noTEST.reg");
		system("regedit.exe /s /c temp_reg_export.reg");
		system("rm temp_reg_export.reg");
		if(-e "temp_reg_export.reg.CBL"){
			system("mv temp_reg_export.reg.CBL temp_reg_export.reg");
		}
	}
	
}

=end testing

=cut

sub checkRegistry {
my $self = shift;

		#*************************
		#XXXY: delete me eventually
		#if(-f "$self->{change_file}") {system("rm $self->{change_file}");}
		#*************************


#$var is used to create different files for different registry exports
my $var = 0;
#This foreach is what allows it to check multiple keys in the registry
foreach my $key_to_check (@{$self->{reg_check_array}}){	

	#First we want @reg1 to hold the clean registry state
	print "reading in existing state for $key_to_check\n";
	open REG, "$self->{clean_reg}$var"  or die "Cannot open $self->{clean_reg}$var: $!\n";
	@{$self->{reg1}} = <REG>;
	close REG;

	#Then we want @reg2 to hold the current registry state
	print "getting current state for $key_to_check\n";
	system("regedit /a \"$self->{current_reg}$var\" \"$key_to_check\""); #More useful for debugging
	open REG2, "$self->{current_reg}$var" or die "Cannot open $self->{current_reg}$var: $!\n";
#	open REG2, "regedit /a \"$self->{current_reg}$var\" \"$key_to_check\" |"  or die "Problem with combo speed hack: $!\n"; #future speed hack
	@{$self->{reg2}} = <REG2>;
	close REG2;



	print "diffing\n";
	#Code to split the entries into chunks in a multi-dimensional array
	#This list is what everything else uses to differentiate different diffs ;)
	system("diff -a $self->{clean_reg}$var $self->{current_reg}$var > $self->{diffs}$var"); #More useful for debugging
	open DIFZ, "$self->{diffs}$var" or die "Cannot open $self->{diffs}$var: $!\n";
#	open DIFZ, "diff -a $self->{clean_reg}$var $self->{current_reg}$var |" or die "Problem with combo speed hack: $!\n"; #future speed hack
	my $inner_count=0; #inner index for the multi-dimensional array for holding diff entries
	@{$self->{changes}} = ();
	while(<DIFZ>){
		#get rid of the nulls embedded by the export
		#NOTE: This will need to change when dealing with the 
		# inaccessible special NULL registry key name case
		$_ =~ s/\0//g;
#		print $_;
		#if the line starts with numbers then it's a new diff entry
		if($_ =~ /^[0-9]/){
			$inner_count = 0;
			$self->{g_count}++;
			$self->{changes}->[$self->{g_count}][$inner_count] = $_;
		}
		else{
			#otherwise it's just an entry in our current diff
			$inner_count++;
			$self->{changes}->[$self->{g_count}][$inner_count] = $_;
		}
	}
	close DIFZ;
	#Print the total number of individual diffs which will need to be parsed
	#NOTE: because "change" entries can include multiple events, this is an 
	# underestimate of how many actual changes there will be
	#ALSO NOTE: The prefix ++ on the count. That's just an array index vs number
	# of elements off by one thing to make it print right.
	print ++$self->{g_count} . " diff blocks put into the changes list for parsing\n";
	$self->{g_count}--;

	#This while loop steps through each of the individual diffs in the multi-dimensional
	# list, parsing one at a time.
	while($self->{g_count} >= 0){
		my $holder = $self->{changes}->[$self->{g_count}][0];
	#	print $holder;
		my $first_start = 0;
		my $first_end = 0;
		my $second_start = 0;
		my $second_end = 0;
	
		#XXX: NESTED SWITCHES CAUSE STRANGE PROBLEMS. Try to use the least nested switches as possible
		#$holder is always the first line of a diff, which is the line that contains the
		# line numbers for where in the two files the adds/deletes/changes are being made.
		#First it splits them into cases and subcases based on whether it's a an add, delete, or the
		# much more complicated change.
		switch($holder){
			case /a/ {
	
				############################################
				#Case of multi-line addition.
				############################################
				
				#TEST 1
				if($holder =~ /([0-9]+)a([0-9]+),([0-9]+)/) {
					$first_start = $1;
					$second_start = $2;
					$second_end = $3;
					my $quick_count = $3-$2+1;
					#We need an extra \ in the 2nd regex when used in a string
					#The regexes tell it to only look at lines that start with
					# the > because those are the lines represending added stuff
					#Use parser because a multi-line addition can inlcude the addition
					# of keys, not just name/data pairs.
					_parser($self, "a", "(^> )(.*)", "^> \\[", $quick_count, $first_start, 1, undef);
				}
				else{ ############################################
					#Case of single name/data pair addition
					############################################
								
					#TEST 2
					if($holder =~ /([0-9]+)a([0-9]+)/) {
						#In this case, there can not be any new keys because that would take
						# at least 2 lines because diff inlcudes the blank line. But that does
						# mean we have to go to the original file to find the name of the 
						# existing key.
						_moonwalk_and_print($self, $first_start, "(^> )(.*)", "New values for existing key\n", 2, ($self->{changes}->[$self->{g_count}][1]));
					}
					else {print "WARNING: some strange case in add\n";}
				
				}	
			}
	
					
			case /d/ {
				############################################
				#Case of multi-line deletion.
				############################################
							
				#TEST 3
				if($holder =~ /([0-9]+),([0-9]+)d([0-9]+)/) {
					$first_start = $1;
					$first_end = $2;
					$second_start = $3;
					my $quick_count = $2-$1+1;
					#need an extra \ in the 2nd regex when used in a string
					#The regexes tell it to only look at lines that start with
					# the < because those are the lines represending deleted stuff
					#Use parser because a multi-line addition can inlcude the deletion
					# of keys, not just name/data pairs.
					_parser($self, "d", "(^< )(.*)", "^< \\[", $quick_count, $first_start, 1, undef);
	
				}
				else {	############################################
					#Case of single name/data pair deletion
					############################################
								
					#TEST 4
					if($holder =~ /([0-9]+)d([0-9]+)/) {
						#We know that this can only be a name/data pair that was deleted because
						# a deletion of a key takes at least 2 lines because diff includes the 
						# blank line separating it from the other keys
						_moonwalk_and_print($self, $first_start, "(^< )(.*)", "Deletion of name/data from existing key\n", 1,($self->{changes}->[$self->{g_count}][1]));
					}
					else {print "WARNING: some strange case in delete\n";}
				}
			}
			
			case /c/ {
	
				#Note about the change case:
				#First of all as mentioned elsewhere "change" diffs can (and do) include multiple
				# actions into a single grouping of change instructions. If this was simply parsed 
				# and dealt with without going to either of the diffed files, this can easily
				# be exploited to hide some registry entries (it would still show an entry, but
				# for every entry added there can be an additional hidden one). Therefore as a
				# tradeoff, generally I always check the *last* entry from both the top and 
				# bottom section (except where it can be proven to be a simple change) against.
				# the first and second file respectively. While I have not found cases that 
				# necessitate this for every change subcase, it is currently done for safety
				# and simplicity because it can be done by reusing the _top_half and _bottom_half
				# code.
	
				switch($holder){
					#the cases have to be in this order ;)
					case /([0-9]+),([0-9]+)c([0-9]+),([0-9]+)/ {
						#XXX: BUG!!! need to do again (cause of nested switches?)
						$holder =~ /([0-9]+),([0-9]+)c([0-9]+),([0-9]+)/;
						$first_start = $1;
						$first_end = $2;
						$second_start = $3;
						$second_end = $4;
	
	#					print "1234 = $1:$2:$3:$4\n";
	
						##first check to make sure there are no keys
						my @full_diff = @{$self->{changes}->[$self->{g_count}]};
						my $simple = 1;
						my @before;
						my @after;
						foreach (@full_diff){
							if(/^[<>] \[/){$simple = 0;}
							if(/^< .*/){
								push @before, $_;
							}
							if(/^> .*/){
								push @after, $_;
							}
						}
	
						#TEST 5
						##############################
						# simple multi-line to multi-line change
						##############################
						if($simple){
							#case where it's only multi-line changes
							my @fake_array = ("> Old Value:", @before, "> New Value:", @after);
							_moonwalk_and_print($self, $first_start, "(^[<>] )(.*)", "Changed: \n", 1, @fake_array);
						}
						else{
							#TEST 6
							##############################
							# the most complicated (multi-line to multi-line) changes ;)
							##############################

							#Haven't been able to recreate this case naturally... punting.
							print("If you got here, please save the $self->{clean_reg}$var and $self->{current_reg}$var and send them to us\n");
							exit();
	
							#parses the output of the diff before and after the "---" 
							# divider independently
							_top_half($self,$first_start, $first_end, @before);
							_bottom_half($self, $second_start, $second_end, @after);
						}
						
						
					}
					case /([0-9]+),([0-9]+)c([0-9]+)/ {
						#XXX: BUG!!! need to do again (cause of nested switches?)
						$holder =~ /([0-9]+),([0-9]+)c([0-9]+)/;				
						$first_start = $1;
						$first_end = $2;
						$second_start = $3;
						my $quick_count = $2-$1+1;
	
	#					print "123 = $1:$2:$3\n";
	
						#first check to see if it is the trivial case of
						# ONLY changing name/data pairs (i.e. should not
						# find any keys (i.e. lines starting with "> [" 
						# or "< [")
						my @full_diff = @{$self->{changes}->[$self->{g_count}]};
						my $simple = 1;
						my @before;
						my @after;
						foreach (@full_diff){
							if(/^[<>] \[/){$simple = 0;}
							if(/^< .*/){
								push @before, $_;
							}
							if(/^> .*/){
								push @after, $_;
							}
						}
						
						#TEST 7
						##############################
						# simple multi-line to single-line change
						##############################
						if($simple){
							#case where it's only multi-line changes
							my @fake_array = ("> Old Value:", @before, "> New Value:", @after);
							_moonwalk_and_print($self, $first_start, "(^[<>] )(.*)", "Changed: \n", 1, @fake_array);
						}
	
						else{
							#TEST 8
							##############################
							# complicated multi-line to single-line change
							##############################
							_top_half($self, $first_start, $first_end, @before);
							_bottom_half($self, $second_start, $second_start, @after);
	
						}
						
	
					}
					case /([0-9]+)c([0-9]+),([0-9]+)/ {
						#XXX: BUG!!! need to do again (cause of nested switches?)
						$holder =~ /([0-9]+)c([0-9]+),([0-9]+)/;
						$first_start = $1;
						$second_start = $2;
						$second_end = $3;
	
						my $quick_count = $3-$2+3;
	
	#					print "123 = $1:$2:$3\n";
	
						##first check to make sure there are no keys
						my @full_diff = @{$self->{changes}->[$self->{g_count}]};
						my $simple = 1;
						my @before;
						my @after;
						foreach (@full_diff){
							if(/^[<>] \[/){$simple = 0;}
							if(/^< .*/){
								push @before, $_;
							}
							if(/^> .*/){
								push @after, $_;
							}
						}
	
						#TEST 9
						##############################
						# simple single-line to multi-line change
						##############################
						if($simple){
							my @fake_array = ("> Old Value:", @before,"> New Value:", @after);
							_moonwalk_and_print($self, $first_start, "(^[<>] )(.*)", "Changed: \n", 1, @fake_array);
						}
	
	
						else{
							#TEST 10
							##############################
							# complicated single-line to multi-line change
							##############################
							_top_half($self, $first_start, $first_start, @before);
							_bottom_half($self, $second_start, $second_end, @after);
						}
						
					}
					case /([0-9]+)c([0-9]+)/ {
						#XXX: BUG!!! need to do again (cause of nested switches?)
						$holder =~ /([0-9]+)c([0-9]+)/;
						$first_start = $1;
						$second_start = $2;
	
						my @full_diff = @{$self->{changes}->[$self->{g_count}]};
						my $simple = 1;
						my @before;
						my @after;
						foreach (@full_diff){
							if(/^[<>] \[/){$simple = 0;}
							if(/^< .*/){
								push @before, $_;
							}
							if(/^> .*/){
								push @after, $_;
							}
						}
									
						#TEST 11
						##############################
						# simple single-line to single-line change
						##############################
						if($simple){
							my @fake_array = ("> Old Value:", @before,"> New Value:", @after);
							_moonwalk_and_print($self, $first_start, "(^[<>] )(.*)", "Changed: \n", 1, @fake_array);
						}
						else{
							#TEST 12
							##############################
							# complicated single-line to single-line change
							##############################
							_top_half($self, $first_start, $first_start, @before);
							_bottom_half($self, $second_start, $second_start, @after);
						}
					}
				}
			}
			else {
				print "holder = $holder matched none of the cases, serious problem!\n";
			}
		}#end switch
		
		$self->{g_count}--;
	} #end big while

	$var++;
} #end big foreach
return $g_reg_changes;

} #end checkRegistry
################################################################################


# A very important function which is responsible for looping through a list which
# is given to it, and treating extra registry keys as adds or deletes with 
# possible adds, deletes, or changes as the "leftover" elements which get passed
# to _moonwalk_and_print. Originally this function only operated on a chunk of 
# the @{$self->{changes}} array, therefore to maintain compatibility for now, if no array 
# is given, it will instead use the @{$self->{changes}} array. 

# The general logic is that if it finds something in an array it pushes it into
# a temporary one. At such time as it pushes a line starting with > [ or < [ 
# that means that there was a registry key included in the array and therefore
# we know which key the name/data pairs belong to and therefore we won't need 
# to consult the disk because we have everything we need to know about that 
# event. If there are still things in the temporary array when we finish looping
# through the given/changes array then that is something leftover which we will
# have to consult either the current or clean registry state about, to determine
# which key the name/data pair belongs to. That's _moonwalk_and_print()'s job.

# TODO: Check to make sure the function generates appriopriate exceptions, when failures
# occur.
sub _parser{
my $self = shift;
my $type = shift;
my $regex = shift;
my $regex2 = shift;
my $quick_count = shift;
my $start_line = shift;
my $offset = shift;
my @custom_array = @_;
my @holding_array;

	open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file} (1): $!\n";
		
	#start to step (backwards) through the output of the diff
	my $tmp;
	while($quick_count >= $offset){
		if (defined $custom_array[$quick_count]){
			$tmp = $custom_array[$quick_count];
		}
		else{
			$tmp = $self->{changes}->[$self->{g_count}][$quick_count];
		}
					
		#If the line starts with '> [' it's a registry key
		#If this case is detected it means it's a new key
		# (possibly with name/data pairs, possibly without) and it
		# will just dump this to the CHANGES file because
		# it doesn't have to consult the original registry
		# dump in order to know which key/names/values is added.
		if($tmp =~ /$regex2/){
			push @holding_array, $tmp;
			@holding_array = reverse (@holding_array);
			switch($type){
				case /a/ {
					if(scalar(@holding_array) > 1){
						print CHANGES "\nAdded key and name/data: \n" or die "Can't write to changefile!\n";
					}
					else {
						print CHANGES "\nAdded empty key: \n" or die "Can't write to changefile!\n";
					}
				}
				case /d/ {
					if(scalar(@holding_array) > 1){
						print CHANGES "\nDeleted key and name/data: \n" or die "Can't write to changefile!\n";
					}
					else {
						print CHANGES "\nDeleted empty key: \n" or die "Can't write to changefile!\n";
					}
				}
				else{die "Unknown type in _parser() switch\n";}
			}

			foreach my $line (@holding_array){
				$line =~ /$regex/;
				#discard $1 which is formatting from diff
				print CHANGES "$2\n" or die "Can't write to changefile!\n";
			}
			print CHANGES "\n" or die "Can't write to changefile!\n";
			@holding_array = ();

		}
		else{
			#Push anything else (except empty line), as it will be included
			# in whatever key it was found in
			if($tmp !~ /^[<>] \r\n/){
				push @holding_array, $tmp;
			}
		}
		$quick_count--;
	}
	$g_reg_changes = 1;
	close CHANGES or warn "Can't close changefile!\n";

	#Anything left over in @holding_array after that loop
	# is a name/data pair which did not have a new key
	# being created, and therefore is the modification of
	# an existing key. Thus we must consult the original
	# file to clean up stragglers if any.
	if(scalar(@holding_array) > 0){
		@holding_array = reverse (@holding_array);
		my $string;
		my $case;
		switch($type){
			case "a" {
				$string = "Added name/data for existing key\n";
				$case = 2;
			}
			case "d" {
				$string = "Deleted name/data for existing key\n";
				$case = 1;
			}
			case /c/ {
				#$string = "Changed name/data for existing key\n";
				return @holding_array;
				$case = 1;
			}
			else{die "Unknown type in 2nd _parser() switch\n";}
		}		

		_moonwalk_and_print($self, $start_line, $regex, $string, $case, @holding_array);
	}

}
################################################################################

# Given a line number to start at in $moonwalk, this
# function walks backwards trying to find the enclosing
# registry key, and then prints the results to the
# CHANGES file.
# NOTE that most of this functionality has been passed off to _find_enclosing_key()
# such that this primarily just prints now. It has been left in place for now 
# simply to maintain current code.

# TODO: Check to make sure the function generates appriopriate exceptions, when failures
# occur.
sub _moonwalk_and_print {
my $self = shift;	#Object
my $start_line = shift;	#The line to start walking backwards from
my $regex = shift;	#regular expression to use to get rid of diff formatting on lines
my $string = shift;	#String to print when 
my $case = shift;		#Add/delete/change case (1 for delete/change, 2 for add)
my @holding_array = @_;

	#walk backwards looking for the registry key
	# which contains us.
	my $enclosing_key = _find_enclosing_key($self, $start_line, $case);

	foreach my $exclude_key (@{$self->{reg_exclude_array}}){
###		print "trying to match $enclosing_key against exclude key $exclude_key\n";
		if($enclosing_key =~ /$exclude_key/){
###			print "SUCCESS! I'm outta here!\n";
			return $start_line;
		}
	}

	open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file} (2): $!\n";		
	print CHANGES "\n$string" or die "Can't write to changefile!\n";
	print CHANGES $enclosing_key or die "Can't write to changefile!\n";
	foreach my $line (@holding_array){
		$line =~ /$regex/;
		#discard $1 which is formatting from diff
		print CHANGES "$2\n" or die "Can't write to changefile!\n";
	}
	$g_reg_changes = 1;
	close CHANGES or warn "Error closing changefile!\n";
	#for use by changed case to avoid another walk
	return $start_line;
}
################################################################################


#This is now what's actually doing the moonwalking due to some code rearrangement ;)
#Steps backwards from the passed in line number in the passed in case
# representing an array (representing a file) you want to use. @{$self->{reg1}} is the first
# file given to the diff (should be the clean file) and @{$self->{reg2}} is therefore the 
# second file (the current state).

# TODO: Check to make sure the function generates appriopriate exceptions, when failures
# occur.
sub _find_enclosing_key{
my $self = shift;	#Object
my $start_line = shift;	#
my $case = shift;

	#This is the delete or change case so it checks the clean registry file (reg1)
	# (because a key which is deleted for instance can only be found in the orignal
	# not the current)
	if($case == 1){
		while($self->{reg1}->[$start_line] !~ /^\[/){
			$start_line--;
		}
		return $self->{reg1}->[$start_line];
	}
	else{
		#This is the add case so it checks the current registry file (reg2)
		# (because a key which is deleted for instance can only be found in 
		#the orignal not the clean)
		if($case == 2){
			while($self->{reg2}->[$start_line] !~ /^\[/){
				$start_line--;
			}
			return $self->{reg2}->[$start_line];
		}
		else{
			die "Invalid value for case in _find_enclosing_key\n";
		}
	}
}

################################################################################

# Because changes can be ambiguous this function (and _bottom_half) were created
# to first deal with the ambigious case and then pass the rest into _parser().
# Based on the way that diff works and testing, it seems that ambiguous cases
# can only manifest themselves in the last entry in the top half (the stuff
# immediately before the "---" line when reading from top to bottom). Similarly
# it can only manifest in the last entry of the bottom half. Therefore if it is
# deal with in this code, the remainder of the array representing changes in the
# top or bottom half should be safe to parse with _parser().

sub _top_half{
my $self = shift;
my $first_start = shift;
my $first_end = shift;
my @before = @_;
my $num_lines = scalar(@before)-1;
my @tmp_array;
my $walk = $first_end;

	##############################
	# treat the top half like *deletes* 
	# BUT first go to file for the last one and check its contents!
	##############################

#	print "BEFORE walk = $walk\n";
	#walk backwards to find how many lines from the end to start at
	while($num_lines >= 0 && $before[$num_lines] !~ /^< \[/){
		$num_lines--;
	}
					
	my $lcount = scalar(@before)-1 - $num_lines;
	#walk is where to start walking *forward* in the clean reg file
	$walk = $first_end - $lcount;

#	print "BEFORE lcount = $lcount, walk = $walk\n";

	while($self->{reg1}->[$walk] !~ /^\[/){
		if($self->{reg1}->[$walk] !~ /^\r\n/){
#			print "pushing $self->{reg1}->[$walk]";
			push @tmp_array, $self->{reg1}->[$walk];	
		}
		$walk++;
	}
					
	open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file} (3): $!\n";
	if(scalar(@tmp_array) > 0){
		print CHANGES "\nDeleted key and name/data: \n";
		my $enclosing_key = _find_enclosing_key($self, $first_end, 1);
#		print "enclosing $enclosing_key";
		print CHANGES $enclosing_key;
		foreach (@tmp_array){
			print CHANGES;
			print "in da top $_";
		}
	}
	else{
		print CHANGES "\nDeleted empty key: \n";
		$walk = $first_end - $lcount-1;
		print CHANGES "$self->{reg1}->[$walk]\n";
		print "in da top $self->{reg1}->[$walk]\n";

	}
	$g_reg_changes = 1;
	close CHANGES;

	#the +1 is because we want to delete the extra empty line from the array
	$lcount++;

#	print "before before: @before";
	
	while($lcount > 0){
		pop @before;
		$lcount--;
	}

#	print "before after: @before";
	
	##############################
	#now the array is safe to be treated as a normal change+deletion array
	###############################
	if(scalar(@before) > 0){
#		print "BEFORE\n @before BEFORE\n";
		_parser($self, "cd", "(^< )(.*)", "^< \\[", scalar(@before)-1, $first_start, 0, @before);
	}

}
################################################################################

# Because changes can be ambiguous this function (and _top_half) were created
# to first deal with the ambigious case and then pass the rest into _parser().
# Based on the way that diff works and testing, it seems that ambiguous cases
# can only manifest themselves in the last entry in the top half (the stuff
# immediately before the "---" line when reading from top to bottom). Similarly
# it can only manifest in the last entry of the bottom half. Therefore if it is
# deal with in this code, the remainder of the array representing changes in the
# top or bottom half should be safe to parse with _parser().


sub _bottom_half{
my $self = shift;

my $second_start = shift;
my $second_end = shift;
my @after = @_;
my $num_lines = scalar(@after)-1;
my @tmp_array;
my $walk = $second_end;
	
	##############################
	#treat the bottom like *adds* 
	#BUT first go to file for the last one and check its contents!
	##############################

#	print "AFTER walk = $walk\n";
	#walk backwards to find how many lines from the end to start at
	while($num_lines >= 0 && $after[$num_lines] !~ /^> \[/){
		$num_lines--;
	}
			
	my $lcount = scalar(@after)-1 - $num_lines;
	#walk is where to start walking *forward* in the clean reg file
	$walk = $second_end - $lcount;


#	print "AFTER lcount = $lcount, walk = $walk\n";

	while($self->{reg2}->[$walk] !~ /^\[/){
						
		if($self->{reg2}->[$walk] !~ /^\r\n/){
#			print "AFTER pushing $self->{reg2}->[$walk]";
			push @tmp_array, $self->{reg2}->[$walk];	
		}
		$walk++;
	}
					
	open CHANGES, ">>$self->{change_file}" or die "Cannot open $self->{change_file} (4): $!\n";
	if(scalar(@tmp_array) > 0){
						
		print CHANGES "\nAdded key and name/data: \n";
		my $enclosing_key = _find_enclosing_key($self, $second_end, 2);
#		print "AFTER enclosing $enclosing_key";
		print CHANGES $enclosing_key;
		foreach (@tmp_array){
			print CHANGES;
#			print "in da bottom $_";
		}
	}
	else{
		print CHANGES "\nAdded empty key: \n";
		$walk = $second_end - $lcount-1;
		print CHANGES "$self->{reg2}->[$walk]\n";
#		print "in da bottom $self->{reg2}->[$walk]\n";

	}
	$g_reg_changes = 1;
	close CHANGES;

	#the +1 is because we want to delete the extra empty line from the array
	$lcount++;

#	print "after before: @after\n";
	
	while($lcount > 0){
		pop @after;
		$lcount--;
	}

#	print "after after: @after";
	
	##############################
	#now the array is safe to be treated as a normal change+addition array
	###############################
	if(scalar(@after) > 0){
#		print "AFTER\n @after AFTER\n";
		_parser($self, "ca", "(^> )(.*)", "^> \\[", scalar(@after)-1, $second_start, 0, @after);
	}

}




################################################################################

=pod

=head1

startCheckProcesses() : Currently just a placeholder incase we put Thanh's 
real-time checking here.

=cut

#Holder incase we put Thanh's stuff in here
sub startCheckProcesses {
	return;
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
sub DESTROY {
}
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

XXX: Fill this in.

XXX: If you have a mailing list, mention it here.

XXX: If you have a web site set up for your module, mention it here.

=head1 REPORTING BUGS

XXX: Mention website/mailing list to use, when reporting bugs.

=head1 ACKNOWLEDGEMENTS


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

