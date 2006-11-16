#!/usr/bin/perl -w

use Test::More 'no_plan';

package Catch;

sub TIEHANDLE {
	my($class, $var) = @_;
	return bless { var => $var }, $class;
}

sub PRINT  {
	my($self) = shift;
	${'main::'.$self->{var}} .= join '', @_;
}

sub OPEN  {}    # XXX Hackery in case the user redirects
sub CLOSE {}    # XXX STDERR/STDOUT.  This is not the behavior we want.

sub READ {}
sub READLINE {}
sub GETC {}
sub BINMODE {}

my $Original_File = 'HoneyClient/Manager/FW/Integrity.pm';

package main;

# pre-5.8.0's warns aren't caught by a tied STDERR.
$SIG{__WARN__} = sub { $main::_STDERR_ .= join '', @_; };
tie *STDOUT, 'Catch', '_STDOUT_' or die $!;
tie *STDERR, 'Catch', '_STDERR_' or die $!;

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 64 HoneyClient/Manager/FW/Integrity.pm

diag("Beginning of HoneyClient::Manager::FW::Integrity testing.");

# Make sure Log::Log4perl loads.
BEGIN { use_ok('Log::Log4perl') or diag("Can't load Log::Log4perl package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Log::Log4perl');
use Log::Log4perl;

# Make sure IO::File loads.
BEGIN { use_ok('IO::File') or diag("Can't load IO::File package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IO::File');
use IO::File;

# Make sure IPTables::IPv4 loads.
BEGIN { use_ok('IPTables::IPv4') or diag("Can't load IPTables::IPv4 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IPTables::IPv4');
use IPTables::IPv4;

# Make sure HoneyClient::Manager::FW loads.
BEGIN { use_ok('HoneyClient::Manager::FW') or diag("Can't load HoneyClient::Manager::FW package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::FW');
use HoneyClient::Manager::FW;

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getServerHandle getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getServerHandle');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getServerHandle getClientHandle);


# test hashref used for Inline testing
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

diag("Making sure needed files exist.\n");
ok( "-f  /var/log/iptables", '/var/log/iptables log file is present' );
ok(" -f  /sbin/iptables", 'IPTables binary does exist');
ok(" -d /tmp", '/tmp does exist');



    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 145 HoneyClient/Manager/FW/Integrity.pm

eval{
	 # yes, this test could of been written better
	 my $vmname = "chainfoo";
    my $testfile = "/tmp/testfile.txt";
    $URL = HoneyClient::Manager::FW->init_fw();
	is($URL, "http://192.168.0.128:8083/", "testing init_fw(), creation of the firewall server") or diag("Failed to start up the FW SOAP server.  Check to see if any other daemon is listening on TCP port $PORT.");
	sleep 1;
 # Wait at least a second, in order to initialize the daemon.
    sleep 1;
    # Connect to daemon as a client.
    my $stub = getClientHandle("HoneyClient::Manager::FW");
    diag("Calling fwInit()");
    $som = $stub->fwInit($hashref);
    diag("Calling addchain()");
    $som = $stub->addChain($hashref);
    diag("Calling addRule()");
    $som = $stub->addRule($hashref);
    diag("Creating test file and appending log entry...");
    open(TEST, ">$testfile");
    print TEST "Jun 24 20:43:52 HcHWALL kernel: VMID=foo IN=eth1 OUT= MAC=00:0c:29:fa:23:66:00:0c:29:94:b9:15:08:00 SRC=10.0.0.128 DST=128.29.239.232 LEN=44 TOS=0x00 PREC=0x00 TTL=32 ID=26351 PROTO=UDP SPT=1452 DPT=38293 LEN=24\n";
    close TEST;
    diag("Calling macCheck()...");
    $som = $stub->macCheck($hashref, $vmname);
    my @list = $som->paramsall;
    my $value = scalar(@list);
    ok( $value > 0,  'Defined data exists within either the @known or @unknown array' );
    diag("Deleting our testfile now...");
    unlink($testfile);
    diag("Setting the Policy to ACCEPT");
    $som = $stub->_setAcceptPolicy();
    diag("Flushing all rules and chains");
    $som = $stub->_flushChains();

};

# Kill the child daemon, if it still exists.
is(HoneyClient::Manager::FW->destroy_fw(), 1, "destroy_fw(), destruction of the firewall server") or diag("Unable to terminate FW");
HoneyClient::Manager::FW->destroy_fw();
sleep 1;

# Report any failure found.
if ($@) {
    fail($@);
	}
	

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

