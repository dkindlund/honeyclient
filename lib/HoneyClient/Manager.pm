#######################################################################
# Created on:  May 11, 2006
# Package:     HoneyClient::Manager
# File:        Manager.pm
# Description: Central library used for manager-based operations.
#
# CVS: $Id$
#
# @author knwang, kindlund
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

HoneyClient::Manager - Perl extension to manage Agent VMs on the
host system.

=head1 VERSION

This documentation refers to HoneyClient::Manager version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager;
  use Data::Dumper;

  # Utility functions to encode configuration data.
  use Storable qw(nfreeze thaw);
  use MIME::Base64 qw(encode_base64 decode_base64);

  # Note: Make sure only one of these "my driver =" lines
  # is uncommented.

  # Use Internet Explorer as the instrumenting application.
  my $driver = "HoneyClient::Agent::Driver::Browser::IE";

  # Use Mozilla Firefox as the instrumenting application.
  #my $driver = "HoneyClient::Agent::Driver::Browser::FF";

  # Start the Manager.
  HoneyClient::Manager->run(

      driver => $driver,

      agent_state => encode_base64(nfreeze({

          $driver => {

              # Specify the next link for the Agent VM to visit.
              next_link_to_visit => "http://www.mitre.org",

              # If you have more than one link, you can also
              # set this type of hashtable:
              links_to_visit => {
                  'http://www.google.com' => 1,
              },
          },

      })),
  );

=head1 DESCRIPTION

This module provides centralized control over provisioning, initializing,
running, and suspending all Agent VMs.  Upon calling the run() function,
the Manager will proceed to create a new clone of the master Honeyclient VM
(aka. an Agent VM) and feed this Agent VM a new list of URLs to crawl.

While the Agent VM is crawling, the Manager will check to make sure the
Agent VM has not been compromised.  If no compromise was found, then the
Manager will signal the Firewall to allow the Agent VM to contact the
next set of network resources (i.e., a webserver).

If the Manager discovers the Agent VM has been compromised, then the
Manager will suspend the clone VM, log the incident, and create a new Agent
VM clone -- where this new clone picks up with the next set of URLs to
crawl.

If there are no URLs left for the Agent VM to visit OR if the user
presses CTRL+C while the Manager is running, then the Manager will
suspend the currently running Agent VM and write its state information
out to the filesystem on the host system.  This file is usually
called 'Manager.dump'; however, the name can be changed by editing
the <HoneyClient/><Manager/><manager_state/> section of the
etc/honeyclient.xml file.

This 'Manager.dump' file contains the set of URLs that the Honeyclients
have visited, ignored, or tried to visit.  In order to determine
which URLs were identified as malicious, you will need to check
the syslog on the host system and search for the keyword of "FAILED".

By default, all cloned VMs that the Manager suspends will have been
flagged as compromised -- unless the set of URLs has been exhausted
or the user prematurely terminates the process (by pressing CTRL+C).

=cut

package HoneyClient::Manager;

use strict;
use warnings FATAL => 'all';
use Config;
use Carp ();

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
    @EXPORT = qw(init destroy);

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Manager ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = (
        'all' => [ qw(init destroy) ],
    );

    # Symbols to autoexport (when qw(:all) tag is used)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

    # Check to see if ithreads are compiled into this version of Perl.
    $Config{useithreads} or Carp::croak "Error: Recompile Perl with ithread support, in order to use this module.\n";

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

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager', qw(init destroy)) or diag("Can't load HoneyClient::Manager package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager');
can_ok('HoneyClient::Manager', 'init');
can_ok('HoneyClient::Manager', 'destroy');
use HoneyClient::Manager qw(init destroy);

