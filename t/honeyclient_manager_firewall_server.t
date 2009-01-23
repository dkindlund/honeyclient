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
BEGIN { use_ok('HoneyClient::Manager::Firewall::Server') or diag("Can't load HoneyClient::Manager::Firewall::Server package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall::Server');
can_ok('HoneyClient::Manager::Firewall::Server', 'run');
use HoneyClient::Manager::Firewall::Server;

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Net::Stomp loads.
BEGIN { use_ok('Net::Stomp') or diag("Can't load Net::Stomp package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Stomp');
use Net::Stomp;

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

# Make sure HoneyClient::Manager::Firewall loads.
BEGIN { use_ok('HoneyClient::Manager::Firewall') or diag("Can't load HoneyClient::Manager::Firewall package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall');
use HoneyClient::Manager::Firewall;

diag("About to run extended tests.");
diag("Warning: These tests may alter the host system's firewall.");
diag("NOTE: The UFW service MUST already be running; if unsure, type '/etc/init.d/ufw restart' as root.");
diag("As such, Running these tests via a remote session is NOT advised.");
diag("");

my $question = prompt("# Do you want to run extended tests?", "yes");
if ($question !~ /^y.*/i) { exit; }
}



# =begin testing
{
eval {

    use HoneyClient::Manager::Firewall::Client;

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

        # Allow all traffic.
        $result = HoneyClient::Manager::Firewall::Client->allowAllTraffic();

        # Validate the result.
        ok($result, "allowAllTraffic()") or diag("The allowAllTraffic() call failed.");
    
        # Restore the default ruleset.
        HoneyClient::Manager::Firewall::Client->denyAllTraffic();

        # Allow VM traffic.
        my $chain_name = "1ea37e398a4d1d0314da7bdee8";
        my $mac_address = "00:0c:29:c5:11:c7";
        my $ip_address = "10.0.0.254";
        my $protocol = "tcp";
        my $port = [ 80, 443 ];

        $result = HoneyClient::Manager::Firewall::Client->allowVM(
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

        # Then, deny VM traffic.
        $result = HoneyClient::Manager::Firewall::Client->denyVM(chain_name => $chain_name);

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
}




1;
