################################################################################
# Created on:  June 01, 2006
# Package:     HoneyClient::Agent::Integrity
# File:        Integrity.pm
# Description: Module for checking the system integrity for possible
#              modifications.
#
# CVS: $Id$
#
# @author knwang, xkovah, ttruong, kindlund, stephenson
#
# Copyright (C) 2007 The MITRE Corporation.  All rights reserved.
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

HoneyClient::Agent::Integrity - Perl extension to perform configurable 
integrity checks of the Agent VM OS.

=head1 VERSION

This documentation refers to HoneyClient::Agent::Integrity version 1.00.

=head1 SYNOPSIS

  use HoneyClient::Agent::Integrity;
  use Data::Dumper;

  # Create the Integrity object.  Upon creation, the object will
  # be initialized, by performing a baseline of the Agent VM OS.
  my $integrity = HoneyClient::Agent::Integrity->new();

  # ... Some time elapses ...

  # Check the Agent VM, for any violations.
  my $changes = $integrity->check();

  if (!defined($changes)) {
      print "No integrity violations have occurred.\n";
  } else {
      print "System integrity has been compromised:\n";
      print Dumper($changes);
  }

  # $changes refers to an array of hashtable references, where
  # each hashtable has the format given in the METHODS IMPLEMENTED section related to
  # check().

  # Once you're finished with the $integrity object, be sure to destroy it.
  $integrity->destroy();

=head1 DESCRIPTION

This library allows the Agent module to easily baseline and perform subsequent
checks of different aspects of the Windows OS for any changes that may occur,
while Agent instruments a target application.

Currently, the Integrity module performs the following checks, using the
listed sub-modules.  Please refer to the sub-module documentation for
further details about how each check is implemented.

No initialization is currently necessary, as real-time changes are read in from
a list exported by the Capture C code. However, in the future it may become 
desirable to perform an initial baseline of the system, in order to automatically
determine the original value for things which were changed.  This is because the
mechanisms that Capture code uses to record events, may in some cases be unable
to record the initial value (e.g., a registry key).

=over 4

=item *

Checks Windows OS Registry.  See L<HoneyClient::Agent::Integrity::Registry>.

=item *

Checks Windows OS Filesystem.  See L<HoneyClient::Agent::Integrity::Filesystem>.

=back

=cut

package HoneyClient::Agent::Integrity;

use strict;
use warnings;
use Carp ();


# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include the Registry Checking Library
#use HoneyClient::Agent::Integrity::Registry;

# Include the Filesystem Checking Library
#use HoneyClient::Agent::Integrity::Filesystem;

# Use Storable Library
use Storable qw(nfreeze thaw dclone);
$Storable::Deparse = 1;
$Storable::Eval = 1;

# Use Dumper Library
use Data::Dumper;

# Include Logging Library
use Log::Log4perl qw(:easy);

# Use MD5
use Digest::MD5;

# Use SHA
use Digest::SHA;

# Use IO::File Library
use IO::File;

# Use File::Type Library
use File::Type;

#######################################################################
# Module Initialization                                               #
#######################################################################

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION);

    # Set our package version.
    $VERSION = 1.00;

    @ISA = qw(Exporter);

    # Symbols to export automatically
    @EXPORT = qw( );

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Agent::Integrity ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = (
        'all' => [ qw( ) ],
    );

    # Symbols to autoexport (when qw(:all) tag is used)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.
}
our (@EXPORT_OK, $VERSION);

=pod

=begin testing

# Make sure Log::Log4perl loads
BEGIN { use_ok('Log::Log4perl', qw(:nowarn))
        or diag("Can't load Log::Log4perl package. Check to make sure the package library is correctly listed within the path.");
       
        # Suppress all logging messages, since we need clean output for unit testing.
        Log::Log4perl->init({
            "log4perl.rootLogger"                               => "DEBUG, Buffer",
            "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
            "log4perl.appender.Buffer.min_level"                => "fatal",
            "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
            "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
        });
}
require_ok('Log::Log4perl');
use Log::Log4perl qw(:easy);

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar setVar)) 
        or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