# Make sure HonyClient::Manager::VM::Clone loads.
BEGIN { use_ok('HoneyClient::Manager::VM::Clone') or diag("Can't load HoneyClient::Manager::VM::Clone package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::VM::Clone');
use HoneyClient::Manager::VM::Clone;

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getServerHandle getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getServerHandle');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getServerHandle getClientHandle);

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Check if HoneyClient::Manager::Database support is enabled. 
my $DB_ENABLE = getVar(name      => "enable",
                       namespace => "HoneyClient::Manager::Database");
if ($DB_ENABLE) {
    # Make sure HoneyClient::Manager::Database loads.
    require_ok('HoneyClient::Manager::Database');
    require HoneyClient::Manager::Database;
}

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(nfreeze thaw)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
use Storable qw(nfreeze thaw);

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

=end testing

=cut

#######################################################################

# Include the SOAP Utility Library
use HoneyClient::Util::SOAP qw(getClientHandle getServerHandle);

# Include Thread Libraries
use threads;
use threads::shared;
use Thread::Semaphore;
use Thread::Queue;

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);

# Include the VM Utility Libraries
use HoneyClient::Manager::VM::Clone;

# XXX: Remove this, eventually.
# TODO: Include unit tests.
#use HoneyClient::Manager::VM qw();

# Check if HoneyClient::Manager::Database support is enabled. 
our $DB_ENABLE = getVar(name      => "enable",
                        namespace => "HoneyClient::Manager::Database");
our $clientDbId = 0;

if ($DB_ENABLE) {
    require HoneyClient::Manager::Database;
}

# XXX: Remove this, eventually.
use Data::Dumper;

# Make Dumper format more verbose.
$Data::Dumper::Terse = 0;
$Data::Dumper::Indent = 2;

# Include Hash Serialization Utility Libraries
use Storable qw(nfreeze thaw);

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Include Hash Serialization Utility Libraries
use Storable qw(nfreeze thaw);

# TODO: Include unit tests.
use IO::File;

# TODO: Include unit tests.
use DateTime::HiRes;

# TODO: Include unit tests.
use Sys::Hostname::Long;

# TODO: Include unit tests.
use Sys::HostIP;

# TODO: Include unit tests.
use Filesys::DfPortable;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# This is a temporary, shared variable, used to print out the
# state of the agent, when _cleanup() occurs.
# XXX: This variable and all reference to it will be deleted,
# eventually.
our $globalAgentState   = undef;

#This variable is used to count how many times stubAgent's fault
#handler has been called, so that special actions can be taken if
#it is called too many times (for instance when Manager loses 
#connectivity with the Agent it would otherwise loop and get errors
#forever if some action isn't taken)
#NOTE: This will have to be changed to be agent/vm-specific in the
#future when we have multiple Agents interacting with a single 
#Manager.
our $globalAgentErrorCount = 0;

# Temporary variable, used to indicate to the fault handler whether
# or not errors/warnings should be suppressed.
our $SUPPRESS_ERRORS = 0;

#######################################################################
# Daemon Initialization / Destruction                                 #
#######################################################################

=pod

=head1 EXPORTED FUNCTIONS

The following init() and destroy() functions are the only direct
calls required to startup and shutdown the SOAP server.

All other interactions with this daemon should be performed as
C<SOAP::Lite> function calls, in order to ensure consistency across
client sessions.  See the L<"EXTERNAL SOAP FUNCTIONS"> section, for
more details.

=head2 HoneyClient::Manager->init()

=over 4

Starts a new SOAP server, within a child process.

I<Inputs>:

# XXX: Finish this.

I<Output>: 

# XXX: Finish this.

=back

#=begin testing
#
# XXX: Test init() method.
#
#=end testing

=cut

#sub init {
#    # Extract arguments.
#    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
#    # hash references directly.  Thus, flat hashtables are used throughout the code
#    # for consistency.
#    my ($class, %args) = @_;
#    
#    # XXX: Finish this.
#}

=pod

=head2 HoneyClient::Manager->destroy()

=over 4

Terminates the SOAP server within the child process.

I<Output>: True if successful, false otherwise.

=back

#=begin testing
#
# XXX: Test destroy() method.
#
#=end testing

=cut

#sub destroy {
#    my $ret = undef;
#   
#    # XXX: Finish this.
#    
#    return $ret;
#}

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

sub _agentHandleFault {

    # Extract arguments.
    my ($class, $res) = @_;


    #NOTE: In the future we may want to have this check first to see if
    #the error is specific to a failed connection (by regexing the error
    #message. But for now, we have no evidence that multiple errors will
    #occur in other circumstances.
    $globalAgentErrorCount++;

    # Construct error message.
    # Figure out if the error occurred in transport or over
    # on the other side.
    my $errMsg = $class->transport->status; # Assume transport error.

    if (ref $res) {
        $errMsg = $res->faultcode . ": ".  $res->faultstring . "\n";
    }

    if (!$SUPPRESS_ERRORS) {
        $LOG->warn("Error occurred during processing. " . $errMsg);
        Carp::carp __PACKAGE__ . "->_handleFault(): Error occurred during processing.\n" . $errMsg;
    }
}

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

    if (!$SUPPRESS_ERRORS) {
        $LOG->warn("Error occurred during processing. " . $errMsg);
        Carp::carp __PACKAGE__ . "->_handleFault(): Error occurred during processing.\n" . $errMsg;
    }
}

