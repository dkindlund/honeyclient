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

HoneyClient::Manager - Perl extension to manage Agent VMs on the
host system.

=head1 VERSION

This documentation refers to HoneyClient::Manager version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager;

  # Note: Make sure only one of these "my $driver_name =" lines
  # is uncommented.

  # Use Internet Explorer as the instrumenting application.
  my $driver_name = "HoneyClient::Agent::Driver::Browser::IE";

  # Use Mozilla Firefox as the instrumenting application.
  #my $driver_name = "HoneyClient::Agent::Driver::Browser::FF";

  # Start the Manager.
  HoneyClient::Manager->run(

      driver_name => $driver_name,

      # The URLs (and priorities) of each entry to process.
      work => {
          'http://www.google.com' => 1,
      },
  );

=head1 DESCRIPTION

This module provides centralized control over provisioning, initializing,
running, and suspending all Agent VMs.  Upon calling the run() function,
the Manager will proceed to create a new clone of the master Honeyclient VM
(aka. an Agent VM) and feed this Agent VM a new list of URLs to visit.

While the Agent VM is running, the Manager will check to make sure the
Agent VM has not been compromised.  If no compromise was found, then the
Manager will signal the Firewall to allow the Agent VM to contact the
next set of network resources (i.e., a webserver).

If the Manager discovers the Agent VM has been compromised, then the
Manager will suspend the clone VM, log the incident, and create a new Agent
VM clone -- where this new clone picks up with the next set of URLs to
visit.

If there are no URLs left for the Agent VM to visit OR if the user
presses CTRL+C while the Manager is running, then the Manager will
suspend the currently running Agent VM.

In order to determine which URLs were identified as malicious, you
will need to check the syslog on the host system and search for the
keyword of "FAILED" or "Failure".

