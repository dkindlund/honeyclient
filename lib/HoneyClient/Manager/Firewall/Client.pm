#######################################################################
# Created on:  Jan 21, 2009
# Package:     HoneyClient::Manager::Firewall::Client
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

HoneyClient::Manager::Firewall::Client - Perl extension to instantiate
an AMQP-aware client that provides programmatic access to all VM-specific
firewall rules on a remote system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Firewall::Client version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::Firewall::Client;

  # To deny all VM-specific traffic.
  if (HoneyClient::Manager::Firewall::Client->denyAllTraffic()) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # To allow all VM-specific traffic.
  if (HoneyClient::Manager::Firewall::Client->allowAllTraffic()) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # To allow specific VM traffic.
  my $chain_name = "1ea37e398a4d1d0314da7bdee8";
  my $mac_address = "00:0c:29:c5:11:c7";
  my $ip_address = "10.0.0.254";
  my $protocol = "tcp";
  my $port = [ 80, 443 ];

  my $result = HoneyClient::Manager::Firewall::Client->allowVM(
      chain_name => $chain_name,
      mac_address => $mac_address,
      ip_address => $ip_address,
      protocol => $protocol,
      port => $port,
  );
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # Then, to deny specific VM traffic.
  $result = HoneyClient::Manager::Firewall::Client->denyVM(chain_name => $chain_name);
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

=head1 DESCRIPTION

This library provides static calls to control the IPTables interface on a
(potentially) remote system that is running the HoneyClient::Manager::Firewall::Server
daemon.  This library only alters the existing firewall ruleset on the
remote system; it does not create or delete any base rules defined by the
remote system.

Specifically, this library assumes that the remote system already has all
the necessary static firewall rules in place to 'deny all' VM traffic.
As such, the library saves this firewall state of the 'filter' table,
using the '/sbin/iptables-save' command on the remote system.

Then, upon exit or reset, the library restores this state of the 'filter'
table back to this 'deny all' mode, using the '/sbin/iptables-restore'
command on the remote system.

Note: This code assumes that the IPTables 'filter' table on the remote system was 
configured using the standared Uncomplicated Firewall (UFW) framework that is
packaged with the Ubuntu Linux distribution.  As such, the code relies
on UFW to have setup and established the basic 'ufw-*' chain names
within the 'filter' table.

=cut