sub _handleFaultAndCleanup {

    # Extract arguments.
    my ($class, $res) = @_;

    # Print fault.
    _handleFault($class, $res);
    
    # Cleanup before dying.
    _cleanup();
}

sub _cleanup {

    $LOG->info("Cleaning up.");

    # Mask all possible signals, so that we don't call this function multiple times.
    $SIG{HUP}     = sub { };
    $SIG{INT}     = sub { };
    $SIG{QUIT}    = sub { };
    $SIG{ABRT}    = sub { };
    $SIG{PIPE}    = sub { };
    $SIG{TERM}    = sub { };

    # XXX: Need to clean this up.
    my $stubFW = getClientHandle(namespace     => "HoneyClient::Manager::FW",
                                 fault_handler => \&_handleFault);

    # XXX: Change this to installDefaultRules(), eventually.
    # Reset the firewall, to allow everything open.
    $stubFW->allowAllTraffic();

    # This variable may contain a filename that the Manager
    # would use to dump its entire state information, upon termination.
    # XXX: May want to change this format/usage, eventually.
    my $STATE_FILE = getVar(name => "manager_state");

    if (length($STATE_FILE) > 0 &&
        defined($globalAgentState)) {
        $LOG->info("Saving state to '" . $STATE_FILE . "'.");
        my $dump_file = new IO::File($STATE_FILE, "a");

        # XXX: Delete this block, eventually.
        $Data::Dumper::Terse = 0;
        $Data::Dumper::Indent = 2;
        print $dump_file Dumper(thaw(decode_base64($globalAgentState)));
        $dump_file->close();
    }

    if ($DB_ENABLE && ($clientDbId > 0)) {
        if (defined($globalAgentState)) {
            $LOG->info("Saving URL History to Database.");
            insert_url_history(agent_state => $globalAgentState,
                               client_id   => $clientDbId);
        }

        # Mark the VM as suspended within the database.
        HoneyClient::Manager::Database::set_client_suspended($clientDbId);
    }


    # XXX: There is an issue where if we try to quit but are in the
    # process of asynchronously archiving a VM, then the async archive
    # process will fail.

    exit;
}

END {
    # TODO: Make sure this works correctly.
    # Make sure all processes in our process group our dead.
    kill("KILL", -$$);
}

# XXX: Install the cleanup handler, in case the parent process dies
# unexpectedly.
$SIG{HUP}  = \&_cleanup;
$SIG{INT}  = \&_cleanup;
$SIG{QUIT} = \&_cleanup;
$SIG{ABRT} = \&_cleanup;
$SIG{PIPE} = \&_cleanup;
$SIG{TERM} = \&_cleanup;

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXPORTS

=head2 run()

=over 4

# XXX: Fill this in.

I<Inputs>: 
 B<$arg> is an optional argument.

driver
master_vm_config
start_state
 
I<Output>: XXX: Fill this in.

=back

#=begin testing
#
# XXX: Fill this in.
#
#=end testing

=cut

