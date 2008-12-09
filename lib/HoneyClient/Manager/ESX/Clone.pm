#######################################################################
# Created on:  June 15, 2007
# Package:     HoneyClient::Manager::ESX::Clone
# File:        Clone.pm
# Description: Generic object model for handling a single HoneyClient
#              cloned VM on the VMware ESX system.
#
# CVS: $Id$
#
# @author kindlund, jpuchalski
#
# Copyright (C) 2007-2008 The MITRE Corporation.  All rights reserved.
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

HoneyClient::Manager::ESX::Clone - Perl extension to provide a generic object
model for handling a single HoneyClient cloned VM on the VMware ESX system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::ESX::Clone version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::ESX::Clone;

  # Library used exclusively for debugging complex objects.
  use Data::Dumper;

  # Create a new cloned VM, using the default
  # 'master_vm_name' listed in the global configuration
  # file (etc/honeyclient.xml).
  my $clone = HoneyClient::Manager::ESX::Clone->new(
      service_url => "https://esx_server/sdk/vimService",
      user_name   => "root",
      password    => "password",
  );

  # When the new() operation completes, you are guaranteed that the
  # cloned VM is powered on, has an IP address, and has a HoneyClient::Agent daemon
  # ready for use.
  
  # Let's get the path to the newly created clone's configuration file.
  my $config = $clone->{'config'};

  # Figure out which master VM this clone is based on.
  my $master_vm_name = $clone->{'master_vm_name'};
  
  # Figure out which quick clone VM this clone is based on.
  my $quick_clone_vm_name = $clone->{'quick_clone_vm_name'};
  
  # Figure out which operational snapshot this clone is based on.
  my $name = $clone->{'name'};

  # Get the MAC address of the cloned VM's primary network interface.
  my $mac_address = $clone->{'mac_address'};

  # Get the IP address of the cloned VM's primary network interface.
  my $ip_address = $clone->{'ip_address'};

  # Specify the type of work you want the clone to handle.
  my $work = {
      "http://www.google.com/" => 1,
      "http://www.cnn.com/" => 1,
      "http://www.mitre.org/" => 10,
  };

  # Drive the clone, using the work specified.
  $clone = $clone->drive(work => $work);

  # Suspend and archive the cloned VM to the snapshot_path directory.
  $clone->suspend(perform_snapshot => 1);

  # If you want the cloned VM to be suspended and no longer used,
  # simply set the variable to 'undef'.
  $clone = undef;

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

Note: If an existing cloned VM's quick_clone_vm_name and operational snapshot
name is specified in the new() call, then the "Clone" object will reuse this
VM (by not creating any duplicate VMs) and proceed to power up this VM, along
with going through the same verification procedures.

=cut

package HoneyClient::Manager::ESX::Clone;

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

    # This allows declaration use HoneyClient::Manager::ESX::Clone ':all';
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

