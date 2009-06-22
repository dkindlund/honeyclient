#######################################################################
# Created on:  Mar 18, 2009
# Package:     HoneyClient::Util::EventEmitter
# File:        EventEmitter.pm
# Description: An AMQP-aware client that sends HoneyClient::Message::*
#              messages to the Drone via the AMQP/STOMP server.
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

HoneyClient::Util::EventEmitter - Perl extension to send HoneyClient::Message::*
messages to the Drone via a STOMP server.

=head1 VERSION

This documentation refers to HoneyClient::Util::EventEmitter version 1.02.

=head1 SYNOPSIS

  use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
  use HoneyClient::Message;
  use HoneyClient::Util::EventEmitter;

  # To send an updated "Host" event:
  my $message = HoneyClient::Message::Host->new({
      hostname => "honeyclient1.foo.com",
      ip       => "10.0.0.1",
  })

  HoneyClient::Util::EventEmitter->Host(action => 'find_or_create', message => $message)

=head1 DESCRIPTION

This library allows the Manager to send specific HoneyClient::Message::* events
to the Drone via a specified STOMP server.

=cut

package HoneyClient::Util::EventEmitter;

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

    # This allows declaration use HoneyClient::Util::EventEmitter ':all';
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
BEGIN { use_ok('HoneyClient::Util::EventEmitter') or diag("Can't load HoneyClient::Util::EventEmitter package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::EventEmitter');
use HoneyClient::Util::EventEmitter;

# Make sure Net::Stomp loads.
BEGIN { use_ok('Net::Stomp') or diag("Can't load Net::Stomp package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Stomp');
use Net::Stomp;

# Make sure JSON::XS loads.
BEGIN { use_ok('JSON::XS', qw(encode_json)) or diag("Can't load JSON::XS package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('JSON::XS');
can_ok('JSON::XS', 'encode_json');
use JSON::XS qw(encode_json);

# Make sure String::CamelCase loads.
BEGIN { use_ok('String::CamelCase', qw(decamelize)) or diag("Can't load String::CamelCase package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('String::CamelCase');
can_ok('String::CamelCase', 'decamelize');
use String::CamelCase qw(decamelize);

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

# Include JSON Library
use JSON::XS qw(encode_json);

# Include CamelCase Library
use String::CamelCase qw(decamelize);

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

# Package Global Variable
our $AUTOLOAD;

#######################################################################
# Private Functions                                                   #
#######################################################################

# Helper function, designed to try and send the supplied frame.
# If we fail, then we automatically retry.
#
# Inputs:
#   stomp          - the current STOMP object
#   new_args       - the STOMP new arguments
#   connect_args   - the STOMP connect arguments
#   send_args      - the STOMP send arguments
#   event          - the encoded HoneyClient::Message::* to send
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
        }

        $args{'send_args'}->{'body'} = $args{'event'};

        eval {
            $args{'stomp'}->send($args{'send_args'});
            $retry = 0;
        };
        if ($@) {
            $LOG->warn("Process ID (" . $$ . "): Encountered a STOMP error while sending. " . $@);
            $LOG->info("Process ID (" . $$ . "): Retrying STOMP connection.");

            if (defined($args{'stomp'}) &&
                (ref($args{'stomp'}) eq "Net::Stomp")) {
                $args{'stomp'}->disconnect();
            }
            $args{'stomp'} = undef;
        }
    }

    return $args{'stomp'};
}

# Helper function, designed to send HoneyClient::Message::*
# type of messages to the Drone.
#
# _send(message => $message, routing_key => $routing_key, session => $session, stomp_address => $stomp_address, stomp_port => $stomp_port, stomp_user_name => $stomp_user_name, stomp_password => $stomp_password, stomp_virtual_host => $stomp_virtual_host, exchange_name => $exchange_name)
#
# Inputs:
#  $message is a required argument, specifying the HoneyClient::Message::* to send.
#  $routing_key a required argument, specifying the routing key associated with the message.
#  $session is an optional argument, specifying the existing Net::Stomp session to use for connecting to the STOMP server.
#  $stomp_address is an optional argument, specifying the IP address of the STOMP server this component should connect to.
#  $stomp_port is an optional argument, specifying the TCP port of the STOMP server this component should connect to.
#  $stomp_user_name is an optional argument, specifying the user name used to authenticate to the STOMP server.
#  $stomp_password is an optional argument, specifying the password used to authenticate to the STOMP server.
#  $stomp_virtual_host is an optional argument, specifying the virtual host used to authenticate to the STOMP server.
#  $exchange_name is an optional argument, specifying the exchange name to use when sending messages from this component.
#
# Output:
#  Returns (true, Net::Stomp $session) if successful; croaks otherwise.
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

    # Encode the message.
    # Figure out the event name.
    my $event_name = ref($args{'message'});
    $event_name =~ s/.*://;
    my $event = encode_json({decamelize($event_name) => $args{'message'}->to_hashref});

# TODO: Delete this, eventually.
print "Action: " . $args{'routing_key'} . "\n";
print "Event:\n";
print Dumper($event) . "\n";

    my $send_args = {
        'exchange'      =>  $args{'exchange_name'},
        'delivery-mode' =>  2, # Make sure the message is durable.
        'destination'   =>  $args{'routing_key'},
    };

    # Send the message - with retry logic.
    $args{'session'} = _send_retry(stomp          => $args{'session'},
                                   new_args       => $new_args,
                                   connect_args   => $connect_args,
                                   send_args      => $send_args,
                                   event          => $event);

    return (1, $args{'session'});
}

#######################################################################
# Public Functions                                                    #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

=head2 AUTOLOAD(session => $session, action => $action, message => $message, priority => $priority)

=over 4

Sends the specified event to the Drone service.

I<Inputs>:
 B<$session> an optional argument, specifying the Net::Stomp session to reuse 
 B<$action> a required argument, specifying the action associated with the message.
 B<$message> a required argument, specifying the HoneyClient::Message::* to send.
 B($priority> an optional argument, specifying the numerical priority to assign
to this event.  Higher the number, the higher the priority.  Defaults to the
priority specified in the global configuration settings.

I<Output>: Returns (true, $session) if successful; croaks otherwise.

=back

=begin testing

SKIP: {
    skip "HoneyClient::Util::EventEmitter->AUTOLOAD() can't be easily tested.", 1;
}

=end testing

=cut

sub AUTOLOAD {
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

    # Now, get the name of the function.
    my $name = $AUTOLOAD;
    # Strip the fully-qualified portion of the function name.
    $name =~ s/.*://;

# TODO: Delete this, eventually.
print "Name: " . $name . "\n";

    # Parse required arguments.
    if (!($argsExist &&
        exists($args{'message'}) &&
        defined($args{'message'})) || 
        (ref($args{'message'}) ne ("HoneyClient::Message::" . $name))) {

        $LOG->error("Error: Unable to send event - unknown or invalid message specified.");
        Carp::croak "Error: Unable to send event - unknown or invalid message specified.";
    } else {
        # Perform validation on the message.
# TODO: Delete this, eventually.
print "Validating...\n";
        eval {
            $args{'message'}->pack();
        };
    }

    $args{'routing_key'} = '';
    if ($argsExist &&
        exists($args{'priority'}) &&
        defined($args{'priority'})) {
        $args{'routing_key'} = $args{'priority'} . ".";
    } else {
        $args{'routing_key'} = getVar(name => 'default_priority') . ".";
    }

    if (!($argsExist &&
        exists($args{'action'}) &&
        defined($args{'action'}))) {

        $LOG->error("Error: Unable to send event - unknown or invalid action specified.");
        Carp::croak "Error: Unable to send event - unknown or invalid action specified.";
    } else {
        # Construct the routing key.
        my $action = delete $args{'action'};
        $args{'routing_key'} .= decamelize($name) . "." . $action; 
    }

    return HoneyClient::Util::EventEmitter->_send(%args);
}

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 BUGS & ASSUMPTIONS

This code assumes that the Drone Event Collector is running and listening
for events from the specified STOMP server.  Specifically,
this library assumes that the <stomp_*>, <exchange_name>
entries defined within the etc/honeyclient.xml are
the same between this client and Drone Event Collector, in order to have
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
