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

# Generate a notice, to clarify our assumptions.
diag("About to run basic unit tests.");

my $question = prompt("# Do you want to run basic tests?", "yes");
if ($question !~ /^y.*/i) { exit; }

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
BEGIN { use_ok('HoneyClient::Manager::ESX') or diag("Can't load HoneyClient::Manager::ESX package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::ESX');
use HoneyClient::Manager::ESX;

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);

# Make sure Digest::MD5 loads.
BEGIN { use_ok('Digest::MD5', qw(md5_hex)) or diag("Can't load Digest::MD5 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Digest::MD5');
can_ok('Digest::MD5', 'md5_hex');
use Digest::MD5 qw(md5_hex);

# Make sure DateTime::HiRes loads.
BEGIN { use_ok('DateTime::HiRes') or diag("Can't load DateTime::HiRes package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure DateTime::Duration loads.
BEGIN { use_ok('DateTime::Duration') or diag("Can't load DateTime::Duration package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::Duration');
use DateTime::Duration;

# Make sure VMware::VIRuntime loads.
BEGIN { use_ok('VMware::VIRuntime') or diag("Can't load VMware::VIRuntime package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('VMware::VIRuntime');
use VMware::VIRuntime;

diag("About to run extended tests.");
diag("Warning: These tests will take significant time to complete (10-20 minutes).");
diag("");
diag("Note: These tests expect VMware ESX Server to be accessible at the following location,");
diag("using the following credentials:");
diag("   service_url: " . getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX"));
diag("   username:    " . getVar(name => "user_name", namespace => "HoneyClient::Manager::ESX"));
diag("   password:    " . getVar(name => "password", namespace => "HoneyClient::Manager::ESX"));
diag("");
diag("Also, these tests expect the following test VM to be registered and powered off on the VMware ESX");
diag("Server:");
diag("   test_vm_name: " . getVar(name => "test_vm_name", namespace => "HoneyClient::Manager::ESX::Test"));
diag("");

# TODO: Provide a URL where users can download, extract, and install the Test_VM.

$question = prompt("# Do you want to run extended tests?", "no");
if ($question !~ /^y.*/i) { exit; }
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Validate the session.
    ok((ref($session) eq 'Vim'), "login()") or diag("The login() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Destroy the session.
    my $result = HoneyClient::Manager::ESX->logout(session => $session);
    ok($result, "logout()") or diag("The logout() call failed.");
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Start the test VM.
    HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);
    ok($cloneVM, "fullCloneVM(src_name => '$testVM')") or diag("The fullCloneVM() call failed.");

    # Get the power state of the clone VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $cloneVM);

    # The clone VM should be powered on.
    is($state, "poweredon", "fullCloneVM(name => '$testVM')") or diag("The fullCloneVM() call failed.");
   
    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    ok($session, "startVM(name => '$testVM')") or diag("The startVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be on.
    is($state, "poweredon", "startVM(name => '$testVM')") or diag("The startVM() call failed.");

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);
    ok($session, "stopVM(name => '$testVM')") or diag("The stopVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be off.
    is($state, "poweredoff", "stopVM(name => '$testVM')") or diag("The stopVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Suspend the test VM.
    $session= HoneyClient::Manager::ESX->resetVM(session => $session, name => $testVM);
    ok($session, "resetVM(name => '$testVM')") or diag("The resetVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be powered on.
    is($state, "poweredon", "resetVM(name => '$testVM')") or diag("The resetVM() call failed.");
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Suspend the test VM.
    $session = HoneyClient::Manager::ESX->suspendVM(session => $session, name => $testVM);
    ok($session, "suspendVM(name => '$testVM')") or diag("The suspendVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be suspended.
    is($state, "suspended", "suspendVM(name => '$testVM')") or diag("The suspendVM() call failed.");
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    ok($session, "destroyVM(name => '$cloneVM')") or diag("The destroyVM() call failed.");
   
    # The clone VM should no longer be registered.
    my $isRegisteredVM = undef;
    ($session, $isRegisteredVM) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $cloneVM);
    ok(!$isRegisteredVM, "destroyVM(name => '$cloneVM')") or diag ("The destroyVM() call failed.");
 
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be off.
    is($state, "poweredoff", "getStateVM(name => '$testVM')") or diag("The getStateVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);

    # Verify that the clone VM is a quick clone.
    my $isQuickCloneVM = undef;
    ($session, $isQuickCloneVM) = HoneyClient::Manager::ESX->isQuickCloneVM(session => $session, name => $cloneVM);
    ok($isQuickCloneVM, "isQuickCloneVM(name => '$cloneVM')") or diag("The isQuickCloneVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # We assume the test VM is stopped and unregistered.

    # The only consistent way to get a VM into a stuck state,
    # is to manually copy a VM into a new directory, register it,
    # and then proceed to start it.  VMware ESX Server will immediately
    # ask if we'd like to create a new identifier before
    # moving on.
   
    # Generate a new VM name. 
    my $newVM = HoneyClient::Manager::ESX->_generateVMID();

    # Create the new VM.
    my $new_config = HoneyClient::Manager::ESX::_fullCopyVM(
        session => $session,
        src_name => $testVM,
        dst_name => $newVM,
    );

    # Register the new VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $newVM, config => $new_config);

    # Start the new VM and indirectly test the answerVM() method.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $newVM);
    ok($session, "answerVM(name => '$newVM')") or diag("The answerVM() call failed.");

    # Destroy the new VM.
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $newVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # Wait until the test VM is on.
    while ($state ne 'poweredon') {
        sleep (1);
        ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);
    }
    
    # Get the MAC address of the test VM.
    my $mac_address = undef;
    for (my $counter = 0; $counter < 240; $counter++) {
        ($session, $mac_address) = HoneyClient::Manager::ESX->getMACaddrVM(session => $session, name => $testVM);
        if (defined($mac_address)) {
            last;
        } else {
            sleep (1);
        }
    }

    # The exact MAC address of the VM will change from system to system,
    # so we check to make sure the result looks like a valid MAC address.
    like($mac_address, "/[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]/", "getMACaddrVM(name => '$testVM')") or diag("The getMACaddrVM() call failed.  Attempted to retrieve the MAC address of test VM ($testVM).");

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # Wait until the test VM is on.
    while ($state ne 'poweredon') {
        sleep (1);
        ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);
    }
    
    # Get the IP address of the test VM.
    my $ip_address = undef;
    for (my $counter = 0; $counter < 240; $counter++) {
        ($session, $ip_address) = HoneyClient::Manager::ESX->getIPaddrVM(session => $session, name => $testVM);
        if (defined($ip_address)) {
            last;
        } else {
            sleep (1);
        }
    }

    # The exact IP address of the VM will change from system to system,
    # so we check to make sure the result looks like a valid IP address.
    like($ip_address, "/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/", "getIPaddrVM(name => '$testVM')") or diag("The getIPaddrVM() call failed.  Attempted to retrieve the IP address of test VM ($testVM).");

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Get the VM's configuration file.    
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->getConfigVM(session => $session, name => $testVM);
    ok($config, "getConfigVM(name => '$testVM')") or diag("The getConfigVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check to see if the test VM is registered (should return true).
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
    
    # The test VM should be registered.
    ok($result, "isRegisteredVM(name => '$testVM')") or diag("The isRegisteredVM() call failed.");

    # Unregister the test VM.
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
    
    # Check to see if the test VM is registered (should return false).
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);

    # The test VM should not be registered.
    ok(!$result, "isRegisteredVM(name => '$testVM')") or diag("The isRegisteredVM() call failed.");
    
    # Reregister the test VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
    
    # Check to see if the test VM is registered (should return true).
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
    
    # The test VM should be registered.
    ok($result, "isRegisteredVM(name => '$testVM')") or diag("The isRegisteredVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check the size of the backing datastore.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->getDatastoreSpaceAvailableESX(session => $session, name => $testVM);
    
    # The size returned should be a number.
    like($result, "/[0-9]+/", "getDatastoreSpaceAvailableESX(name => '$testVM')") or diag("The getDatastoreSpaceAvailableESX() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check the size of the backing datastore.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->getHostnameESX(session => $session);
    
    # The result should be a string.
    ok($result, "getHostnameESX()") or diag("The getHostnameESX() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check the size of the backing datastore.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->getIPaddrESX(session => $session);
    
    # The result should be a real IP address.
    like($result, "/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/", "getIPaddrESX()") or diag("The getIPaddrESX() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Unregister the test VM.
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
    
    # Reregister the test VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
    
    # The test VM should be registered.
    ok($session, "registerVM(name => '$testVM', config => '$config')") or diag("The registerVM() call failed.");
    
    # Check to see if the test VM is registered (should return true).
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
    
    # The test VM should be registered.
    ok($result, "registerVM(name => '$testVM', config => '$config')") or diag("The registerVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Unregister the test VM.
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
    
    # The test VM should not be registered.
    ok($config, "unregisterVM(name => '$testVM')") or diag("The unregisterVM() call failed.");
    
    # Reregister the test VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);
    ok($snapshot_name, "snapshotVM(name => '$cloneVM')") or diag("The snapshotVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);

    # Wait 2 seconds.
    sleep (2);

    # Revert the clone VM.
    $session = HoneyClient::Manager::ESX->revertVM(session => $session, name => $cloneVM, snapshot_name => $snapshot_name);
    ok($session, "revertVM(name => '$cloneVM', snapshot_name => '$snapshot_name')") or diag("The revertVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);

    # Wait 2 seconds.
    sleep (2);

    # Rename this snapshot on the clone VM.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->renameSnapshotVM(session => $session, name => $cloneVM, old_snapshot_name => $snapshot_name);
    ok($result, "renameSnapshotVM(name => '$cloneVM', old_snapshot_name => '$snapshot_name')") or diag("The renameSnapshotVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);

    # Wait 2 seconds.
    sleep (2);

    # Remove this snapshot on the clone VM.
    $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $cloneVM, snapshot_name => $snapshot_name);
    ok($session, "removeSnapshotVM(name => '$cloneVM', snapshot_name => '$snapshot_name')") or diag("The removeSnapshotVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);
    ok($cloneVM, "quickCloneVM(src_name => '$testVM')") or diag("The quickCloneVM() call failed.");

    # Verify that the clone VM is a quick clone.
    my $isQuickClone = undef;
    ($session, $isQuickClone) = HoneyClient::Manager::ESX->isQuickCloneVM(session => $session, name => $cloneVM);
    ok($isQuickClone, "quickCloneVM(src_name => '$testVM')") or diag("The quickCloneVM() call failed.");

    # Get the power state of the clone VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $cloneVM);

    # The clone VM should be powered on.
    is($state, "poweredon", "quickCloneVM(name => '$testVM')") or diag("The quickCloneVM() call failed.");
   
    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}
}




1;
