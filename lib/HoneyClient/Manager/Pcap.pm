#######################################################################
# Created on:  June 07, 2009
# Package:     HoneyClient::Manager::Pcap
# File:        Pcap.pm
# Description: A module that provides programmatic access to the
#              pcap(3) interface on the local system.
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

HoneyClient::Manager::Pcap - Perl extension to provide programmatic
access to the pcap(3) interface on the local system in order to
capture and analyze packets associated with Honeyclient VMs.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Pcap version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::Pcap;
  use Data::Dumper;
  use Compress::Zlib;
  use MIME::Base64 qw(encode_base64 decode_base64);

  my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
  my $quick_clone_name = "foo";
  my $mac_address = "00:0c:29:35:54:60";
  my $src_ip_address = "10.0.0.141";
  my $dst_tcp_port = 80;

  # Start a new capture.
  my $sessions = HoneyClient::Manager::Pcap->startCapture(quick_clone_name => $quick_clone_name, mac_address => $mac_address);

  # Wait a little time for the capture to collect packets.
  print "Sleeping 60s...\n";
  sleep (60);

  # Stop the capture session.
  $sessions = HoneyClient::Manager::Pcap->stopCapture(sessions => $sessions, quick_clone_name => $quick_clone_name);

  # Get the first server IP this clone VM contacts.
  my $serverIP = HoneyClient::Manager::Pcap->getFirstIP(sessions => $sessions, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port);
  print "Server IP: " . Dumper($serverIP) . "\n";

  # Get the file name of the corresponding capture session.
  my $pcapFile = HoneyClient::Manager::Pcap->getPcapFile(sessions => $sessions, quick_clone_name => $quick_clone_name);
  print "Pcap File: " . Dumper($pcapFile) . "\n";

  # Get the file data of the corresponding capture session.
  my $pcapData = HoneyClient::Manager::Pcap->getPcapData(sessions => $sessions, quick_clone_name => $quick_clone_name);
  print "Pcap Data: " . Dumper(uncompress(decode_base64($pcapData))) . "\n";

  # Shutdown all other capture sessions.
  HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);

=head1 DESCRIPTION

This library provides static calls to control the pcap(3) interface on the 
local system.  Specifically, this library captures packets associated with
the Honeyclient clone VMs.

=cut

package HoneyClient::Manager::Pcap;

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

    # This allows declaration use HoneyClient::Manager::Pcap ':all';
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

