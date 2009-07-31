#######################################################################
# Created on:  June 08, 2009
# Package:     HoneyClient::Manager::Pcap::Server
# File:        Server.pm
# Description: An AMQP-aware server that provides programmatic access
#              to all VM-specific packet captures on the host system.
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

HoneyClient::Manager::Pcap::Server - Perl extension to instantiate
an AMQP-aware server that provides programmatic access to all VM-specific
packet captures on the host system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Pcap::Server version 1.02.

=head1 SYNOPSIS

=head2 CREATING THE SERVER

  use HoneyClient::Manager::Pcap::Server;

  HoneyClient::Manager::Pcap::Server->run();

=head2 INTERACTING WITH THE SERVER 

  use HoneyClient::Manager::Pcap::Client;

  my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
  my $mac_address = "00:0c:29:c5:11:c7";
  my $src_ip_address = "10.0.0.1";
  my $dst_tcp_port = 80;
  my $result = undef;
  my $session = undef;

  # To start a new packet capture.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
      session => $session,
      quick_clone_name => $quick_clone_name,
      mac_address => $mac_address,
  );
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # To stop a packet capture.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->stopCapture(session => $session, quick_clone_name => $quick_clone_name);
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # To get the first server IP a clone VM contacts.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->getFirstIP(session => $session, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port);
  print "First Server IP: " . Dumper($result) . "\n";

  # To get a relative path to the pcap file.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->getPcapFile(session => $session, quick_clone_name => $quick_clone_name);
  print "PCAP Filename: " . Dumper($result) . "\n";

  # To stop all packet captures.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

=head1 DESCRIPTION

Once created, the daemon acts as a stand-alone AMQP 'server',
processing individual requests and manipulating VM-specific
packet capture sessions on the host system.

=cut

package HoneyClient::Manager::Pcap::Server;

