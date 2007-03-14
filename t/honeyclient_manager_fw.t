#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
diag("Beginning of HoneyClient::Manager::FW testing.");
diag("Making sure all Modules are present");

# Make sure Log::Log4perl loads.
BEGIN { use_ok('Log::Log4perl') or diag("Can't load Log::Log4perl package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Log::Log4perl');
use Log::Log4perl;

# Make sure Filehandle loads.
BEGIN { use_ok('FileHandle') or diag("Can't load FileHandle package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('FileHandle');
use FileHandle;

# Make sure IO::File loads.
BEGIN { use_ok('IO::File') or diag("Can't load IO::File package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IO::File');
use IO::File;

# Make sure IPTables::IPv4 loads.
BEGIN { use_ok('IPTables::IPv4') or diag("Can't load IPTables::IPv4 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IPTables::IPv4');
use IPTables::IPv4;

# Make sure Config::General loads.
BEGIN { use_ok('Config::General') or diag("Can't load Config::General package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Config::General');
use Config::General;

# Make sure use Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load use Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure use Net::DNS::Resolver loads.
BEGIN { use_ok('Net::DNS::Resolver') or diag("Can't load use Net::DNS::Resolver package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::DNS::Resolver');
use Net::DNS::Resolver;

# Make sure use Time::HiRes loads.
BEGIN { use_ok('Time::HiRes', qw(gettimeofday)) or diag("Can't load use Time::HiRes package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Time::HiRes');
can_ok('Time::HiRes', 'gettimeofday');
use Time::HiRes qw(gettimeofday);

# Make sure use English loads.
BEGIN { use_ok('English') or diag("Can't load use English package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('English');
use English '-no_match_vars';

# Make sure use threads loads.
BEGIN { use_ok('threads') or diag("Can't load use threads package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads');
use threads;

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::FW', qw(init_fw destroy_fw _getVMName)) or diag("Can't load HoneyClient::Manager:VM package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::FW');
can_ok('HoneyClient::Manager::FW', 'init_fw');
can_ok('HoneyClient::Manager::FW', 'destroy_fw');
can_ok('HoneyClient::Manager::FW', '_getVMName');
use HoneyClient::Manager::FW qw(init_fw destroy_fw _getVMName);

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getServerHandle getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getServerHandle');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getServerHandle getClientHandle);

# Make sure use Proc::ProcessTable loads.
BEGIN { use_ok('Proc::ProcessTable') or diag("Can't load use Proc::ProcessTable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Proc::ProcessTable');
use Proc::ProcessTable;

diag("Making sure perl and shell scripts exist.\n");
ok( "-f /hc/startFWListener.pl", '/hc/startFWListener.pl is present' );
ok( "-f /hc/startLogListener.pl", '/hc/startLogListener.pl is present' );
ok( "-f /hc/startFWListener.sh", '/hc/startFWListener.sh is present' );
ok( "-f /hc/startLogListener.sh", '/hc/startLogListener.sh is present' );
ok( "-f  /etc/honeylog.conf", '/etc/honeylog.conf is present' );
ok("-f  /etc/honeyclient.conf", '/etc/honeyclient.conf exists');
#ok( -f , "/proc/sys/net/ipv4/ip_forward", '/proc/sys/net/ipv4/ip_forward does exist');
ok(" -f /etc/resolv.conf", '/etc/resolv.conf file does exist');
ok(" -f /etc/syslog.conf", '/etc/syslog.conf file does exist');
ok( "-f /usr/bin/uptime", '/usr/bin/uptime is present' );
ok(" -f /bin/uname", '/bin/uname exists');
ok(" -f /bin/mail", 'mail() exists');
ok(" -f /sbin/iptables", 'IPTables binary does exist');
diag("Enabling test hash reference here");
my $hashref = {

    'foo' => {
        'targets' => {
            'rcf.mitre.org'   => { 'tcp' => [ 80 ], },
        },

        'resources' => {
            'http://www.mitre.org' => 1,
        },
        'sources' => {

            '00:0C:29:94:B9:15' => {
                '10.0.0.128' => {
                    'tcp' => undef,
                    'udp' => [ 23, 53, '80:1024', ],
                },
            },
        },
    },
};

#my $hwall = getVar(name => "address");
#my $port = getVar(name => "port");

diag("Beginning our function testing now...");
$URL = HoneyClient::Manager::FW->init_fw();
is($URL, "http://192.168.0.129:8083/", "testing init_fw(), creation of the firewall server") or diag("Failed to start up the FW SOAP server.  Check to see if any other daemon is listening on TCP port $PORT.");
sleep 3;
is(HoneyClient::Manager::FW->destroy_fw(), 1, "destroy_fw(), destruction of the firewall server") or diag("Unable to terminate FW");
sleep 1;
}



# =begin testing
{
eval{
	diag("Testing fwInit()...");
    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep(1);
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    $som = $stub->fwInit($hashref);
    $som = $stub->_validateInit();
    is($som->result, 24, "fwInit current has set up 28 rules")   or diag("The fwInit() call failed.");
    $som = $stub->_setAcceptPolicy();
    $som = $stub->_flushChains();

};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep(1);

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
eval{
	diag("Testing addChain()...");
    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    $som = $stub->addChain($hashref);
    ok($som->result, "addChain() successfully passed.")   or diag("The addChain() call failed.");
    $som = $stub->_setAcceptPolicy();
    $som = $stub->_flushChains();
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
}



# =begin testing
{
eval{
	 diag("Testing deleteChain()...");
    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    $som = $stub->addChain($hashref);
    sleep 1;
    $som = $stub->deleteChain($hashref);
    ok($som->result, "deleteChain() successfully passed.")   or diag("The deleteChain() call failed.");
    $som = $stub->_setAcceptPolicy();
    $som = $stub->_flushChains();

};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
}



# =begin testing
{
eval{
     diag("Testing addRule()...");
    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    my $som  = $stub->fwInit($hashref);
    $som = $stub->addChain($hashref);
    $som = $stub->addRule($hashref);
    ok($som->result, "addRule() successfully passed and added a new rule.")   or diag("The addRule() call failed.");
    $som = $stub->_setAcceptPolicy();
    $som = $stub->_flushChains();
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
}



# =begin testing
{
eval{
	diag("Testing fwStatus()...");
    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    $som = $stub->getStatus();
    # testing to make sure the chains are empty
    ok(!$som->result, "getStatus() successfully passed.")   or diag("The getStatus() call failed.");
#    $som = $stub->_setAcceptPolicy();
#    $som = $stub->_flushChains();
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
}



# =begin testing
{
eval{

    diag("Testing _chainExists()...");
    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    my $som  = $stub->fwInit($hashref);
    $som = $stub->addChain($hashref);
    is($som->result, 1, "_chainExists($hashref) successfully passed.")  or diag("The _chainExists() call failed.");
    $som = $stub->_setAcceptPolicy();
    $som = $stub->_flushChains();
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
}



# =begin testing
{
eval{

    $URL = HoneyClient::Manager::FW->init_fw();
    # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::FW");
    $som = $stub->starttestProcess();
    $som = $stub->fwShutdown();
    $som = $stub->findProcess();
   ok($som->result, "fwShutdown() successfully passed.")   or diag("The FWShutdown() call failed.");
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
}




1;
