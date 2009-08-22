#######################################################################
# Created on:  June 08, 2009
# Package:     HoneyClient::Manager::Pcap::Client
# File:        Client.pm
# Description: An AMQP-aware client that provides programmatic
#              access to all VM-specific firewall rules on a
#              remote system.
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

HoneyClient::Manager::Pcap::Client - Perl extension to instantiate
an AMQP-aware client that provides programmatic access to all VM-specific
packet captures on a remote system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Pcap::Client version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::Pcap::Client;
  use Data::Dumper;
  use Compress::Zlib;
  use MIME::Base64 qw(encode_base64 decode_base64);

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

  # To get the data in the pcap file.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->getPcapData(session => $session, quick_clone_name => $quick_clone_name);
  print "PCAP Data: " . Dumper(uncompress(decode_base64($result))) . "\n";

  # To stop all packet captures.
  ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

=head1 DESCRIPTION

This library provides static calls to control packet capture sessions on a
(potentially) remote system that is running the HoneyClient::Manager::Pcap::Server
daemon.

=cut

package HoneyClient::Manager::Pcap::Client;

use strict;
use warnings;
use Carp ();

#######################################################################
# Module Initialization                                               #
#######################################################################

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION, $INIT_FILTER_RULES);

    # Set our package version.
    $VERSION = 1.02;

    @ISA = qw(Exporter);

    # Symbols to export automatically
    @EXPORT = qw();

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Manager::Pcap::Client ':all';
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

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::Pcap::Client') or diag("Can't load HoneyClient::Manager::Pcap::Client package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Pcap::Client');
use HoneyClient::Manager::Pcap::Client;

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