# Make sure POSIX loads.
BEGIN { use_ok('POSIX') or diag("Can't load POSIX package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('POSIX');
use POSIX ":sys_wait_h";

# Make sure Net::Frame::Dump::Offline loads.
BEGIN { use_ok('Net::Frame::Dump::Offline') or diag("Can't load Net::Frame::Dump::Offline package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Frame::Dump::Offline');
use Net::Frame::Dump::Offline;

# Make sure Net::Frame::Simple loads.
BEGIN { use_ok('Net::Frame::Simple') or diag("Can't load Net::Frame::Simple package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Frame::Simple');
use Net::Frame::Simple;

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the
path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

# Make sure Compress::Zlib loads.
BEGIN { use_ok('Compress::Zlib')
        or diag("Can't load Compress::Zlib package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Compress::Zlib');
use Compress::Zlib;

# Make sure File::Slurp loads.
BEGIN { use_ok('File::Slurp')
        or diag("Can't load File::Slurp package. Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Slurp');
use File::Slurp;

# Make sure the module loads properly, with the exportable
# functions shared.
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

# Include Packet Parsing Libraries
use Net::Frame::Dump::Offline;
use Net::Frame::Simple;

# Include POSIX Libraries
use POSIX ":sys_wait_h";

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Use Compress::Zlib Library
use Compress::Zlib;

# Use File::Slurp Library
use File::Slurp;

#######################################################################
# Private Functions                                                   #
#######################################################################

# Helper function designed to clear all running captures.
#
# Inputs: hashref of pcap sessions.
# Outputs: Returns true if successful; croaks otherwise.
sub _clear {

    my $sessions = shift;

    foreach my $key (keys %{$sessions}) {
        if (defined($sessions->{$key})) {
            # If an existing session is already running, then stop it.
            if (kill(0, $sessions->{$key}) >= 1) {
                # Send a SIGNINT.
                kill("INT", $sessions->{$key});
                # Wait for the child process to end.
                waitpid($sessions->{$key}, 0);
            }

            # Clean out any PCAP files from the previous session.
            unlink(getVar(name => "directory") . '/' . $key . '.pcap');
        }
    }

    return 1;
}

#######################################################################
# Public Functions                                                    #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

=head2 shutdown(sessions => $sessions)

=over 4

Shuts down all running packet captures.

I<Inputs>:
 B<$sessions> is a hashref of all running packet captures.

I<Output>: Returns true if successful; croaks otherwise.

=back

=begin testing

eval {
    # Shutdown all captures.
    my $sessions = {};
    my $result = HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);

    # Validate the result.
    ok($result, "shutdown()") or diag("The shutdown() call failed.");
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
    # TODO: Change this to debug, eventually.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'sessions'}) ||
        !defined($args{'sessions'})) {
        $LOG->error("Error shutting down - no sessions specified.");
        Carp::croak "Error shutting down - no sessions specified.";
    }

    return _clear($args{'sessions'});
}

=pod

=head2 getFirstIP(sessions => $sessions, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port)

=over 4

Given a hashref of existing sessions, a quick clone name, source IP, and
destination TCP port, this function will lookup any matching capture session
and attempt to extract the first IP address the clone VM contacts on the
specified destination TCP port.

I<Inputs>:
 B<$sessions> is a hashref of all running packet captures.
 B<$quick_clone_name> is the name of the quick clone VM.
 B<$dst_tcp_port> is the destination TCP port of the server to match.
 B<$src_ip_address> is the source IP address of the clone VM to match.

I<Output>: Returns the IP address, if successful; undef otherwise.

=back

=begin testing

eval {
    my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address      = "00:0c:29:c5:11:c7";
    my $src_ip_address   = "10.0.0.1";
    my $dst_tcp_port     = 80;

    my $sessions = HoneyClient::Manager::Pcap->startCapture(
        quick_clone_name => $quick_clone_name,
        mac_address => $mac_address,
    );

    $sessions = HoneyClient::Manager::Pcap->stopCapture(sessions => $sessions, quick_clone_name => $quick_clone_name);
    my $result = HoneyClient::Manager::Pcap->getFirstIP(sessions => $sessions, quick_clone_name => $quick_clone_name, src_ip_address => $src_ip_address, dst_tcp_port => $dst_tcp_port);

    # Validate the result.
    is($result, undef, "getFirstIP(quick_clone_name => '$quick_clone_name', src_ip_address => '$src_ip_address', dst_tcp_port => '$dst_tcp_port')") or diag("The getFirstIP() call failed.");

    
    # Shutdown all captures.
    HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);
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
    # TODO: Change this to debug, eventually.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'quick_clone_name'}) ||
        !defined($args{'quick_clone_name'})) {
        $LOG->error("Error getting IP address - no quick clone name specified.");
        Carp::croak "Error getting IP address - no quick clone name specified.";
    }

    if (!exists($args{'sessions'}) ||
        !defined($args{'sessions'})) {
        $LOG->error("Error getting IP address - no sessions specified.");
        Carp::croak "Error getting IP address - no sessions specified.";
    }

    if (!exists($args{'src_ip_address'}) ||
        !defined($args{'src_ip_address'})) {
        $LOG->error("Error getting IP address - no source IP address specified.");
        Carp::croak "Error getting IP address - no source IP address specified.";
    }

    if (!exists($args{'dst_tcp_port'}) ||
        !defined($args{'dst_tcp_port'})) {
        $LOG->error("Error getting IP address - no destination TCP port specified.");
        Carp::croak "Error getting IP address - no destination TCP port specified.";
    }

    # Make sure the PCAP session exists already.
    my $filename = getVar(name => "directory") . '/' . $args{'quick_clone_name'} . '.pcap';
    if (!exists($args{'sessions'}->{$args{'quick_clone_name'}}) ||
        !defined($args{'sessions'}->{$args{'quick_clone_name'}}) ||
        !(-e $filename)) {
        return undef;
    }

    my $dump = Net::Frame::Dump::Offline->new(file => $filename);
    my $serverIP = undef;
    eval {
        $dump->start;
        my $next = $dump->next;
        my $frame = undef;
        if (defined($next)) {
            open SAVESTDOUT, '>&STDOUT' or Carp::croak "Error getting IP address - Can't suppress stdout. $!";
            open STDOUT, '>/dev/null' or Carp::croak "Error starting capture - Can't write to /dev/null. $!";
            $frame = Net::Frame::Simple->newFromDump($next);
            close STDOUT;
            open STDOUT, '>&SAVESTDOUT';
        }
        while (defined($frame)) {
            if (exists($frame->ref->{'ETH'}) &&
                defined($frame->ref->{'ETH'}) &&
                exists($frame->ref->{'IPv4'}) &&
                defined($frame->ref->{'IPv4'}) &&
                ($frame->ref->{'IPv4'}->src eq $args{'src_ip_address'}) &&
                exists($frame->ref->{'TCP'}) &&
                defined($frame->ref->{'TCP'}) &&
                ($frame->ref->{'TCP'}->dst == $args{'dst_tcp_port'})) {

                $serverIP = $frame->ref->{'IPv4'}->dst;
                last;
            }

            $dump->flush;
            $next = $dump->next;
            $frame = undef;
            if (defined($next)) {
                open SAVESTDOUT, '>&STDOUT' or Carp::croak "Error getting IP address - Can't suppress stdout. $!";
                open STDOUT, '>/dev/null' or Carp::croak "Error starting capture - Can't write to /dev/null. $!";
                $frame = Net::Frame::Simple->newFromDump($next);
                close STDOUT;
                open STDOUT, '>&SAVESTDOUT';
            }
        }
        $dump->stop;
        $dump->flush;
    };
    if ($@) {
        $LOG->warn("Error getting IP address - " . $@);
    }

    return $serverIP;
}

=pod

=head2 getPcapFile(sessions => $sessions, quick_clone_name => $quick_clone_name)

=over 4

Given a hashref of existing sessions and a quick clone name, this function
will return the path and file name of any corresponding generated .pcap
file.

I<Inputs>:
 B<$sessions> is a hashref of all running packet captures.
 B<$quick_clone_name> is the name of the quick clone VM.

I<Output>: Returns the path and file name of the .pcap file, if successful; undef otherwise.

=back

=begin testing

eval {
    my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address      = "00:0c:29:c5:11:c7";
    my $src_ip_address   = "10.0.0.1";
    my $dst_tcp_port     = 80;

    my $sessions = HoneyClient::Manager::Pcap->startCapture(
        quick_clone_name => $quick_clone_name,
        mac_address => $mac_address,
    );

    # Make sure PCAP file gets created.
    sleep(2);

    $sessions = HoneyClient::Manager::Pcap->stopCapture(sessions => $sessions, quick_clone_name => $quick_clone_name);

    my $result = HoneyClient::Manager::Pcap->getPcapFile(sessions => $sessions, quick_clone_name => $quick_clone_name);

    # Validate the result.
    ok($result, "getPcapFile(quick_clone_name => '$quick_clone_name')") or diag("The getPcapFile() call failed.");

    
    # Shutdown all captures.
    HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);
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
    # TODO: Change this to debug, eventually.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'quick_clone_name'}) ||
        !defined($args{'quick_clone_name'})) {
        $LOG->error("Error getting PCAP file - no quick clone name specified.");
        Carp::croak "Error getting PCAP file - no quick clone name specified.";
    }

    if (!exists($args{'sessions'}) ||
        !defined($args{'sessions'})) {
        $LOG->error("Error getting PCAP file - no sessions specified.");
        Carp::croak "Error getting PCAP file - no sessions specified.";
    }

    # Make sure the PCAP session exists already.
    my $filename = getVar(name => "directory") . '/' . $args{'quick_clone_name'} . '.pcap';
    if (!exists($args{'sessions'}->{$args{'quick_clone_name'}}) ||
        !defined($args{'sessions'}->{$args{'quick_clone_name'}}) ||
        !(-e $filename)) {
        return undef;
    }

    return $filename;
}

=pod

=head2 getPcapData(sessions => $sessions, quick_clone_name => $quick_clone_name)

=over 4

Given a hashref of existing sessions and a quick clone name, this function
will return the contents of any corresponding generated .pcap file in Zlib compressed,
base64 encoded form.

I<Inputs>:
 B<$sessions> is a hashref of all running packet captures.
 B<$quick_clone_name> is the name of the quick clone VM.

I<Output>: Returns the contents of the .pcap file in compressed, base64 encoded form, if successful; undef otherwise.

=back

=begin testing

eval {
    my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address      = "00:0c:29:c5:11:c7";
    my $src_ip_address   = "10.0.0.1";
    my $dst_tcp_port     = 80;

    my $sessions = HoneyClient::Manager::Pcap->startCapture(
        quick_clone_name => $quick_clone_name,
        mac_address => $mac_address,
    );

    # Make sure PCAP file gets created.
    sleep(2);

    $sessions = HoneyClient::Manager::Pcap->stopCapture(sessions => $sessions, quick_clone_name => $quick_clone_name);

    my $result = HoneyClient::Manager::Pcap->getPcapData(sessions => $sessions, quick_clone_name => $quick_clone_name);

    # Validate the result.
    ok($result, "getPcapData(quick_clone_name => '$quick_clone_name')") or diag("The getPcapData() call failed.");
    
    # Shutdown all captures.
    HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);
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
    # TODO: Change this to debug, eventually.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'quick_clone_name'}) ||
        !defined($args{'quick_clone_name'})) {
        $LOG->error("Error getting PCAP data - no quick clone name specified.");
        Carp::croak "Error getting PCAP data - no quick clone name specified.";
    }

    if (!exists($args{'sessions'}) ||
        !defined($args{'sessions'})) {
        $LOG->error("Error getting PCAP data - no sessions specified.");
        Carp::croak "Error getting PCAP data - no sessions specified.";
    }

    # Make sure the PCAP session exists already.
    my $filename = getVar(name => "directory") . '/' . $args{'quick_clone_name'} . '.pcap';
    my $data = undef;
    if (exists($args{'sessions'}->{$args{'quick_clone_name'}}) &&
        defined($args{'sessions'}->{$args{'quick_clone_name'}}) &&
        (-r $filename)) {
        $data = encode_base64(compress(read_file($filename, binmode => ':raw')));
    }

    return $data;
}

=pod

=head2 startCapture(sessions => $sessions, quick_clone_name => $quick_clone_name, mac_address => $mac_address)

=over 4

Starts a packet capture session of the specified quick clone VM, based upon the
provided MAC address.

I<Inputs>:
 B<$sessions> is a hashref of all running packet captures (optional).
 B<$quick_clone_name> is the name of the quick clone VM.
 B<$mac_address> is the VM's MAC address.

I<Output>: Returns an updated hashref of all packet capture sessions, if successful;
croaks otherwise.

I<Notes>:
If startCapture() is called multiple times successively with the same quick_clone_name,
then the previously associated packet capture session will be discarded.

=back

=begin testing

eval {
    my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address = "00:0c:29:c5:11:c7";

    my $sessions = HoneyClient::Manager::Pcap->startCapture(
        quick_clone_name => $quick_clone_name,
        mac_address => $mac_address,
    );

    ok($sessions, "startCapture(quick_clone_name => '$quick_clone_name', mac_address => '$mac_address')") or diag("The startCapture() call failed.");

    # Shutdown all captures.
    HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);
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
    # TODO: Change this to debug, eventually.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'quick_clone_name'}) ||
        !defined($args{'quick_clone_name'})) {
        $LOG->error("Error starting capture - no quick clone name specified.");
        Carp::croak "Error starting capture - no quick clone name specified.";
    }

    if (!exists($args{'mac_address'}) ||
        !defined($args{'mac_address'})) {
        $LOG->error("Error starting capture - no MAC address specified.");
        Carp::croak "Error starting capture - no MAC address specified.";
    }

    # Create a new sessions hashref, if one wasn't defined.
    if (!exists($args{'sessions'}) ||
        !defined($args{'sessions'})) {
        $args{'sessions'} = {};
    }

    # Check if we already have a PCAP session.
    if (exists($args{'sessions'}->{$args{'quick_clone_name'}}) &&
        defined($args{'sessions'}->{$args{'quick_clone_name'}})) {

        # If an existing session is already running, then stop it.
        if (kill(0, $args{'sessions'}->{$args{'quick_clone_name'}}) >= 1) {
            # Send a SIGNINT.
            kill("INT", $args{'sessions'}->{$args{'quick_clone_name'}});
            # Wait for the child process to end.
            waitpid($args{'sessions'}->{$args{'quick_clone_name'}}, 0);
        }
    }

    # Start a new capture.
    if (my $pid = fork()) {
        if (!defined($pid)) {
            $LOG->error("Error starting capture - Unable to fork child process. $!");
            Carp::croak "Error starting capture - Unable to fork child process. $!";
        }
        $args{'sessions'}->{$args{'quick_clone_name'}} = $pid;
    } else {
        if (!defined($pid)) {
            $LOG->error("Error starting capture - Unable to fork child process. $!");
            Carp::croak "Error starting capture - Unable to fork child process. $!";
        }

        # Make sure all STDIO is supressed.
        open STDIN, '/dev/null' or Carp::croak "Error starting capture - Can't read /dev/null. $!";
        open STDOUT, '>/dev/null' or Carp::croak "Error starting capture - Can't write to /dev/null. $!";
        open STDERR, '>&STDOUT' or Carp::croak "Error starting capture - Can't dup stdout. $!";

        my $tcpdump_args = '-ni';
        if (!getVar(name => "promiscuous")) {
           $tcpdump_args = '-npi'; 
        }

        my @cmd = (getVar(name => "tcpdump_bin"), '-s', getVar(name => "snaplen"), $tcpdump_args, getVar(name => "capture_interface"), '-w', 'pcaps/' . $args{'quick_clone_name'} . '.pcap', 'ether host ' . $args{'mac_address'});
        exec { $cmd[0] } @cmd;
    }

    return $args{'sessions'};
}