sub run {
    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;
    my $agentState = undef;

    # Sanity check, make sure the master_vm_config is
    # set.
    my $argsExist = scalar(%args);
    if (!$argsExist ||
        !exists($args{'master_vm_config'}) ||
        !defined($args{'master_vm_config'})) {
        # Get the master_vm_config from the configuration file.
        $args{'master_vm_config'} = getVar(name      => "master_vm_config",
                                           namespace => "HoneyClient::Manager::VM");
    }

    for (;;) {
        print "Starting new session...\n";
        $agentState = $class->runSession(%args);
        $args{'agent_state'} = $agentState;

        # XXX: Fix this, eventually.
        $globalAgentState = $agentState;
    }
}

sub runSession {

    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;

    # XXX: Remove some of these, eventually.
    my $stubFW    = undef;
    my $stubAgent = undef;
    my $som       = undef;
    my $ret       = undef;
    # XXX: Need to figure out a way to move this data into the VM object.
    my $vmCompromised = 0;
    my $vmStateTable = { };

    # Temporary variable to hold each cloned VM.
    my $vm        = undef;

    # Get a stub connection to the firewall.
    $stubFW = getClientHandle(namespace     => "HoneyClient::Manager::FW",
                              fault_handler => \&_handleFaultAndCleanup);

    # Open up the firewall initially, to allow the Agent to do an SVN update.
    #FIXME: This needs to be more limited for the multi-vm case, and should probably 
    # just be included by making the default rules require no action
    $stubFW->allowAllTraffic();

    # Check disk space.
    checkSpaceAvailable();

    # Create a new cloned VM.
    $vm = HoneyClient::Manager::VM::Clone->new();

    #Register Client with the Honeyclient Database
    if ($DB_ENABLE) {
        eval {
            dbRegisterClient($vm);
            $clientDbId = $vm->database_id;
        };
        if ($@ || ($vm->database_id == 0) || !defined($vm->database_id)) {
            $vm->database_id(0); #$DB_FAILURE
            $LOG->warn("Failure Inserting Client Object:\n$@");
        }
    }

    # Build our VM's connection table.
    # Note: We assume our VM has a single MAC address
    # and a single IP address.
    $vmStateTable->{$vm->name}->{sources}->{$vm->mac_address}->{$vm->ip_address} = {
        # XXX: We assume we can't pinpoint what source TCP ports the
        # corresponding driver will need.  (We may want to get this
        # information eventually from the Agent, as part of Driver::next().)
        'tcp' => [80,443],
    };

    print "VM State Table:\n";
    # Make Dumper format more verbose.
    $Data::Dumper::Terse = 0;
    $Data::Dumper::Indent = 2;
    print Dumper($vmStateTable) . "\n";
  
    # Initialize the firewall.
    $stubFW->installDefaultRules();

    # Add new chain, per cloned VM.
    $stubFW->addChain($vmStateTable);
   
    sleep (2);

    # Recreate the client stub; handle faults.
    $stubAgent = getClientHandle(namespace     => "HoneyClient::Agent",
                                 address       => $vm->ip_address,
                                 fault_handler => \&_handleFaultAndCleanup);

    # If supported, get a URL list from the database.
    if ($DB_ENABLE && ($vm->database_id > 0)) {
        $args{'agent_state'} = get_urls($vm, $args{'agent_state'}, $args{'driver'});
    }

    # Call updateState() first, to seed initial data.
    # TODO: Need to support asynchronous updates (url adding)
    # from user input.
    print "Calling updateState()...\n";
    $som = $stubAgent->updateState($args{'agent_state'});

    # Recreate the client stub; ignore faults.
    $stubAgent = getClientHandle(namespace     => "HoneyClient::Agent",
                                 address       => $vm->ip_address,
                                 fault_handler => \&_agentHandleFault);

    # Recreate the firewall stub; ignore faults.
    $stubFW = getClientHandle(namespace     => "HoneyClient::Manager::FW",
                              fault_handler => \&_handleFault);

    for (my $counter = 1;; $counter++) {

        # XXX: This isn't a valid assumption!
        # From this point on, catch all errors generated and
        # assume that the Agent's watchdog process will recover.
        eval {
            print "Calling getStatus()...\n";
            $som = $stubAgent->getStatus();
            print "Result:\n";
            $ret = thaw(decode_base64($som->result()));
            # Make Dumper format more verbose.
            $Data::Dumper::Terse = 0;
            $Data::Dumper::Indent = 2;
            print Dumper($ret->{$args{'driver'}}->{status});
            #print Dumper($ret);

            # Derive current agent state from full status.
            my @driverNames = keys(%{$ret});
            my $state = {};
            foreach my $driverName (@driverNames) {
                $state->{$driverName} = $ret->{$driverName}->{'state'};
            }
            $args{'agent_state'} = encode_base64(nfreeze($state));
            $globalAgentState = $args{'agent_state'};
            #print "GlobalAgentState:\n";
            #print Dumper(thaw(decode_base64($globalAgentState)));

            # Check to see if Agent::run() thread has stopped
            # and that a compromise was detected.
            if (!$ret->{$args{'driver'}}->{status}->{is_running}) {
                if ($ret->{$args{'driver'}}->{status}->{is_compromised}) {
                    # Check to see if the VM has been compromised.
                    print "WARNING: VM HAS BEEN COMPROMISED!\n";
                    my $vmName = $vm->name;
                    $vmCompromised = 1;

                    my $fingerprint = $ret->{$args{'driver'}}->{status}->{fingerprint};
                    $LOG->warn("VM Compromised. Last Resource (" . $fingerprint->{'last_resource'} . ")");

                    # Dump the fingerprint to a file, if needed.
                    # XXX: May want to change this format/usage, eventually.
                    my $COMPROMISE_FILE = getVar(name => "fingerprint_dump");
                    if (length($COMPROMISE_FILE) > 0 &&
                        defined($fingerprint)) {
                        $LOG->info("Saving fingerprint to '" . $COMPROMISE_FILE . "'.");
                        my $dump_file = new IO::File($COMPROMISE_FILE, "a");

                        # XXX: Delete this block, eventually.
                        $Data::Dumper::Terse = 0;
                        $Data::Dumper::Indent = 2;
                        print $dump_file "\$vmName = \"" . $vmName . "\";\n";
                        print $dump_file Dumper($fingerprint);
                        $dump_file->close();
                    }

                    # Archive the VM.
                    $LOG->info("Archiving VM...");
                    $vm->archive();

                    # Insert Compromised Fingerprint into DB.
                    if ($DB_ENABLE && ($vm->database_id > 0)) {
                        # Put URL History in database.
                        $LOG->info("Saving URL History to Database.");
                        $args{'agent_state'} = insert_url_history(agent_state => $args{'agent_state'},
                                                                  client_id   => $vm->database_id);
                        $globalAgentState = $args{'agent_state'};
                   
                        # Delete the 'last_resource' attribute.
                        delete $fingerprint->{last_resource};

                        # Associate the client who has this fingerprint.
                        $fingerprint->{client_id} = $vm->database_id;

                        $LOG->info("Inserting Fingerprint Into Database.");
                        my $fingerprint_id = undef;
                        eval {
                            $fingerprint_id = HoneyClient::Manager::Database::insert_fingerprint($fingerprint);
                        };
                        if ($@ || ($fingerprint_id == 0) || !defined($fingerprint_id)) {
                            $LOG->warn("Failure Inserting Fingerprint Object:\n$@");
                        }

                        $LOG->info("Database Insert Successful.");
                    }
                    # The VM should be suspended, at this point.  Clear out the global DB ID, so
                    # that our cleanup code doesn't re-mark the VM as suspended.
                    $clientDbId = 0;

                    # Make sure VM is suspended.
                    $vm = undef;

                    return; # Return out of eval block.
                } else {
                    print "VM Integrity Check: OK!\n";

                    # Check to see if any links remain to be processed by the
                    # Agent.
                    if (!$ret->{$args{'driver'}}->{status}->{links_remaining}) {
    
                        # If supported, get more URLs from the database.
                        if ($DB_ENABLE && ($vm->database_id > 0)) {
                            # Put URL History in database.
                            $LOG->info("Saving URL History to Database.");
                            $args{'agent_state'} = insert_url_history(agent_state => $args{'agent_state'},
                                                                      client_id   => $vm->database_id);

                            $args{'agent_state'} = get_urls($vm, $args{'agent_state'}, $args{'driver'});
                            $globalAgentState = $args{'agent_state'};
                            print "Calling updateState()...\n";
                            $som = $stubAgent->updateState($args{'agent_state'});
                        } else {
                            $LOG->info("All URLs exhausted. Shutting down Manager.");
                            $vm = undef;
                            _cleanup();
                        }
                    } else {
                        # The Agent::run() thread has stopped; we assume
                        # it's because the Agent is waiting for the firewall
                        # to allow access to the new targets.
                
                        # Delete the old firewall rules, based upon existing
                        # targets.
                        $stubFW->deleteRules($vmStateTable);

                        # Get the new targets from the Agent.
                        $vmStateTable->{$vm->name}->{targets} = $ret->{$args{'driver'}}->{next}->{targets};
                        #$vmStateTable->{$vm->name}->{targets} = '0.0.0.0';

                        print "VM State Table:\n";
                        # Make Dumper format more verbose.
                        $Data::Dumper::Terse = 0;
                        $Data::Dumper::Indent = 2;
                        print Dumper($vmStateTable) . "\n";

                        # Add the new targets from the Agent.
                        $stubFW->addRules($vmStateTable);

                        print "Calling run()...\n";
                        $som = $stubAgent->run(driver_name => $args{'driver'});
                    }
                }
            }
        };
        if ($@) {
            print "Error: $@\n";
            my $resetSuccessful = 0;
            while (!$resetSuccessful) {
                print "Resetting firewall...\n";
                eval {
                    # We assume the error was caused by some sort of communications
                    # problem with the Agent.  Assume the Agent's watchdog will restart
                    # the daemon, in which case, we indefinately try to reset the
                    # firewall accordingly.
                    $stubFW->installDefaultRules();
                    $stubFW->addChain($vmStateTable);
                    $stubFW->addRules($vmStateTable);
                };
                if (!$@) {
                    $resetSuccessful = 1;
                } else {
                    sleep (3);
                }
            }   
        }
        if ($vmCompromised) {
            # Reset the FW state table. 
            $vmStateTable = ( );
            return $args{'agent_state'};
        }
        if ($globalAgentErrorCount >= getVar(name => "max_agent_error_count")) {
            if ($DB_ENABLE && ($vm->database_id > 0)) {
                # Mark the VM as suspended within the database.
    			my $dt = DateTime::HiRes->now(time_zone => "local");
                HoneyClient::Manager::Database::set_client_suspicious({
					client_id => $vm->database_id,
        			compromise => $dt->ymd('-').'T'.$dt->hms(':'),
				});
            }
            $globalAgentErrorCount = 0;
            # Reset the FW state table. 
            $vmStateTable = ( );
            return $args{'agent_state'};
        }
        print "Sleeping for 2s...\n";
        sleep (2);
    }
}