By default, all cloned VMs that the Manager suspends will have been
flagged as suspicious -- unless the set of URLs has been exhausted
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
    @EXPORT = qw();

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Manager ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = (
        'all' => [ qw() ],
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
BEGIN { use_ok('HoneyClient::Manager') or diag("Can't load HoneyClient::Manager package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager');
use HoneyClient::Manager;

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

# Make sure HoneyClient::Manager::Database loads.
BEGIN { use_ok('HoneyClient::Manager::Database') or diag("Can't load HoneyClient::Manager::Database package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Database');
use HoneyClient::Manager::Database;

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

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Sys::Hostname loads.
BEGIN { use_ok('Sys::Hostname') or diag("Can't load Sys::Hostname package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Sys::Hostname');
use Sys::Hostname;

# Make sure Sys::HostIP loads.
BEGIN { use_ok('Sys::HostIP') or diag("Can't load Sys::HostIP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Sys::HostIP');
use Sys::HostIP;

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

# Include Database Libraries
use HoneyClient::Manager::Database;

# Use Hostname Libraries
use Sys::Hostname::Long;

# Use HostIP Libraries
use Sys::HostIP;

# Use Dumper Library
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

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# The global work queue.  Each entry represents
# work destined for a child thread worker.
our $WORK_QUEUE : shared = undef;

# The global wait queue.  Each entry represents
# a thread ID waiting for more work.
our $WAIT_QUEUE : shared = undef;

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

=begin testing

SKIP: {
    skip "HoneyClient::Manager->init() is not implemented, yet.", 1;
}

=end testing

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

=begin testing

SKIP: {
    skip "HoneyClient::Manager->destroy() is not implemented, yet.", 1;
}

=end testing

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

# Default handler for any faults that are received by a SOAP client.
# Inputs: Class, SOAP::SOM
# Outputs: None
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

    $LOG->warn("Error occurred during processing. " . $errMsg);
    Carp::carp __PACKAGE__ . "->_handleFault(): Error occurred during processing.\n" . $errMsg;
}

# Specialized fault handler for any faults that are received by a SOAP client.
# Outputs the fault and then performs cleanup operations before shutting down.
# Inputs: Class, SOAP::SOM
# Outputs: None
sub _handleFaultAndCleanup {

    # Extract arguments.
    my ($class, $res) = @_;

    # Print fault.
    _handleFault($class, $res);
    
    exit;
}

END {
    # Reset the firewall.
    eval {
        $LOG->info("Resetting firewall.");
        my $stubFW = getClientHandle(namespace     => "HoneyClient::Manager::FW",
                                     fault_handler => \&_handleFault);
        $stubFW->installDefaultRules();
    };

    # Verify all sub threads are finished, prior to shutting down.
    my $thread;
    foreach $thread (threads->list()) {
        # Don't kill/detach the main thread or ourselves.
        if ($thread->tid() && !$thread->equal(threads->self())) {
            # Kill the child thread, if it's running.
            if ($thread->is_running()) {
                # Send empty work, if need be.
                my $work = {};
                $WORK_QUEUE->enqueue(nfreeze($work));

                $LOG->info("Shutting down Thread ID (" . $thread->tid() . ").");
                $thread->kill('USR1');

                # Join the child thread.
                if (!$thread->is_detached()) {
                    $LOG->debug("Joining Thread ID (" . $thread->tid() . ").");
                    $thread->join();
                }
            }
        }
    }

    # XXX: There is an issue where if we try to quit but are in the
    # process of asynchronously archiving a VM, then the async archive
    # process will fail.

    # Make sure all processes in our process group our dead.
    kill("KILL", -$$);
}

# Helper function designed to "pop" a (key, value) pair off a given hashtable.
# When given a hashtable reference, this function will extract a valid (key, value)
# pair from the hashtable and delete the (key, value) pair from the
# hashtable.  The (key, value) pair with the highest score is returned.
#
# Inputs: hashref
# Outputs: valid (key, val) hashref or undef if the hash is empty
sub _pop {

    # Get supplied hash reference.
    my $hash = shift;

    # Get the highest score.
    my @array = sort {$$hash{$b} <=> $$hash{$a}} keys %{$hash};
    my $topkey = $array[0];

    if (defined($topkey)) {
        # Delete the key from the hashtable.
        # Return the (key, val) pair found.
        return { $topkey => delete($hash->{$topkey}) };
    } else {
        return undef;
    }
}

# Helper function designed to take in specified work
# and split up that work evenly amongst the specified
# number of clones by creating individual "buckets"
# for each clone, adding non-empty buckets to the
# work queue.
#
# Inputs: work_queue, wait_queue, work, num_simultaneous_clones
# Outputs: None.
sub _divide_work {

    # Extract arguments.
    my (%args) = @_;

    # Initalize buckets - 1 bucket per client.
    my $buckets = [ ];
    for (my $counter = 0; $counter < $args{'num_simultaneous_clones'}; $counter++) {
        $buckets->[$counter] = { };
    }

    # Divide up the work evenly across each bucket.
    while (scalar(%{$args{'work'}})) {
        for (my $counter = 0; $counter < $args{'num_simultaneous_clones'}; $counter++) {
            my $item = _pop($args{'work'});
            if (defined($item)) {
                $buckets->[$counter] = { %{$buckets->[$counter]}, %{$item} };
            } else {
                # We have no more work to place into any bucket,
                # so exit the loop.
                last;
            }
        }
    }

    # Place the contents of each bucket onto the work queue,
    # but ignore empty buckets.
    my $tid = undef;
    for (my $counter = 0; $counter < $args{'num_simultaneous_clones'}; $counter++) {
        if (scalar %{$buckets->[$counter]}) {

            # For each bucket inserted into the work queue, delete a corresponding
            # signal from the wait queue -- if there is a signal on the wait queue.
            if (defined($tid = $args{'wait_queue'}->dequeue_nb)) {
        
                # Sanity check: Make sure the thread is still alive.
                if (!defined(threads->object($tid))) {
                    $LOG->error("Thread ID (" . $tid . "): Unexpectedly terminated.");
                    Carp::croak "Thread ID (" . $tid . "): Unexpectedly terminated.";
                }

            }
            $args{'work_queue'}->enqueue(nfreeze($buckets->[$counter]));
        }
    }
}

# Helper function designed to get new URLs from the Drone
# database.  If it's the first attempt at obtaining URLs,
# then it will ask the Drone database for any existing,
# pre-assigned URLs.  Otherwise, it will ask the Drone
# database for new, unassigned URLs.
#
# Inputs: first_attempt
# Outputs: Hashref of (url => priority) pairs.
sub _get_urls {

    # Extract arguments.
    my (%args) = @_;

    # Returned argument.
    my $ret = { };

    # If this is the first attempt, then get any pre-assigned URLs.
    if ($args{'first_attempt'}) {
        $ret = HoneyClient::Manager::Database::get_queue_urls_by_hostname(Sys::Hostname::Long::hostname_long);
    } else {
        $ret = HoneyClient::Manager::Database::get_new_queue_urls(Sys::Hostname::Long::hostname_long, getVar(name => "num_urls_to_process"));
    }
    return $ret;
}

# Helper function designed to create a worker thread which manages a single
# VM, using a WORK_QUEUE and a WAIT_QUEUE.
#
# Note: We can gracefully stop each worker, by sending an empty hashtable of work,
# or by signalling the thread.
sub _worker {

    # Make sure the thread can only kill itself and not the entire application.
    threads->set_thread_exit_only(1);

    # Register interrupt/kill signal handlers.
    # These handlers are designed to kill this thread upon overall module
    # destruction.  These handlers should never be used for normal program
    # operations, since they will NOT release any locks/semaphores properly.
    local $SIG{USR1} = sub {
        my $LOG = get_logger();
        $LOG->warn("Thread ID (" . threads->tid() . "): Received SIGUSR1. Shutting down worker.");
        threads->exit();
    };

    local $SIG{INT} = sub { 
        my $LOG = get_logger();
        $LOG->warn("Thread ID (" . threads->tid() . "): Received SIGINT. Shutting down worker.");
        threads->exit();
    };

    # Extract arguments.
    my $args = shift;

    $LOG->info("Thread ID (" . threads->tid() . "): Starting worker.");

    # Yield processing to parent thread.
    threads->yield();

    eval {
        # Create a new cloned VM.
        my $vm = HoneyClient::Manager::VM::Clone->new(%{$args});

        # Variable to hold our work.
        my $work = undef;
        my $data = undef;

        # If there's no work on the queue, signal that we need more work.
        if (!$WORK_QUEUE->pending) {
            $LOG->info("Thread ID (" . threads->tid() . "): Signaling for more work.");
            # Signal that we're ready for more work.
            $WAIT_QUEUE->enqueue(threads->tid());
        }

        # This is a little hackish, since calling Thread::Queue->dequeue
        # doesn't properly handle signals.
        $LOG->info("Thread ID (" . threads->tid() . "): Waiting for more work.");
        while (!defined($data = $WORK_QUEUE->dequeue_nb)) {
            # Poll the wait queue every 2 seconds.
            # This time delay should be short.
            threads->yield();
            sleep(2);
        }
        $work = thaw($data);
        
        while (scalar(%{$work})) {
            $vm = $vm->drive(work => $work);

            # If there's no work on the queue, signal that we need more work.
            if (!$WORK_QUEUE->pending) {
                $LOG->info("Thread ID (" . threads->tid() . "): Signaling for more work.");
                # Signal that we're ready for more work.
                $WAIT_QUEUE->enqueue(threads->tid());
            }
            # This is a little hackish, since calling Thread::Queue->dequeue
            # doesn't properly handle signals.
            $LOG->info("Thread ID (" . threads->tid() . "): Waiting for more work.");
            while (!defined($data = $WORK_QUEUE->dequeue_nb)) {
                # Poll the wait queue every 2 seconds.
                # This time delay should be short.
                threads->yield();
                sleep(2);
            }
            $work = thaw($data);
        }
    };
    # Report when a fault occurs.
    if ($@) {
        $LOG->warn("Thread ID (" . threads->tid() . "): Encountered an error. Shutting down worker. " . $@);
    } else {
        $LOG->info("Thread ID (" . threads->tid() . "): Received empty work. Shutting down worker.");
    }

    # Signal to the parent that we're shutting down.
    if (!threads->is_detached()) {
        threads->detach();
    }
    $WAIT_QUEUE->enqueue(threads->tid());
   
    # Shut thread down.
    threads->exit();
}


# Signal handler to help give user immediate feedback during
# shutdown process.
sub _shutdown {
    my $LOG = get_logger();
    $LOG->warn("Received termination signal.  Shutting down (please wait).");
    exit;
};
$SIG{HUP}  = \&_shutdown;
$SIG{INT}  = \&_shutdown;
$SIG{QUIT} = \&_shutdown;
$SIG{ABRT} = \&_shutdown;
$SIG{TERM} = \&_shutdown;

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXPORTS

=head2 run(driver_name => $driver_name, master_vm_config => $master_vm_config, work => $work)

=over 4

Runs the Manager code, using the specified arguments.

I<Inputs>: 
 B<$driver_name> is an optional argument, indicating the driver name to
use when driving all cloned VMs.
 B<$master_vm_config> is an optional argument, indicating the absolute
path to the master VM configuration file that each clone VM should use.
 B<$work> is an optional argument, indicating the work each cloned
VM should process.

=back

=begin testing

SKIP: {
    skip "HoneyClient::Manager->run() can't be easily tested, yet.", 1;
}

=end testing

=cut

sub run {

    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;

    # Sanity check: If there's no database support and no work was
    # specified, then stop.
    my $localLinksExist = scalar(%{$args{'work'}});
    if (!getVar(name      => "enable",
                namespace => "HoneyClient::Manager::Database") && !$localLinksExist) {
        $LOG->error("No URLs specified and database support is disabled.  Shutting down Manager.");
        exit;
    }

    # Temporary variable to hold each cloned VM.
    my $vm        = undef;

    # Get a stub connection to the firewall.
    my $stubFW = getClientHandle(namespace     => "HoneyClient::Manager::FW",
                                 fault_handler => \&_handleFaultAndCleanup);

    $LOG->info("Installing default firewall rules.");
    $stubFW->installDefaultRules();

    # If these parameters weren't defined, delete them
    # from the specified arg hash.
    if (!defined($args{'master_vm_config'})) {
        delete $args{'master_vm_config'}; 
    }
    if (!defined($args{'driver_name'})) {
        delete $args{'driver_name'}; 
    }

    # Create a new work queue.
    $WORK_QUEUE = new Thread::Queue;
    
    # Create a new wait queue.
    $WAIT_QUEUE = new Thread::Queue;

    # Create the thread pool.
    my @THREAD_POOL;

    # Create the cloned VMs.
    for (my $counter = 0; $counter < getVar(name => "num_simultaneous_clones"); $counter++) {
        my $thread = threads->create(\&_worker, \%args);
        if (!defined($thread)) {
            $LOG->error("Unable to create worker thread! Shutting down.");
            Carp::croak "Unable to create worker thread! Shutting down.";
        }
        # Push thread onto thread pool.
        push(@THREAD_POOL, $thread);
    }

    # Register the host system with the database, if need be.
    if (getVar(name      => "enable",
               namespace => "HoneyClient::Manager::Database")) {

        my $host = {
            org => getVar(name => "organization"),
            hostname => Sys::Hostname::Long::hostname_long,
            ip => Sys::HostIP->ip,
        };
        HoneyClient::Manager::Database::insert_host($host);
    }

    # If supported, get a URL list from the database.
    my $remoteLinksExist = 0;
    my $queue_url_list = {};
    my $tid = undef;
    my $first_access_attempt = 1;
    while (getVar(name      => "enable",
                  namespace => "HoneyClient::Manager::Database")) {
        $LOG->info("Waiting for new URLs from database.");
        $queue_url_list = _get_urls(first_attempt => $first_access_attempt);
        $first_access_attempt = 0;

        $remoteLinksExist = scalar(%{$queue_url_list});
        while (!$localLinksExist && !$remoteLinksExist) {

            # Sleep for a bit, before trying again to contact the database.
            sleep(getVar(name => "database_retry_delay"));
            # XXX: Trap/ignore all errors and simply retry.
            eval {
                $queue_url_list = _get_urls(first_attempt => 0);
                $remoteLinksExist = scalar(%{$queue_url_list});
            };
        }
        # If we do have URLs from the database, then merge them into the agent state.
        # Note: Priorities specified in the database take precedent over any URLs specified locally.
        if ($remoteLinksExist) {
            $args{'work'} = { %{$args{'work'}}, %{$queue_url_list} };
        }
        
        # Drive the VMs, using the work found.
        $LOG->info("Received new work and updating queue.");
        _divide_work(work_queue              => $WORK_QUEUE,
                     wait_queue              => $WAIT_QUEUE,
                     work                    => $args{'work'},
                     num_simultaneous_clones => getVar(name => "num_simultaneous_clones"));

        # Wait until the VMs need more work.
        while (!$WAIT_QUEUE->pending) {
            # Poll the wait queue every 2 seconds.
            # This time delay should be short.
            threads->yield();
            sleep(2);

            # Make sure all worker threads are still alive.
            for (my $counter = 0; $counter < getVar(name => "num_simultaneous_clones"); $counter++) {
                my $thread = $THREAD_POOL[$counter];
                if (!$thread->is_running()) {
                    $LOG->error("Thread ID (" . $thread->tid() . "): Unexpectedly terminated.");
                    Carp::croak "Thread ID (" . $thread->tid() . "): Unexpectedly terminated.";
                }
            }
        }
        $LOG->info("Got a signal that a thread needs more work.");

        # Once finished, empty the work queue.
        $args{'work'} = {};
        # If we had any local links, they definately will have been processed by now.
        $localLinksExist = 0;

        # Loop forever, since we have a database connection.
    }

    # If we don't have a database connection, then just handle the work
    # that was provided from the command line and then shut down.
    if (scalar(%{$args{'work'}})) {

        # Drive the VMs, using the work found.
        $LOG->info("Received new work and updating queue.");
        _divide_work(work_queue              => $WORK_QUEUE,
                     wait_queue              => $WAIT_QUEUE,
                     work                    => $args{'work'},
                     num_simultaneous_clones => getVar(name => "num_simultaneous_clones"));

        # Wait until all VMs are finished.
        # We wait for each worker to signal that they are waiting for more work, before shutting down
        # the application.
        for (my $i = 0; $i < getVar(name => "num_simultaneous_clones"); $i++) {
            my $tid = undef;
            # This is a little hackish, since calling Thread::Queue->dequeue
            # doesn't properly handle signals.
            while (!defined($tid = $WAIT_QUEUE->dequeue_nb)) {
                # Poll the wait queue every 2 seconds.
                # This time delay should be short.
                threads->yield();
                sleep(2);

                # Make sure all worker threads are still alive.
                for (my $counter = 0; $counter < getVar(name => "num_simultaneous_clones"); $counter++) {
                    my $thread = $THREAD_POOL[$counter];
                    if (!$thread->is_running()) {
                        $LOG->error("Thread ID (" . $thread->tid() . "): Unexpectedly terminated.");
                        Carp::croak "Thread ID (" . $thread->tid() . "): Unexpectedly terminated.";
                    }
                }
            }
        }
        # Once finished, empty the work queue.
        $args{'work'} = {};
    }
    $LOG->info("All URLs exhausted. Shutting down Manager.");
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