=pod

=head2 stopCapture(sessions => $sessions, quick_clone_name => $quick_clone_name, delete_pcap => $delete_pcap)

=over 4

Stops a packet capture session of the specified quick clone VM.

I<Inputs>:
 B<$sessions> is a hashref of all running packet captures.
 B<$quick_clone_name> is the name of the quick clone VM.
 B<$delete_pcap> is a boolean, indicating if the data associated with the
stopped packet capture session should be discarded.

I<Output>: Returns an updated hashref of all packet capture sessions, if successful;
croaks otherwise.

=back

=begin testing

eval {
    my $quick_clone_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address = "00:0c:29:c5:11:c7";

    my $sessions = HoneyClient::Manager::Pcap->startCapture(
        quick_clone_name => $quick_clone_name,
        mac_address => $mac_address,
    );

    $sessions = HoneyClient::Manager::Pcap->stopCapture(sessions => $sessions, quick_clone_name => $quick_clone_name);

    # Validate the result.
    ok($sessions, "stopCapture(quick_clone_name => '$quick_clone_name')") or diag("The stopCapture() call failed.");
    
    # Shutdown all captures.
    HoneyClient::Manager::Pcap->shutdown(sessions => $sessions);
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
    # TODO: Change this to debug, eventually.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'quick_clone_name'}) ||
        !defined($args{'quick_clone_name'})) {
        $LOG->error("Error stopping capture - no quick clone name specified.");
        Carp::croak "Error stopping capture - no quick clone name specified.";
    }

    if (!exists($args{'sessions'}) ||
        !defined($args{'sessions'})) {
        $LOG->error("Error stopping capture - no sessions specified.");
        Carp::croak "Error stopping capture - no sessions specified.";
    }

    # Check if we already have a PCAP session.
    if (exists($args{'sessions'}->{$args{'quick_clone_name'}}) &&
        defined($args{'sessions'}->{$args{'quick_clone_name'}})) {

        # If an existing session is already running, then stop it.
        if (kill(0, $args{'sessions'}->{$args{'quick_clone_name'}}) >= 1) {
            # Send a SIGNINT.
            kill("INT", $args{'sessions'}->{$args{'quick_clone_name'}});
            # Wait for the child process to end.
            waitpid($args{'sessions'}->{$args{'quick_clone_name'}}, 0);
        }

        if (exists($args{'delete_pcap'}) &&
            defined($args{'delete_pcap'}) &&
            $args{'delete_pcap'}) {
            # Clean out any PCAP files from the previous session.
            unlink(getVar(name => "directory") . '/' . $args{'quick_clone_name'} . '.pcap');

            # Remove all references to the PID.
            delete $args{'sessions'}->{$args{'quick_clone_name'}};
        }
    }

    return $args{'sessions'}; 
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

This package requires access to the network interfaces in order to
perform promiscious packet captures.  As such, it is likely this
code will need to run as 'root' via sudo or at an elevated
priviledge level.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

Net::Frame::Dump::Offline, Net::Frame::Simple

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Sebastien Aperghis-Tramoni E<lt>sebastien@aperghis.netE<gt>,
for using his Net::Pcap code via Net::Frame.

Patrice Auffret, for using his Net::Frame code to perform
network packet captures via perl.

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