sub insert_url_history {

    # Extract arguments.
    my %args = @_;
    
    my $state = thaw(decode_base64($args{'agent_state'}));
    my $driver = undef;
    foreach my $key (keys %$state) {
        if ($state->{$key}) {
            $driver = $key; 
            last;
        }
    }

    # Set the client ID.
    $state->{$driver}->{'client_id'} = $args{'client_id'};
   
    # XXX: Delete this, eventually.
    #use Data::Dumper;
    #$LOG->info("agent_state = " . Data::Dumper::Dumper($state));

    my $num_urls_inserted = HoneyClient::Manager::Database::insert_history_urls($state->{$driver});
    $LOG->info($num_urls_inserted . " URL(s) Inserted.");

    # Flush the URL history, after committing to the database.
    $state->{$driver}->{'links_visited'} = {};
    return encode_base64(nfreeze($state));
}

sub dbRegisterClient {
    my $vm = shift;
    my $dt = DateTime::HiRes->now(time_zone => "local");

    # Register the VM with the DB
    my $client = {
        cid => $vm->name,
        status => 'running',
        host => {
            org => getVar(name => "organization"),
            hostname => Sys::Hostname::Long::hostname_long,
            ip => Sys::HostIP->ip,
        },
        os => {
            name => 'Default Windows XP SP2',
            shortname => 'Microsoft Windows',
            version => 'XP Professional',
            #os_patches => [{
            #    name => 'Service Pack 2',
            #}],
            os_applications => [{
                manufacturer => 'Microsoft',
                shortname => 'Internet Explorer',
                version => '6',
            }],
        },
        start => $dt->ymd('-').'T'.$dt->hms(':'),
    };
    $vm->database_id(HoneyClient::Manager::Database::insert_client($client));
}

