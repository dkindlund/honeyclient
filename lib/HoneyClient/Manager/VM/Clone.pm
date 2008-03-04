#######################################################################
# Created on:  June 15, 2007
# Package:     HoneyClient::Manager::VM::Clone
# File:        Clone.pm
# Description: Generic object model for handling a single HoneyClient
#              cloned VM on the host system.
#
# CVS: $Id$
#
# @author kindlund
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
#######################################################################

=pod

=head1 NAME

HoneyClient::Manager::VM::Clone - Perl extension to provide a generic object
model for handling a single HoneyClient cloned VM on the host system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::VM::Clone version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::VM::Clone;

  # Library used exclusively for debugging complex objects.
  use Data::Dumper;

  # Create a new cloned VM, using the default
  # 'master_vm_config' listed in the global configuration
  # file (etc/honeyclient.xml).
  my $clone = HoneyClient::Manager::VM::Clone->new();

  # When the new() operation completes, you are guaranteed that the
  # cloned VM is powered on, has an IP address, and has a HoneyClient::Agent daemon
  # ready for use.
  
  # Let's get the path to the newly created clone's configuration file.
  my $config = $clone->{'config'};

  # Figure out which master VM this clone is based on.
  my $master_vm_config = $clone->{'master_vm_config'};

  # Get the MAC address of the cloned VM's primary network interface.
  my $mac_address = $clone->{'mac_address'};

  # Get the IP address of the cloned VM's primary network interface.
  my $ip_address = $clone->{'ip_address'};

  # Get the name of the cloned VM (as it appears in the VMware Console).
  my $name = $clone->{'name'};

  # Archive the cloned VM to the snapshot_path directory.
  $clone->archive();

  # If you want the cloned VM to be suspended and no longer used,
  # simply set the variable to 'undef'.
  $clone = undef;

  # For existing cloned VMs that have been powered off or suspended,
  # you can create a Clone object to interact with those as well.
  $clone = HoneyClient::Manager::VM::Clone->new(config => '/vm/clones/other/winXPPro.cfg');

  # If you want to see what type of "state information" is physically
  # inside $clone, try this command at any time.
  print Dumper($clone);

=head1 DESCRIPTION

This library provides the Manager module with an object-oriented interface
towards interacting with cloned virtual machines.  It allows the Manager
to quickly create new cloned VMs in a consistent manner, without requiring 
the Manager to deal with all the nuances in cloning VMs.

When a new "Clone" object is created, the following normally occurs:

=over 4

=item 1)

A new VM is created, based upon cloning a given master VM.

=item 2) 

The cloned VM is powered on and the name of the VM is recorded.

=item 3) 

The MAC and IP address of the cloned VM's primary network interface
are recorded.

=item 4)

The HoneyClient::Agent daemon running inside the cloned VM is verified
and ready for use.

=back

Note: If an existing cloned VM's configuration file is specified in
the new() call, then the "Clone" object will reuse this VM (by not
creating any duplicate VMs) and proceed to power up this VM, along
with going through the same verification procedures.

=cut

package HoneyClient::Manager::VM::Clone;

use strict;
use warnings;
use Config;
use Carp ();

# Traps signals, allowing END: blocks to perform cleanup.
use sigtrap qw(die untrapped normal-signals);

#######################################################################
# Module Initialization                                               #
#######################################################################

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION);

    # Set our package version.
    $VERSION = 1.02;

    @ISA = qw(Exporter);

    # Symbols to export automatically
    # Note: Since this module is object-oriented, we do *NOT* export
    # any functions other than "new" to call statically.  Each function
    # for this module *must* be called as a method from a unique
    # object instance.
    @EXPORT = qw();

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Manager::VM::Clone ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    # Note: Since this module is object-oriented, we do *NOT* export
    # any functions other than "new" to call statically.  Each function
    # for this module *must* be called as a method from a unique
    # object instance.
    %EXPORT_TAGS = (
        'all' => [ qw() ],
    );

    # Symbols to autoexport (when qw(:all) tag is used)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

    # Check to see if ithreads are compiled into this version of Perl.
    if (!$Config{useithreads}) {
        Carp::croak "Error: Recompile Perl with ithread support, in order to use this module.\n";
    }

    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.
}
our (@EXPORT_OK, $VERSION);

