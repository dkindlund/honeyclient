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

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::Pcap') or diag("Can't load HoneyClient::Manager::Pcap package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Pcap');
use HoneyClient::Manager::Pcap;
}



# =begin testing
{
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
}



# =begin testing
{
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
}



# =begin testing
{
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
}



# =begin testing
{
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
}



# =begin testing
{
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
}




1;