sub get_urls {
    my $vm = shift;
    my $agent_state = shift;
    my $driver = shift;

    # Decode and thaw the initial agent state.
    my $state = thaw(decode_base64($agent_state));

    my $queue_url_list = {};
    $LOG->info("Waiting for new URLs from database.");
    # XXX: We hardcode the value of 10 URLs to request; this will change, eventually.
    $queue_url_list = HoneyClient::Manager::Database::get_queue_urls(10, $vm->database_id);
    my $remoteLinksExist = scalar(%{$queue_url_list});

    # While we have no local URLs and no URLs from the database, re-query the database.
    while (!defined($state->{$driver}->{next_link_to_visit}) &&
           !$remoteLinksExist) {

        # XXX: Hardcoded timeout.
        sleep (2);
        # XXX: Trap/ignore all errors and simply retry.
        eval {
            $queue_url_list = HoneyClient::Manager::Database::get_queue_urls(10, $vm->database_id);
            $remoteLinksExist = scalar(%{$queue_url_list});
        };
    }

    # If we do have URLs from the database, then merge them into the agent state.
    # Note: Priorities specified in the database take precedent over any URLs specified locally.
    if ($remoteLinksExist) {
        $state->{$driver}->{links_to_visit} = { %{$state->{$driver}->{links_to_visit}}, 
                                                %{$queue_url_list} };
        $agent_state = encode_base64(nfreeze($state));
    }

    return $agent_state;
}