# Make sure HoneyClient::Manager::ESX loads.
BEGIN { use_ok('HoneyClient::Manager::ESX') or diag("Can't load HoneyClient::Manager::ESX package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::ESX');
use HoneyClient::Manager::ESX;

# Make sure HoneyClient::Manager::Database loads.
BEGIN { use_ok('HoneyClient::Manager::Database') or diag("Can't load HoneyClient::Manager::Database package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Database');
use HoneyClient::Manager::Database;

# Make sure HoneyClient::Manager::Firewall loads.
BEGIN { use_ok('HoneyClient::Manager::Firewall') or diag("Can't load HoneyClient::Manager::Firewall package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall');
use HoneyClient::Manager::Firewall;

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::ESX::Clone') or diag("Can't load HoneyClient::Manager::ESX::Clone package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::ESX::Clone');
use HoneyClient::Manager::ESX::Clone;

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(dclone thaw)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
can_ok('Storable', 'thaw');
use Storable qw(dclone thaw);

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

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

# Make sure Thread::Semaphore loads.
BEGIN { use_ok('Thread::Semaphore') or diag("Can't load Thread::Semaphore package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Thread::Semaphore');
use Thread::Semaphore;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);

# Make sure DateTime::HiRes loads.
BEGIN { use_ok('DateTime::HiRes') or diag("Can't load Sys::HostIP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure IO::File loads.
BEGIN { use_ok('IO::File') or diag("Can't load IO::File package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IO::File');
use IO::File;

=end testing

=cut

#######################################################################

# Include Threading Library
use threads;
use threads::shared;
use Thread::Semaphore;

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include SOAP Library
use HoneyClient::Util::SOAP qw(getClientHandle);

# Include VM Libraries
use HoneyClient::Manager::ESX;

# Use Storable Library
use Storable qw(dclone thaw);

# Use Dumper Library
use Data::Dumper;

# Package Global Variable
our $AUTOLOAD;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Use DateTime::HiRes Libraries
use DateTime::HiRes;

# Include Database Libraries
use HoneyClient::Manager::Database;

# Include Firewall Libraries
use HoneyClient::Manager::Firewall;

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Include IO::File Libraries
use IO::File;

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

=head2 service_url

=over 4

The URL of the VIM webservice running on the VMware ESX Server.
This is usually in the format of:
https://esx_server/sdk/vimService

=back

=head2 user_name

=over 4

The user name used to authenticate to the VMware ESX Server.
Note: This user should have Administrator rights.

=back

=head2 password

=over 4

The password used to authenticate to the VMware ESX Server.

=back

=head2 master_vm_name

=over 4

The name of the master VM, whose contents will be the basis
for each subsequently cloned VM.

=back

=head2 quick_clone_vm_name

=over 4

The name of the quick clone VM, whose contents will be the basis
for this cloned VM.

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

The snapshot name of the cloned VM.

=back

=head2 database_id

=over 4

The ID of the VM instance, if it is stored within the Drone database.

=back

=head2 status

=over 4

The status of the cloned VM.

=back

=head2 driver_name

=over 4

The Driver assigned to this cloned VM.

=back

=head2 work_units_processed

=over 4

The number of work units processed by this VM.

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
# use HoneyClient::Manager::ESX::Clone;
# my $clone = HoneyClient::Manager::ESX::Clone->new(someVar => 'someValue');
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

    if (defined($self->{'quick_clone_vm_name'}) &&
        (($self->{'status'} eq 'running') ||
         ($self->{'status'} eq 'initialized') ||
         ($self->{'status'} eq 'uninitialized') ||
         ($self->{'status'} eq 'registered'))) {
        # Signal firewall to deny traffic from this clone.
        # Ignore errors.
        eval {
            $self->_denyNetwork();
        };
       
        $LOG->info("Thread ID (" . threads->tid() . "): Suspending clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        my $som = undef;
        eval {
            $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        };

        if (!defined($som)) {
            $LOG->error("Thread ID (" . threads->tid() . "): Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . ").");
            $self->_changeStatus(status => "error");
        } else {
            $self->{'_vm_session'} = $som;
            $self->_changeStatus(status => "suspended");
        }

        # Upon termination, close our session.
        $LOG->info("Thread ID (" . threads->tid() . "): Closing ESX session.");
        HoneyClient::Manager::ESX->logout(session => $self->{'_vm_session'});
    }
}

# Handle Agent SOAP faults.
#
# When initially contacting the HoneyClient::Agent daemon running
# inside the cloned VM, we suppress any "Connection refused" messages
# we initially receive.  If a new cloned VM is slow to respond, we
# assume it's because the initial integrity check is still running
# and the daemon isn't ready to accept commands from the
# HoneyClient::Manager yet.
sub _handleAgentFault {

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
        $LOG->warn("Thread ID (" . threads->tid() . "): Error occurred during processing. " . $errMsg);
        Carp::carp __PACKAGE__ . "->_handleAgentFault(): Error occurred during processing.\n" . $errMsg;
    }
}

# Initialized cloned VMs.
#
# If no existing quick_clone_vm_name is supplied, then this method creates
# a new clone VM from the supplied master VM.  Otherwise, if a
# quick_clone_vm_name is supplied, then the existing clone VM is used and
# reverted to an operational snapshot for immediate use.
#
# Furthermore, this method will power on the clone, and wait until
# the clone VM has fully booted and has an operational HoneyClient::Agent
# daemon running on it.
# 
# During this power on process, the name, MAC address, and 
# IP address of the running clone are recorded in the object.
#
# Output: The updated Clone $object, containing state information
# from starting the clone VM.  Will croak if this operation fails.
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

    # Determine if the quick_clone_vm_name was specified.
    if (!defined($self->{'quick_clone_vm_name'}) ||
        !defined($self->{'name'}) ||
        !defined($self->{'mac_address'}) ||
        !defined($self->{'ip_address'})) {

        # If the quick_clone_vm_name wasn't specified, then create a new quick clone from the master_vm_name
        # and initialize it completely.

        $LOG->info("Thread ID (" . threads->tid() . "): Quick cloning master VM (" . $self->{'master_vm_name'} . ").");
        ($self->{'_vm_session'}, $ret) = HoneyClient::Manager::ESX->quickCloneVM(session => $self->{'_vm_session'}, src_name => $self->{'master_vm_name'});
        if (!defined($ret)) {
            $LOG->fatal("Thread ID (" . threads->tid() . "): Unable to quick clone master VM (" . $self->{'master_vm_name'} . ").");
            Carp::croak "Unable to quick clone master VM (" . $self->{'master_vm_name'} . ").";
        }
        # Set the name of the cloned VM.
        $self->{'quick_clone_vm_name'} = $ret;
        $self->{'_num_snapshots'}++;
        $self->_changeStatus(status => "initialized");

        # Wait until the VM gets registered, before proceeding.
        $LOG->debug("Thread ID (" . threads->tid() . "): Checking if clone VM (" . $self->{'quick_clone_vm_name'} . ") is registered.");
        $ret = undef;
        while (!defined($ret) or !$ret) {
            ($self->{'_vm_session'}, $ret) = HoneyClient::Manager::ESX->isRegisteredVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

            # If the VM isn't registered yet, wait before trying again.
            if (!defined($ret) or !$ret) {
                sleep ($self->{'_retry_period'});
            }
        }
        # Now, get the VM's configuration.
        $LOG->debug("Thread ID (" . threads->tid() . "): Retrieving config of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        ($self->{'_vm_session'}, $self->{'config'}) = HoneyClient::Manager::ESX->getConfigVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        $self->_changeStatus(status => "registered");

        # Once registered, check if the VM is ON yet.
        $LOG->debug("Thread ID (" . threads->tid() . "): Checking if clone VM (" . $self->{'quick_clone_vm_name'} . ") is powered on.");
        $ret = undef;
        while (!defined($ret) or ($ret ne 'poweredon')) {
            ($self->{'_vm_session'}, $ret) = HoneyClient::Manager::ESX->getStateVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

            # If the VM isn't ON yet, wait before trying again.
            if (!defined($ret) or ($ret ne 'poweredon')) {
                sleep ($self->{'_retry_period'});
            }
        }
        $self->_changeStatus(status => "running");
    

        # Now, get the VM's MAC/IP address.
        $LOG->info("Thread ID (" . threads->tid() . "): Waiting for a valid MAC/IP address of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        $ret = undef;
        my $logMsgPrinted = 0;
        while (!defined($self->{'ip_address'}) or 
               !defined($self->{'mac_address'}) or
               !defined($ret)) {
            ($self->{'_vm_session'}, $self->{'mac_address'}) = HoneyClient::Manager::ESX->getMACaddrVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
            ($self->{'_vm_session'}, $self->{'ip_address'}) = HoneyClient::Manager::ESX->getIPaddrVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

            # If the VM isn't booted yet, wait before trying again.
            if (!defined($self->{'ip_address'}) or !defined($self->{'mac_address'})) {
                sleep ($self->{'_retry_period'});
                next; # skip further processing
            } elsif (!$logMsgPrinted) {
                $LOG->info("Thread ID (" . threads->tid() . "): Initialized clone VM (" . $self->{'quick_clone_vm_name'} . ") using IP (" .
                           $self->{'ip_address'} . ") and MAC (" . $self->{'mac_address'} . ").");

                # Signal firewall to allow traffic from this clone through.
                $self->_allowNetwork();

                $LOG->info("Thread ID (" . threads->tid() . "): Waiting for Agent daemon to initialize inside clone VM.");
                $logMsgPrinted = 1;
            }
        
            # Now, try contacting the Agent.
            $self->{'_agent_handle'} = getClientHandle(namespace     => "HoneyClient::Agent",
                                                       address       => $self->{'ip_address'},
                                                       fault_handler => \&_handleAgentFault);

            eval {
                $som = $self->{'_agent_handle'}->getProperties(driver_name => $self->{'driver_name'});
                $ret = $som->result();
            };
            # Clear returned state, if any fault occurs.
            if ($@) {
                $ret = undef;
            }

            # If the Agent daemon isn't responding yet, wait before trying again.
            if (!defined($ret)) {
                sleep ($self->{'_retry_period'});

            } elsif (getVar(name      => "enable",
                            namespace => "HoneyClient::Manager::Database")) {

                # Generate a new Operational snapshot.
                $LOG->info("Thread ID (" . threads->tid() . "): Creating a new operational snapshot of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
                ($self->{'_vm_session'}, $self->{'name'}) = HoneyClient::Manager::ESX->snapshotVM(session              => $self->{'_vm_session'},
                                                                                                  name                 => $self->{'quick_clone_vm_name'},
                                                                                                  snapshot_description => getVar(name => "operational_quick_clone_snapshot_description"));
                $self->{'_num_snapshots'}++;
                $LOG->info("Thread ID (" . threads->tid() . "): Created operational snapshot (" . $self->{'name'} . ") on clone VM (" . $self->{'quick_clone_vm_name'} . ").");

                # Register the cloned VM with the Drone database.
                my $dt = DateTime::HiRes->now(time_zone => "local");
   
                # XXX: We need to separate this call into 2 smaller ones.
                #      1) Register basic client information.
                #      2) Register OS/application details.
                #      That way, if this function fails for some reason,
                #      we have *some* sort of record in the database about it,
                #      for cleanup purposes.

                # Construct the 'Client' object.
                my $hostname = undef;
                ($self->{'_vm_session'}, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $self->{'_vm_session'});
                my $ip = undef;
                ($self->{'_vm_session'}, $ip) = HoneyClient::Manager::ESX->getIPaddrESX(session => $self->{'_vm_session'});
                my $client = {
                    cid => $self->{'quick_clone_vm_name'},
                    snapshot_name => $self->{'name'},
                    status => $self->{'status'},
                    host => {
                        org => getVar(name => "organization"),
                        hostname => $hostname,
                        ip => $ip,
                    },
                    os => $ret,
                    start => $dt->ymd('-').'T'.$dt->hms(':'),
                };
                $self->{'database_id'} = HoneyClient::Manager::Database::insert_client($client);
            }
        }
        
    } else {

        # If the quick_clone_vm_name was specified, then revert the existing quick clone to the Operational
        # snapshot that had the IP address fully assigned.  At that point, we assume the Agent code is fully
        # operational.

        # First, make sure that an operational snapshot name was already provided (as a basis).
        if (!defined($self->{'name'})) {
            $LOG->fatal("Thread ID (" . threads->tid() . "): Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): No operational snapshot name provided.");
            Carp::croak "Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): No operational snapshot name provided.";
        }

        # Revert to operational snapshot; upon revert, the VM will already be running.
        $LOG->info("Thread ID (" . threads->tid() . "): Reverting clone VM (" . $self->{'quick_clone_vm_name'} . ") to operational snapshot (" . $self->{'name'} . ").");
        $ret = HoneyClient::Manager::ESX->revertVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'}, snapshot_name => $self->{'name'});
        if (!$ret) {
            $LOG->fatal("Thread ID (" . threads->tid() . "): Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to revert to operational snapshot.");
            Carp::croak "Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to revert to operational snapshot.";
        }
        $self->{'_vm_session'} = $ret;

        # Rename operational snapshot to reflect a new VMID.
        ($self->{'_vm_session'}, $self->{'name'}) = HoneyClient::Manager::ESX->renameSnapshotVM(session => $self->{'_vm_session'},
                                                                                                name    => $self->{'quick_clone_vm_name'},
                                                                                                old_snapshot_name        => $self->{'name'},
                                                                                                new_snapshot_description => getVar(name => "operational_quick_clone_snapshot_description"));
        if (!defined($self->{'name'})) {
            $LOG->fatal("Thread ID (" . threads->tid() . "): Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to rename operational snapshot.");
            Carp::croak "Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to rename operational snapshot.";
        }
        $LOG->info("Thread ID (" . threads->tid() . "): Renamed operational snapshot on clone VM (" . $self->{'quick_clone_vm_name'} . ") to (" . $self->{'name'} . ").");
        $self->_changeStatus(status => "running");

        $ret = undef;
        while (!defined($ret)) {

            # Try contacting the Agent.
            $self->{'_agent_handle'} = getClientHandle(namespace     => "HoneyClient::Agent",
                                                       address       => $self->{'ip_address'},
                                                       fault_handler => \&_handleAgentFault);

            eval {
                $som = $self->{'_agent_handle'}->getProperties(driver_name => $self->{'driver_name'});
                $ret = $som->result();
            };
            # Clear returned state, if any fault occurs.
            if ($@) {
                $ret = undef;
            }

            # If the Agent daemon isn't responding yet, wait before trying again.
            if (!defined($ret)) {
                sleep ($self->{'_retry_period'});

            } elsif (getVar(name      => "enable",
                            namespace => "HoneyClient::Manager::Database")) {

                # Register the cloned VM with the Drone database.
                my $dt = DateTime::HiRes->now(time_zone => "local");
   
                # XXX: We need to separate this call into 2 smaller ones.
                #      1) Register basic client information.
                #      2) Register OS/application details.
                #      That way, if this function fails for some reason,
                #      we have *some* sort of record in the database about it,
                #      for cleanup purposes.

                # Construct the 'Client' object.
                my $hostname = undef;
                ($self->{'_vm_session'}, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $self->{'_vm_session'});
                my $ip = undef;
                ($self->{'_vm_session'}, $ip) = HoneyClient::Manager::ESX->getIPaddrESX(session => $self->{'_vm_session'});
                my $client = {
                    cid => $self->{'quick_clone_vm_name'},
                    snapshot_name => $self->{'name'},
                    status => $self->{'status'},
                    host => {
                        org => getVar(name => "organization"),
                        hostname => $hostname,
                        ip => $ip,
                    },
                    os => $ret,
                    start => $dt->ymd('-').'T'.$dt->hms(':'),
                };
                $self->{'database_id'} = HoneyClient::Manager::Database::insert_client($client);
            }
        }
    }

    return $self;
}

# Helper function designed to "pop" a key off a given hashtable.
# When given a hashtable reference, this function will extract a valid key
# from the hashtable and delete the (key, value) pair from the
# hashtable.  The key with the highest score is returned.
#
# Inputs: hashref
# Outputs: valid key, or undef if the hash is empty
sub _pop {

    # Get supplied hash reference.
    my $hash = shift;

    # Get the highest score.
    my @array = sort {$$hash{$b} <=> $$hash{$a}} keys %{$hash};
    my $topkey = $array[0];

    # Delete the key from the hashtable.
    if (defined($topkey)) {
        delete $hash->{$topkey};
    }

    # Return the key found.
    return $topkey;
}

# Helper function designed to change the status of a supplied
# VM Clone object.
#
# Input: hashref
#
# Output: The updated Clone $object, reflecting the status change
# of the clone VM.  Will croak if this operation fails.
sub _changeStatus {

    # Extract arguments.
    my ($self, %args) = @_;

    # Sanity check: Make sure we've been fed an object.
    unless (ref($self)) {
        $LOG->error("Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!");
        Carp::croak "Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!";
    }

    # Sanity check.  Make sure we get a valid argument.
    my $argsExist = scalar(%args);
    if (!$argsExist || 
        !exists($args{'status'}) ||
        !defined($args{'status'})) {

        # Croak if no valid argument is supplied.
        $LOG->error("Thread ID (" . threads->tid() . "): Error: No status argument supplied.");
        Carp::croak "Error: No status argument supplied.";
    }

    # Don't change the status field for any VM that has been marked
    # as suspicious, compromised, error, bug, or deleted.
    if (($self->{'status'} eq "suspicious") ||
        ($self->{'status'} eq "compromised") ||
        ($self->{'status'} eq "error") ||
        ($self->{'status'} eq "bug") ||
        ($self->{'status'} eq "deleted")) {
# TODO: Delete this, eventually.
$LOG->warn("Returning out of _changeStatus early; status already: " . $self->{'status'});
        return $self;
    #}
# TODO: Delete this, eventually.
} else {
$LOG->warn("Evaluating _changeStatus; status: " . $self->{'status'} . " -> " . $args{'status'} . "  - db_id: " . $self->{'database_id'});
}

    # Change the status field.
    $self->{'status'} = $args{'status'};

    # Update the corresponding client record in the Drone database.
    if (defined($self->{'database_id'})) {
        for ($self->{'status'}) {
            if (/running/) {
                HoneyClient::Manager::Database::set_client_running($self->{'database_id'});
            } elsif (/suspended/) {
                HoneyClient::Manager::Database::set_client_suspended($self->{'database_id'});
            } elsif (/suspicious/) {
                if (!$argsExist || 
                    !exists($args{'fingerprint'}) ||
                    !defined($args{'fingerprint'})) {

                    # Warn if no valid fingerprint is supplied.
                    $LOG->warn("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - No valid fingerprint found.");
                    Carp::carp __PACKAGE__ . "->_changeStatus(): (" . $self->{'quick_clone_vm_name'} . ") - No valid fingerprint found.";

                    # Mark the VM as suspicious, manually.
                    my $dt = DateTime::HiRes->now(time_zone => "local");
                    HoneyClient::Manager::Database::set_client_suspicious({
                        client_id => $self->{'database_id'},
                        compromise => $dt->ymd('-').'T'.$dt->hms(':'),
                    });

                } else {

                    # Mark the VM as suspicious indirectly, by inserting the fingerprint.

                    $LOG->info("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - Inserting Fingerprint Into Database.");
                    # Make sure the fingerprint contains a client_id.
                    $args{'fingerprint'}->{'client_id'} = $self->{'database_id'};
                    my $fingerprint_id = undef;
                    eval {
                        $fingerprint_id = HoneyClient::Manager::Database::insert_fingerprint($args{'fingerprint'});
                    };
                    if ($@ || ($fingerprint_id == 0) || !defined($fingerprint_id)) {
                        $LOG->warn("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - Failure Inserting Fingerprint: " . $@);
                    } else {
                        $LOG->info("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - Database Insert Successful.");
                    }
                }
            } elsif (/compromised/) {
                HoneyClient::Manager::Database::set_client_compromised($self->{'database_id'});
            } elsif (/deleted/) {
                HoneyClient::Manager::Database::set_client_deleted($self->{'database_id'});
            } elsif (/error/) {
                HoneyClient::Manager::Database::set_client_error($self->{'database_id'});
            } elsif (/bug/) {
                HoneyClient::Manager::Database::set_client_bug($self->{'database_id'});
            }
        }
    }

    return $self;
}

# If specified, dumps the supplied fingerprint information to
# a corresponding file.
# 
# Inputs: self, fingerprint hashref
sub _dumpFingerprint {

    # Get the supplied fingerprint.
    my ($self, $fingerprint) = @_;

    # XXX: Should this be a new .dump file, per compromise?
    # Dump the fingerprint to a file, if needed.
    my $COMPROMISE_FILE = getVar(name => "fingerprint_dump");
    if (length($COMPROMISE_FILE) > 0 &&
        defined($fingerprint)) {
        $LOG->info("Thread ID (" . threads->tid() . "): Saving fingerprint to '" . $COMPROMISE_FILE . "'.");
        my $dump_file = new IO::File($COMPROMISE_FILE, "a");

        $Data::Dumper::Terse = 0;
        $Data::Dumper::Indent = 2;
        print $dump_file "\$vm_name = \"" . $self->{'name'} . "\";\n";
        print $dump_file Dumper($fingerprint);
        $dump_file->close();
    }
}

# Allows the specified VM to use the network.
#
# Inputs: self
sub _allowNetwork {
    # Extract arguments.
    my ($self, %args) = @_;

    # Determine if the firewall needs to be bypassed.
    if ($self->{'_bypass_firewall'}) {
        return;
    }

    $LOG->info("Thread ID (" . threads->tid() . "): Allowing VM (" . $self->{'quick_clone_vm_name'} . ") network access.");

    my $allowed_outbound_ports = getVar(name      => "allowed_outbound_ports",
                                        namespace => "HoneyClient::Manager::Firewall");
    if (HoneyClient::Manager::Firewall->allowVM(
            chain_name  => $self->{'quick_clone_vm_name'},
            mac_address => $self->{'mac_address'},
            ip_address  => $self->{'ip_address'},
            # XXX: Need to make this more configurable, by supporting other protocols.
            protocol    => "tcp",
            ports       => $allowed_outbound_ports->{'tcp'},)) {

        # Mark that the VM has been granted network access.
        $self->{'_has_network_access'} = 1;
    }
}

# Denies the specified VM use of the network.
# 
# Inputs: self
sub _denyNetwork {
    # Extract arguments.
    my ($self, %args) = @_;

    # Determine if the firewall needs to be bypassed.
    if ($self->{'_bypass_firewall'}) {
        return;
    }

    # Check if the VM even has network access.
    if (!$self->{'_has_network_access'}) {
        return;
    }

    $LOG->info("Thread ID (" . threads->tid() . "): Denying VM (" . $self->{'quick_clone_vm_name'} . ") network access.");
    if (HoneyClient::Manager::Firewall->denyVM(chain_name => $self->{'quick_clone_vm_name'})) {
        # Mark that the VM has been denied network access.
        $self->{'_has_network_access'} = 0;
    }
}

# Helper function to check if the VMware ESX system has enough disk
# space available, in order to run the Manager.
#
# Inputs: self
sub _checkSpaceAvailable {
    # Extract arguments.
    my ($self, %args) = @_;

    my $datastore_free = undef;
    ($self->{'_vm_session'}, $datastore_free) = HoneyClient::Manager::ESX->getDatastoreSpaceAvailableESX(session => $self->{'_vm_session'}, name => $self->{'master_vm_name'});

    my $min_space_free = getVar(name      => "min_space_free",
                                namespace => "HoneyClient::Manager::ESX");

    # Convert size to bytes.
    $min_space_free = $min_space_free * 1024 * 1024 * 1024;

    if ($datastore_free < $min_space_free) {
        my $datastore_free_in_gb = sprintf("%.2f", $datastore_free / (1024 * 1024 * 1024));
        $LOG->warn("Thread ID (" . threads->tid() . "): Primary datstore has low disk space (" . $datastore_free_in_gb . " GB).");
    } else {
        return;
    }
    $LOG->info("Thread ID (" . threads->tid() . "): Low disk space detected. Shutting down.");
    exit;
}

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 METHODS IMPLEMENTED 

The following functions have been implemented by any Clone object.

=head2 HoneyClient::Manager::ESX::Clone->new($param => $value, ...)

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
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Include notice, to clarify our assumptions.
diag("About to run basic unit tests; these may take some time.");
diag("Note: These tests *expect* VMware ESX Server to be accessible and running beforehand.");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    # Create a generic empty clone object, with test state data.
    my $clone = HoneyClient::Manager::ESX::Clone->new(
                    service_url      => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                    user_name        => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                    password         => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                    test             => 1, 
                    master_vm_name   => $testVM,
                    _dont_init       => 1,
                    _bypass_firewall => 1,
                );
    is($clone->{test}, 1, "new(" .
                            "service_url => '" . getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test") . "', " .
                            "user_name => '" . getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test") . "', " .
                            "password => '" . getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test") . "', " .
                            "test => 1, " .
                            "master_vm_name => '$testVM', " .
                            "_dont_init => 1, " .
                            "_bypass_firewall => 1)") or diag("The new() call failed.");
    isa_ok($clone, 'HoneyClient::Manager::ESX::Clone', "new(test => 1, master_vm_name => '$testVM', _dont_init => 1, _bypass_firewall => 1)") or diag("The new() call failed.");
    $clone = undef;

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real clone operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM?", "no");
    if ($question =~ /^y.*/i) {
        $clone = HoneyClient::Manager::ESX::Clone->new(
                     service_url    => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                     user_name      => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                     password       => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                     test           => 1
                 );
        is($clone->{test}, 1, "new(test => 1)") or diag("The new() call failed.");
        isa_ok($clone, 'HoneyClient::Manager::ESX::Clone', "new(test => 1)") or diag("The new() call failed.");
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};
        $clone = undef;
    
        # Destroy the clone VM.
        my $session = HoneyClient::Manager::ESX->login(
                          service_url => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                          user_name   => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                          password    => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                      );
        $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

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
        # The URL of the VIM webservice running on the VMware ESX Server.
        service_url => undef,

        # The user name used to authenticate to the VMware ESX Server.
        user_name => undef,

        # The password used to authenticate to the VMware ESX Server.
        password => undef,

        # The name of the master VM, whose
        # contents will be the basis for each subsequently cloned VM.
        master_vm_name => getVar(name => "master_vm_name"),
        
        # The name of the quick clone VM, whose
        # contents will be the basis this cloned VM.
        quick_clone_vm_name => undef,

        # A variable containing the absolute path to the cloned VM's
        # configuration file.
        config => undef,

        # A variable containing the MAC address of the cloned VM's primary
        # interface.
        mac_address => undef,
    
        # A variable containing the IP address of the cloned VM's primary
        # interface.
        ip_address => undef,
    
        # A variable containing the snapshot name the cloned VM.
        name => undef,

        # A variable containing the database identifier, if any is specified.
        database_id => undef,
   
        # A variable reflecting the current status of the cloned VM.
        status => "uninitialized",

        # A variable reflected the driver assigned to this cloned VM.
        driver_name => getVar(name      => "default_driver",
                              namespace => "HoneyClient::Agent"),

        # A variable indicating the number of work units processed by this
        # cloned VM.
        work_units_processed => 0,

        # A Vim session object, used as credentials when accessing the
        # VMware ESX server remotely.  (This internal variable
        # should never be modified externally.)
        _vm_session => undef,

        # A SOAP handle to the Agent daemon.  (This internal variable
        # should never be modified externally.)
        _agent_handle => undef,

        # A variable indicated how long the object should wait for
        # between subsequent retries to any SOAP server
        # daemon (in seconds).  (This internal variable should never
        # be modified externally.)
        _retry_period => 2,

        # A variable indicating if the firewall should be bypassed.
        # (For testing use only.)
        _bypass_firewall => 0,

        # A variable indicating if the cloned VM has been granted
        # network access.
        _has_network_access => 0,

        # A variable indicating the number of snapshots currently
        # associated with this cloned VM.
        _num_snapshots => 0,
    );

    @{$self}{keys %params} = values %params;

    # Now, overwrite any default parameters that were redefined
    # in the supplied arguments.
    @{$self}{keys %args} = values %args;

    # Now, assign our object the appropriate namespace.
    bless $self, $class;
    
    # Set a valid handle for the VM daemon.
    if (!defined($self->{'_vm_session'})) {
        $LOG->info("Thread ID (" . threads->tid() . "): Creating a new ESX session to (" . $self->{'service_url'} . ").");
        $self->{'_vm_session'} = HoneyClient::Manager::ESX->login(
                                     service_url => $self->{'service_url'},
                                     user_name   => $self->{'user_name'},
                                     password    => $self->{'password'},
                                 );
    }

    # Sanity check: Make sure there is enough disk space available. 
    $self->_checkSpaceAvailable();
    
    # Install the default firewall rules only if we're being called by code
    # other than HoneyClient::Manager or by ourselves.
    my $caller = caller();
    if (($caller ne __PACKAGE__) && ($caller ne "HoneyClient::Manager")) {
        $LOG->info("Thread ID (" . threads->tid() . "): Installing default firewall rules.");
        HoneyClient::Manager::Firewall->denyAllTraffic();
    }

    # Determine if the firewall needs to be bypassed.
    if ($self->{'_bypass_firewall'}) {
        HoneyClient::Manager::Firewall->allowAllTraffic();
    }

    # Check to see if this quick clone VM already has reached the
    # maximum number of snapshots.
    if ($self->{'_num_snapshots'} >= getVar(name => "max_num_snapshots")) {

        # If so, then suspend the existing quick clone.
        $LOG->info("Thread ID (" . threads->tid() . "): Suspending clone VM (" . $self->{'quick_clone_vm_name'} . ") - reached maximum number of snapshots (" . $self->{'_num_snapshots'} . ").");
        my $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        
        if (!defined($som)) {
            $LOG->error("Thread ID (" . threads->tid() . "): Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . ").");
        } else {
            $self->{'_vm_session'} = $som;
        }

        # And then clear out the quick_clone_vm_name, name, mac_address, and ip_address,
        # in order for a new quick clone VM to be created upon calling _init().
        $self->{'quick_clone_vm_name'} = undef;
        $self->{'name'}                = undef;
        $self->{'mac_address'}         = undef;
        $self->{'ip_address'}          = undef;
        $self->{'_num_snapshots'}      = 0;
    }

    # Finally, return the blessed object, with a fully initialized
    # cloned VM unless otherwise specified.
    if ($self->{'_dont_init'}) {
        return $self;
    } else {
        return $self->_init();
    }
}

=pod

=head2 $object->suspend(perform_snapshot => $perform_snapshot)

=over 4

Suspends the specified Clone object and (optionally)
creates a new snapshot of this suspended state.

I<Inputs>:
 B<$perform_snapshot> is an optional argument, indicating that the
Clone object should be snapshotted before suspending.
 
I<Output>: The suspended Clone B<$object>.

I<Notes>:
If B<$perform_snapshot> is set to true, then a new
snapshot will be created before the VM is suspended with
a snapshot name of $object->{name}.

This operation alters the Clone B<$object>.  Do not
expect to perform any additional operations with 
this object once this call is finished, since the
underlying VM snapshot has been suspended.

=back

=begin testing

# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real suspend/snapshot operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM and suspending/snapshotting a subsequent clone?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::ESX::Clone->new(
                        service_url      => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                        user_name        => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                        password         => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                        _bypass_firewall => 1,
                    );
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};
        my $name = $clone->{name};

        # Snapshot and suspend the clone.
        $clone->suspend(perform_snapshot => 1);

        # Destroy the clone object.
        $clone->destroy();

        # Wait for the suspend/snapshot to complete.
        sleep (5);

        # Test if the operations worked.
        my $result = HoneyClient::Manager::ESX::_findSnapshot($name, HoneyClient::Manager::ESX::_getViewVMSnapshotTrees(session => $clone->{_vm_session}));
        is(defined($result), 1, "suspend(perform_snapshot => 1)") or diag("The suspend() call failed.");
   
        $clone = undef;

        # Now, destroy the backing cloned VM.
        my $session = HoneyClient::Manager::ESX->login(
                          service_url => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                          user_name   => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                          password    => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                      );
        $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub suspend {

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
    if (!$argsExist || 
        !exists($args{'perform_snapshot'}) ||
        !defined($args{'perform_snapshot'})) {
        $args{'perform_snapshot'} = getVar(name => "snapshot_upon_suspend");
    }

    # Signal firewall to deny traffic from this clone.
    $self->_denyNetwork();

    # Extract the VM configuration file.
    my $vmConfig = $self->{'config'};

    # Set the internal VM configuration to undef, in order to
    # avoid potential object DESTROY() calls.
    $self->{'config'} = undef;

    # Snapshot the VM.
    if ($args{'perform_snapshot'}) {
        $LOG->info("Thread ID (" . threads->tid() . "): Saving operational snapshot (" . $self->{'name'} . ") of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        my $som = undef;
        ($self->{'_vm_session'}, $som) = HoneyClient::Manager::ESX->snapshotVM(session              => $self->{'_vm_session'},
                                                                               name                 => $self->{'quick_clone_vm_name'},
                                                                               snapshot_name        => $self->{'name'},
                                                                               snapshot_description => getVar(name => "compromised_quick_clone_snapshot_description"),
                                                                               ignore_collisions    => 1);

        if (!defined($som)) {
            $LOG->error("Thread ID (" . threads->tid() . "): Unable to save operational snapshot (" . $self->{'name'} . ") on clone VM (" . $self->{'quick_clone_vm_name'} . ").");
            $self->_changeStatus(status => "error");
        } else {
            $self->{'_num_snapshots'}++;
            $self->_changeStatus(status => "suspended");
        }
    }

    # Even though the VM is technically not "suspended" at this point, the expectation is that
    # the VM will be reverted shortly after this call completes.  As such, we forgo any actual
    # suspend calls, as they can be wasteful since the VM will be reverted anyway.

    return $self;
}

=pod

=head2 $object->destroy()

=over 4

Destroys an existing Clone object, by deleting the corresponding
snapshot containing the VM data.

I<Output>: The destroyed Clone B<$object>.

I<Notes>:
This operation alters the Clone B<$object>.  Do not
expect to perform any additional operations with 
this object once this call is finished, since the
underlying VM snapshot has been destroyed.

=back

=begin testing

# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real destroy operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM and destroying a subsequent clone?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::ESX::Clone->new(
                        service_url      => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                        user_name        => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                        password         => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                        _bypass_firewall => 1,
                    );
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};
        my $name = $clone->{name};

        # Destroy the clone object.
        $clone->destroy();

        # Wait for the destroy to complete.
        sleep (5);
    
        # Test if the operations worked.
        my $result = HoneyClient::Manager::ESX::_findSnapshot($name, HoneyClient::Manager::ESX::_getViewVMSnapshotTrees(session => $clone->{_vm_session}));
        is(!defined($result), 1, "destroy()") or diag("The destroy() call failed.");
   
        $clone = undef;

        # Now, destroy the backing cloned VM.
        my $session = HoneyClient::Manager::ESX->login(
                          service_url => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                          user_name   => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                          password    => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                      );
        $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub destroy {

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

    # Signal firewall to deny traffic from this clone.
    $self->_denyNetwork();

    # Remove the clone VM's underlying snapshot.
    # We don't actually delete the snapshot, instead we just obliterate the operational snapshot's
    # original name; that way, it's equivalent to deletion.  We assume the operational snapshot
    # will then be reverted and renamed to the next valid operational snapshot name.
    $LOG->info("Thread ID (" . threads->tid() . "): Destroying snapshot (" . $self->{'name'} . ") on clone VM (" . $self->{'quick_clone_vm_name'} . ").");
    my $som = undef;
    ($self->{'_vm_session'}, $som) = HoneyClient::Manager::ESX->renameSnapshotVM(session                  => $self->{'_vm_session'},
                                                                                 name                     => $self->{'quick_clone_vm_name'},
                                                                                 old_snapshot_name        => $self->{'name'},
                                                                                 new_snapshot_name        => "Deleted Snapshot",
                                                                                 new_snapshot_description => getVar(name => "operational_quick_clone_snapshot_description"),
                                                                                 ignore_collisions        => 1);

    if (!defined($som)) {
        $LOG->error("Thread ID (" . threads->tid() . "): Unable to remove snapshot (" . $self->{'name'} .  ") on clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        $self->_changeStatus(status => "error");
    } else {
        $self->_changeStatus(status => "deleted");
    }

    # Record the new name of the operational snapshot.
    $self->{'name'} = $som;

    return $self;
}

=pod

=head2 $object->drive(work => $work)

=over 4

Drives the Agent running inside the Clone VM, based upon
the work supplied.  If any portion of the work causes the
VM to become compromised, then the compromised VM will be
suspended, archived, and logged -- while a new clone VM
will be created to continue processing the remaining
work.

I<Inputs>:
 B<$work> is a required argument, referencing a hashtable of
different parameters to pass to the driven application,
which is running on the Agent inside the cloned VM.

I<Notes>:
 Each "key" in the $work hashtable is a parameter;
each "value" in the $work hashtable is an integer,
reflecting the priority assigned to that key.  Large values
indicate high priority.

Here is an example of a possible $work hashtable:

 my $work = {
     "http://www.mitre.org/"  => 10, # First to process
     "http://www.google.com/" =>  5, # Second to process
     "http://www.cnn.com/"    =>  1, # Last to process
 };

=back

=begin testing

# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real drive operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning and driving this master VM?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::ESX::Clone->new(
                        service_url      => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                        user_name        => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                        password         => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                        _bypass_firewall => 1,
                    );
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};

        $clone = $clone->drive(work => { 'http://www.google.com/' => 1 });
        isa_ok($clone, 'HoneyClient::Manager::ESX::Clone', "drive(work => { 'http://www.google.com/' => 1})") or diag("The drive() call failed.");
        $clone = undef;

        # Now, destroy the backing cloned VM.
        my $session = HoneyClient::Manager::ESX->login(
                          service_url => getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX::Test"),
                          user_name   => getVar(name => "user_name",   namespace => "HoneyClient::Manager::ESX::Test"),
                          password    => getVar(name => "password",    namespace => "HoneyClient::Manager::ESX::Test"),
                      );
        $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub drive {

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

    # Sanity check.  Make sure we get a valid argument.
    my $argsExist = scalar(%args);
    if (!$argsExist || 
        !exists($args{'work'}) ||
        !defined($args{'work'})) {

        # Croak if no valid argument is supplied.
        $LOG->error("Thread ID (" . threads->tid() . "): Error: No work argument supplied.");
        Carp::croak "Error: No work argument supplied.";
    }

    my $som;
    my $result;
    my $currentWork;
    my $finishedWork = {
        'client_id'     => {},
        'links_visited' => {}, 
        'links_timed_out' => {},
        'links_ignored' => {},
        'links_suspicious' => {},
    };
    my $numWorkInserted;

    while (scalar(%{$args{'work'}})) {

        # Before driving, check if a work unit limit has been specified
        # and if we've exceeded that limit.
        if ((getVar(name => "work_unit_limit") > 0) &&
            ($self->{'work_units_processed'} >= getVar(name => "work_unit_limit"))) {

            $LOG->info("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - Work Unit Limit Reached (" . getVar(name => "work_unit_limit") . ").  Recycling clone VM.");
            $self->destroy();
        }

        # Create a new clone, if the current clone is not already running.
        if ($self->{'status'} ne "running") {
            # Be sure to carry over any customizations into the newly created
            # clones.
            $self = HoneyClient::Manager::ESX::Clone->new(
                        _vm_session           => $self->{'_vm_session'},
                        master_vm_name        => $self->{'master_vm_name'},
                        quick_clone_vm_name   => $self->{'quick_clone_vm_name'},
                        driver_name           => $self->{'driver_name'},
                        name                  => $self->{'name'},
                        mac_address           => $self->{'mac_address'},
                        ip_address            => $self->{'ip_address'},
                        _num_snapshots        => $self->{'_num_snapshots'},
                    );
        }

        # Make sure the database_id is set to the client_id.
        $finishedWork->{'client_id'} = $self->{'database_id'};

        # Extract the highest priority work.
        $currentWork = _pop($args{'work'});

        # Drive the Agent.
        eval {
            $LOG->info("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Driving To Resource: " . $currentWork);
            $self->{'work_units_processed'}++;
            $som = $self->{'_agent_handle'}->drive(driver_name => $self->{'driver_name'},
                                                   parameters  => encode_base64($currentWork));
            $result = thaw(decode_base64($som->result()));
        };
        if ($@) {
            # We lost communications with the Agent; assume the worst
            # and mark the VM as suspicious.
            $LOG->warn("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - Encountered Error or Lost Communication with Agent! Assuming Integrity Check: FAILED");

            # Suspend the cloned VM.
            $self->suspend();

            # If possibile, insert work history.
            # XXX: This may need to be changed; we need to mark these URLs differently.
            #      Technically, the link didn't time out; we lost some sort of communication
            #      with the Agent, when we tried visiting the link.
            $finishedWork->{'links_timed_out'}->{$currentWork} = $result->{'time_at'};
            if (defined($self->{'database_id'})) {
                $numWorkInserted = HoneyClient::Manager::Database::insert_history_urls($finishedWork);
                $LOG->info("Thread ID (" . threads->tid() . "): " . $numWorkInserted . " URL(s) Inserted.");
            }

            # Mark the VM as bug.
            $self->_changeStatus(status => "bug");

        # Figure out if there was a compromise found.
        } elsif (scalar(@{$result->{'fingerprint'}->{os_processes}})) {
            $LOG->warn("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Integrity Check: FAILED");

            # Dump the fingerprint to a file, if need be.
            $self->_dumpFingerprint($result->{'fingerprint'});

            # Suspend the cloned VM.
            $self->suspend();

            # If possibile, insert work history.
            $finishedWork->{'links_suspicious'}->{$currentWork} = $result->{'time_at'};
            if (defined($self->{'database_id'})) {
                $numWorkInserted = HoneyClient::Manager::Database::insert_history_urls($finishedWork);
                $LOG->info("Thread ID (" . threads->tid() . "): " . $numWorkInserted . " URL(s) Inserted.");
            }

            # Mark the VM as suspicious and insert the fingerprint, if possible.
            $self->_changeStatus(status => "suspicious", fingerprint => $result->{'fingerprint'});

        } else {
            $LOG->info("Thread ID (" . threads->tid() . "): (" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Integrity Check: PASSED");
            # If possibile, insert work history.
            $finishedWork->{'links_visited'}->{$currentWork} = $result->{'time_at'};
            if (defined($self->{'database_id'})) {
                $numWorkInserted = HoneyClient::Manager::Database::insert_history_urls($finishedWork);
                $LOG->info("Thread ID (" . threads->tid() . "): " . $numWorkInserted . " URL(s) Inserted.");
            }
        }

        # Flush the work history, after committing to the database.
        $finishedWork->{'links_visited'} = {};
        $finishedWork->{'links_timed_out'} = {};
        $finishedWork->{'links_ignored'} = {};
        $finishedWork->{'links_suspicious'} = {};

        # Create a new clone, if a compromise was found and we still have work to do.
        if (($self->{'status'} eq "suspicious") &&
            scalar(%{$args{'work'}})) {
            # Be sure to carry over any customizations into the newly created
            # clones.
            $self = HoneyClient::Manager::ESX::Clone->new(
                        _vm_session           => $self->{'_vm_session'},
                        master_vm_name        => $self->{'master_vm_name'},
                        quick_clone_vm_name   => $self->{'quick_clone_vm_name'},
                        driver_name           => $self->{'driver_name'},
                        name                  => $self->{'name'},
                        mac_address           => $self->{'mac_address'},
                        ip_address            => $self->{'ip_address'},
                        _num_snapshots        => $self->{'_num_snapshots'},
                    );
        }
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

Copyright (C) 2007-2008 The MITRE Corporation.  All rights reserved.

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
