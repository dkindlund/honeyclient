#######################################################################
# Created on:  Feb 01, 2009
# Package:     HoneyClient::Manager::Worker
# File:        Worker.pm
# Description: Central library used for controlling a single honeyclient
#              VM.
#
# CVS: $Id$
#
# @author kindlund
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

HoneyClient::Manager::Worker - Perl extension to manage a single
Agent VM on the host system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Worker version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::Worker;

  # Note: Make sure only one of these "my $driver_name =" lines
  # is uncommented.

  # Use Internet Explorer as the instrumenting application.
  my $driver_name = "HoneyClient::Agent::Driver::Browser::IE";

  # Use Mozilla Firefox as the instrumenting application.
  #my $driver_name = "HoneyClient::Agent::Driver::Browser::FF";

  # Start the Manager.
  HoneyClient::Manager::Worker->run(
      driver_name => $driver_name,
      service_url => "https://127.0.0.1/sdk/vimService",
      user_name   => "root",
      password    => "password",
  );

=head1 DESCRIPTION

This module provides centralized control over provisioning, initializing,
running, and suspending a single Agent VM.  Upon calling the run() function,
the Worker will proceed to create a new clone of the master Honeyclient VM
(aka. an Agent VM) and feed this Agent VM a new list of URLs to visit.

While the Agent VM is running, the Worker will check to make sure the
Agent VM has not been compromised.  If no compromise was found, then the
Worker will signal the Firewall to allow the Agent VM to contact the
next set of network resources (i.e., a webserver).

If the Worker discovers the Agent VM has been compromised, then the
Worker will suspend the clone VM, log the incident, and create a new Agent
VM clone -- where this new clone picks up with the next set of URLs to
visit.

If the user presses CTRL+C while the Worker is running, then the Worker will
suspend the currently running Agent VM.

In order to determine which URLs were identified as malicious, you
will need to check the syslog on the host system and search for the
keywords of: "FAILED", "Failure", or "ERROR".

By default, all cloned VMs that the Worker suspends will have been
flagged as suspicious -- unless the user prematurely terminates the
process (by pressing CTRL+C); those VMs are marked as suspended.

=cut

package HoneyClient::Manager::Worker;