use strict;
use warnings;
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

    # This allows declaration use HoneyClient::Manager::Pcap::Server ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

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
BEGIN { use_ok('HoneyClient::Manager::Pcap::Server') or diag("Can't load HoneyClient::Manager::Pcap::Server package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Pcap::Server');
can_ok('HoneyClient::Manager::Pcap::Server', 'run');
use HoneyClient::Manager::Pcap::Server;

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Net::Stomp loads.
BEGIN { use_ok('Net::Stomp') or diag("Can't load Net::Stomp package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Stomp');
use Net::Stomp;

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

# Make sure HoneyClient::Manager::Pcap loads.
BEGIN { use_ok('HoneyClient::Manager::Pcap') or diag("Can't load HoneyClient::Manager::Pcap package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Pcap');
use HoneyClient::Manager::Pcap;

=end testing

=cut

#######################################################################
# Path Variables                                                      #
#######################################################################

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include Data Dumper API
use Data::Dumper;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Make Dumper format more terse.
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

#######################################################################

# Include STOMP Client Library
use Net::Stomp;

# The global STOMP handle.
our $STOMP = undef;

# Create an initial, empty state of PCAP sessions.
our $PCAP_SESSIONS = {};

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

# Include Base64 Library
use MIME::Base64 qw(decode_base64 encode_base64);

# Include Pcap Library
use HoneyClient::Manager::Pcap;

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

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

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXPORTS

=head2 run(stomp_address => $stomp_address, stomp_port => $stomp_port, stomp_user_name => $stomp_user_name, stomp_password => $stomp_password, stomp_virtual_host => $stomp_virtual_host, exchange_name => $exchange_name, queue_name => $queue_name, routing_key => $routing_key)

=over 4

Runs the server, using the specified arguments.  Specifically, the
daemon connects to the specified STOMP server (which is really an
AMQP server) and declares the exchange and queue that it will
start receiving HoneyClient::Message::Pcap::Command messages.

Based upon the messages received, the daemon will update the
VM-specific packet captures on the host system.

I<Inputs>:
 B<$stomp_address> is an optional argument, specifying the IP address of the STOMP server this component should connect to.
 B<$stomp_port> is an optional argument, specifying the TCP port of the STOMP server this component should connect to.
 B<$stomp_user_name> is an optional argument, specifying the user name used to authenticate to the STOMP server.
 B<$stomp_password> is an optional argument, specifying the password used to authenticate to the STOMP server.
 B<$stomp_virtual_host> is an optional argument, specifying the virtual host used to authenticate to the STOMP server.
 B<$exchange_name> is an optional argument, specifying the exchange name to use when receiving messages sent to this component.
 B<$queue_name> is an optional argument, specifying the queue name to use when receiving messages sent to this component.
 B<$routing_key> is an optional argument, specifying the routing key to use when sending messages to this component.

=back

=begin testing

eval {

    use HoneyClient::Manager::Pcap::Client;

    # Create a new HoneyClient::Manager::Pcap::Server daemon.
    use HoneyClient::Manager::Pcap::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
        my $mac_address = "00:0c:29:c5:11:c7";
        my $src_ip_address = "10.0.0.1";
        my $dst_tcp_port = 80;
        my $result = undef;
        my $session = undef;

        # Start a new packet capture.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
            session => $session,
            quick_clone_name => $quick_clone_name,
            mac_address => $mac_address,
        );

        # Validate the result.
        ok($result, "startCapture(quick_clone_name => '$quick_clone_name', mac_address => '$mac_address')") or diag("The startCapture() call failed.");

        # Sleep for 2s, in order to create the PCAP file.
        sleep(2);

        # Stop a packet capture.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->stopCapture(session => $session, quick_clone_name => $quick_clone_name);

        # Validate the result.
        ok($result, "stopCapture(quick_clone_name => '$quick_clone_name')") or diag("The stopCapture() call failed.");

        # Get the first server IP a clone VM contacts.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->getFirstIP(session => $session, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port);

        # Validate the result.
        is($result, '', "getFirstIP(quick_clone_name => '$quick_clone_name', src_ip_address => '$src_ip_address', dst_tcp_port => '$dst_tcp_port')") or diag("The getFirstIP() call failed.");

        # Get a relative path to the pcap file.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->getPcapFile(session => $session, quick_clone_name => $quick_clone_name);

        # Validate the result.
        ok($result, "getPcapFile(quick_clone_name => '$quick_clone_name')") or diag("The getPcapFile() call failed.");

        # Stop all packet captures.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);

        # Validate the result.
        ok($result, "shutdown()") or diag("The shutdown() call failed.");

        # Cleanup.
        kill("QUIT", $pid);
    } else {
        if (!defined($pid)) {
            die "Unable to fork child process. $!";
        }
        HoneyClient::Manager::Pcap::Server->run();
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub run {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

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

    # Temporary variable, for retry logic.
    my $retry = undef;

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

    # Initialize the STOMP client handle.
    $STOMP = Net::Stomp->new($new_args);

    # Connect to the STOMP server.
    $STOMP->connect($connect_args);

    # Subscribe to the specified exchange, declaring the queue and
    # routing key.
    $STOMP->subscribe($subscribe_args);

    # Loop forever, unless explicitly terminated.
    while (1) {

        # Get a new frame - with retry logic.
        my $frame = undef;
        ($frame, $STOMP) = _receive_retry(stomp          => $STOMP,
                                          new_args       => $new_args,
                                          connect_args   => $connect_args,
                                          subscribe_args => $subscribe_args);

        my $message = HoneyClient::Message::Pcap::Command->new(decode_base64($frame->body));

        # Sanity check.
        if (!scalar(%{$message->to_hashref()})) {
            # Empty hash refs indicate the message did not get parsed properly.
            $LOG->warn("Unable to parse received message.");

            # Construct a reply, if we can.
            if (exists($frame->{'headers'}->{'X-reply-to'}) &&
                defined($frame->{'headers'}->{'X-reply-to'})) {
                $message->set_action(HoneyClient::Message::Pcap::Command::ActionType::UNKNOWN);
                $message->set_response(HoneyClient::Message::Pcap::Command::ResponseType::ERROR);
                $message->set_err_message("Unable to parse received message.");

                # Send response - with retry logic.
                $STOMP = _send_retry(stomp          => $STOMP,
                                     new_args       => $new_args,
                                     connect_args   => $connect_args,
                                     subscribe_args => $subscribe_args,
                                     send_args      => {
                                        'exchange'        =>  $args{'exchange_name'},
                                        'delivery-mode'   =>  2, # Make sure the message is durable.
                                        'destination'     =>  $frame->{'headers'}->{'X-reply-to'},
                                        'body'            =>  encode_base64($message->pack()),
                                        'X-reply-to'      =>  $args{'routing_key'},
                                     });
            }

            # Remove the original message from the incoming queue.
            # Send ACK - with retry logic.
            $STOMP = _ack_retry(stomp          => $STOMP,
                                new_args       => $new_args,
                                connect_args   => $connect_args,
                                subscribe_args => $subscribe_args,
                                ack_args       => {
                                    'frame'        =>  $frame,
                                });
            next;
        }

        my $cmd_response = "1";
        eval {
            # TODO: Terminate server gracefully, if we receive the proper command.
            # XXX: last if $frame->body eq 'QUIT';

            my $cmd_args = $message->to_hashref();
            $cmd_args->{'sessions'} = $PCAP_SESSIONS;
            if ($message->action() == HoneyClient::Message::Pcap::Command::ActionType::STOP_ALL) {
                HoneyClient::Manager::Pcap->shutdown(%{$cmd_args});
            } elsif ($message->action() == HoneyClient::Message::Pcap::Command::ActionType::STOP_VM) {
                $PCAP_SESSIONS = HoneyClient::Manager::Pcap->stopCapture(%{$cmd_args});
            } elsif ($message->action() == HoneyClient::Message::Pcap::Command::ActionType::START_VM) {
                $PCAP_SESSIONS = HoneyClient::Manager::Pcap->startCapture(%{$cmd_args});
            } elsif ($message->action() == HoneyClient::Message::Pcap::Command::ActionType::GET_IP) {
                $cmd_response = HoneyClient::Manager::Pcap->getFirstIP(%{$cmd_args});
            } elsif ($message->action() == HoneyClient::Message::Pcap::Command::ActionType::GET_FILE) {
                $cmd_response = HoneyClient::Manager::Pcap->getPcapFile(%{$cmd_args});
            } else {
                $LOG->warn("Encountered unknown action type (" . $message->action() . ") in message.");
                die "Unknown action type (" . $message->action() . ") in message.\n";
            }

        };
        if ($@) {
            $LOG->error("Error: " . $@);
            # If the commands failed, return an error message.
            $message->set_response(HoneyClient::Message::Pcap::Command::ResponseType::ERROR);
            $message->set_err_message($@);
        } else {
            # If the commands succeeded, return success.
            $message->set_response(HoneyClient::Message::Pcap::Command::ResponseType::OK);
            if (!defined($cmd_response)) {
                $cmd_response = "";
            }
            $message->set_response_message($cmd_response);
        }

        # Construct a reply, if we can.
        if (exists($frame->{'headers'}->{'X-reply-to'}) &&
            defined($frame->{'headers'}->{'X-reply-to'})) { 

            # Send response - with retry logic.
            $STOMP = _send_retry(stomp          => $STOMP,
                                 new_args       => $new_args,
                                 connect_args   => $connect_args,
                                 subscribe_args => $subscribe_args,
                                 send_args      => {
                                    'exchange'        =>  $args{'exchange_name'},
                                    'delivery-mode'   =>  2, # Make sure the message is durable.
                                    'destination'     =>  $frame->{'headers'}->{'X-reply-to'},
                                    'body'            =>  encode_base64($message->pack()),
                                    'X-reply-to'      =>  $args{'routing_key'},
                                 });
        }

        # Remove the original message from the incoming queue.
        # Send ACK - with retry logic.
        $STOMP = _ack_retry(stomp          => $STOMP,
                            new_args       => $new_args,
                            connect_args   => $connect_args,
                            subscribe_args => $subscribe_args,
                            ack_args       => {
                                'frame'        =>  $frame,
                            });

    }
    $STOMP->disconnect();
}

#######################################################################
# Module Shutdown                                                     #
#######################################################################

=pod

=head2 stop()

=over 4

Stops the server.

=back

=cut

sub stop {

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

    HoneyClient::Manager::Pcap->shutdown(sessions => $PCAP_SESSIONS);

    # Properly disconnect from the STOMP server.
    if (defined($STOMP) &&
        (ref($STOMP) eq "Net::Stomp")) {
        $STOMP->disconnect();
    }
}

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 FAULT REPORTING & IMPLEMENTATION DETAILS

Any faults generated from client RPC calls are sent back to the corresponding
client via the response message.  It is up to the client to properly
parse and handle the corresponding error from there.

=head1 BUGS & ASSUMPTIONS

The server makes a best-effort attempt at parsing all messages received.
If it fails to properly decode any messages, then it will emit a corresponding
warning -- but not terminate.

There is no way to terminate the server remotely, this can be a
(potential) limitation or a security feature.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

Net::Stomp

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Leon Brocard E<lt>acme@astray.comE<gt>, for using their
Net::Stomp library to communicate with an AMQP server.

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
