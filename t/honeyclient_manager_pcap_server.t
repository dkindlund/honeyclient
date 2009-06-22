#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
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
}



# =begin testing
{
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
}




1;