# Make sure Data::UUID loads.
BEGIN { use_ok('Data::UUID') or diag("Can't load Data::UUID package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::UUID');
use Data::UUID;

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

=end testing

=cut

#######################################################################
# Path Variables                                                      #
#######################################################################

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include Base64 Library
use MIME::Base64 qw(decode_base64 encode_base64);

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

# Include UUID Generator
use Data::UUID;

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

#######################################################################
# Private Functions                                                   #
#######################################################################

# Helper function, designed to try and receive the next frame.
# If we fail, then we automatically retry.
#
# Inputs:
#   stomp          - the current STOMP object
#   new_args       - the STOMP new arguments
#   connect_args   - the STOMP connect arguments
#   subscribe_args - the STOMP subscribe arguments
#   send_args      - the STOMP send arguments
#   command        - the HoneyClient::Message::Pcap::Command to serialize
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
            $LOG->warn("Encountered a STOMP error while receiving. " . $@);
            $LOG->info("Retrying STOMP connection.");

            $frame = undef;
            $args{'stomp'} = undef;
            # Resend the original request.
            $args{'stomp'} = _send_retry(%args);
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
#   command        - the HoneyClient::Message::Pcap::Command to serialize
# Output: the STOMP object
sub _send_retry {
    # Extract arguments.
    my (%args) = @_;

    my $retry = 1;
    while ($retry) {

        if (!defined($args{'stomp'})) {
            # Initialize the STOMP client handle.
            $args{'stomp'} = Net::Stomp->new($args{'new_args'});

            # Connect to the STOMP server.
            $args{'stomp'}->connect($args{'connect_args'});

            # Subscribe to the specified exchange, declaring the queue and
            # routing key.
            $args{'stomp'}->subscribe($args{'subscribe_args'});
        }

        $args{'send_args'}->{'body'} = encode_base64($args{'command'}->pack());

        eval {
            $args{'stomp'}->send($args{'send_args'});
            $retry = 0;
        };
        if ($@) {
            $LOG->warn("Encountered a STOMP error while sending. " . $@);
            $LOG->info("Retrying STOMP connection.");

            if (defined($args{'stomp'}) &&
                (ref($args{'stomp'}) eq "Net::Stomp")) {
                $args{'stomp'}->disconnect();
            }
            $args{'stomp'} = undef;
        }
    }

    return $args{'stomp'};
}

# Helper function, designed to send HoneyClient::Message::Pcap::Command
# type of messages to the HoneyClient::Manager::Pcap::Server, and
# interpret the corresponding responses.
#
# _send(message => $message, session => $session, stomp_address => $stomp_address, stomp_port => $stomp_port, stomp_user_name => $stomp_user_name, stomp_password => $stomp_password, stomp_virtual_host => $stomp_virtual_host, exchange_name => $exchange_name)
#
# Inputs:
#  $message is a required argument, specifying the HoneyClient::Message::Pcap::Command to send.
#  $session is an optional argument, specifying the existing Net::Stomp session to use for connecting to the STOMP server.
#  $stomp_address is an optional argument, specifying the IP address of the STOMP server this component should connect to.
#  $stomp_port is an optional argument, specifying the TCP port of the STOMP server this component should connect to.
#  $stomp_user_name is an optional argument, specifying the user name used to authenticate to the STOMP server.
#  $stomp_password is an optional argument, specifying the password used to authenticate to the STOMP server.
#  $stomp_virtual_host is an optional argument, specifying the virtual host used to authenticate to the STOMP server.
#  $exchange_name is an optional argument, specifying the exchange name to use when sending messages from this component.
#
# Output:
#  Returns (response_message, Net::Stomp $session) if successful; croaks otherwise.
sub _send {
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

    # Parse required arguments.
    if (!($argsExist &&
        exists($args{'message'}) &&
        defined($args{'message'}))) {

        $LOG->error("Error: Unable to send command - unknown or invalid message specified.");
        Carp::croak "Error: Unable to send command - unknown or invalid message specified.";
    }

    my $arg_names = [ 'stomp_address',
                      'stomp_port',
                      'stomp_user_name',
                      'stomp_password',
                      'stomp_virtual_host',
                      'exchange_name', ];

    # Parse optional arguments.
    foreach my $name (@{$arg_names}) {
        if (!($argsExist &&
            exists($args{$name}) &&
            defined($args{$name}))) {
            $args{$name} = getVar(name => $name);
        }
    }

    # Check if an existing Net::Stomp session was defined.
    if (!($argsExist &&
        exists($args{'session'}) &&
        defined($args{'session'}))) {
        $args{'session'} = undef;
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

    # Generate a random queue name and routing key (for temporary use).
    my $generator = Data::UUID->new();
    $args{'queue_name'} = $generator->create_str();
    $args{'routing_key'} = $args{'queue_name'};

    my $subscribe_args = {
        'durable'       =>  'false',
        'exclusive'     =>  'true',
        'passive'       =>  'false',
        'auto-delete'   =>  'true',
        'exchange'      =>  $args{'exchange_name'},
        'destination'   =>  $args{'queue_name'},
        'routing_key'   =>  $args{'routing_key'},
        'ack'           =>  'auto',
    };

    # Subscribe to the specified exchange, declaring the queue and
    # routing key.
    if (defined($args{'session'}) &&
        (ref($args{'session'}) eq "Net::Stomp")) {
        $args{'session'}->subscribe($subscribe_args);
    }

    # Pack the message.
    my $command = HoneyClient::Message::Pcap::Command->new($args{'message'});
    my $send_args = {
        'exchange'      =>  $args{'exchange_name'},
        'delivery-mode' =>  2, # Make sure the message is durable.
        'destination'   =>  getVar(name => "routing_key"),
        'X-reply-to'    =>  $args{'routing_key'},
    };

    my $message = undef;

    while (!defined($message) || ($message->response() == HoneyClient::Message::Pcap::Command::ResponseType::ERROR)) {

        # Send the message - with retry logic.
        $args{'session'} = _send_retry(stomp          => $args{'session'},
                                       new_args       => $new_args,
                                       connect_args   => $connect_args,
                                       subscribe_args => $subscribe_args,
                                       send_args      => $send_args,
                                       command        => $command);

        # Wait for the response - with retry logic.
        my $frame = undef;
        ($frame, $args{'session'}) = _receive_retry(stomp          => $args{'session'},
                                                    new_args       => $new_args,
                                                    connect_args   => $connect_args,
                                                    subscribe_args => $subscribe_args,
                                                    send_args      => $send_args,
                                                    command        => $command);
        $message = HoneyClient::Message::Pcap::Command->new(decode_base64($frame->body));

        # Sanity check.
        if (!scalar(%{$message->to_hashref()})) {
            # Empty hash refs indicate the message did not get parsed properly.
            $LOG->warn("Error: Unable to parse acknowledgement message - Retrying operation.");

            $message = undef;
            next;
        }

        if ($message->response() == HoneyClient::Message::Pcap::Command::ResponseType::ERROR) {
            my $err_message = "Error: Pcap command failed, but no error message was provided.";
            if ($message->has_err_message()) {
                $err_message = $message->err_message();
            }
            $LOG->warn($err_message . " - Retrying operation.");

        } elsif ($message->response() != HoneyClient::Message::Pcap::Command::ResponseType::OK) {
            $LOG->warn("Encoutered unknown response type (" . $message->response() . ") in acknowledgement message.");
        }
    }

    # Unsubscribe to the specified exchange, destroying the temporary queue.
    if (defined($args{'session'}) &&
        (ref($args{'session'}) eq "Net::Stomp")) {
        $args{'session'}->unsubscribe($subscribe_args);
    }

    return ($message->response_message(), $args{'session'});
}

#######################################################################
# Public Functions                                                    #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

=head2 shutdown(session => $session)

=over 4

Shuts down all running packet captures.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 

I<Output>: Returns (true, $session) if successful; croaks otherwise.

=back

=begin testing

eval {

    # Create a new HoneyClient::Manager::Pcap::Server daemon.
    use HoneyClient::Manager::Pcap::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        # Deny all traffic.
        my $session = undef;
        my $result = undef;
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

sub shutdown {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $session = undef;
    if (defined($args{'session'})) {
        $session = delete $args{'session'}; 
    }
    return HoneyClient::Manager::Pcap::Client->_send(session => $session, message => { action => HoneyClient::Message::Pcap::Command::ActionType::STOP_ALL });
}

=pod

=head2 getFirstIP(session => $session, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port)

=over 4

Given a quick clone name, source IP, and destination TCP port, this function will
lookup any matching capture session and attempt to extract the first IP address the
clone VM contacts on the specified destination TCP port.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 
 B<$quick_clone_name> is the name of the quick clone VM.
 B<$src_ip_address> is the VM's IP address.
 B<$dst_tcp_port> is the destination TCP port of the server to match.

I<Output>: Returns the IP address, if successful; empty string otherwise.

=back

=begin testing

eval {
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

        ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
            session => $session,
            quick_clone_name => $quick_clone_name,
            mac_address => $mac_address,
        );

        # Sleep for 2s, in order to create PCAP file.
        sleep(2);

        ($result, $session) = HoneyClient::Manager::Pcap::Client->stopCapture(session => $session, quick_clone_name => $quick_clone_name);
        ($result, $session) = HoneyClient::Manager::Pcap::Client->getFirstIP(session => $session, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port);

        # Validate the result.
        is($result, '', "getFirstIP(quick_clone_name => '$quick_clone_name', src_ip_address => '$src_ip_address', dst_tcp_port => '$dst_tcp_port')") or diag("The getFirstIP() call failed.");

        # Shutdown all packet captures.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);

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

sub getFirstIP {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $session = undef;
    if (defined($args{'session'})) {
        $session = delete $args{'session'}; 
    }
    $args{'action'} = HoneyClient::Message::Pcap::Command::ActionType::GET_IP;
    return HoneyClient::Manager::Pcap::Client->_send(session => $session, message => \%args);
}

=pod

=head2 getPcapFile(session => $session, quick_clone_name => $quick_clone_name)

=over 4

Given a quick clone name, this function will return the path and file name of
any corresponding generated .pcap file.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 
 B<$quick_clone_name> is the name of the quick clone VM.

I<Output>: Returns the path and file name of the .pcap file, if successful;
empty string otherwise.

=back

=begin testing

eval {
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

        ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
            session => $session,
            quick_clone_name => $quick_clone_name,
            mac_address => $mac_address,
        );

        # Sleep for 2s, in order to create PCAP file.
        sleep(2);

        ($result, $session) = HoneyClient::Manager::Pcap::Client->stopCapture(session => $session, quick_clone_name => $quick_clone_name);
        ($result, $session) = HoneyClient::Manager::Pcap::Client->getPcapFile(session => $session, quick_clone_name => $quick_clone_name);

        # Validate the result.
        ok($result, "getPcapFile(quick_clone_name => '$quick_clone_name')") or diag("The getPcapFile() call failed.");

        # Shutdown all packet captures.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);

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

sub getPcapFile {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $session = undef;
    if (defined($args{'session'})) {
        $session = delete $args{'session'}; 
    }
    $args{'action'} = HoneyClient::Message::Pcap::Command::ActionType::GET_FILE;
    return HoneyClient::Manager::Pcap::Client->_send(session => $session, message => \%args);
}

=pod

=head2 getPcapData(session => $session, quick_clone_name => $quick_clone_name)

=over 4

Given a quick clone name, this function will return the contents of any corresponding
generated .pcap file in Zlib compressed, base64 encoded form.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 
 B<$quick_clone_name> is the name of the quick clone VM.

I<Output>: Returns the contents of the .pcap file in compressed, base64 encoded form, if successful;
empty string otherwise.

=back

=begin testing

eval {
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

        ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
            session => $session,
            quick_clone_name => $quick_clone_name,
            mac_address => $mac_address,
        );

        # Sleep for 2s, in order to create PCAP file.
        sleep(2);

        ($result, $session) = HoneyClient::Manager::Pcap::Client->stopCapture(session => $session, quick_clone_name => $quick_clone_name);
        ($result, $session) = HoneyClient::Manager::Pcap::Client->getPcapData(session => $session, quick_clone_name => $quick_clone_name);

        # Validate the result.
        ok($result, "getPcapData(quick_clone_name => '$quick_clone_name')") or diag("The getPcapData() call failed.");

        # Shutdown all packet captures.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);

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

sub getPcapData {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $session = undef;
    if (defined($args{'session'})) {
        $session = delete $args{'session'}; 
    }
    $args{'action'} = HoneyClient::Message::Pcap::Command::ActionType::GET_DATA;
    return HoneyClient::Manager::Pcap::Client->_send(session => $session, message => \%args);
}

=pod

=head2 startCapture(session => $session, quick_clone_name => $quick_clone_name, mac_address => $mac_address)

=over 4

Updates the firewall to allow the specified client's MAC/IP address to
have limited network connectivity.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 
 B<$quick_clone_name> is the name of the quick clone VM to monitor.
 B<$mac_address> is the VM's MAC address.

I<Output>: Returns true, if successful; croaks otherwise.

I<Notes>:
If startCapture() is called multiple times successively with the same quick_clone_name,
then the previously associated packet capture session will be discarded.

=back

=begin testing

eval {
    # Create a new HoneyClient::Manager::Pcap::Server daemon.
    use HoneyClient::Manager::Pcap::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
        my $mac_address = "00:0c:29:c5:11:c7";
        my $result = undef;
        my $session = undef;

        ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
            session => $session,
            quick_clone_name => $quick_clone_name,
            mac_address => $mac_address,
        );

        # Validate the result.
        ok($result, "startCapture(quick_clone_name => '$quick_clone_name', mac_address => '$mac_address')") or diag("The startCapture() call failed.");

        # Shutdown all packet captures.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);

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

sub startCapture {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $session = undef;
    if (defined($args{'session'})) {
        $session = delete $args{'session'}; 
    }
    $args{'action'} = HoneyClient::Message::Pcap::Command::ActionType::START_VM;
    return HoneyClient::Manager::Pcap::Client->_send(session => $session, message => \%args);
}

=pod

=head2 stopCapture(session => $session, quick_clone_name => $quick_clone_name)

=over 4

Stops a packet capture session of the specified quick clone VM.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 
 B<$quick_clone_name> is the name of the quick clone VM.

I<Output>: Returns true, if successful; croaks otherwise.

=back

=begin testing

eval {

    # Create a new HoneyClient::Manager::Pcap::Server daemon.
    use HoneyClient::Manager::Pcap::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
        my $mac_address = "00:0c:29:c5:11:c7";
        my $result = undef;
        my $session = undef;

        ($result, $session) = HoneyClient::Manager::Pcap::Client->startCapture(
            session => $session,
            quick_clone_name => $quick_clone_name,
            mac_address => $mac_address,
        );

        ($result, $session) = HoneyClient::Manager::Pcap::Client->stopCapture(session => $session, quick_clone_name => $quick_clone_name);

        # Validate the result.
        ok($result, "stopCapture(quick_clone_name => '$quick_clone_name')") or diag("The stopCapture() call failed.");
    
        # Shutdown all packet captures.
        ($result, $session) = HoneyClient::Manager::Pcap::Client->shutdown(session => $session);

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

sub stopCapture {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $session = undef;
    if (defined($args{'session'})) {
        $session = delete $args{'session'}; 
    }
    $args{'action'} = HoneyClient::Message::Pcap::Command::ActionType::STOP_VM;
    return HoneyClient::Manager::Pcap::Client->_send(session => $session, message => \%args);
}

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 TODO

Develop a 'monitor' capability, in order to detect suspicious network
activity eminating from any of the allowed VMs.  The assumption is that
while malware inside a VM could change the VM's MAC address, VMware will
only allow packets through the network if they match the MAC address
assigned to that VM.  Therefore, all packets coming from the honeyclient
network should correlate with any of the active VMs.

Thus, we need to develop a new call:
checkVM(mac_address => ...), which would

1) check the logs for any suspicious activity
2) if activity is found, then figure out if that VM is responsible
3) if the VM is responsible, return 1; otherwise, return 0

This will require updating the syslog-ng.conf file, in order to
create dedicated logs for 1) IP-to-MAC mappings and 2) Forward block
entries.

=head1 BUGS & ASSUMPTIONS

Before running this code, it is assumed that the
HoneyClient::Manager::Pcap::Server daemon is configured and running
on a (potentially) remote system.  As such, the same AMQP/STOMP server
that the daemon is using must also be used by this client.  Specifically,
this library assumes that the <stomp_*>, <exchange_name>, <queue_name>,
and <routing_key> entries defined within the etc/honeyclient.xml are
the same between the client and daemon libraries, in order to have
both components communicate properly.

=head1 SEE ALSO

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
