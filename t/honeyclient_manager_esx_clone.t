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

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getClientHandle);

# Make sure HoneyClient::Manager::ESX loads.
BEGIN { use_ok('HoneyClient::Manager::ESX') or diag("Can't load HoneyClient::Manager::ESX package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::ESX');
use HoneyClient::Manager::ESX;

# Make sure HoneyClient::Manager::Database loads.
BEGIN { use_ok('HoneyClient::Manager::Database') or diag("Can't load HoneyClient::Manager::Database package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Database');
use HoneyClient::Manager::Database;

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::ESX::Clone') or diag("Can't load HoneyClient::Manager::ESX::Clone package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::ESX::Clone');
use HoneyClient::Manager::ESX::Clone;

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(dclone thaw)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
can_ok('Storable', 'thaw');
use Storable qw(dclone thaw);

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure threads loads.
BEGIN { use_ok('threads') or diag("Can't load threads package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads');
use threads;

# Make sure threads::shared loads.
BEGIN { use_ok('threads::shared') or diag("Can't load threads::shared package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads::shared');
use threads::shared;

# Make sure Thread::Semaphore loads.
BEGIN { use_ok('Thread::Semaphore') or diag("Can't load Thread::Semaphore package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Thread::Semaphore');
use Thread::Semaphore;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);

# Make sure DateTime::HiRes loads.
BEGIN { use_ok('DateTime::HiRes') or diag("Can't load Sys::HostIP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure IO::File loads.
BEGIN { use_ok('IO::File') or diag("Can't load IO::File package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IO::File');
use IO::File;
}



# =begin testing
{
# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Include notice, to clarify our assumptions.
diag("About to run basic unit tests; these may take some time.");
diag("Note: These tests *expect* VMware ESX Server to be accessible and running beforehand.");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    # Create a generic empty clone object, with test state data.
    my $clone = HoneyClient::Manager::ESX::Clone->new(test => 1, master_vm_name => $testVM, _dont_init => 1, _bypass_firewall => 1);
    is($clone->{test}, 1, "new(test => 1, master_vm_name => '$testVM', _dont_init => 1, _bypass_firewall => 1)") or diag("The new() call failed.");
    isa_ok($clone, 'HoneyClient::Manager::ESX::Clone', "new(test => 1, master_vm_name => '$testVM', _dont_init => 1, _bypass_firewall => 1)") or diag("The new() call failed.");
    $clone = undef;

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real clone operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM?", "no");
    if ($question =~ /^y.*/i) {
        $clone = HoneyClient::Manager::ESX::Clone->new(test => 1);
        is($clone->{test}, 1, "new(test => 1)") or diag("The new() call failed.");
        isa_ok($clone, 'HoneyClient::Manager::ESX::Clone', "new(test => 1)") or diag("The new() call failed.");
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};
        $clone = undef;
    
        # Destroy the clone VM.
        my $session = HoneyClient::Manager::ESX->login();
        HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real suspend/snapshot operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM and suspending/snapshotting a subsequent clone?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::ESX::Clone->new(_bypass_firewall => 1);
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};
        my $name = $clone->{name};

        # Snapshot and suspend the clone.
        $clone->suspend(perform_snapshot => 1);

        # Destroy the clone object.
        $clone->destroy();

        # Wait for the suspend/snapshot to complete.
        sleep (5);

        # Test if the operations worked.
        my $result = HoneyClient::Manager::ESX::_findSnapshot($name, HoneyClient::Manager::ESX::_getViewVMSnapshotTrees(session => $clone->{_vm_session}));
        is(defined($result), 1, "suspend()") or diag("The suspend() call failed.");
   
        $clone = undef;

        # Now, destroy the backing cloned VM.
        my $session = HoneyClient::Manager::ESX->login();
        HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real destroy operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning this master VM and destroying a subsequent clone?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::ESX::Clone->new(_bypass_firewall => 1);
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};
        my $name = $clone->{name};

        # Destroy the clone object.
        $clone->destroy();

        # Wait for the destroy to complete.
        sleep (5);
    
        # Test if the operations worked.
        my $result = HoneyClient::Manager::ESX::_findSnapshot($name, HoneyClient::Manager::ESX::_getViewVMSnapshotTrees(session => $clone->{_vm_session}));
        is(!defined($result), 1, "destroy()") or diag("The destroy() call failed.");
   
        $clone = undef;

        # Now, destroy the backing cloned VM.
        my $session = HoneyClient::Manager::ESX->login();
        HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}
}



# =begin testing
{
# Shared test variables.
my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    my $question;
    $question = prompt("#\n" .
                       "# Note: Testing real drive operations will *ONLY* work\n" .
                       "# with a fully functional master VM that has the HoneyClient code\n" .
                       "# loaded upon boot-up.\n" .
                       "#\n" .
                       "# This test also requires that the firewall VM is registered,\n" .
                       "# powered on, and operational.\n" .
                       "#\n" .
                       "# Your master VM is: " . getVar(name => "master_vm_name", namespace => "HoneyClient::Manager::ESX") . "\n" .
                       "#\n" .
                       "# Do you want to test cloning and driving this master VM?", "no");
    if ($question =~ /^y.*/i) {

        # Create a generic empty clone, with test state data.
        my $clone = HoneyClient::Manager::ESX::Clone->new(_bypass_firewall => 1);
        my $quick_clone_vm_name = $clone->{quick_clone_vm_name};

        $clone = $clone->drive(work => { 'http://www.google.com/' => 1 });
        isa_ok($clone, 'HoneyClient::Manager::ESX::Clone', "drive(work => { 'http://www.google.com/' => 1})") or diag("The drive() call failed.");
        $clone = undef;

        # Now, destroy the backing cloned VM.
        my $session = HoneyClient::Manager::ESX->login();
        HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        HoneyClient::Manager::ESX->logout(session => $session);
    }
};

# Report any failure found.
if ($@) {
    fail($@);
}
}




1;