sub checkSpaceAvailable {

    my $datastore_path = getVar(name      => "datastore_path",
                                namespace => "HoneyClient::Manager::VM");
    my $snapshot_path  = getVar(name      => "snapshot_path",
                                namespace => "HoneyClient::Manager::VM");
    my $min_space_free = getVar(name      => "min_space_free",
                                namespace => "HoneyClient::Manager::VM");

                                                    # Obtain sizes in GB
    my $datastore_attr = dfportable($datastore_path, 1024 * 1024 * 1024);
    my $snapshot_attr  = dfportable($snapshot_path,  1024 * 1024 * 1024);

    if ($datastore_attr->{bavail} < $min_space_free) {
        $LOG->warn("Directory (" . $datastore_path . ") has low disk space (" . $datastore_attr->{bavail} . " GB).");
    } elsif ($snapshot_attr->{bavail} < $min_space_free) {
        $LOG->warn("Directory (" . $snapshot_path . ") has low disk space (" . $snapshot_attr->{bavail} . " GB).");
    } else {
        return;
    }
    $LOG->info("Low disk space detected. Shutting down Manager.");
    _cleanup();
}

#######################################################################

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 BUGS & ASSUMPTIONS

Currently the documentation in the "EXPORTED FUNCTIONS" and
"EXPORTS" sections are both incomplete; these sections are still
a work-in-progress.

This module relies on various libraries, which may have their own
set of issues.  As such, see the following sections:

=over 4

=item *

L<HoneyClient::Manager::VM::Clone/"BUGS & ASSUMPTIONS">

=back

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Paul Kulchenko for developing the SOAP::Lite module.

=head1 AUTHORS

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

Kathy Wang, E<lt>knwang@mitre.orgE<gt>

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