use strict;
use warnings;
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

    # This allows declaration use HoneyClient::Manager::Worker ':all';
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
BEGIN { use_ok('HoneyClient::Manager::Worker') or diag("Can't load HoneyClient::Manager::Worker package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Worker');
use HoneyClient::Manager::Worker;

# Make sure the Virtualization Library loads.
my $VM_MODE = getVar(name => "virtualization_mode", namespace => "HoneyClient::Manager") . "::Clone";
require_ok($VM_MODE);
eval "require $VM_MODE";

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Net::Stomp loads.
BEGIN { use_ok('Net::Stomp') or diag("Can't load Net::Stomp package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Stomp');
use Net::Stomp;

# Make sure HoneyClient::Util::EventEmitter loads.
BEGIN { use_ok('HoneyClient::Util::EventEmitter') or diag("Can't load HoneyClient::Util::EventEmitter package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::EventEmitter');
use HoneyClient::Util::EventEmitter;

# Make sure Data::UUID loads.
BEGIN { use_ok('Data::UUID') or diag("Can't load Data::UUID package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::UUID');
use Data::UUID;

# Make sure JSON::XS loads.
BEGIN { use_ok('JSON::XS', qw(encode_json decode_json)) or diag("Can't load JSON::XS package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('JSON::XS');
can_ok('JSON::XS', 'encode_json decode_json');
use JSON::XS qw(encode_json decode_json);

# Make sure String::CamelCase loads.
BEGIN { use_ok('String::CamelCase', qw(camelize)) or diag("Can't load String::CamelCase package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('String::CamelCase');
can_ok('String::CamelCase', 'camelize');
use String::CamelCase qw(camelize);

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

=end testing

=cut

#######################################################################

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);

# Include the VM Utility Libraries
my $VM_MODE = getVar(name => "virtualization_mode") . "::Clone";
eval "require $VM_MODE";

# Use Dumper Library
use Data::Dumper;

# Make Dumper format more verbose.
$Data::Dumper::Terse = 0;
$Data::Dumper::Indent = 2;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Include STOMP Client Library
use Net::Stomp;

# Include UUID Library
use Data::UUID;

# Include JSON LIbrary
use JSON::XS qw(encode_json decode_json);

# Include CamelCase Library
use String::CamelCase qw(camelize);

# Include Event Emitter Library
use HoneyClient::Util::EventEmitter;

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# Signal handler to help give user immediate feedback during
# shutdown process.
sub _shutdown {
    my $LOG = get_logger();
    $LOG->warn("Received termination signal.  Shutting down worker (please wait).");
    exit;
};
$SIG{HUP}  = \&_shutdown;
$SIG{INT}  = \&_shutdown;
$SIG{QUIT} = \&_shutdown;
$SIG{ABRT} = \&_shutdown;
$SIG{TERM} = \&_shutdown;

# Helper function, designed to try and receive the next frame.
# If we fail, then we automatically retry.
#
# Inputs:
#   stomp          - the current STOMP object
#   new_args       - the STOMP new arguments
#   connect_args   - the STOMP connect arguments
#   subscribe_args - the STOMP subscribe arguments
# Output: the next frame received, the STOMP object
sub _receive_retry {
    # Extract arguments.
    my (%args) = @_;

    my $frame = undef;
    while (!defined($frame)) {
        eval {
            $frame = $args{'stomp'}->receive_frame();
        };
        if ($@) {
            $LOG->warn("Encountered a STOMP error. " . $@);
            $LOG->info("Retrying STOMP connection.");
            $frame = undef;
            if (defined($args{'stomp'}) &&
                (ref($args{'stomp'}) eq "Net::Stomp")) {
                $args{'stomp'}->disconnect();
            }
            # Initialize the STOMP client handle.
            $args{'stomp'} = Net::Stomp->new($args{'new_args'});

            # Connect to the STOMP server.
            $args{'stomp'}->connect($args{'connect_args'});

            # Subscribe to the specified exchange, declaring the queue and
            # routing key.
            $args{'stomp'}->subscribe($args{'subscribe_args'});
        }
    }

    return ($frame, $args{'stomp'});
}

# TODO: Delete this?
# Helper function, designed to try and send the supplied frame.
# If we fail, then we automatically retry.
#
# Inputs:
#   stomp          - the current STOMP object
#   new_args       - the STOMP new arguments
#   connect_args   - the STOMP connect arguments
#   subscribe_args - the STOMP subscribe arguments
#   send_args      - the STOMP send arguments
# Output: the STOMP object
sub _send_retry {
    # Extract arguments.
    my (%args) = @_;

    my $retry = 1;
    while ($retry) {
        eval {
            $args{'stomp'}->send($args{'send_args'});
            $retry = 0;
        };
        if ($@) {
            $LOG->warn("Encountered a STOMP error. " . $@);
            $LOG->info("Retrying STOMP connection.");
            if (defined($args{'stomp'}) &&
                (ref($args{'stomp'}) eq "Net::Stomp")) {
                $args{'stomp'}->disconnect();
            }
            # Initialize the STOMP client handle.
            $args{'stomp'} = Net::Stomp->new($args{'new_args'});

            # Connect to the STOMP server.
            $args{'stomp'}->connect($args{'connect_args'});

            # Subscribe to the specified exchange, declaring the queue and
            # routing key.
            $args{'stomp'}->subscribe($args{'subscribe_args'});
        }
    }

    return $args{'stomp'};
}

# Helper function, designed to try and ACK the supplied frame.
# If we fail, then we automatically retry.
#
# Inputs:
#   stomp          - the current STOMP object
#   new_args       - the STOMP new arguments
#   connect_args   - the STOMP connect arguments
#   subscribe_args - the STOMP subscribe arguments
#   ack_args       - the STOMP ack arguments
# Output: the STOMP object
sub _ack_retry {
    # Extract arguments.
    my (%args) = @_;

    my $retry = 1;
    while ($retry) {
        eval {
            $args{'stomp'}->ack($args{'ack_args'});
            $retry = 0;
        };
        if ($@) {
            $LOG->warn("Encountered a STOMP error. " . $@);
            $LOG->info("Retrying STOMP connection.");
            if (defined($args{'stomp'}) &&
                (ref($args{'stomp'}) eq "Net::Stomp")) {
                $args{'stomp'}->disconnect();
            }
            # Initialize the STOMP client handle.
            $args{'stomp'} = Net::Stomp->new($args{'new_args'});

            # Connect to the STOMP server.
            $args{'stomp'}->connect($args{'connect_args'});

            # Subscribe to the specified exchange, declaring the queue and
            # routing key.
            $args{'stomp'}->subscribe($args{'subscribe_args'});
        }
    }

    return $args{'stomp'};
}

# TODO: Delete this?
# Helper function, designed to flush all messages from the incoming
# queue.
sub _flush_queue {

    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;

    $LOG->info("Starting worker.");

    my $argsExist = scalar(%args);
    my $arg_names = [ 'stomp_address',
                      'stomp_port',
                      'stomp_user_name',
                      'stomp_password',
                      'stomp_virtual_host',
                      'exchange_name',
                      'queue_name',
                      'routing_key', ];

    # Parse optional arguments.
    foreach my $name (@{$arg_names}) {
        if (!($argsExist &&
            exists($args{$name}) &&
            defined($args{$name}))) {
            $args{$name} = getVar(name => $name);
        }
    }

    # Temporary variables to hold our jobs and work.
    my $job  = undef;
    my %work = ();

    # STOMP client handle.
    my $stomp = undef;
    my $frame = undef;

    eval {
        # Initialize the STOMP client handle.
        $stomp = Net::Stomp->new({
                     'hostname'  =>  $args{'stomp_address'},
                     'port'      =>  $args{'stomp_port'},
                 });

        # Connect to the STOMP server.
        $stomp->connect({
                    'login'         =>  $args{'stomp_user_name'},
                    'passcode'      =>  $args{'stomp_password'},
                    'virtual-host'  =>  $args{'stomp_virtual_host'},
        });

        # Subscribe to the specified exchange, declaring the queue and
        # routing key.
        $stomp->subscribe({
                    'durable'       =>  'true',
                    'exclusive'     =>  'false',
                    'passive'       =>  'false',
                    'auto-delete'   =>  'false',
                    'exchange'      =>  $args{'exchange_name'},
                    'destination'   =>  $args{'queue_name'},
                    'routing_key'   =>  $args{'routing_key'},
                    'ack'           =>  'client',
        });

        $LOG->info("Waiting for more work.");
        while (1) {
            # Get a new job.
            $frame = $stomp->receive_frame();
            $LOG->info("Got more work.");

            # Decode the job.
            $job = HoneyClient::Message::Job->new(decode_json($frame->body)->{'job'});

            # TODO: Delete this, eventually.
            #print Dumper($job->to_hashref()) . "\n";
            #print Dumper($frame) . "\n";

            # ACK the frame, indicating that the work has been completed.
            $LOG->info("Signaling work complete.");
            $stomp->ack({frame => $frame});

            # TODO: Delete this, eventually.
            sleep (60);
        }

    };
    # Report when a fault occurs.
    if ($@) {
        $LOG->error("Encountered an error. Shutting down worker. " . $@);
    }

    # Cleanup - Close STOMP connection.
    if (defined($stomp) &&
        (ref($stomp) eq "Net::Stomp")) {
        $stomp->disconnect();
    }
}

# Helper function, designed to prune undef values from a nested
# hashtable reference.  Returns the hashref without any undef
# values.
#
# Input: hashref
# Output: hashref
sub _prune {
    my $data = shift;
    if (ref($data) ne 'HASH') {
        return $data;
    }
    foreach my $key (keys %{$data}) {
        if (!defined($data->{$key})) {
            delete($data->{$key}); 
        } elsif (ref($data->{$key}) eq 'HASH') {
            $data->{$key} = _prune($data->{$key}); 
        } elsif (ref($data->{$key}) eq 'ARRAY') {
            foreach my $entry (@{$data->{$key}}) {
                $entry = _prune($entry);
            }
        }
    }
    return $data;
}

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXPORTS

=head2 run(driver_name => $driver_name, master_vm_name => $master_vm_name, service_url => $service_url, user_name => $user_name, password => $password, stomp_address => $stomp_address, stomp_port => $stomp_port, stomp_user_name => $stomp_user_name, stomp_password => $stomp_password, stomp_virtual_host => $stomp_virtual_host, exchange_name => $exchange_name, queue_name => $queue_name, routing_key => $routing_key)

=over 4

Runs the Worker code, using the specified arguments.

I<Inputs>: 
 B<$driver_name> is an optional argument, indicating the driver name to
use when driving all cloned VMs.
 B<$master_vm_name> is an optional argument, indicating the name of
master VM that each clone VM should use.
 B<$service_url> is a required argument for ESX hosts, specifying the URL
to the VIM webservice running on the VMware ESX Server.
 B<$user_name> is a required argument for ESX hosts, specifying the user
name used to authenticate to the VIM webservice running on the VMware
ESX Server.
 B<$password> is a required argument for ESX hosts, specifying the password
used to authenticate to the VIM webservice running on the VMware ESX Server.
 B<$stomp_address> is an optional argument, specifying the IP address
of the STOMP server this component should connect to.
 B<$stomp_port> is an optional argument, specifying the TCP port of the
STOMP server this component should connect to.
 B<$stomp_user_name> is an optional argument, specifying the user name
used to authenticate to the STOMP server.
 B<$stomp_password> is an optional argument, specifying the password
used to authenticate to the STOMP server.
 B<$stomp_virtual_host> is an optional argument, specifying the virtual
host used to authenticate to the STOMP server.
 B<$exchange_name> is an optional argument, specifying the exchange name
to use when sending messages from this component.
 B<$queue_name> is an optional argument, specifying the queue name
to use when receiving messages to this component.
 B<$routing_key> is an optional argument, specifying the routing key
to use when receiving messages to this component.

=back

=begin testing

SKIP: {
    skip "HoneyClient::Manager::Worker->run() can't be easily tested, yet.", 1;
}

=end testing

=cut

sub run {

    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;

    $LOG->info("Starting worker.");

    # If these parameters weren't defined, delete them
    # from the specified arg hash.
    if (!defined($args{'master_vm_name'})) {
        delete $args{'master_vm_name'}; 
    }
    if (!defined($args{'driver_name'})) {
        delete $args{'driver_name'}; 
    }
    
    my $argsExist = scalar(%args);
    my $arg_names = [ 'stomp_address',
                      'stomp_port',
                      'stomp_user_name',
                      'stomp_password',
                      'stomp_virtual_host',
                      'exchange_name',
                      'queue_name',
                      'routing_key', ];

    # Parse optional arguments.
    foreach my $name (@{$arg_names}) {
        if (!($argsExist &&
            exists($args{$name}) &&
            defined($args{$name}))) {
            $args{$name} = getVar(name => $name);
        }
    }

    my $new_args = {
        'hostname'  =>  $args{'stomp_address'},
        'port'      =>  $args{'stomp_port'},
    };
    my $connect_args = {
        'login'         =>  $args{'stomp_user_name'},
        'passcode'      =>  $args{'stomp_password'},
        'virtual-host'  =>  $args{'stomp_virtual_host'},
    };
    my $subscribe_args = {
        'durable'       =>  'true',
        'exclusive'     =>  'false',
        'passive'       =>  'false',
        'auto-delete'   =>  'false',
        'exchange'      =>  $args{'exchange_name'},
        'destination'   =>  $args{'queue_name'},
        'routing_key'   =>  $args{'routing_key'},
        'ack'           =>  'client',
    };


    # Temporary variables to hold our jobs and work.
    my $job  = undef;

    # STOMP client handle.
    my $stomp = undef;
    my $frame = undef;

    eval {
        # Create a new cloned VM.
        my $VM_MODE = getVar(name => "virtualization_mode") . "::Clone";
        my $vm = $VM_MODE->new(%args);

        # Initialize the STOMP client handle.
        $stomp = Net::Stomp->new($new_args);

        # Connect to the STOMP server.
        $stomp->connect($connect_args);

        # Subscribe to the specified exchange, declaring the queue and
        # routing key.
        $stomp->subscribe($subscribe_args);

        $LOG->info("Waiting for more work.");
        while (1) {

            # Get a new job - with retry logic.
            ($frame, $stomp) = _receive_retry(stomp          => $stomp,
                                              new_args       => $new_args,
                                              connect_args   => $connect_args,
                                              subscribe_args => $subscribe_args);
            $LOG->info("Got more work.");

            # TODO: Delete this, eventually.
            $Data::Dumper::Terse = 0;
            $Data::Dumper::Indent = 1;
            #print Dumper($frame) . "\n";

            # Decode and prune the job.
            $job = HoneyClient::Message::Job->new(_prune(decode_json($frame->body)->{'job'}));

            # TODO: Delete this, eventually.
            $Data::Dumper::Terse = 0;
            $Data::Dumper::Indent = 1;
            #print Dumper($job->to_hashref()) . "\n";
            #print Dumper($frame) . "\n";

            # Drive the VM using the specified job.
            $vm = $vm->drive(job => $job);

            # ACK the frame, indicating that the work has been completed.
            $LOG->info("Signaling work complete.");
            $stomp = _ack_retry(stomp          => $stomp,
                                new_args       => $new_args,
                                connect_args   => $connect_args,
                                subscribe_args => $subscribe_args,
                                ack_args       => {
                                    'frame'        =>  $frame,
                                });
        }

    };
    # Report when a fault occurs.
    if ($@) {
        $LOG->error("Encountered an error. Shutting down worker. " . $@);
    }

    # Cleanup - Close STOMP connection.
    if (defined($stomp) &&
        (ref($stomp) eq "Net::Stomp")) {
        $stomp->disconnect();
    }
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

L<HoneyClient::Manager::ESX::Clone/"BUGS & ASSUMPTIONS">

=back

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Paul Kulchenko for developing the SOAP::Lite module.

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