can_ok('HoneyClient::Util::Config', 'setVar');
use HoneyClient::Util::Config qw(getVar setVar);

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Storable loads
BEGIN { use_ok('Storable', qw(nfreeze thaw dclone))
        or diag("Can't load Storable package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
can_ok('Storable', 'dclone');
use Storable qw(nfreeze thaw dclone);

# Make sure HoneyClient::Agent::Integrity::Registry loads
#BEGIN { use_ok('HoneyClient::Agent::Integrity::Registry')
#        or diag("Can't load HoneyClient::Agent::Integrity::Registry package. Check to make sure the package library is correctly listed within the path."); }
#require_ok('HoneyClient::Agent::Integrity::Registry');
#use HoneyClient::Agent::Integrity::Registry;

# Make sure HoneyClient::Agent::Integrity::Filesystem loads
#BEGIN { use_ok('HoneyClient::Agent::Integrity::Filesystem')
#        or diag("Can't load HoneyClient::Agent::Integrity::Filesystem package. Check to make sure the package library is correctly listed within the path."); }
#require_ok('HoneyClient::Agent::Integrity::Filesystem');
#use HoneyClient::Agent::Integrity::Filesystem;

# Make sure HoneyClient::Agent::Integrity loads.
BEGIN { use_ok('HoneyClient::Agent::Integrity') or diag("Can't load HoneyClient::Agent::Integrity package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent::Integrity');
use HoneyClient::Agent::Integrity;

=end testing

=cut

#######################################################################
# Global Configuration Variables                                      #
#######################################################################

# The global logging object.
our $LOG = get_logger();

=pod

=head1 DEFAULT PARAMETER LIST

When an Integrity B<$object> is instantiated using the B<new()> function,
the following parameters are supplied default values.  Each value
can be overridden by specifying the new (key => value) pair into the
B<new()> function, as arguments.

=head2 bypass_baseline 

=over 4

Currently defaults to 1, whereby the object will forgo any type of initial baselining
process, upon initialization.  If set to 0, baselining will occur upon initialization.
Baselining is currently deprecated.
=back

=head2 changes_found_file

A string to the absolute path of a file on the VM's filesystem.
When an integrity check fails, all changes will be written to this
file within the compromized honeyclient VM's filesystem.

=back

=cut

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# Helper function, designed to baseline the system.
# 
# Inputs: None.
# Outputs: None.
sub _baseline {
    my $self = shift;
    # XXX: The Registry object MUST be created before the Filesystem object, since
    # the Registry object creates new files that must exist to be added to the
    # Filesystem's baseline list of files that exist on the system.
    $self->{'_registry'} = HoneyClient::Agent::Integrity::Registry->new();
    $self->{'_filesystem'} = HoneyClient::Agent::Integrity::Filesystem->new();
}

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 METHODS IMPLEMENTED

The following functions have been implemented by any Integrity object.

=head2 HoneyClient::Agent::Integrity->new($param => $value, ...)

=over 4

Creates a new Integrity object, which contains a hashtable
containing any of the supplied "param => value" arguments.  Upon
creation, the Integrity object initializes all of its sub-modules,
by creating a baseline of the operating system.

I<Inputs>:
 B<$param> is an optional parameter variable.
 B<$value> is $param's corresponding value.
 
Note: If any $param(s) are supplied, then an equal number of
corresponding $value(s) B<must> also be specified.

I<Output>: The instantiated Integrity B<$object>, fully initialized.

=back

=begin testing

diag("These tests will create temporary files in /tmp.  Be sure to cleanup this directory, if any of these tests fail.");

# Create a generic Integrity object, with test state data.
my $integrity = HoneyClient::Agent::Integrity->new(test => 1, bypass_baseline => 1);
is($integrity->{test}, 1, "new(test => 1, bypass_baseline => 1)") or diag("The new() call failed.");
isa_ok($integrity, 'HoneyClient::Agent::Integrity', "new(test => 1, bypass_baseline => 1)") or diag("The new() call failed.");

diag("Performing baseline check of the system; this may take some time...");

# Perform baseline.
$integrity = HoneyClient::Agent::Integrity->new();
isa_ok($integrity, 'HoneyClient::Agent::Integrity', "new()") or diag("The new() call failed.");
$integrity->destroy();

=end testing

=cut

sub new {
    # - This function takes in an optional hashtable,
    #   that contains various key => 'value' configuration
    #   parameters.
    #
    # - For each parameter given, it overwrites any corresponding
    #   parameters specified within the default hashtable, %params, 
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
    my %params = (
        # When set to 1, the object will forgo any type of initial baselining
        # process, upon initialization.  Otherwise, baselining will occur
        # as normal, upon initialization.
        # XXX: Bypass static baselining, for now.
        # XXX: Baselining will not be used with the current version which includes Capture
        bypass_baseline => 1,

        # Contains the Registry object, once initialized.
        # (For internal use only.)
        _registry => undef,

        # Contains the Filesystem object, once initialized.
        # (For internal use only.)
        _filesystem => undef,

        # A string to the absolute path of a file on the VM's filesystem.
        # When an integrity check fails, all changes will be written to this
        # file within the compromized honeyclient VM's filesystem.
        changes_found_file => getVar(name => 'changes_found_file'),
    
        # XXX: comment this
        realtime_changes_file => getVar(name => 'realtime_changes_file'),
    );

    @{$self}{keys %params} = values %params;

    # Now, overwrite any default parameters that were redefined
    # in the supplied arguments.
    @{$self}{keys %args} = values %args;

    # Now, assign our object the appropriate namespace.
    bless $self, $class;

    # Perform baselining, if not bypassed.
    if (!$self->{'bypass_baseline'}) {
        $LOG->info("Baselining system.");
        $self->_baseline();
    }

    # Finally, return the blessed object.
    return $self;
}


=pod

=head2 $object->check()

=over 4

Checks the operating system for various changes, based upon
the baseline snapshot of the system, when the new() method
was invoked.

I<Output>:
 B<$changes>, which is an array of hashtable references, where each
hashtable has the following format:

  $changes = {
    #A reference to an anonymous array of process objects
    processes => [ {
        'name' => "C:\WINDOWS\system32\Notepad.exe", # The process name as a full path
        'pid' => 1000,              # The Windows system process ID
        'parent_name' => "C:\WINDOWS\system32\explorer.exe",  # The process name as
                                    # a full path for the process which created this process
        'parent_pid' => 999,        # The Windows system process ID for the
                                    # process which created this process
        
        #The absence of both a created and terminated time implies that the enclosed 
        #filesystem and/or registry events are related to a process which was running
        #when the realtime checks were started, and was still running when they ended
        
        #OPTIONAL, its existence signifies that we saw this process be created
        'created_time' => ISO 8601 Timestamp (yyyy-mm-dd hh24:mi:ss.uuuuuu)
        
        #OPTIONAL, its existence signifies that we saw this process be terminated
        'terminated_time' => ISO 8601 Timestamp

        #A reference to an anonymous array of registry objects
        registry => [ {
            # The registry directory name in regedit
            'key_name' => 'HKEY_LOCAL_MACHINE\Software...',

            'time' => ISO 8601 Timestamp, 

            #The specific registry event type which took place, as given by it's Windows name
            'event_type' => { CreateKey | OpenKey | CloseKey | Query Key |
                                QueryValueKey, EnumerateKey | EnumerateValueKey | 
                                SetValueKey | DeleteValueKey | DeleteKey },

            #The "name" which shows up in regedit
            'value_name' => "my key", 

            #The "type" which shows up in regedit. It is only possible to create the first 
            # 6 types by manually using regedit (and REG_NONE is only indirect, for instance
            # on a DeleteValueKey event_type).
            'value_type' => { REG_NONE | REG_SZ | REG_BINARY | REG_DWORD | 
                                REG_EXPAND_SZ | REG_MULTI_SZ | REG_LINK | 
                                REG_DWORD_BIG_ENDIAN | REG_RESOURCE_LIST |
                                REG_FULL_RESOURCE_DESCRIPTOR |
                                REG_RESOURCE_REQUIREMENTS_LIST |
                                REG_QWORD_LITTLE_ENDIAN},
            #The "value" which shows up in regedit
            'value' => many possible data types, but converted into a string,
    
        }, ],
        
        #A reference to an anonymous array of file system objects
        file_system => [ {
            #The full path and name of the file which was effected
            'name'  => 'C:\WINDOWS\SYSTEM32...',

            'event_type' => { Deleted | Read | Write }, #TODO: add created & renamed/moved

            'time' => ISO 8601 Timestamp, 
            
            #OPTIONAL, this will not exist for deleted files
            'content' => {
                'size' => 1234,                                       # size of new content
                'type' => 'application/octect-stream',                # type of new content
                'md5'  => 'b1946ac92492d2347c6235b4d2611184',         # md5  of new content
                'sha1' => 'f572d396fae9206628714fb2ce00f72e94f2258f', # sha1 of new content
            },
        },]
    },]
  }

I<Notes>:

=back

=cut

sub check {

    # Extract arguments.
    my ($self, %args) = @_;

    # Sanity check: Make sure we've been fed an object.
    unless (ref($self)) {
        $LOG->error("Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!");
        Carp::croak "Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!\n";
    }

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

#    my $changes = {
#        'registry' => $self->{'_registry'}->check(),
#        'filesystem' => $self->{'_filesystem'}->check(),
#    };
#XENO - BEGIN REPLACEMENT WITH CAPTURE-READING CODE
    my $change_file_name = $self->{realtime_changes_file};
    my %changes;
    my @capdump;
    if(-s $change_file_name > 0 ){
        open(CAP, $change_file_name) or die "Can't open $change_file_name";
        @capdump = <CAP>;
        close(CAP);
    }
    else{
        %changes = (
            'processes' => [],
        );

        return \%changes;
    }

    my @reg_list = ();
    my @reg_lines = ();
    my @file_list = ();
    my @file_lines = ();
    my @proc_list = ();
    my @proc_lines = ();
    my @bad_line_list = ();
    my $key;
    my $status;
    my @proc_and_file_list;
    my @proc_objs = ();
    my %names = ();
    #Indices in the string for different types of information
    my $ENTRY_TYPE = 1;
    my $R_TIME = 0;
    my $R_EVENT_TYPE = 2;
    my $R_PROC_PID = 3;
    my $R_PROC_NAME = 4;
    my $R_KEY_NAME = 5;
    my $R_VALUE_NAME = 6;
    my $R_VALUE_TYPE = 7;
    my $R_VALUE = 8;
    my $F_TIME = 0;
    my $F_EVENT_TYPE = 2;
    my $F_PROC_PID = 3;
    my $F_PROC_NAME = 4;
    my $F_NAME = 5;
    my $P_TIME = 0;
    my $P_EVENT_TYPE = 2;
    my $P_PARENT_PID = 3;
    my $P_PARENT_NAME = 4;
    my $P_PID = 5;
    my $P_NAME = 6;
    my $TOTAL_PROC_TOKENS = 7;
    my $TOTAL_FILE_TOKENS = 6;
    my $TOTAL_REG_TOKENS = 9;
    my $STATUS_DELETED = 0;
    my $STATUS_ADDED = 1;
    my $STATUS_MODIFIED = 2;


    #Get the time of the first event from the first entry and used it for compromise_time
    my @tmp_toks = split("\",\"",$capdump[0]);
    $tmp_toks[0] =~ s/^"(.*)/$1/;
    %changes = ('compromise_time' => $tmp_toks[0]);
    my $line_num = 0;

    foreach my $line (@capdump){
        $line_num++;
        my $ret = undef;
        #Get rid of the windows carriage return and newline (sometimes looks like ^M)
        $line =~ s/\r\n$//;       
        #Get rid of first and last quotes
        $line =~ s/^\"(.*)/$1/;
        chop($line);
        
        my @toks = split("\",\"", $line, $TOTAL_REG_TOKENS+1);
        my $index = undef;
        my $proc_obj = undef;
        my $proc_push;
        if($toks[$ENTRY_TYPE] eq "process"){
            $proc_push = 1;
            if($toks[$P_EVENT_TYPE] eq "terminated"){
                ($ret, $index) = checkForExistingProcObj($toks[$P_PID], $toks[$P_NAME], @proc_objs);
                #If the object already exists as something which didn't have anything filled in, then fill it in
                if($ret == 1){
                    $proc_objs[$index]->{"$toks[$P_EVENT_TYPE]_time"} = $toks[$P_TIME];
                    $proc_push = 0; 
                }
            }
            #create this object
            $proc_obj = {
                'pid' => $toks[$P_PID],
                'name' => $toks[$P_NAME],
                'parent_pid' => $toks[$P_PARENT_PID],
                'parent_name' => $toks[$P_PARENT_NAME],
                "$toks[$P_EVENT_TYPE]_time" => $toks[$P_TIME],
                'file_system' => [],
                'registry' => [],
            };
        }
        else{
            $proc_push = 0;

            ($ret, $index) = checkForExistingProcObj($toks[$R_PROC_PID], $toks[$R_PROC_NAME], @proc_objs);
            if($ret == 1){
                $proc_obj = $proc_objs[$index];
            }
            else{
                #First build an empty proc object
                $proc_obj = {
                    'pid' => $toks[$R_PROC_PID],
                    'name' => $toks[$R_PROC_NAME],
                    'registry' => [],
                    'file_system' => [], 
                }; 
                $proc_push = 1;
            }

            if($toks[$ENTRY_TYPE] eq "registry"){
                #Build the registry object and put it in to the proc object
                #Sanity check incase Capture gets messed up, because the database can't accept
                # an empty string for key_name, but also we want to make it clear that something
                # bad happened.
                my $sanit_key_name;
                if($toks[$R_KEY_NAME] eq "" || $toks[$R_KEY_NAME] !~ /^[HKLM,HKCU,HKU,HKCR]/){
                    $sanit_key_name = "KEY NAME ERROR \"$toks[$R_KEY_NAME]\"";
                    print "KEY NAME ERROR at line $line_num \"$toks[$R_KEY_NAME]\"\n";
                } 
                else{
                    $sanit_key_name = $toks[$R_KEY_NAME];
                }
                my $reg_obj = {
                    'time' => $toks[$R_TIME],
                    'event_type' => $toks[$R_EVENT_TYPE],
                    'key_name' => $sanit_key_name,
                    'value_name' => $toks[$R_VALUE_NAME],
                    'value_type' => $toks[$R_VALUE_TYPE],
                    'value' => $toks[$R_VALUE],
                };
                push @{$proc_obj->{'registry'}}, $reg_obj;
            }
            elsif($toks[$ENTRY_TYPE] eq "file"){

                #Build the filesystem object and put it in to the proc object
                my $fs_ref = $proc_obj->{'file_system'};
                if(scalar(@{$fs_ref}) == 0 || $fs_ref->[-1]->{'name'} ne $toks[$F_NAME] ||
                        $fs_ref->[-1]->{'event_type'} ne $toks[$F_EVENT_TYPE]){
                      
                    my $file_obj = {
                        'name' => $toks[$F_NAME],
                        'event_type' => $toks[$F_EVENT_TYPE],
                        'time' => $toks[$F_TIME],
                    };
                    if($toks[$F_EVENT_TYPE] ne "Delete"){
                        #Fill in the default values, incase the file can't be found due to a rename rather than delete
                        $file_obj->{'contents'} = {
                            'size' => 0,
                            'type' => "UNKNOWN",
                            'md5' => "$toks[$F_NAME]$toks[$F_TIME]",
                            'sha1' => "$toks[$F_NAME]$toks[$F_TIME]",
                        };
                        my $tmp_name = $toks[$F_NAME];
                        eval{
                            if(-f $tmp_name){
                                my $md5_ctx  = Digest::MD5->new();
                                my $sha1_ctx = Digest::SHA->new("1");
                                my $type_ctx = File::Type->new();
                                my $md5 = 'UNKNOWN';
                                my $sha1 = 'UNKNOWN';
                                my $type = 'UNKNOWN';
                                my $size = 0;
                                my $fh = IO::File->new($tmp_name, "r");
                                #print "md5ing $tmp_name\n";
                                # Compute MD5 Checksum.
                                $md5_ctx->addfile($fh);
                                $md5 = $md5_ctx->hexdigest();
    
                                # Rewind file handle.
                                seek($fh, 0, 0);
    
                                #print "sha1ing $tmp_name\n";
                                # Compute SHA1 Checksum.
                                $sha1_ctx->addfile($fh);
                                $sha1 = $sha1_ctx->hexdigest();
        
                                #Compute file size
                                $size = -s $tmp_name;
        
                                # Compute File Type.
                                $type = $type_ctx->mime_type($tmp_name);
        
                                # Close the file handle.
                                undef $fh;
                                $file_obj->{'contents'}->{'size'} = $size;
                                $file_obj->{'contents'}->{'md5'} = $md5;
                                $file_obj->{'contents'}->{'sha1'} = $sha1;
                                $file_obj->{'contents'}->{'type'} = $type;
                            }
                        };
                        if($@){
                            print "Filesystem error occurred, setting safe values for $tmp_name\n";
                            $file_obj->{'contents'} = {
                                'size' => 0,
                                'type' => "FSERROR",
                                'md5' => "FSERROR",
                                'sha1' => "FSERROR",
                            };
                        }
                        push @{$proc_obj->{'file_system'}},$file_obj;
                    }

                }
            }
        }
        if($proc_push){
            push @proc_objs, $proc_obj;
        }
    }#end foreach

    $changes{'processes'} = \@proc_objs;
#    $Data::Dumper::Terse = 1;
#    $Data::Dumper::Indent = 1;
#    print Dumper(\%changes);


#XENO - END REPLACEMENT WITH CAPTURE-READING CODE
 
    # If any changes were found, write them out to the
    # filesystem.
    if (scalar($changes{'processes'})){
        if (!open(CHANGE_FILE, ">>" . $self->{changes_found_file})) {
            $LOG->error("Unable to write changes to file '" . $self->{changes_found_file} . "'.");
        } else {
            $Data::Dumper::Terse = 1;
            $Data::Dumper::Indent = 1;
            print CHANGE_FILE Dumper(\%changes);
            print Dumper(\%changes);
            close CHANGE_FILE;
        }
    }

    return \%changes;
}

# TODO: Comment this.
# This function looks for if there is already a process object with the given pid and name
# and if it exists, returns its index in the processes array
# This function is used to find process objects for merging
# NOTE: In the future, we may want to make it be a hash, keyed by name:pid rather than an
# array, so that lookups are not O(n)
# Also, this function is predicated on the assumption that we will not see the same name:pid
# pair during our run
sub checkForExistingProcObj {
    my $pid = shift;
    my $name = shift;
    my $index = 0;
    my @proc_objs = @_;

    foreach my $obj (@proc_objs){
       #Check if the object already exists
            #&& !defined $obj->{'terminated_time'}
        if($obj->{'pid'} eq $pid && $obj->{'name'} eq $name){
            #object already exists
            return (1, $index);
        }
        $index++;
    }
    return (0, $index);
}

=pod

=head2 $object->closeFiles()

=over 4

Closes any temporary files that may have been created by any
of the Integrity::* sub-modules.  By performing this operation,
the Integrity B<$object> can become serializable.

=back

=cut

sub closeFiles {
    my $self = shift;

    # Sanity check: Make sure we've been fed an object.
    unless (ref($self)) {
        $LOG->error("Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!");
        Carp::croak "Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!\n";
    }

    if (defined($self->{'_registry'})) {
        $self->{'_registry'}->closeFiles();
    }
}

=pod

=head2 $object->destroy()

=over 4

Destroys any temporary files that have been created by any
of the Integrity::* sub-modules.  By performing this operation,
the Integrity B<$object> can be released from memory without
leaving any residual temporary files on the filesystem.

=back

=cut

sub destroy {
    my $self = shift;

    # Sanity check: Make sure we've been fed an object.
    unless (ref($self)) {
        $LOG->error("Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!");
        Carp::croak "Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!\n";
    }

    if (defined($self->{'_registry'})) {
        $self->{'_registry'}->destroy();
    }
}

1;

=pod

=head1 BUGS & ASSUMPTIONS

When performing an integrity check, this library assumes that it will never
see the same process name and process ID (PID) pair twice, because the malware
will not have had enough time to create processes that cause the OS to reissue
the same PIDs again.

For a complete list of when these checks may fail, see the following sections:

=over 4

=item *

L<HoneyClient::Agent::Integrity::Registry/"BUGS & ASSUMPTIONS">

=item *

L<HoneyClient::Agent::Integrity::Filesystem/"BUGS & ASSUMPTIONS">

=back

=head1 TODO

The following sub-modules are still a work-in-progress:

=over 4

=item *

Real-time filesystem detection.

=item *

Real-time registry detection.

=item *

Static and/or real-time rogue process detection.

=item *

Static and/or real-time memory alteration detection.

=back

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Christian Seifert E<lt>cseifert@mcs.vuw.ac.nzE<gt> and Ramon Steenson
E<lt>rsteenson@gmail.comE<gt> from the Victoria University of Wellington,
for their work on the Capture Client-Side Honeypot, which is used to
obtain kernel-level system events from Windows in the event of a compromise.

L<http://www.client-honeynet.org/capture.html>

=head1 AUTHORS

Kathy Wang, E<lt>knwang@mitre.orgE<gt>

Xeno Kovah, E<lt>xkovah@mitre.orgE<gt>

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

Brad Stephenson, E<lt>stephenson@mitre.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2007 The MITRE Corporation.  All rights reserved.

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