package HoneyClient::Manager::Firewall::Client;

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

    # This allows declaration use HoneyClient::Manager::Firewall::Client ':all';
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
BEGIN { use_ok('HoneyClient::Manager::Firewall::Client') or diag("Can't load HoneyClient::Manager::Firewall::Client package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall::Client');
use HoneyClient::Manager::Firewall::Client;

# Make sure Net::Stomp loads.
BEGIN { use_ok('Net::Stomp') or diag("Can't load Net::Stomp package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Stomp');
use Net::Stomp;

# Make sure Data::UUID loads.
BEGIN { use_ok('Data::UUID') or diag("Can't load Data::UUID package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::UUID');
use Data::UUID;

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

diag("About to run extended tests.");
diag("Warning: These tests may alter the host system's firewall.");
diag("NOTE: The UFW service MUST already be running; if unsure, type '/etc/init.d/ufw restart' as root.");
diag("As such, Running these tests via a remote session is NOT advised.");
diag("");

my $question = prompt("# Do you want to run extended tests?", "yes");
if ($question !~ /^y.*/i) { exit; }

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

# Include UUID Generator
use Data::UUID;

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

#######################################################################
# Private Functions                                                   #
#######################################################################

# Helper function, designed to send HoneyClient::Message::Firewall::Command
# type of messages to the HoneyClient::Manager::Firewall::Server, and
# interpret the corresponding responses.
#
# _send(message => $message, stomp_address => $stomp_address, stomp_port => $stomp_port, stomp_user_name => $stomp_user_name, stomp_password => $stomp_password, stomp_virtual_host => $stomp_virtual_host, exchange_name => $exchange_name)
#
# Inputs:
#  $message is a required argument, specifying the HoneyClient::Message::Firewall::Command to send.
#  $stomp_address is an optional argument, specifying the IP address of the STOMP server this component should connect to.
#  $stomp_port is an optional argument, specifying the TCP port of the STOMP server this component should connect to.
#  $stomp_user_name is an optional argument, specifying the user name used to authenticate to the STOMP server.
#  $stomp_password is an optional argument, specifying the password used to authenticate to the STOMP server.
#  $stomp_virtual_host is an optional argument, specifying the virtual host used to authenticate to the STOMP server.
#  $exchange_name is an optional argument, specifying the exchange name to use when sending messages from this component.
#  $queue_name is an optional argument, specifying the queue name to use when receiving messages sent to this component.
#  $routing_key is an optional argument, specifying the routing key to use when sending messages to this component.
#
# Output:
#  Returns true if successful; croaks otherwise.
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
        defined($args{'message'})) &&
        (ref($args{'message'}) ne "HoneyClient::Message::Firewall::Command")) {

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

    # Initialize the STOMP client handle.
    my $stomp = Net::Stomp->new({
                    'hostname'  =>  $args{'stomp_address'},
                    'port'      =>  $args{'stomp_port'},
                });

    # Connect to the STOMP server.
    $stomp->connect({
                'login'         =>  $args{'stomp_user_name'},
                'passcode'      =>  $args{'stomp_password'},
                'virtual-host'  =>  $args{'stomp_virtual_host'},
    });

    # Generate a random queue name and routing key (for temporary use).
    my $generator = Data::UUID->new();
    $args{'queue_name'} = $generator->create_str();
    $args{'routing_key'} = $args{'queue_name'};

    # Subscribe to the specified exchange, declaring the queue and
    # routing key.
    $stomp->subscribe({
                'durable'       =>  'false',
                'exclusive'     =>  'true',
                'passive'       =>  'false',
                'auto-delete'   =>  'true',
                'exchange'      =>  $args{'exchange_name'},
                'destination'   =>  $args{'queue_name'},
                'routing_key'   =>  $args{'routing_key'},
                'ack'           =>  'auto',
    });

    # Pack the message.
    my $command = HoneyClient::Message::Firewall::Command->new($args{'message'});
    my $body = $command->pack();

    # Send the message.
    $stomp->send({
        'exchange'      =>  $args{'exchange_name'},
        'delivery-mode' =>  2, # Make sure the message is durable.
        'destination'   =>  getVar(name => "routing_key"),
        'body'          =>  $body,
        'X-reply-to'    =>  $args{'routing_key'},
    });


    # Wait for the response.
    my $frame = $stomp->receive_frame();
    my $message = HoneyClient::Message::Firewall::Command->new($frame->body);
    $stomp->disconnect();

    # Sanity check.
    if (!scalar(%{$message->to_hashref()})) {
        # Empty hash refs indicate the message did not get parsed properly.
        $LOG->error("Error: Unable to parse acknowledgement message.");
        Carp::croak "Error: Unable to parse acknowledgement message.";
    }

    if ($message->response() == HoneyClient::Message::Firewall::Command::ResponseType::ERROR) {
        my $err_message = "Error: Firewall command failed, but no error message was provided.";
        if ($message->has_err_message()) {
            $err_message = $message->err_message();
        }
        $LOG->error($err_message);
        Carp::croak $err_message;
    } elsif ($message->response() != HoneyClient::Message::Firewall::Command::ResponseType::OK) {
        $LOG->warn("Encoutered unknown response type (" . $message->response() . ") in acknowledgement message.");
    }
    return 1;
}

#######################################################################
# Public Functions                                                    #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

=head2 denyAllTraffic()

=over 4

Clears all existing VM-specific chains and denies all future traffic
through the firewall.

I<Inputs>: None.

I<Output>: Returns true if successful; croaks otherwise.

=back

=begin testing

eval {

    # Create a new HoneyClient::Manager::Firewall::Server daemon.
    use HoneyClient::Manager::Firewall::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        # Deny all traffic.
        my $result = HoneyClient::Manager::Firewall::Client->denyAllTraffic();

        # Validate the result.
        ok($result, "denyAllTraffic()") or diag("The denyAllTraffic() call failed.");

        # Cleanup.
        kill("QUIT", $pid);
    } else {
        if (!defined($pid)) {
            die "Unable to fork child process. $!";
        }
        HoneyClient::Manager::Firewall::Server->run();
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub denyAllTraffic {
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

    return HoneyClient::Manager::Firewall::Client->_send(message => { action => HoneyClient::Message::Firewall::Command::ActionType::DENY_ALL });
}

=pod

=head2 allowAllTraffic()

=over 4

Clears all existing VM-specific chains and allows all future traffic
through the firewall.

I<Inputs>: None.

I<Output>: Returns true, if successful; croaks otherwise.

=back

=begin testing

eval {
    # Create a new HoneyClient::Manager::Firewall::Server daemon.
    use HoneyClient::Manager::Firewall::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        # Allow all traffic.
        my $result = HoneyClient::Manager::Firewall::Client->allowAllTraffic();

        # Validate the result.
        ok($result, "allowAllTraffic()") or diag("The allowAllTraffic() call failed.");
    
        # Restore the default ruleset.
        HoneyClient::Manager::Firewall::Client->denyAllTraffic();

        # Cleanup.
        kill("QUIT", $pid);
    } else {
        if (!defined($pid)) {
            die "Unable to fork child process. $!";
        }
        HoneyClient::Manager::Firewall::Server->run();
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub allowAllTraffic {
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

    return HoneyClient::Manager::Firewall::Client->_send(message => { action => HoneyClient::Message::Firewall::Command::ActionType::ALLOW_ALL });
}

=pod

=head2 allowVM(chain_name => $chain_name, mac_address => $mac_address, ip_address => $ip_address, protocol => $protocol, port => $port)

=over 4

Updates the firewall to allow the specified client's MAC/IP address to
have limited network connectivity.

I<Inputs>:
 B<$chain_name> is the name of the IPTables chain name to use for this access.
 B<$mac_address> is the client's MAC address.
 B<$ip_address> is the client's IP address.
 B<$protocol> is the protocol to be allowed.
 B<$port> is an array reference, containing the list of ports to be allowed.

I<Output>: Returns true, if successful; croaks otherwise.

I<Notes>:
If allowVM() is called multiple times successively, then the previous rules associated
with this chain will be purged.

=back

=begin testing

eval {
    # Create a new HoneyClient::Manager::Firewall::Server daemon.
    use HoneyClient::Manager::Firewall::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);

        # Allow VM traffic.
        my $chain_name = "1ea37e398a4d1d0314da7bdee8";
        my $mac_address = "00:0c:29:c5:11:c7";
        my $ip_address = "10.0.0.254";
        my $protocol = "tcp";
        my $port = [ 80, 443 ];

        my $result = HoneyClient::Manager::Firewall::Client->allowVM(
            chain_name => $chain_name,
            mac_address => $mac_address,
            ip_address => $ip_address,
            protocol => $protocol,
            port => $port,
        );

        # Validate the result.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        ok($result, "allowVM(chain_name => '$chain_name', mac_address => '$mac_address', ip_address => '$ip_address', protocol => '$protocol', port => '" . Dumper($port) . "')") or diag("The allowVM() call failed.");

        # Restore the default ruleset.
        HoneyClient::Manager::Firewall::Client->denyAllTraffic();

        # Cleanup.
        kill("QUIT", $pid);
    } else {
        if (!defined($pid)) {
            die "Unable to fork child process. $!";
        }
        HoneyClient::Manager::Firewall::Server->run();
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub allowVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    $args{'action'} = HoneyClient::Message::Firewall::Command::ActionType::ALLOW_VM;
    return HoneyClient::Manager::Firewall::Client->_send(message => \%args);
}

=pod

=head2 denyVM(chain_name => $chain_name)

=over 4

Updates the firewall to deny the specified client's network
connectivity by deleting the corresponding chain.

I<Inputs>:
 B<$chain_name> is the name of the IPTables chain name to delete.

I<Output>: Returns true, if successful; croaks otherwise.

=back

=begin testing

eval {

    # Create a new HoneyClient::Manager::Firewall::Server daemon.
    use HoneyClient::Manager::Firewall::Server;

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);


        # Allow VM traffic.
        my $chain_name = "1ea37e398a4d1d0314da7bdee8";
        my $mac_address = "00:0c:29:c5:11:c7";
        my $ip_address = "10.0.0.254";
        my $protocol = "tcp";
        my $port = [ 80, 443 ];

        HoneyClient::Manager::Firewall::Client->allowVM(
            chain_name => $chain_name,
            mac_address => $mac_address,
            ip_address => $ip_address,
            protocol => $protocol,
            port => $port,
        );

        # Then, deny VM traffic.
        my $result = HoneyClient::Manager::Firewall::Client->denyVM(chain_name => $chain_name);

        # Validate the result.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        ok($result, "denyVM(chain_name => '$chain_name')") or diag("The denyVM() call failed.");
    
        # Restore the default ruleset.
        HoneyClient::Manager::Firewall::Client->denyAllTraffic();

        # Cleanup.
        kill("QUIT", $pid);
    } else {
        if (!defined($pid)) {
            die "Unable to fork child process. $!";
        }
        HoneyClient::Manager::Firewall::Server->run();
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub denyVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    $args{'action'} = HoneyClient::Message::Firewall::Command::ActionType::DENY_VM;
    return HoneyClient::Manager::Firewall::Client->_send(message => \%args);
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

This code assumes that the IPTables 'filter' table on the remote system was 
configured using the standared Uncomplicated Firewall (UFW) framework that is
packaged with the Ubuntu Linux distribution.  As such, the code relies
on UFW to have setup and established the basic 'ufw-*' chain names
within the 'filter' table.

Before running this code, it is assumed that the
HoneyClient::Manager::Firewall::Server daemon is configured and running
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
