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
# Copyright (C) 2007-2009 The MITRE Corporation.  All rights reserved.
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
# TODO: Fix this.
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

# Make sure HoneyClient::Util::EventEmitter loads.
BEGIN { use_ok('HoneyClient::Util::EventEmitter') or diag("Can't load HoneyClient::Util::EventEmitter package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::EventEmitter');
use HoneyClient::Util::EventEmitter;

# Make sure HoneyClient::Manager::Firewall::Client loads.
BEGIN { use_ok('HoneyClient::Manager::Firewall::Client') or diag("Can't load HoneyClient::Manager::Firewall::Client package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall::Client');
use HoneyClient::Manager::Firewall::Client;

# Make sure HoneyClient::Manager::Pcap::Client loads.
BEGIN { use_ok('HoneyClient::Manager::Pcap::Client') or diag("Can't load HoneyClient::Manager::Pcap::Client package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Pcap::Client');
use HoneyClient::Manager::Pcap::Client;

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

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure URI::URL loads.
BEGIN { use_ok('URI::URL')
        or diag("Can't load URI::URL package. Check to make sure the package library is correctly listed within the path."); }
require_ok('URI::URL');
use URI::URL;

# Make sure File::Slurp loads.
BEGIN { use_ok('File::Slurp')
        or diag("Can't load File::Slurp package. Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Slurp');
use File::Slurp;

# Make sure File::Temp loads.
BEGIN { use_ok('File::Temp')
        or diag("Can't load File::Temp package. Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Temp');
use File::Temp;

# Make sure Compress::Zlib loads.
BEGIN { use_ok('Compress::Zlib')
        or diag("Can't load Compress::Zlib package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Compress::Zlib');
use Compress::Zlib;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);

# Make sure HoneyClient::Util::DateTime loads.
BEGIN { use_ok('HoneyClient::Util::DateTime') or diag("Can't load HoneyClient::Util::DateTime package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::DateTime');
use HoneyClient::Util::DateTime;

# Make sure IO::File loads.
BEGIN { use_ok('IO::File') or diag("Can't load IO::File package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IO::File');
use IO::File;

# Make sure VMware::Vix::Simple loads.
BEGIN { use_ok('VMware::Vix::Simple') or diag("Can't load VMware::Vix::Simple package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('VMware::Vix::Simple');
use VMware::Vix::Simple;

# Make sure VMware::Vix::API::Constants loads.
BEGIN { use_ok('VMware::Vix::API::Constants') or diag("Can't load VMware::Vix::API::Constants package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('VMware::Vix::API::Constants');
use VMware::Vix::API::Constants;

# Make sure Perl::Unsafe::Signals loads.
BEGIN { use_ok('Perl::Unsafe::Signals') or diag("Can't load Perl::Unsafe::Signals package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Perl::Unsafe::Signals');
use Perl::Unsafe::Signals;

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

# Make sure Prima::noX11 loads.
BEGIN { use_ok('Prima::noX11') or diag("Can't load Prima::noX11 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Prima::noX11');
require Prima::noX11;

# Make sure Image::Match loads.
BEGIN { use_ok('Image::Match') or diag("Can't load Image::Match package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Image::Match');
require Image::Match;

# Make sure DateTime::HiRes loads.
BEGIN { use_ok('DateTime::HiRes') or diag("Can't load DateTime::HiRes package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure DateTime::Duration loads.
BEGIN { use_ok('DateTime::Duration') or diag("Can't load DateTime::Duration package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::Duration');
use DateTime::Duration;

=end testing

=cut

#######################################################################

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

# Use URL Library
use URI::URL;

# Use File::Slurp Library
use File::Slurp;

# Use File::Temp Library
use File::Temp;

# Use Compress::Zlib Library
use Compress::Zlib;

# Package Global Variable
our $AUTOLOAD;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Include DateTime Libraries
use HoneyClient::Util::DateTime;

# Include Event Emitter Libraries
use HoneyClient::Util::EventEmitter;

# Include Firewall Libraries
use HoneyClient::Manager::Firewall::Client;

# Include Pcap Libraries
use HoneyClient::Manager::Pcap::Client;

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Include IO::File Libraries
use IO::File;

# Include VMware VIX Libraries
use VMware::Vix::Simple;
use VMware::Vix::API::Constants;

# Include Unsafe Signals Library
use Perl::Unsafe::Signals;

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

# Include ISO8601 Date/Time Libraries
use DateTime::HiRes;
use DateTime::Duration;

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

=head2 load_complete_image

=over 4

An optional variable, specifying the filename of the 'load complete'
image to use, when performing image analysis of the screenshot when
the application has successfully loaded all content.

=cut

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# Helper function designed to programmatically get or set parameters
# within this object, through indirect use of the AUTOLOAD function.
#
# It's best to explain by example:
# Assume we have defined an object, like the following.
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

    if ($@) {
        $LOG->error("Encountered an error. " . $@);
    }

    # Get the object.
    my $self = shift;

    # Disconnect from VM via VIX, if enabled.
    if (getVar(name => "vix_enable")) {
        eval {
            $self->_vixDisconnectVM();
        };
        if ($@) {
            $LOG->error("Unable to disconnect from VM. " . $@);
        }
    }

    if (defined($self->{'quick_clone_vm_name'}) &&
        (($self->{'status'} eq 'running') ||
         ($self->{'status'} eq 'initialized') ||
         ($self->{'status'} eq 'uninitialized') ||
         ($self->{'status'} eq 'registered'))) {

# TODO: Delete this, eventually.
$DB::single=1;

        # Signal firewall to deny traffic from this clone.
        # Ignore errors.
        eval {
            $self->_denyNetwork();
        };
       
        $LOG->info("Suspending clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        my $som = undef;
        my $suspended_at = undef;
        eval {
            $suspended_at = HoneyClient::Util::DateTime->now();
            $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        };

        if (!defined($som)) {
            $LOG->error("Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . ").");
            $self->_changeStatus(status => "error");
        } else {
            $self->{'_vm_session'} = $som;
            $self->_changeStatus(status => "suspended", suspended_at => $suspended_at);
        }

        # Upon termination, close our session.
        $LOG->info("Closing ESX session.");
        HoneyClient::Manager::ESX->logout(session => $self->{'_vm_session'});


        # Disconnect from host via VIX, if enabled.
        if (getVar(name => "vix_enable")) {
            eval {
                $self->_vixDisconnectHost();
            };
            if ($@) {
                $LOG->error("Unable to disconnect from host. " . $@);
            }
        }
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
        $LOG->warn("Error occurred during processing. " . $errMsg);
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

        $LOG->info("Quick cloning master VM (" . $self->{'master_vm_name'} . ").");
        ($self->{'_vm_session'}, $ret) = HoneyClient::Manager::ESX->quickCloneVM(session => $self->{'_vm_session'}, src_name => $self->{'master_vm_name'});
        if (!defined($ret)) {
            $LOG->error("Unable to quick clone master VM (" . $self->{'master_vm_name'} . ").");
            Carp::croak "Unable to quick clone master VM (" . $self->{'master_vm_name'} . ").";
        }
        # Set the name of the cloned VM.
        $self->{'quick_clone_vm_name'} = $ret;
        $self->{'_num_snapshots'}++;
        $self->_changeStatus(status => "initialized");

        # Wait until the VM gets registered, before proceeding.
        $LOG->debug("Checking if clone VM (" . $self->{'quick_clone_vm_name'} . ") is registered.");
        $ret = undef;
        while (!defined($ret) or !$ret) {
            ($self->{'_vm_session'}, $ret) = HoneyClient::Manager::ESX->isRegisteredVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

            # If the VM isn't registered yet, wait before trying again.
            if (!defined($ret) or !$ret) {
                sleep ($self->{'_retry_period'});
            }
        }
        # Now, get the VM's configuration.
        $LOG->debug("Retrieving config of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        ($self->{'_vm_session'}, $self->{'config'}) = HoneyClient::Manager::ESX->getConfigVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        $self->_changeStatus(status => "registered");

        # Once registered, check if the VM is ON yet.
        $LOG->debug("Checking if clone VM (" . $self->{'quick_clone_vm_name'} . ") is powered on.");
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
        $LOG->info("Waiting for a valid MAC/IP address of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        $ret = undef;
        my $logMsgPrinted = 0;
        my $ip_address = undef;
        while (!defined($self->{'ip_address'}) or 
               !defined($self->{'mac_address'}) or
               !defined($ret)) {

            ($self->{'_vm_session'}, $self->{'mac_address'}) = HoneyClient::Manager::ESX->getMACaddrVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

            ($self->{'_vm_session'}, $ip_address) = HoneyClient::Manager::ESX->getIPaddrVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
            if (defined($ip_address) && 
                (!defined($self->{'ip_address'}) ||
                 ($ip_address ne $self->{'ip_address'}))) {
                $LOG->info("Clone VM (" . $self->{'quick_clone_vm_name'} . ") has a new IP (" . $ip_address . ") - updating firewall.");
                $self->_denyNetwork();
                $self->{'ip_address'} = $ip_address;
            }

            # If the VM isn't booted yet, wait before trying again.
            if (!defined($self->{'ip_address'}) or !defined($self->{'mac_address'})) {
                $self->_checkForBSOD(snapshot_name => getVar(name => "default_quick_clone_snapshot_name"));
                sleep ($self->{'_retry_period'});
                next; # skip further processing
            } elsif (!$logMsgPrinted) {
                $LOG->info("Initialized clone VM (" . $self->{'quick_clone_vm_name'} . ") using IP (" .
                           $self->{'ip_address'} . ") and MAC (" . $self->{'mac_address'} . ").");

                $LOG->info("Waiting for Agent daemon to initialize inside clone VM.");
                $logMsgPrinted = 1;
            }

            # Signal firewall to allow traffic from this clone through.
            $self->_allowNetwork();
        
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
                $self->_checkForBSOD(snapshot_name => getVar(name => "default_quick_clone_snapshot_name"));
            }

            # If the Agent daemon isn't responding yet, wait before trying again.
            if (!defined($ret)) {
                sleep ($self->{'_retry_period'});

            } else {

                # Generate a new Operational snapshot.
                $LOG->info("Creating a new operational snapshot of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
                ($self->{'_vm_session'}, $self->{'name'}) = HoneyClient::Manager::ESX->snapshotVM(session              => $self->{'_vm_session'},
                                                                                                  name                 => $self->{'quick_clone_vm_name'},
                                                                                                  snapshot_description => getVar(name => "operational_quick_clone_snapshot_description"));
                $self->{'_num_snapshots'}++;
                $LOG->info("Created operational snapshot (" . $self->{'name'} . ") on clone VM (" . $self->{'quick_clone_vm_name'} . ").");

                # XXX: We need to separate this call into 2 smaller ones.
                #      1) Register basic client information.
                #      2) Register OS/application details.
                #      That way, if this function fails for some reason,
                #      we have *some* sort of record in the database about it,
                #      for cleanup purposes.

                # Notify the Drone about the new client.
                my $hostname = undef;
                ($self->{'_vm_session'}, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $self->{'_vm_session'});
                my $ip = undef;
                ($self->{'_vm_session'}, $ip) = HoneyClient::Manager::ESX->getIPaddrESX(session => $self->{'_vm_session'});
                my $message = HoneyClient::Message::Client->new({
                    quick_clone_name => $self->{'quick_clone_vm_name'},
                    snapshot_name    => $self->{'name'},
                    created_at       => HoneyClient::Util::DateTime->now(),
                    host             => {
                        hostname     => $hostname,
                        ip           => $ip,
                    },
                    client_status    => {
                        status       => $self->{'status'},
                    },
                    os               => $ret->{'os'},
                    application      => $ret->{'application'},
                    ip               => $self->{'ip_address'},
                    mac              => $self->{'mac_address'},
                });
                my $result = undef;
                ($result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Client(session => $self->{'_emitter_session'}, action => 'find_or_create', message => $message);
            }
        }
        
    } else {

        # If the quick_clone_vm_name was specified, then revert the existing quick clone to the Operational
        # snapshot that had the IP address fully assigned.  At that point, we assume the Agent code is fully
        # operational.

        # First, make sure that an operational snapshot name was already provided (as a basis).
        if (!defined($self->{'name'})) {
            $LOG->error("Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): No operational snapshot name provided.");
            Carp::croak "Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): No operational snapshot name provided.";
        }

        # Revert to operational snapshot; upon revert, the VM will already be running.
        $LOG->info("Reverting clone VM (" . $self->{'quick_clone_vm_name'} . ") to operational snapshot (" . $self->{'name'} . ").");
        $ret = HoneyClient::Manager::ESX->revertVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'}, snapshot_name => $self->{'name'});
        if (!$ret) {
            $LOG->error("Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to revert to operational snapshot.");
            Carp::croak "Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to revert to operational snapshot.";
        }
        $self->{'_vm_session'} = $ret;

        # Rename operational snapshot to reflect a new VMID.
        ($self->{'_vm_session'}, $self->{'name'}) = HoneyClient::Manager::ESX->renameSnapshotVM(session => $self->{'_vm_session'},
                                                                                                name    => $self->{'quick_clone_vm_name'},
                                                                                                old_snapshot_name        => $self->{'name'},
                                                                                                new_snapshot_description => getVar(name => "operational_quick_clone_snapshot_description"));
        if (!defined($self->{'name'})) {
            $LOG->error("Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to rename operational snapshot.");
            Carp::croak "Unable to start clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to rename operational snapshot.";
        }
        $LOG->info("Renamed operational snapshot on clone VM (" . $self->{'quick_clone_vm_name'} . ") to (" . $self->{'name'} . ").");

        # Now, get the VM's configuration.
        $LOG->debug("Retrieving config of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        ($self->{'_vm_session'}, $self->{'config'}) = HoneyClient::Manager::ESX->getConfigVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

        $LOG->info("Starting clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        $self->{'_vm_session'} = HoneyClient::Manager::ESX->startVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        # Sanity check: Make sure the VM is powered ON.
        $ret = undef;
        while (!defined($ret) or ($ret ne 'poweredon')) {
            $LOG->info("Checking if clone VM (" . $self->{'quick_clone_vm_name'} . ") is powered on.");
            ($self->{'_vm_session'}, $ret) = HoneyClient::Manager::ESX->getStateVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

            # If the VM isn't ON yet, wait before trying again.
            if (!defined($ret) or ($ret ne 'poweredon')) {
                sleep ($self->{'_retry_period'});
            }
        }
        $self->_changeStatus(status => "running");

        $ret = undef;
        while (!defined($ret)) {

            # Signal firewall to allow traffic from this clone through.
            $self->_allowNetwork();

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
                $self->_checkForBSOD(snapshot_name => $self->{'name'});
            }

            # If the Agent daemon isn't responding yet, wait before trying again.
            if (!defined($ret)) {
                sleep ($self->{'_retry_period'});

            } else {

                # XXX: We need to separate this call into 2 smaller ones.
                #      1) Register basic client information.
                #      2) Register OS/application details.
                #      That way, if this function fails for some reason,
                #      we have *some* sort of record in the database about it,
                #      for cleanup purposes.

                # Notify the Drone about the new client.
                my $hostname = undef;
                ($self->{'_vm_session'}, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $self->{'_vm_session'});
                my $ip = undef;
                ($self->{'_vm_session'}, $ip) = HoneyClient::Manager::ESX->getIPaddrESX(session => $self->{'_vm_session'});
                my $message = HoneyClient::Message::Client->new({
                    quick_clone_name => $self->{'quick_clone_vm_name'},
                    snapshot_name    => $self->{'name'},
                    created_at       => HoneyClient::Util::DateTime->now(),
                    host             => {
                        hostname     => $hostname,
                        ip           => $ip,
                    },
                    client_status    => {
                        status       => $self->{'status'},
                    },
                    os               => $ret->{'os'},
                    application      => $ret->{'application'},
                    ip               => $self->{'ip_address'},
                    mac              => $self->{'mac_address'},
                });
                my $result = undef;
                ($result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Client(session => $self->{'_emitter_session'}, action => 'find_or_create', message => $message);
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

# TODO: Change this, eventually.
    # Log resolved arguments.
    $LOG->warn(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

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
        $LOG->error("Error: No status argument supplied.");
        Carp::croak "Error: No status argument supplied.";
    }

    # Don't change the status field for any VM that has been marked
    # as suspicious, compromised, error, bug, or deleted.
    if (($self->{'status'} eq "suspicious") ||
        ($self->{'status'} eq "compromised") ||
        ($self->{'status'} eq "error") ||
        ($self->{'status'} eq "bug") ||
        ($self->{'status'} eq "deleted")) {
        return $self;
    }

    # Change the status field.
    $self->{'status'} = $args{'status'};

    # Notify the Drone that the client status has changed.
    if (defined($self->{'quick_clone_vm_name'}) &&
        defined($self->{'name'})) {
        my $message = HoneyClient::Message::Client->new({
            quick_clone_name => $self->{'quick_clone_vm_name'},
            snapshot_name    => $self->{'name'},
            client_status    => {
                status       => $self->{'status'},
            },
        });
        my $action = 'find_and_update.client_status';

        if ($argsExist &&
            exists($args{'suspended_at'}) &&
            defined($args{'suspended_at'})) {
            $message->set_suspended_at($args{'suspended_at'});
            $action .= '.suspended_at';
        }

        my $result = undef;
        ($result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Client(session => $self->{'_emitter_session'}, action => $action, message => $message);
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
        $LOG->info("Saving fingerprint to '" . $COMPROMISE_FILE . "'.");
        my $dump_file = new IO::File($COMPROMISE_FILE, "a");

        $Data::Dumper::Terse = 0;
        $Data::Dumper::Indent = 2;
        print $dump_file "\$quick_clone_vm_name = \"" . $self->{'quick_clone_vm_name'} . "\";\n";
        print $dump_file "\$snapshot_name = \"" . $self->{'name'} . "\";\n";
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

    # Check if the VM even has network access.
    if ($self->{'_has_network_access'}) {
        return;
    }
    my $result = undef; 

    $LOG->info("Allowing VM (" . $self->{'quick_clone_vm_name'} . ") network access.");

    my $allowed_outbound_ports = getVar(name      => "allowed_outbound_ports",
                                        namespace => "HoneyClient::Manager::Firewall");
    ($result, $self->{'_firewall_session'}) = HoneyClient::Manager::Firewall::Client->allowVM(
            session     => $self->{'_firewall_session'},
            chain_name  => $self->{'quick_clone_vm_name'},
            mac_address => $self->{'mac_address'},
            ip_address  => $self->{'ip_address'},
            # XXX: Need to make this more configurable, by supporting other protocols.
            protocol    => "tcp",
            port        => $allowed_outbound_ports->{'tcp'});
    if ($result) {

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
    my $result = undef; 

    $LOG->info("Denying VM (" . $self->{'quick_clone_vm_name'} . ") network access.");
    
    ($result, $self->{'_firewall_session'}) = HoneyClient::Manager::Firewall::Client->denyVM(session => $self->{'_firewall_session'}, chain_name => $self->{'quick_clone_vm_name'});
    if ($result) {
        # Mark that the VM has been denied network access.
        $self->{'_has_network_access'} = 0;
    }

    $LOG->info("Destroying Packet Capture Session on VM (" . $self->{'quick_clone_vm_name'} . ").");
    ($result, $self->{'_pcap_session'}) = HoneyClient::Manager::Pcap::Client->stopCapture(
        session          => $self->{'_pcap_session'},
        quick_clone_name => $self->{'quick_clone_vm_name'},
        delete_pcap      => 1);
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
        $LOG->warn("Primary datstore has low disk space (" . $datastore_free_in_gb . " GB).");
    } else {
        return;
    }
    $LOG->info("Low disk space detected. Shutting down.");
    exit;
}

# Helper function to check if the initialized clone VM has inadvertently
# generated a BSOD.  We count how many times this function is called; if
# if exceeds max_retry_count, then we re-initialize the VM by reverting
# to the specified snapshot_name.
#
# Inputs: self, snapshot_name
sub _checkForBSOD {
    # Extract arguments.
    my ($self, %args) = @_;

    if ($self->{'_num_failed_inits'} >= getVar(name => "max_retry_count")) {

        # Deny the VM's network, since when we revert, we'll probably be getting a new IP address.
        $self->_denyNetwork();

        $LOG->warn("Detected possible BSOD in initializing clone VM (" . $self->{'quick_clone_vm_name'} . ").");

        # Revert to default snapshot; upon revert, the VM will already be stopped.
        $LOG->info("Reverting clone VM (" . $self->{'quick_clone_vm_name'} . ") to snapshot (" . $args{'snapshot_name'} . ").");
        my $ret = HoneyClient::Manager::ESX->revertVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'}, snapshot_name => $args{'snapshot_name'});
        if (!$ret) {
            $LOG->error("Unable to revert clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to revert to snapshot (" . $args{'snapshot_name'} . ").");
            Carp::croak "Unable to revert clone VM (" . $self->{'quick_clone_vm_name'} . "): Failed to revert to snapshot (" . $args{'snapshot_name'} . ").";
        }
        $self->{'_vm_session'} = $ret;

        $LOG->info("Starting clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        $self->{'_vm_session'} = HoneyClient::Manager::ESX->startVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});

        $self->{'_num_failed_inits'} = 0;
    } else {
        $self->{'_num_failed_inits'}++;

# TODO: Delete this, eventually.
        $LOG->warn("Clone VM (" . $self->{'quick_clone_vm_name'} . ") - _num_failed_inits: " . $self->{'_num_failed_inits'} . ".");
    }
}

#######################################################################
# VIX Helper Methods                                                  #
#######################################################################

# Helper function to connect to the VMware ESX server, via VIX.
# Silently returns if already connected to a host.
# Dies upon any failure.
sub _vixConnectHost {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    if ($self->{'_vix_host_handle'} == VIX_INVALID_HANDLE) {
        $LOG->info("Obtaining VIX host handle.");
        # Connect to the host.
        my $vix_url = URI::URL->new_abs("/sdk", URI::URL->new($self->{'service_url'}));

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            die "VIX Timeout\n";
        };

        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            ($vix_result, $self->{'_vix_host_handle'}) = HostConnect(VIX_API_VERSION,
                                                                    VIX_SERVICEPROVIDER_VMWARE_VI_SERVER,
                                                                    $vix_url,
                                                                    $vix_url->port,
                                                                    $self->{'user_name'},
                                                                    $self->{'password'},
                                                                    0,
                                                                    VIX_INVALID_HANDLE);
        };
        alarm(0);
        if ($vix_result != VIX_OK) {
            die "VIX::HostConnect() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
        }
        $self->{'_vix_host_updated_at'} = DateTime::HiRes->now();
    }
}

# Helper function to connect to a VM the VMware ESX server, via VIX.
# Silently returns if already connected to a VM.
# Dies upon any failure.
sub _vixConnectVM {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    if ($self->{'_vix_vm_handle'} == VIX_INVALID_HANDLE) {
        $LOG->info("Obtaining VIX VM handle.");

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            die "VIX Timeout\n";
        };

        # Open the VM.
        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            ($vix_result, $self->{'_vix_vm_handle'}) = VMOpen($self->{'_vix_host_handle'}, $self->{'config'});
        };
        alarm(0);
        if ($vix_result != VIX_OK) {
            die "VIX::VMOpen() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
        }
        $self->{'_vix_vm_updated_at'} = DateTime::HiRes->now();
    }
}

# Helper function to disconnect from a VM on the VMware ESX server, via VIX.
# Logs any failure.
sub _vixDisconnectVM {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    if (($self->{'_vix_vm_handle'} != VIX_INVALID_HANDLE) &&
        (GetHandleType($self->{'_vix_vm_handle'}) == VIX_HANDLETYPE_VM)) {
        $LOG->info("Releasing VIX VM Handle.");

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            # Issue an error on timeout, but continue.
            $LOG->error("Error: VIX Timeout.");
        };

        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            ReleaseHandle($self->{'_vix_vm_handle'});
        };
        alarm(0);
    }
    $self->{'_vix_vm_handle'} = VIX_INVALID_HANDLE;
}

# Helper function to disconnect from the VMware ESX server, via VIX.
# Logs any failure.
sub _vixDisconnectHost {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    if (($self->{'_vix_host_handle'} != VIX_INVALID_HANDLE) &&
        (GetHandleType($self->{'_vix_host_handle'}) == VIX_HANDLETYPE_HOST)) {
        $LOG->info("Releasing VIX Host Handle.");

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            # Issue an error on timeout, but continue.
            $LOG->error("Error: VIX Timeout.");
        };

        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            HostDisconnect($self->{'_vix_host_handle'});
        };
        alarm(0);
    }
    $self->{'_vix_host_handle'} = VIX_INVALID_HANDLE;
}

# Helper function to indicate if the current host handle on the VMware ESX server is valid.
#
# Output: true if valid; false otherwise.
sub _vixIsHostValid {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Find all registered VMs; if this call fails, then this handle is no longer valid.
    eval {
        my @vm_list = ();

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            die "VIX Timeout\n";
        };

        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            @vm_list = FindItems($self->{'_vix_host_handle'}, VIX_FIND_REGISTERED_VMS, getVar(name => "timeout", namespace => "HoneyClient::Agent"));
        };
        alarm(0);
        $vix_result = shift(@vm_list);
        if ($vix_result != VIX_OK) {
            die "VIX::FindItems() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
        }
    };
    if ($@) {
        return (0);
    }
    return (1);
}

# Helper function to indicate if the current VM handle on the VMware ESX server is valid.
#
# Output: true if valid; false otherwise.
sub _vixIsVMValid {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Find all registered VMs; if this call fails, then this handle is no longer valid.
    eval {
        my $vm_power_state = undef;

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            die "VIX Timeout\n";
        };

        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            ($vix_result, $vm_power_state) = GetProperties($self->{'_vix_vm_handle'},
                                                           VIX_PROPERTY_VM_POWER_STATE);
        };
        alarm(0);
        if ($vix_result != VIX_OK) {
            die "VIX::GetProperties() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
        }
    };
    if ($@) {
        return (0);
    }
    return (1);
}

# Helper function to validate both the host and VM handles.
# Dies upon any failures.
sub _vixValidateHandles {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Validate current host, if older than the given threshold.
    if ((DateTime::HiRes->now() - DateTime::Duration->new(seconds => getVar(name => "session_timeout"))) > $self->{'_vix_host_updated_at'}) {
        if (!$self->_vixIsHostValid()) {
            # Reconnect host and VM, if host is not valid.
            $self->_vixDisconnectVM();
            $self->_vixDisconnectHost();
            $self->_vixConnectHost();
            $self->_vixConnectVM();
        } else {
            # Host remains valid; update timestamp.
            $self->{'_vix_host_updated_at'} = DateTime::HiRes->now();
        }
    }

    # Validate current VM, if older than the given threshold.
    if ((DateTime::HiRes->now() - DateTime::Duration->new(seconds => getVar(name => "session_timeout"))) > $self->{'_vix_vm_updated_at'}) {
        if (!$self->_vixIsVMValid()) {
            # Reconnect VM, if VM is not valid.
            $self->_vixDisconnectVM();
            $self->_vixConnectVM();
        } else {
            # Session remains valid; update timestamp.
            $self->{'_vix_vm_updated_at'} = DateTime::HiRes->now();
        }
    }
}

# Helper function to wait for VMware Tools and
# log into the Guest OS on the VM.
# Dies upon any failures.
sub _vixLoginInGuest {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    $LOG->info("Waiting for VMware Tools.");

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };

    # Make sure we can access VMware Tools.
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        $vix_result = VMWaitForToolsInGuest($self->{'_vix_vm_handle'}, getVar(name => "timeout", namespace => "HoneyClient::Agent"));
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMWaitForToolsInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }

    $LOG->info("Logging into guest OS.");

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };

    # Login to guest OS.
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        $vix_result = VMLoginInGuest($self->{'_vix_vm_handle'},
                                     $self->{'guest_user_name'},
                                     $self->{'guest_password'},
                                     VIX_LOGIN_IN_GUEST_REQUIRE_INTERACTIVE_ENVIRONMENT);
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMLoginInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }
}

# Helper function to maximize the application in the VM.
# Dies upon any failures.
sub _vixMaximizeApplication {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    $LOG->info("Setting application to open in maximized mode.");
    if (!defined($self->{'_maximize_registry_file'})) {
        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            die "VIX Timeout\n";
        };
        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            ($vix_result, $self->{'_maximize_registry_file'}) = VMCreateTempFileInGuest($self->{'_vix_vm_handle'}, 0, VIX_INVALID_HANDLE);
        };
        alarm(0);
        if ($vix_result != VIX_OK) {
            die "VIX::VMCreateTempFileInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
        }

        # What do we do, when a VIX call times out.
        local $SIG{ALRM} = sub {
            die "VIX Timeout\n";
        };
        alarm($self->{'_vix_call_timeout'});
        UNSAFE_SIGNALS {
            $vix_result = VMCopyFileFromHostToGuest($self->{'_vix_vm_handle'},
                                                    getVar(name => "maximize_registry", namespace => $self->{'driver_name'}),
                                                    $self->{'_maximize_registry_file'},
                                                    0,
                                                    VIX_INVALID_HANDLE);
        };
        alarm(0);
        if ($vix_result != VIX_OK) {
            die "VIX::VMCopyFileFromHostToGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
        }
    }

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        $vix_result = VMRunProgramInGuest($self->{'_vix_vm_handle'},
                                          # TODO: Should probably not hard-code this path.
                                          'C:\WINDOWS\System32\cmd.exe',
                                          '/C reg import ' . $self->{'_maximize_registry_file'},
                                          0,
                                          VIX_INVALID_HANDLE);
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMRunProgramInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }
}

# Helper function to drive the application in the VM.
# 
# Input: url
#
# Dies upon any failures.
sub _vixDriveApplication {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    $LOG->info("Driving the application.");

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        $vix_result = VMOpenUrlInGuest($self->{'_vix_vm_handle'}, $args{'url'}, 0, VIX_INVALID_HANDLE);
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMOpenUrlInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }
}

# Helper function to capture the screen of the VM.
# Dies upon any failures.
sub _vixCaptureScreenImage {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };
    my $vix_image_size = undef;
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        ($vix_result, $vix_image_size, $self->{'_vix_image_bytes'}) = VMCaptureScreenImage($self->{'_vix_vm_handle'},
                                                                                           VIX_CAPTURESCREENFORMAT_PNG,
                                                                                           VIX_INVALID_HANDLE);
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMCaptureScreenImage() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }
}

# Helper function to close the application in the VM.
# Dies upon any failures.
sub _vixCloseApplication {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    $LOG->info("Listing processes in guest OS.");
    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };
    my @vix_process_properties = ();
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        ($vix_result, @vix_process_properties) = VMListProcessesInGuest($self->{'_vix_vm_handle'}, 0);
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMListProcessesInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }

    foreach my $property (@vix_process_properties) {
        if (($property->{'PROCESS_OWNER'} ne "NT AUTHORITY\\SYSTEM") &&
            ($property->{'PROCESS_NAME'} eq getVar(name => "process_name", namespace => $self->{'driver_name'}))) {
            $LOG->info("Terminating application.");
            # What do we do, when a VIX call times out.
            local $SIG{ALRM} = sub {
                die "VIX Timeout\n";
            };
            alarm($self->{'_vix_call_timeout'});
            UNSAFE_SIGNALS {
                $vix_result = VMKillProcessInGuest($self->{'_vix_vm_handle'}, $property->{'PROCESS_ID'}, 0);
            };
            alarm(0);
            if ($vix_result != VIX_OK) {
                die "VIX::VMKillProcessInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
            }
        } elsif ($property->{'PROCESS_NAME'} eq getVar(name => "process_name", namespace => $self->{'driver_name'})) {

            # XXX: This method is hideously slow, but we have no choice, because if we try to kill an application
            # (using VIX), which is running as "NT AUTHORITY\SYSTEM", we will get permission denied issues.
            # Thankfully, this code will only run for ESX 3.5U4 and earlier deployments -- as VMware fixed this
            # issue in ESX 4.0.

            $LOG->info("Terminating application.");
            # What do we do, when a VIX call times out.
            local $SIG{ALRM} = sub {
                die "VIX Timeout\n";
            };
            alarm($self->{'_vix_call_timeout'});
            UNSAFE_SIGNALS {
                $vix_result = VMRunProgramInGuest($self->{'_vix_vm_handle'},
                                                  # TODO: Probably should not hard code this path.
                                                  'C:\WINDOWS\System32\taskkill.exe',
                                                  '/F /IM ' . getVar(name => "process_name", namespace => $self->{'driver_name'}) . ' /T',
                                                  0,
                                                  VIX_INVALID_HANDLE);
            };
            alarm(0);
            if ($vix_result != VIX_OK) {
                die "VIX::VMRunProgramInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
            }
        }
    }
}

# Helper function to copy a file out of a VM.
#
# Inputs: guest_filename, host_filename
#
# Dies upon any failures.
sub _vixCopyFileFromGuestToHost {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        $vix_result = VMCopyFileFromGuestToHost($self->{'_vix_vm_handle'},
                                                $args{'guest_filename'},
                                                $args{'host_filename'},
                                                0,
                                                VIX_INVALID_HANDLE);
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMCopyFileFromGuestToHost() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }
}

# Helper function to log out of a Guest OS on the VM.
# Dies upon any failures.
sub _vixLogoutFromGuest {
    # Extract arguments.
    my ($self, %args) = @_;

    # VIX Temporary Variables.
    my $vix_result = VIX_OK;

    # Sanity check.
    $self->_vixValidateHandles();

    $LOG->info("Logging off guest OS.");

    # What do we do, when a VIX call times out.
    local $SIG{ALRM} = sub {
        die "VIX Timeout\n";
    };

    # Logout from guest OS.
    alarm($self->{'_vix_call_timeout'});
    UNSAFE_SIGNALS {
        $vix_result = VMLogoutFromGuest($self->{'_vix_vm_handle'});
    };
    alarm(0);
    if ($vix_result != VIX_OK) {
        die "VIX::VMLogoutFromGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n";
    }
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

        # The user name used to authenticate to the guest OS inside the master VM.
        guest_user_name => undef,

        # The password used to authenticate to the guest OS inside the master VM.
        guest_password => undef,

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

        # A variable reflecting the current status of the cloned VM.
        status => "uninitialized",

        # A variable reflecting the driver assigned to this cloned VM.
        driver_name => getVar(name      => "default_driver",
                              namespace => "HoneyClient::Agent"),

        # A variable indicating the number of work units processed by this
        # cloned VM.
        work_units_processed => 0,

        # A variable indicating the filename of the 'load complete' image
        # to use, when performing image analysis of the screenshot when
        # the application has successfully loaded all content.
        load_complete_image => undef,

        # A Vim session object, used as credentials when accessing the
        # VMware ESX server remotely.  (This internal variable
        # should never be modified externally.)
        _vm_session => undef,

        # A Net::Stomp session object, used to interact with the 
        # HoneyClient::Manager::Firewall::Server daemon. (This internal variable
        # should never be modified externally.)
        _firewall_session => undef,

        # A Net::Stomp session object, used to interact with the
        # HoneyClient::Manager::Pcap::Server daemon. (This internal variable
        # should never be modified externally.)
        _pcap_session => undef,

        # A Net::Stomp session object, used to interact with the 
        # Drone server. (This internal variable
        # should never be modified externally.)
        _emitter_session => undef,

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

        # A variable indicating the number of failed retries in attempting
        # to contact the clone VM upon initialization.
        _num_failed_inits => 0,

        # A variable specifying the temporary filename in the guest OS
        # which has the registry settings that force the application to
        # always display in a maximized state.
        _maximize_registry_file => undef,

        # A VIX host handle, used when accessing the VMware ESX server remotely.
        # (This internal variable should never be modified externally.)
        _vix_host_handle => VIX_INVALID_HANDLE,

        # A VIX VM handle, used when accessing the VM on the VMware ESX server
        # remotely.  (This internal variable should never be modified externally.)
        _vix_vm_handle => VIX_INVALID_HANDLE,

        # A buffer, used to store the latest screenshot acquired via VIX.
        # (This internal variable should never be modified externally.)
        _vix_image_bytes => undef,

        # A variable indicating how long to wait for each VIX call to finish.
        # (This internal variable should never be modified externally.)
        _vix_call_timeout => getVar(name => "vix_timeout"),

        # A variable, indicating when the last time the VIX host handle was updated.
        # (This internal variable should never be modified externally.)
        _vix_host_updated_at => undef,

        # A variable, indicating when the last time the VIX VM handle was updated.
        # (This internal variable should never be modified externally.)
        _vix_vm_updated_at => undef,
    );

    @{$self}{keys %params} = values %params;

    # Now, overwrite any default parameters that were redefined
    # in the supplied arguments.
    @{$self}{keys %args} = values %args;

    # Now, assign our object the appropriate namespace.
    bless $self, $class;

    # Sanity check: Make sure guest OS username/password credentials were provided.
    if (!defined($self->{'guest_user_name'})) {
        $LOG->error("Guest OS user name was not provided.  Unable to continue.");
        Carp::croak "Guest OS user name was not provided.  Unable to continue.";
    }
    if (!defined($self->{'guest_password'})) {
        $LOG->error("Guest OS password was not provided.  Unable to continue.");
        Carp::croak "Guest OS password was not provided.  Unable to continue.";
    }

    # Include Image Manipulation Libaries
    require Prima::noX11;
    require Image::Match;

    # Identify the proper 'load complete' image for dynamic image analysis (if specified).
    if (!defined($self->{'load_complete_image'}) ||
        !(-e $self->{'load_complete_image'})) {
        $self->{'load_complete_image'} = getVar(name => "load_complete_image", namespace => $self->{'driver_name'});
    }
    if (-e $self->{'load_complete_image'}) {
        $self->{'load_complete_image'} = Prima::Image->load($self->{'load_complete_image'});
    } else {
        $self->{'load_complete_image'} = undef;
    }
    
    # Set a valid handle for the VM daemon.
    if (!defined($self->{'_vm_session'})) {
        $LOG->info("Creating a new ESX session to (" . $self->{'service_url'} . ").");
        $self->{'_vm_session'} = HoneyClient::Manager::ESX->login(
                                     service_url => $self->{'service_url'},
                                     user_name   => $self->{'user_name'},
                                     password    => $self->{'password'},
                                 );

        # Notify Drone about the new host.
        my $hostname = undef;
        ($self->{'_vm_session'}, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $self->{'_vm_session'});
        my $ip = undef;
        ($self->{'_vm_session'}, $ip) = HoneyClient::Manager::ESX->getIPaddrESX(session => $self->{'_vm_session'});
        my $message = HoneyClient::Message::Host->new({
            hostname => $hostname,
            ip       => $ip,
        });
        my $result = undef;
        ($result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Host(session => $self->{'_emitter_session'}, action => 'find_or_create', message => $message);
    }

    # Sanity check: Make sure there is enough disk space available. 
    $self->_checkSpaceAvailable();

    # Connect (or reconnect) to host via VIX, if enabled.
    if (getVar(name => "vix_enable")) {
        eval {
            $self->_vixDisconnectVM();
            $self->_vixDisconnectHost();
            $self->_vixConnectHost();
        };
        if ($@) {
            $LOG->error("Unable to connect to host. " . $@);
            Carp::croak "Unable to connect to host. " . $@;
        }
    }
    
    # Determine if the firewall needs to be bypassed.
    if ($self->{'_bypass_firewall'}) {
        my $result = undef;
        ($result, $self->{'_firewall_session'}) = HoneyClient::Manager::Firewall::Client->allowAllTraffic(session => $self->{'_firewall_session'});
    }

    # Check to see if this quick clone VM already has reached the
    # maximum number of snapshots.
    if ($self->{'_num_snapshots'} >= getVar(name => "max_num_snapshots")) {

        # If so, then suspend the existing quick clone.
        $LOG->info("Suspending clone VM (" . $self->{'quick_clone_vm_name'} . ") - reached maximum number of snapshots (" . $self->{'_num_snapshots'} . ").");
        my $som = undef;
        eval {
            $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        }; 
        if ($@ || !defined($som)) {
            $LOG->error("Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . "). " . $@);
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
        eval {
            $self->_init();
        };
        if ($@) {
            $LOG->error("Unable to initialize VM (" . $self->{'quick_clone_vm_name'} . ") - Retrying operation. " . $@);
# TODO: Make sure this works!
#$DB::single = 1;

            # Make sure the old VM is at least suspended, before attempting to clone another one.
            $LOG->info("Suspending clone VM (" . $self->{'quick_clone_vm_name'} . ").");
            my $som = undef;
            my $suspended_at = undef;
            eval {
                $suspended_at = HoneyClient::Util::DateTime->now();
                $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
            };

            if (!defined($som)) {
                $LOG->error("Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . ").");
            } else {
                $self->{'_vm_session'} = $som;
                $self->_changeStatus(status => "suspended", suspended_at => $suspended_at);
            }

            my $new_self = HoneyClient::Manager::ESX::Clone->new(%{$self});

            # We mark the old clone VM as an "error" and move on.
            $self->_changeStatus(status => "error");
            $self = $new_self;
        }
        # Connect to VM and login via VIX, if enabled.
        if (getVar(name => "vix_enable")) {
            eval {
                $self->_vixConnectVM();
                $self->_vixLoginInGuest();
            };
            if ($@) {
                $LOG->error("Unable to connect and login to VM. " . $@);
                Carp::croak "Unable to connect and login to VM. " . $@;
            }
        }
        return $self;
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
        $LOG->info("Saving operational snapshot (" . $self->{'name'} . ") of clone VM (" . $self->{'quick_clone_vm_name'} . ").");
        my $som = undef;
        my $suspended_at = undef;
        eval {
            $suspended_at = HoneyClient::Util::DateTime->now();
            ($self->{'_vm_session'}, $som) = HoneyClient::Manager::ESX->snapshotVM(session              => $self->{'_vm_session'},
                                                                                   name                 => $self->{'quick_clone_vm_name'},
                                                                                   snapshot_name        => $self->{'name'},
                                                                                   snapshot_description => getVar(name => "compromised_quick_clone_snapshot_description"),
                                                                                   ignore_collisions    => 1);
        };
        if ($@ || !defined($som)) {
            $LOG->error("Unable to save operational snapshot (" . $self->{'name'} . ") on clone VM (" . $self->{'quick_clone_vm_name'} . "). " . $@);
            # Try at least to suspend the VM, when an error occurs.
            eval {
                $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
            };
            if (!defined($som)) {
                $LOG->error("Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . ").");
            } else {
                $self->{'_vm_session'} = $som;
            }
            $self->_changeStatus(status => "error");
        } else {
            $self->{'_num_snapshots'}++;
            $self->_changeStatus(status => "suspended", suspended_at => $suspended_at);
        }
    }

    # In the best case, Even though the VM is technically not "suspended" at this point, the expectation is that
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
    $LOG->info("Destroying snapshot (" . $self->{'name'} . ") on clone VM (" . $self->{'quick_clone_vm_name'} . ").");
    my $som = undef;
    eval {
        ($self->{'_vm_session'}, $som) = HoneyClient::Manager::ESX->renameSnapshotVM(session                  => $self->{'_vm_session'},
                                                                                     name                     => $self->{'quick_clone_vm_name'},
                                                                                     old_snapshot_name        => $self->{'name'},
                                                                                     new_snapshot_name        => "Deleted Snapshot",
                                                                                     new_snapshot_description => getVar(name => "operational_quick_clone_snapshot_description"),
                                                                                     ignore_collisions        => 1);
    };
    if ($@ || !defined($som)) {
        $LOG->error("Unable to remove snapshot (" . $self->{'name'} .  ") on clone VM (" . $self->{'quick_clone_vm_name'} . "). " . $@);
        # Try at least to suspend the VM, when an error occurs.
        eval {
            $som = HoneyClient::Manager::ESX->suspendVM(session => $self->{'_vm_session'}, name => $self->{'quick_clone_vm_name'});
        };
        if (!defined($som)) {
            $LOG->error("Unable to suspend VM (" . $self->{'quick_clone_vm_name'} . ").");
        } else {
            $self->{'_vm_session'} = $som;
        }
        $self->_changeStatus(status => "error");
    } else {
        # Record the new name of the operational snapshot.
        $self->_changeStatus(status => "deleted");
        $self->{'name'} = $som;
    }

    return $self;
}

=pod

=head2 $object->drive(job => $job)

=over 4

Drives the Agent running inside the Clone VM, based upon
the job supplied.  If any portion of the work causes the
VM to become compromised, then the compromised VM will be
suspended, archived, and logged -- while a new clone VM
will be created to continue processing the remaining
work.

I<Inputs>:
 B<$job> is a required argument, referencing a 
HoneyClient::Message::Job, which contains URLs to pass to
the driven application, running on the Agent inside
the cloned VM.

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

# TODO: Fix this.
        $clone = $clone->drive(work => { 'http://www.google.com/' => 1 });
# TODO: Fix this.
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
        !exists($args{'job'}) ||
        !defined($args{'job'}) ||
        ref($args{'job'}) ne "HoneyClient::Message::Job") {

        # Croak if no valid argument is supplied.
        $LOG->error("Error: Invalid job supplied.");
        Carp::croak "Error: Invalid job supplied.";
    }

    $LOG->info("Processing Job (" . $args{'job'}->uuid() . ").");

    # Record the start time of the job (in seconds).
    my $start_time = time;

    # Sort the URLs by priority - highest one first.
    my @urls = sort {$b->priority() <=> $a->priority()} $args{'job'}->urls();

    # Declare a completed urls array for final reporting.
    my @completed_urls = ();

    # Clear all extraneous data from the job, but retain the uuid and job_alerts.
    my $job_alerts = [];
    foreach my $job_alert ($args{'job'}->job_alerts()) {
        push(@{$job_alerts}, $job_alert->to_hashref);
    }
    $args{'job'} = HoneyClient::Message::Job->new({uuid => $args{'job'}->uuid(), job_alerts => $job_alerts});

    # Temporary variables.
    my $som;
    my $result;
    my $emit_result;
    my $vm_status;

    # Notify the Drone that we've acquired the job.
    my $message = HoneyClient::Message::Job->new({
        uuid   => $args{'job'}->uuid(),
        client => {
            quick_clone_name => $self->{'quick_clone_vm_name'},
            snapshot_name    => $self->{'name'},
        },
    });
    $emit_result = undef;
    ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => 'find_and_update.client', message => $message);

    # If the Job is empty, then immediately complete it.
    if (@urls <= 0) {
        $args{'job'}->set_completed_at(HoneyClient::Util::DateTime->now());
        $emit_result = undef;
        ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => 'find_and_update.completed_at', message => $args{'job'});

        return $self;
    }

    for my $url_counter (0..$#urls) {
        # Get the next URL.
        my $url = $urls[$url_counter];

        # Clear the URL priority - otherwise Drone will not properly update url->time_at() fields.
        $url->clear_priority();

        # Before driving, check if a work unit limit has been specified
        # and if we've exceeded that limit.
        if ((getVar(name => "work_unit_limit") > 0) &&
            ($self->{'work_units_processed'} >= getVar(name => "work_unit_limit"))) {

            $LOG->info("(" . $self->{'quick_clone_vm_name'} . ") - Work Unit Limit Reached (" . getVar(name => "work_unit_limit") . ").  Recycling clone VM.");
            $self->destroy();
        }

        # Create a new clone, if the current clone is not already running.
        if ($self->{'status'} ne "running") {
            # Be sure to carry over any customizations into the newly created
            # clones.
            $self = HoneyClient::Manager::ESX::Clone->new(
                        _vm_session           => $self->{'_vm_session'},
                        _firewall_session     => $self->{'_firewall_session'},
                        _pcap_session         => $self->{'_pcap_session'},
                        master_vm_name        => $self->{'master_vm_name'},
                        quick_clone_vm_name   => $self->{'quick_clone_vm_name'},
                        driver_name           => $self->{'driver_name'},
                        name                  => $self->{'name'},
                        mac_address           => $self->{'mac_address'},
                        ip_address            => $self->{'ip_address'},
                        _num_snapshots        => $self->{'_num_snapshots'},
                        guest_user_name       => $self->{'guest_user_name'},
                        guest_password        => $self->{'guest_password'},
                        service_url           => $self->{'service_url'},
                        _emitter_session      => $self->{'_emitter_session'},
                        user_name             => $self->{'user_name'},
                        password              => $self->{'password'},
                        _vix_host_handle      => $self->{'_vix_host_handle'},
                        _vix_call_timeout     => $self->{'_vix_call_timeout'},
                        _vix_host_updated_at  => $self->{'_vix_host_updated_at'},
                    );

            # Notify the Drone that we've acquired the job.
            my $message = HoneyClient::Message::Job->new({
                uuid   => $args{'job'}->uuid(),
                client => {
                    quick_clone_name => $self->{'quick_clone_vm_name'},
                    snapshot_name    => $self->{'name'},
                },
            });
            $emit_result = undef;
            ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => 'find_and_update.client', message => $message);
        }

        # Set the VM status.
        $vm_status = $self->{'status'};

        # Record which client is about to visit this URL.
        $url->set_client(HoneyClient::Message::Client->new({
            quick_clone_name => $self->{'quick_clone_vm_name'},
            snapshot_name    => $self->{'name'},
        }));

        my $capture_result = undef;
        $LOG->info("Starting Packet Capture Session on VM (" . $self->{'quick_clone_vm_name'} . ").");
        ($capture_result, $self->{'_pcap_session'}) = HoneyClient::Manager::Pcap::Client->startCapture(
            session          => $self->{'_pcap_session'},
            quick_clone_name => $self->{'quick_clone_vm_name'},
            mac_address      => $self->{'mac_address'});

        # Drive the Agent.
        $result                    = undef;

        # VIX Temporary Variables.
        my $vix_driver_timeout     = getVar(name      => "timeout",
                                            namespace => "HoneyClient::Agent::Driver");
        eval {
            $LOG->info("(" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Driving To Resource: " . $url->url());
            $self->{'work_units_processed'}++;

            if ($url->has_wait_id()) {
                # Before we assign a user configurable timeout, we want to check to make sure the user's
                # timeout doesn't exceed our range of valid timeout values.  For example, if the user
                # specifies a timeout of 10 mins but we wait only for 2 mins, then we will always get
                # communications errors and flag the VM as 'error'.
                my $agent_timeout = getVar(name      => "timeout",
                                           namespace => "HoneyClient::Agent");

                # The minimum amount of time it takes to get back valid data from the Agent service via SOAP.
                my $agent_soap_delay = 20;
                my $agent_max_timeout = $agent_timeout - $agent_soap_delay;
                my $agent_min_timeout = 2;
              
                # Sanity checks. 
                if ($url->wait_id() > $agent_max_timeout) {
                    $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Ignoring Invalid Timeout (" . $url->wait_id() . ") - Using Timeout Value (" . $agent_max_timeout . ")");
                    $vix_driver_timeout = $agent_max_timeout;
                } elsif ($url->wait_id() < $agent_min_timeout) {
                    $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Ignoring Invalid Timeout (" . $url->wait_id() . ") - Using Timeout Value (" . $agent_min_timeout . ")");
                    $vix_driver_timeout = $agent_min_timeout;
                } else {
                    $vix_driver_timeout = $url->wait_id();
                }
            }

            if (!getVar(name => "vix_enable")) {

                # If we don't use VIX, then pass the available options down to the Agent.
                # Take a screenshot, if asked.
                my $screenshot = undef;
                if ($url->has_screenshot_id()) {
                    $screenshot = $url->screenshot_id(); 
                }

                $som = $self->{'_agent_handle'}->drive(driver_name => $self->{'driver_name'},
                                                       parameters  => encode_base64($url->url()),
                                                       screenshot  => $screenshot,
                                                       timeout     => $vix_driver_timeout);
                $result = thaw(decode_base64($som->result()));

                # If integrity check didn't pass, then try and perform automated malware extraction using VIX.
                if (scalar(@{$result->{'fingerprint'}->{'os_processes'}})) {
                    eval {
                        $self->_vixConnectHost();
                        $self->_vixConnectVM();
                        $self->_vixLoginInGuest();
                        $LOG->info("Attempting malware extraction.");

                        foreach my $process (@{$result->{'fingerprint'}->{'os_processes'}}) {
                            if (exists($process->{'process_files'}) &&
                                defined($process->{'process_files'})) {
        
                                foreach my $process_file (@{$process->{'process_files'}}) {
                                    if (($process_file->{'event'} eq 'Write') &&
                                        exists($process_file->{'file_content'}) &&
                                        defined($process_file->{'file_content'}) &&
                                        exists($process_file->{'name'}) &&
                                        defined($process_file->{'name'}) &&
                                        exists($process_file->{'file_content'}->{'size'}) &&
                                        defined($process_file->{'file_content'}->{'size'}) &&
                                        ($process_file->{'file_content'}->{'size'} > 0)) {

                                        eval {
                                            # Create a temp file on the host to store the data.
                                            my $temp_file = File::Temp->new();
        
                                            $LOG->info("Extracting file (" . $process_file->{'name'} . ").");
                                            $self->_vixCopyFileFromGuestToHost(guest_filename => $process_file->{'name'},
                                                                               host_filename  => $temp_file->filename);
                                            $process_file->{'file_content'}->{'data'} = encode_base64(compress(read_file($temp_file->filename, binmode => ':raw')));
                                        };
                                        if ($@) {
                                            $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - Encountered error during file extraction. " . $@);
                                        }
                                    }
                                }
                            }
                        }
                        $self->_vixDisconnectVM();
                        $self->_vixDisconnectHost();
                    };
                    if ($@) {
                        $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - Encountered error during file extraction. " . $@);
                    }
                }

            } else {
                # We use VIX, instead of relying on the Agent code.

                # If a 'load complete' image was defined and the 'end early' flag was specified and true,
                # then we can expect an image analysis will be performed.
                if (defined($self->{'load_complete_image'}) && 
                    $url->has_end_early_if_load_complete_id() &&
                    $url->end_early_if_load_complete_id() &&
                    (($url_counter == 0) ||
                    (($url_counter > 0) &&
                    (!$url->has_reuse_browser_id() ||
                    !$url->reuse_browser_id())))) {

                    # As such, make sure the target application is always maximized.
                    $self->_vixMaximizeApplication();
                }

                # Drive the browser.
                my $visit_start_time = time;
                $self->_vixDriveApplication(url => $url->url());

                # Adjust $vix_driver_timeout to account for load delay.
                $vix_driver_timeout = $vix_driver_timeout - (time - $visit_start_time);
                if ($vix_driver_timeout < 0) {
                    $vix_driver_timeout = 0;
                }

                # If a 'load complete' image was defined and the 'end early' flag was specified and true,
                # then perform image analysis of the VM's screen to determine if the application has finished loading all content.
                if (defined($self->{'load_complete_image'}) && 
                    $url->has_end_early_if_load_complete_id() &&
                    $url->end_early_if_load_complete_id()) {

                    # Figure out how many samples we can perform.
                    my $image_sample_delay = getVar(name => "image_sample_delay", namespace => $self->{'driver_name'});
                    my $max_num_loops  = 0;
                    my $remaining_time = 0;
                    {
                        use integer;
                        # We add one to our delay, since it takes about 1 second to acquire an image.
                        $max_num_loops  = $vix_driver_timeout / ($image_sample_delay + 1);
                        $remaining_time = $vix_driver_timeout % ($image_sample_delay + 1);
                    };

                    # Start sampling the VM's display.
                    my $load_complete = 0;
                    my $loop_count    = 0;
                    while ($loop_count < $max_num_loops) {
                        # Sleep until next cycle.
                        sleep($image_sample_delay);

                        # Acquire sample.
                        $LOG->info("Checking if content has fully rendered.");
                        $self->_vixCaptureScreenImage();
                        open (my $IMAGE_DATA, "<:scalar", \$self->{'_vix_image_bytes'}) or
                            die "Unable to extract VM screenshot contents. " . $!;
                        my $screenshot = Prima::Image->load($IMAGE_DATA);
                        my $status_bar = $screenshot->extract( 
                                            getVar(name => "load_complete_image", namespace => $self->{'driver_name'}, attribute => "x"),
                                            getVar(name => "load_complete_image", namespace => $self->{'driver_name'}, attribute => "y"),
                                            getVar(name => "load_complete_image", namespace => $self->{'driver_name'}, attribute => "width"),
                                            getVar(name => "load_complete_image", namespace => $self->{'driver_name'}, attribute => "height"));

                        my ($x,$y) = $status_bar->match($self->{'load_complete_image'});
                        if (defined($x) && defined($y)) {
                            $LOG->info("Load complete.");
                            $load_complete = 1;
                            last;
                        }
                        $loop_count++;
                    }
                    # If we found no matching 'load complete' images, then wait for the remaining time of the timeout.
                    if (!$load_complete) {
                        sleep($remaining_time);
                    }
                
                } else {
                    # Else, if we're not doing any type of image analysis, then
                    # sleep for the specified timeout.
                    sleep($vix_driver_timeout);
                }

                # Take a screenshot, if asked.
                if (!defined($self->{'_vix_image_bytes'}) && $url->has_screenshot_id() && $url->screenshot_id()) {
                    $LOG->info("Taking screenshot.");
                    $self->_vixCaptureScreenImage();
                }

                # Perform an integrity check.
                $som = $self->{'_agent_handle'}->check();
                $result = thaw(decode_base64($som->result()));
    
                # If the integrity check passes and either we've completed the job or we want a fresh browser
                # per URL, then close the browser.
                if ((scalar(@{$result->{'fingerprint'}->{'os_processes'}}) == 0) &&
                    (($url_counter == $#urls) ||
                    !$url->has_reuse_browser_id() ||
                    !$url->reuse_browser_id())) {
                    $self->_vixCloseApplication();
                } elsif (scalar(@{$result->{'fingerprint'}->{'os_processes'}})) {
                    # Integrity check didn't pass, so try and perform automated malware extraction.
                    $LOG->info("Attempting malware extraction.");
    
                    foreach my $process (@{$result->{'fingerprint'}->{'os_processes'}}) {
                        if (exists($process->{'process_files'}) &&
                            defined($process->{'process_files'})) {
    
                            foreach my $process_file (@{$process->{'process_files'}}) {
                                if (($process_file->{'event'} eq 'Write') &&
                                    exists($process_file->{'file_content'}) &&
                                    defined($process_file->{'file_content'}) &&
                                    exists($process_file->{'name'}) &&
                                    defined($process_file->{'name'}) &&
                                    exists($process_file->{'file_content'}->{'size'}) &&
                                    defined($process_file->{'file_content'}->{'size'}) &&
                                    ($process_file->{'file_content'}->{'size'} > 0)) {
    
                                    eval {
                                        # Create a temp file on the host to store the data.
                                        my $temp_file = File::Temp->new();
    
                                        $LOG->info("Extracting file (" . $process_file->{'name'} . ").");
                                        $self->_vixCopyFileFromGuestToHost(guest_filename => $process_file->{'name'},
                                                                           host_filename  => $temp_file->filename);
                                        $process_file->{'file_content'}->{'data'} = encode_base64(compress(read_file($temp_file->filename, binmode => ':raw')));
                                    };
                                    if ($@) {
                                        $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - Encountered error during file extraction. " . $@);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        };
        if ($@) {
            # We lost communications with the Agent; assume the worst
            # and mark the VM as suspicious.
            $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - Encountered Error or Lost Communication with Agent! Assuming Integrity Check: FAILED. " . $@);

            $url->set_url_status(HoneyClient::Message::UrlStatus->new({status => "error"}));

            # Mark the VM as error.
            $vm_status = "error";

        # Figure out if there was a compromise found.
        } elsif (scalar(@{$result->{'fingerprint'}->{'os_processes'}})) {
            $LOG->warn("(" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Integrity Check: FAILED");

            # Dump the fingerprint to a file, if need be.
            $self->_dumpFingerprint($result->{'fingerprint'});

            $url->set_url_status(HoneyClient::Message::UrlStatus->new({status => "suspicious"}));

            # Mark the VM as suspicious and insert the fingerprint, if possible.
            $vm_status = "suspicious";

        } else {
            $LOG->info("(" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - Integrity Check: PASSED");

            $url->set_url_status(HoneyClient::Message::UrlStatus->new({status => "visited"}));
        }

        $LOG->info("Stopping Packet Capture Session on VM (" . $self->{'quick_clone_vm_name'} . ").");
        ($capture_result, $self->{'_pcap_session'}) = HoneyClient::Manager::Pcap::Client->stopCapture(
            session          => $self->{'_pcap_session'},
            quick_clone_name => $self->{'quick_clone_vm_name'});

        # Construct the basic action.
        my $action = 'find_and_update.urls.url_status.ip.time_at.client';

        # If possible, insert work history.
# TODO: Fix this - use local time, not integrity check time (?).
        if (defined($result) &&
            exists($result->{'time_at'}) &&
            defined($result->{'time_at'})) {
            $url->set_time_at($result->{'time_at'});
        } else {
            $url->set_time_at(HoneyClient::Util::DateTime->epoch());
        }

        # If defined, insert screenshot data.
        if ($url->has_screenshot_id() && $url->screenshot_id()) {
            if (defined($self->{'_vix_image_bytes'})) {
                $url->set_screenshot_data(encode_base64(compress($self->{'_vix_image_bytes'})));
                $action .= ".screenshot_data";
                # Clear the screenshot buffer.
                $self->{'_vix_image_bytes'} = undef;
            } elsif (defined($result) && 
                     exists($result->{'screenshot'}) && 
                     defined($result->{'screenshot'})) { 
                $url->set_screenshot_data($result->{'screenshot'});
                $action .= ".screenshot_data";
            }
        }

        # Figure out the destination TCP port associated with this URL.
        my $dst_tcp_port = undef;
        my $ip_result = undef;
        eval {
            $dst_tcp_port = URI::URL->new($url->url())->port;
        };

        # If possible, get the IP address associated with this URL.
        if (defined($dst_tcp_port)) {
            ($ip_result, $self->{'_pcap_session'}) = HoneyClient::Manager::Pcap::Client->getFirstIP(
                session          => $self->{'_pcap_session'},
                quick_clone_name => $self->{'quick_clone_vm_name'},
                src_ip_address   => $self->{'ip_address'},
                dst_tcp_port     => $dst_tcp_port);
            # If we got back valid data, then set the IP address of the URL.
            if (defined($ip_result) && ($ip_result ne "")) {
                $url->set_ip($ip_result);
            }
        }

        if (!defined($ip_result) || ($ip_result eq "")) {
            # If we can't get the IP of the initial server, then we assume the connection timed out.
            $url->set_url_status(HoneyClient::Message::UrlStatus->new({status => "timed_out"}));
        }

        # Store this completed URL.
        push(@completed_urls, $url);

        # Transmit the Job updates.
        # To conserve bandwidth, we only emit events in any of the following conditions:
        # - The job is complete.
        # - The current URL was found to be suspicious.
        # - For all other URLs, emit if URL's fingerprint will always be generated.

        # Check if this is the last URL.
        if ($url_counter == $#urls) {
            $args{'job'}->set_completed_at(HoneyClient::Util::DateTime->now());
            $action .= ".completed_at";

            # Calculate how many URLs per hour we've averaged.
            my $urls_per_hour = (($#urls * 3600) / (time - $start_time));
            $args{'job'}->set_urls_per_hour($urls_per_hour);
            $LOG->info("(" . $self->{'quick_clone_vm_name'} . ") - " . $self->{'driver_name'} . " - URLs/Hour: " . $urls_per_hour);

            # Add all the completed URLs back into the job.  This allows other programs
            # to easily pick out "completed" jobs versus "in process" jobs.
            foreach my $entry (@completed_urls) {
                $args{'job'}->add_urls($entry);
            }

            # TODO: Delete this, eventually.
            $Data::Dumper::Terse = 0;
            $Data::Dumper::Indent = 1;
            #print Dumper($args{'job'}->to_hashref) . "\n";

            $emit_result = undef;
            ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => $action, message => $args{'job'});

            # Once we've emitted the job update, be sure to clear the URL list.
            $args{'job'}->clear_urls();

        } elsif ($vm_status eq 'suspicious') {
            $args{'job'}->add_urls($url);

            # TODO: Delete this, eventually.
            $Data::Dumper::Terse = 0;
            $Data::Dumper::Indent = 1;
            #print Dumper($args{'job'}->to_hashref) . "\n";

            $emit_result = undef;
            ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => $action, message => $args{'job'});

            # Once we've emitted the job update, be sure to clear the URL list.
            $args{'job'}->clear_urls();

        } elsif ($url->has_always_fingerprint_id() &&
                 $url->always_fingerprint_id()) {

            $args{'job'}->add_urls($url);

            # TODO: Delete this, eventually.
            $Data::Dumper::Terse = 0;
            $Data::Dumper::Indent = 1;
            #print Dumper($args{'job'}->to_hashref) . "\n";

            $emit_result = undef;
            ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => $action, message => $args{'job'});

            # Once we've emitted the job update, be sure to clear the URL list.
            $args{'job'}->clear_urls();
        }

        # If the VM is marked as bug, error, or suspicious, then suspend it.
        # XXX: We call suspend AFTER we've emitted our events.  We assume
        # that event emissions will not take significantly long; otherwise,
        # malware could be running inside the VM needlessly longer than we'd like.
        if ($vm_status ne $self->{'status'}) {

            # Check if a fingerprint was supplied.
            if (defined($result) && scalar(@{$result->{'fingerprint'}->{'os_processes'}})) {

                # Corellate the fingerprint to the URL.
                $result->{'fingerprint'}->{'url'} = {
                    # XXX: We assume there are always unique (url,time_at) entries and
                    # no such duplicates occur.
                    url          => $url->url(),
                    time_at      => $url->time_at(),
                    # XXX: This field is for informational use only, as the Drone does not use it.
                    job_id       => $args{'job'}->uuid(),
                };

                # Figure out if we have a valid PCAP.
                my $pcap_file = undef;
                ($pcap_file, $self->{'_pcap_session'}) = HoneyClient::Manager::Pcap::Client->getPcapFile(
                    session          => $self->{'_pcap_session'},
                    quick_clone_name => $self->{'quick_clone_vm_name'});

                # If we have a valid PCAP file name, then try to set the fingerprint's pcap attribute accordingly.
                if (defined($pcap_file) && ($pcap_file ne "") && (-r $pcap_file)) {
                    $result->{'fingerprint'}->{'pcap'} = encode_base64(compress(read_file($pcap_file, binmode => ':raw')));
                }

                # Emit fingerprint.
                my $message = HoneyClient::Message::Fingerprint->new($result->{'fingerprint'});

                # TODO: Delete this, eventually.
                $Data::Dumper::Terse = 0;
                $Data::Dumper::Indent = 1;
                #print Dumper($message->to_hashref) . "\n";

                $emit_result = undef;
                ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Fingerprint(session => $self->{'_emitter_session'}, action => 'create.fingerprint.os_processes.process_files.process_registries', message => $message);
            } 

            $self->suspend();
            $self->_changeStatus(status => $vm_status);

        } elsif (defined($result) &&
                 (scalar(@{$result->{'fingerprint'}->{'os_processes'}}) <= 0) &&
                 $url->has_always_fingerprint_id() &&
                 $url->always_fingerprint_id()) {
            # If we were forced to always generate a fingerprint and we didn't encounter an error or suspicious activity,
            # then generate an empty fingerprint with the corresponding PCAP data.

            # Corellate the fingerprint to the URL.
            $result->{'fingerprint'}->{'url'} = {
                # XXX: We assume there are always unique (url,time_at) entries and
                # no such duplicates occur.
                url          => $url->url(),
                time_at      => $url->time_at(),
                # XXX: This field is for informational use only, as the Drone does not use it.
                job_id       => $args{'job'}->uuid(),
            };

            # Figure out if we have a valid PCAP.
            my $pcap_file = undef;
            ($pcap_file, $self->{'_pcap_session'}) = HoneyClient::Manager::Pcap::Client->getPcapFile(
                session          => $self->{'_pcap_session'},
                quick_clone_name => $self->{'quick_clone_vm_name'});

            # If we have a valid PCAP file name, then try to set the fingerprint's pcap attribute accordingly.
            if (defined($pcap_file) && ($pcap_file ne "") && (-r $pcap_file)) {
                $result->{'fingerprint'}->{'pcap'} = encode_base64(compress(read_file($pcap_file, binmode => ':raw')));

                # Only emit the fingerprint, if we're successful at PCAP extraction (since we know there's no other data).
                # Emit fingerprint.
                my $message = HoneyClient::Message::Fingerprint->new($result->{'fingerprint'});

                # TODO: Delete this, eventually.
                $Data::Dumper::Terse = 0;
                $Data::Dumper::Indent = 1;
                #print Dumper($message->to_hashref) . "\n";

                $emit_result = undef;
                ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Fingerprint(session => $self->{'_emitter_session'}, action => 'create.fingerprint.os_processes.process_files.process_registries', message => $message);
            }
        }

        # Create a new clone, if a compromise was found.
        if ($self->{'status'} eq "suspicious") {
            # Be sure to carry over any customizations into the newly created
            # clones.
            $self = HoneyClient::Manager::ESX::Clone->new(
                        _vm_session           => $self->{'_vm_session'},
                        _firewall_session     => $self->{'_firewall_session'},
                        _pcap_session         => $self->{'_pcap_session'},
                        master_vm_name        => $self->{'master_vm_name'},
                        quick_clone_vm_name   => $self->{'quick_clone_vm_name'},
                        driver_name           => $self->{'driver_name'},
                        name                  => $self->{'name'},
                        mac_address           => $self->{'mac_address'},
                        ip_address            => $self->{'ip_address'},
                        _num_snapshots        => $self->{'_num_snapshots'},
                        guest_user_name       => $self->{'guest_user_name'},
                        guest_password        => $self->{'guest_password'},
                        service_url           => $self->{'service_url'},
                        _emitter_session      => $self->{'_emitter_session'},
                        user_name             => $self->{'user_name'},
                        password              => $self->{'password'},
                        _vix_host_handle      => $self->{'_vix_host_handle'},
                        _vix_call_timeout     => $self->{'_vix_call_timeout'},
                        _vix_host_updated_at  => $self->{'_vix_host_updated_at'},
                    );

            # Notify the Drone that we've acquired the job.
            my $message = HoneyClient::Message::Job->new({
                uuid   => $args{'job'}->uuid(),
                client => {
                    quick_clone_name => $self->{'quick_clone_vm_name'},
                    snapshot_name    => $self->{'name'},
                },
            });
            $emit_result = undef;
            ($emit_result, $self->{'_emitter_session'}) = HoneyClient::Util::EventEmitter->Job(session => $self->{'_emitter_session'}, action => 'find_and_update.client', message => $message);
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

Copyright (C) 2007-2009 The MITRE Corporation.  All rights reserved.

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