=pod

=begin testing

# Make sure ExtUtils::MakeMaker loads.
BEGIN { use_ok('ExtUtils::MakeMaker', qw(prompt)) or diag("Can't load ExtUtils::MakeMaker package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('ExtUtils::MakeMaker');
can_ok('ExtUtils::MakeMaker', 'prompt');
use ExtUtils::MakeMaker qw(prompt);

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

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar))
        or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); 

        # Suppress all logging messages, since we need clean output for unit testing.
        Log::Log4perl->init({
            "log4perl.rootLogger"                               => "DEBUG, Buffer",
            "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
            "log4perl.appender.Buffer.min_level"                => "fatal",
            "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
            "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
        });
        
}
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getClientHandle);

# Make sure HoneyClient::Manager::VM loads.
BEGIN { use_ok('HoneyClient::Manager::VM') or diag("Can't load HoneyClient::Manager::VM package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::VM');
use HoneyClient::Manager::VM;

# Make sure VMware::VmPerl loads.
BEGIN { use_ok('VMware::VmPerl', qw(VM_EXECUTION_STATE_ON VM_EXECUTION_STATE_OFF VM_EXECUTION_STATE_STUCK VM_EXECUTION_STATE_SUSPENDED)) or diag("Can't load VMware::VmPerl package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('VMware::VmPerl');
use VMware::VmPerl qw(VM_EXECUTION_STATE_ON VM_EXECUTION_STATE_OFF VM_EXECUTION_STATE_STUCK VM_EXECUTION_STATE_SUSPENDED);

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::VM::Clone') or diag("Can't load HoneyClient::Manager::VM::Clone package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::VM::Clone');
use HoneyClient::Manager::VM::Clone;

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(dclone)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
use Storable qw(dclone);

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure threads loads.
BEGIN { use_ok('threads') or diag("Can't load threads package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads');
use threads;

# Make sure threads::shared loads.
BEGIN { use_ok('threads::shared') or diag("Can't load threads::shared package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads::shared');
use threads::shared;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);

=end testing

=cut

#######################################################################

# Include Threading Library
use threads;
use threads::shared;

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include SOAP Library
use HoneyClient::Util::SOAP qw(getClientHandle);

# Include VM Libraries
use VMware::VmPerl qw(VM_EXECUTION_STATE_ON
                      VM_EXECUTION_STATE_OFF
                      VM_EXECUTION_STATE_STUCK
                      VM_EXECUTION_STATE_SUSPENDED);
use HoneyClient::Manager::VM;

# Use Storable Library
use Storable qw(dclone);

# Use Dumper Library
use Data::Dumper;

# Package Global Variable
our $AUTOLOAD;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# The global variable, used to count the number of
# Clone objects that have been created.
our $OBJECT_COUNT : shared = -1;

=pod

=head1 DEFAULT PARAMETER LIST

When a Clone B<$object> is instantiated using the B<new()> function,
the following parameters are supplied default values.  Each value
can be overridden by specifying the new (key => value) pair into the
B<new()> function, as arguments.

Furthermore, as each parameter is initialized, each can be individually 
retrieved and set at any time, using the following syntax:

  my $value = $object->{key}; # Gets key's value.
  $object->{key} = $value;    # Sets key's value.

=head2 master_vm_config

=over 4

The full absolute path to the master VM's configuration file, whose
contents will be the basis for each subsequently cloned VM.

=back

=head2 config

=over 4

The full absolute path to the cloned VM's configuration file.

=back

=head2 mac_address

=over 4

The MAC address of the cloned VM's primary network interface.

=back

=head2 ip_address

=over 4

The IP address of the cloned VM's primary network interface.

=back

=head2 name

=over 4

The name of the cloned VM.

=back

=head2 database_id

=over 4

The ID of the VM data, if it is stored within a database.

=back

=cut

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# Helper function designed to programmatically get or set parameters
# within this object, through indirect use of the AUTOLOAD function.
#
# It's best to explain by example:
# Assume we have defined a driver object, like the following.
#
# use HoneyClient::Manager::VM::Clone;
# my $clone = HoneyClient::Manager::VM::Clone->new(someVar => 'someValue');
#
# What this function allows us to do, is programmatically, get or set
# the 'someVar' parameter, like:
#
# my $value = $clone->someVar();    # Gets the value of 'someVar'.
# my $value = $clone->someVar('2'); # Sets the value of 'someVar' to '2'
#                                   # and returns '2'.
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
        $LOG->error("Can't access '$name' parameter in class $type!");
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

# Base destructor function.
# Since none of our state data ever contains circular references,
# we can simply leave the garbage collection up to Perl's internal
# mechanism.
sub DESTROY {
    # Get the object.
    my $self = shift;

    if (($OBJECT_COUNT >= 0) && defined($self->{'config'})) {
       
        # Initialize a new handler, but suppress any initial connection errors.
        $self->{'_vm_handle'} = getClientHandle(namespace => "HoneyClient::Manager::VM",
                                                fault_handler => sub { die "ERROR"; });

        $LOG->info("Suspending clone VM (" . $self->{'config'} . ").");
        my $som = undef;
        eval {
            $som = $self->{'_vm_handle'}->suspendVM(config => $self->{'config'});
        };

        # Reinitialize the VM daemon, in case it died from
        # a CTRL-C or other forced termination.
        unless(defined($som)) {
            # Make sure the VM daemon was properly destroyed.
            HoneyClient::Manager::VM->destroy();
            
            # Sleep a bit, in order for the terminated VM daemon to release
            # its network bindings.
            # XXX: See if this is still needed.
            #sleep(20);

            # Reinitialize VM daemon.
            HoneyClient::Manager::VM->init();

            # Reinitialize handler, with errors not suppressed.
            $self->{'_vm_handle'} = getClientHandle(namespace => "HoneyClient::Manager::VM");

            # Call suspendVM one more time...
            $som = $self->{'_vm_handle'}->suspendVM(config => $self->{'config'});
        }

        if (!defined($som)) {
            $LOG->error("Unable to suspend VM (" . $self->{'config'} . ").");
        }

    }

    # Decrement our global object count.
    $OBJECT_COUNT--;
}

END {
    # Upon termination, destroy the global instance of the VM manager.
    if ($OBJECT_COUNT == 0) {
        # XXX: Delete this, eventually.
        $LOG->info("Destroying VM daemon.");
        HoneyClient::Manager::VM->destroy();
    }
}

# Handle SOAP faults.
#
# When initially contacting the HoneyClient::Agent daemon running
# inside the cloned VM, we suppress any "Connection refused" messages
# we initially receive.  If a new cloned VM is slow to respond, we
# assume it's because the initial integrity check is still running
# and the daemon isn't ready to accept commands from the
# HoneyClient::Manager yet.
sub _handleFault {

    # Extract arguments.
    my ($class, $res) = @_;

    # Construct error message.
    # Figure out if the error occurred in transport or over
    # on the other side.
    my $errMsg = $class->transport->status; # Assume transport error.

    if (ref $res) {
        $errMsg = $res->faultcode . ": ".  $res->faultstring . "\n";
    }
    
    if (($errMsg !~ /Connection refused/) &&
        ($errMsg !~ /No route to host/)) {
        $LOG->warn("Error occurred during processing. " . $errMsg);
        Carp::carp __PACKAGE__ . "->_handleFault(): Error occurred during processing.\n" . $errMsg;
    }
}

# Initialized cloned VMs.
#
# If no existing configuration is supplied, then this method creates
# a new clone VM from the supplied master VM.  Furthermore, this method
# will power on the clone, and wait until the clone VM has fully booted and
# has an operational HoneyClient::Agent daemon running on it.
# 
# During this power on process, the name, MAC address, and 
# IP address of the running clone are recorded in the object.
#
# Output: The updated Clone $object, containing state information
# from starting the clone VM.  Will croak if this operation fails.
#
# TODO: Need to configure a timeout failure operation -- in case
# there's a problem and the VM operations hang.
sub _init {

    # Extract arguments.
    my ($self, %args) = @_;

    # Sanity check: Make sure we've been fed an object.
    unless (ref($self)) {
        $LOG->error("Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!");
        Carp::croak "Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!";
    }
    
    # Temporary variable to hold SOAP Object Message.
    my $som = undef;

    # Temporary variable to hold return message data.
    my $ret = undef;

    # If the clone's configuration wasn't supplied initially, then
    # perform the quick clone operation.
    if (!defined($self->{'config'})) {
        $LOG->info("Quick cloning master VM (" . $self->{'master_vm_config'} . ").");
        $som = $self->{'_vm_handle'}->quickCloneVM(src_config => $self->{'master_vm_config'});
        $ret = $som->result();
        if (!$ret) {
            $LOG->fatal("Unable to quick clone master VM (" . $self->{'master_vm_config'} . ").");
            Carp::croak "Unable to quick clone master VM (" . $self->{'master_vm_config'} . ").";
        }
        # Set the cloned VM configuration.
        $self->{'config'} = $ret;
    } else {
        $LOG->debug("Starting clone VM (" . $self->{'config'} . ").");
        $som = $self->{'_vm_handle'}->startVM(config => $self->{'config'});
        $ret = $som->result();
        if (!$ret) {
            $LOG->fatal("Unable to start clone VM (" . $self->{'config'} . ").");
            Carp::croak "Unable to start clone VM (" . $self->{'config'} . ").";
        }
    }

    # Wait until the VM gets registered, before proceeding.
    $LOG->debug("Checking if clone VM (" . $self->{'config'} . ") is registered.");
    $ret = undef;
    while (!defined($ret) or !$ret) {
        $som = $self->{'_vm_handle'}->isRegisteredVM(config => $self->{'config'});
        $ret = $som->result();

        # If the VM isn't registered yet, wait before trying again.
        if (!defined($ret) or !$ret) {
            sleep ($self->{'_retry_period'});
        }
    }

    # Once registered, check if the VM is ON yet.
    $LOG->debug("Checking if clone VM (" . $self->{'config'} . ") is powered on.");
    $ret = undef;
    while (!defined($ret) or ($ret != VM_EXECUTION_STATE_ON)) {
        $som = $self->{'_vm_handle'}->getStateVM(config => $self->{'config'});
        $ret = $som->result();

        # If the VM isn't ON yet, wait before trying again.
        if (!defined($ret) or ($ret != VM_EXECUTION_STATE_ON)) {
            sleep ($self->{'_retry_period'});
        }
    }

    # Now, get the VM's MAC address.
    $LOG->debug("Retrieving MAC address of clone VM (" . $self->{'config'} . ").");
    $som = $self->{'_vm_handle'}->getMACaddrVM(config => $self->{'config'});
    $self->{'mac_address'} = $som->result();

    # Now, get the VM's name.
    $LOG->debug("Retrieving name of clone VM (" . $self->{'config'} . ").");
    $som = $self->{'_vm_handle'}->getNameVM(config => $self->{'config'});
    $self->{'name'} = $som->result();

    # Now, get the VM's IP address.
    $LOG->debug("Retrieving IP address of clone VM (" . $self->{'config'} . ").");
    $ret = undef;
    my $stubAgent = undef;
    my $logMsgPrinted = 0;
    while (!defined($self->{'ip_address'}) or !defined($ret)) {
        $som = $self->{'_vm_handle'}->getIPaddrVM(config => $self->{'config'});
        $self->{'ip_address'} = $som->result();

        # If the VM isn't booted yet, wait before trying again.
        if (!defined($self->{'ip_address'})) {
            sleep ($self->{'_retry_period'});
            next; # skip further processing
        } elsif (!$logMsgPrinted) {
            $LOG->info("Initialized clone VM (" . $self->{'name'} . ") using IP (" .
                       $self->{'ip_address'} . ") and MAC (" . $self->{'mac_address'} . ").");
            $logMsgPrinted = 1;
        }
        
        # Now, try contacting the Agent.
        $stubAgent = getClientHandle(namespace     => "HoneyClient::Agent",
                                     address       => $self->{'ip_address'},
                                     fault_handler => \&_handleFault);

        eval {
            $som = $stubAgent->getStatus();
            $ret = $som->result();
        };
        # Clear returned state, if any fault occurs.
        if ($@) {
            $ret = undef;
        }

        # If the Agent daemon isn't responding yet, wait before trying again.
        if (!defined($ret)) {
            sleep ($self->{'_retry_period'});
        }
    }

    return $self;
}

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 METHODS IMPLEMENTED 

The following functions have been implemented by any Clone object.

=head2 HoneyClient::Manager::VM::Clone->new($param => $value, ...)

=over 4

Creates a new Clone object, which contains a hashtable
containing any of the supplied "param => value" arguments.

I<Inputs>:
 B<$param> is an optional parameter variable.
 B<$value> is $param's corresponding value.
 
Note: If any $param(s) are supplied, then an equal number of
corresponding $value(s) B<must> also be specified.

I<Output>: The instantiated Clone B<$object>, fully initialized
with a ready-to-use cloned honeyclient VM.

=back

=begin testing

# Shared test variables.
my ($stub, $som, $URL);
my $testVM = $ENV{PWD} . "/" . getVar(name      => "test_vm_config",
                                      namespace => "HoneyClient::Manager::VM::Test");

# Include notice, to clarify our assumptions.
diag("About to run basic unit tests; these may take some time.");
diag("Note: These tests *expect* VMware Server or VMware GSX to be installed and running on this system beforehand.");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    $URL = HoneyClient::Manager::VM->init();

    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::VM");

    # In order to test setMasterVM(), we're going to fully clone
    # the testVM, then set the newly created clone as a master VM.

    # Get the test VM's parent directory,
    # in order to create a temporary master VM.
    my $testVMDir = dirname($testVM);
    my $masterVMDir = dirname($testVMDir) . "/test_vm_master";
    my $masterVM = $masterVMDir . "/" . basename($testVM);

    # Create the master VM.
    $som = $stub->fullCloneVM(src_config => $testVM, dest_dir => $masterVMDir);

    # Wait a small amount of time for the asynchronous clone
    # to complete.
    sleep (10);

    # The master VM should be on.
    $som = $stub->getStateVM(config => $masterVM);
   
    # Since the master VM doesn't have an OS installed on it,
    # the VM may be considered stuck.  Go ahead and answer
    # this question, if need be.
    if ($som->result == VM_EXECUTION_STATE_STUCK) {
        $som = $stub->answerVM(config => $masterVM);
    }

    # Turn off the master VM.
    $som = $stub->stopVM(config => $masterVM);

    # Now, kill the VM daemon.
    HoneyClient::Manager::VM->destroy();
    # XXX: See if this is still needed.
    #sleep (10);

    # Create a generic empty clone, with test state data.
    my $clone = HoneyClient::Manager::VM::Clone->new(test => 1, master_vm_config => $masterVM, _dont_init => 1);
    is($clone->{test}, 1, "new(test => 1, master_vm_config => '$masterVM', _dont_init => 1)") or diag("The new() call failed.");
    isa_ok($clone, 'HoneyClient::Manager::VM::Clone', "new(test => 1, master_vm_config => '$masterVM', _dont_init => 1)") or diag("The new() call failed.");
    $clone = undef;

    # Destroy the master VM.
    $som = $stub->destroyVM(config => $masterVM);

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real clone operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_config", namespace => "HoneyClient::Manager::VM") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM?", "no");
    if ($question =~ /^y.*/i) {
        $clone = HoneyClient::Manager::VM::Clone->new(test => 1);
        is($clone->{test}, 1, "new(test => 1)") or diag("The new() call failed.");
        isa_ok($clone, 'HoneyClient::Manager::VM::Clone', "new(test => 1)") or diag("The new() call failed.");
        my $cloneConfig = $clone->{config};
        $clone = undef;
    
        # Destroy the clone VM.
        $som = $stub->destroyVM(config => $cloneConfig);
    }
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::VM->destroy();
# XXX: See if this is still needed.
#sleep (1);

# Report any failure found.
if ($@) {
    fail($@);
}

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
        # The full absolute path to the master VM's configuration file, whose
        # contents will be the basis for each subsequently cloned VM.
        master_vm_config => getVar(name => "master_vm_config"),

        # A variable containing the absolute path to the cloned VM's
        # configuration file.
        config => undef,

        # A variable containing the MAC address of the cloned VM's primary
        # interface.
        mac_address => undef,
    
        # A variable containing the IP address of the cloned VM's primary
        # interface.
        ip_address => undef,
    
        # A variable containing the name the cloned VM.
        name => undef,

        # A variable containing the database identifier, if any is specified.
        database_id => undef,
    
        # A SOAP handle to the VM manager daemon.  (This internal variable
        # should never be modified externally.)
        _vm_handle => undef,

        # A variable indicated how long the object should wait for
        # between subsequent retries to the HoneyClient::Manager::VM
        # daemon (in seconds).  (This internal variable should never
        # be modified externally.)
        _retry_period => 2,
    );

    @{$self}{keys %params} = values %params;

    # Now, overwrite any default parameters that were redefined
    # in the supplied arguments.
    @{$self}{keys %args} = values %args;

    # Now, assign our object the appropriate namespace.
    bless $self, $class;

    # Upon first use, start up a global instance of the VM manager.
    if ($OBJECT_COUNT < 0) {
        HoneyClient::Manager::VM->init();
        $OBJECT_COUNT = 0;
    }

    # Set a valid handle for the VM daemon.
    $self->{'_vm_handle'} = getClientHandle(namespace => "HoneyClient::Manager::VM");

    # If the clone's configuration wasn't supplied initially, then
    # set the master VM to prepare for cloning.
    unless (defined($self->{'config'})) {
        $LOG->info("Setting VM (" . $self->{'master_vm_config'} . ") as master.");
        my $som = $self->{'_vm_handle'}->setMasterVM(config => $self->{'master_vm_config'});
        if (!$som->result()) {
            $LOG->fatal("Unable to set VM (" . $self->{'master_vm_config'} . ") as a master VM.");
            Carp::croak "Unable to set VM (" . $self->{'master_vm_config'} . ") as a master VM.";
        }
    }

    # Update our global object count.
    $OBJECT_COUNT++;

    # Finally, return the blessed object, with a fully initialized
    # cloned VM unless otherwise specified.
    if ($self->{'_dont_init'}) {
        return $self;
    } else {
        return $self->_init();
    }
}

=pod

=head2 $object->archive(snapshot_file => $snapshotFile) 

=over 4

Archives an existing Clone object, by suspending the VM and saving
a tar.gz archive file containing the VM to the B<$SNAPSHOT_PATH>
directory, as specified in the <HoneyClient/><Manager/><VM/>
section of the etc/honeyclient.xml file.

I<Inputs>:
 B<$snapshotFile> is an optional argument, indicating the
full, absolute path and filename of where the snapshot
file should be stored.
 
I<Output>: The archived Clone B<$object>.

I<Notes>:
If B<$snapshotFile> is not specified, all snapshots
will be stored within the directory specified by the 
global variable B<$SNAPSHOT_PATH>, by default.

The format of this destination directory is:
S<"$SNAPSHOT_PATH/$VMDIRNAME-YYYYMMDDThhmmss.tar.gz">, 
using ISO8601 date format variables.

This operation destroys the Clone B<$object>.  Do not
expect to perform any additional operations with 
this object once this call is finished.

=back

=begin testing

# Shared test variables.
my ($stub, $som, $URL);
my $testVM = $ENV{PWD} . "/" . getVar(name      => "test_vm_config",
                                      namespace => "HoneyClient::Manager::VM::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $testVMDir = dirname($testVM);

    # Specify where the snapshot should be created.
    my $snapshot = dirname($testVMDir) . "/test_vm_clone.tar.gz";

    # Pretend as though no other Clone objects have been created prior
    # to this point.
    $HoneyClient::Manager::VM::Clone::OBJECT_COUNT = -1;
    
    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real archive operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_config", namespace => "HoneyClient::Manager::VM") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::VM::Clone->new();
        my $cloneConfig = $clone->{config};

        # Archive the clone.
        $clone->archive(snapshot_file => $snapshot);

        # Wait for the archive to complete.
        sleep (45);
    
        # Test if the archive worked.
        is(-f $snapshot, 1, "archive(snapshot_file => '$snapshot')") or diag("The archive() call failed.");
   
        unlink $snapshot;
        $clone = undef;
    
        # Connect to daemon as a client.
        $stub = getClientHandle(namespace => "HoneyClient::Manager::VM");
    
        # Destroy the clone VM.
        $som = $stub->destroyVM(config => $cloneConfig);
    }
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::VM->destroy();
# XXX: See if this is still needed.
#sleep (1);

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub archive {

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

    # Sanity checks; check if any args were specified.
    my $argsExist = scalar(%args);

    # Extract the VM configuration file.
    my $vmConfig = $self->{'config'};

    # Set the internal VM configuration to undef, in order to
    # avoid potential object DESTROY() calls.
    $self->{'config'} = undef;
    
    $LOG->debug("Archiving clone VM (" . $vmConfig . ").");
    my $som = $self->{'_vm_handle'}->suspendVM(config => $vmConfig);
    if ($argsExist &&
        exists($args{'snapshot_file'}) &&
        defined($args{'snapshot_file'})) {
        $som = $self->{'_vm_handle'}->snapshotVM(config        => $vmConfig,
                                                 snapshot_file => $args{'snapshot_file'});
    } else {
        $som = $self->{'_vm_handle'}->snapshotVM(config => $vmConfig);
    }
    if (!defined($som)) {
        $LOG->error("Unable to archive VM (" . $vmConfig . ").");
    }

    return $self;
}

#######################################################################

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 BUGS & ASSUMPTIONS

Currently, the new() function assumes that the master VM supplied
has been setup and configured according to the specification listed
here:

L<http://www.honeyclient.org/trac/wiki/UserGuide#HoneyclientVM>

Thus, upon cloning, if a cloned VM is unable to properly boot into
Windows and load the HoneyClient::Agent daemon properly, then the
new() call will B<hang indefinately>.

In a nutshell, this object is basically a blessed anonymous
reference to a hashtable, where (key => value) pairs are defined in
the L<DEFAULT PARAMETER LIST>, as well as fed via the new() function
during object initialization.  As such, this package does B<not>
perform any rigorous B<data validation> prior to accepting any new
or overriding (key => value) pairs.

=head1 SEE ALSO

L<perltoot/"Autoloaded Data Methods">

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 AUTHORS

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

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
