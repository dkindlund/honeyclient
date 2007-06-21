#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
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

# Make sure HoneyClient::Manager::VM loads.
BEGIN { use_ok('HoneyClient::Manager::VM') or diag("Can't load HoneyClient::Manager:VM package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::VM');
use HoneyClient::Manager::VM;

# Make sure VMware::VmPerl loads.
BEGIN { use_ok('VMware::VmPerl', qw(VM_EXECUTION_STATE_ON VM_EXECUTION_STATE_OFF VM_EXECUTION_STATE_STUCK VM_EXECUTION_STATE_SUSPENDED)) or diag("Can't load VMware::VmPerl package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('VMware::VmPerl');
use VMware::VmPerl qw(VM_EXECUTION_STATE_ON VM_EXECUTION_STATE_OFF VM_EXECUTION_STATE_STUCK VM_EXECUTION_STATE_SUSPENDED);

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::VM::Clone') or diag("Can't load HoneyClient::Manager::VM::Clone package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::VM::Clone');
use HoneyClient::Manager::VM::Clone;

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(dclone)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
use Storable qw(dclone);

# Make sure threads loads.
BEGIN { use_ok('threads') or diag("Can't load threads package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads');
use threads;

# Make sure threads::shared loads.
BEGIN { use_ok('threads::shared') or diag("Can't load threads::shared package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads::shared');
use threads::shared;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);
}



# =begin testing
{
# Shared test variables.
my ($stub, $som, $URL);
my $testVM = $ENV{PWD} . "/" . getVar(name      => "test_vm_config",
                                      namespace => "HoneyClient::Manager::VM::Test");

# Catch all errors, in order to make sure child processes are
# properly killed.
eval {

    $URL = HoneyClient::Manager::VM->init();

    # Connect to daemon as a client.
    $stub = getClientHandle(namespace => "HoneyClient::Manager::VM");

    # In order to test setMasterVM(), we're going to fully clone
    # the testVM, then set the newly created clone as a master VM.

    # Get the test VM's parent directory,
    # in order to create a temporary master VM.
    my $testVMDir = dirname($testVM);
    my $masterVMDir = dirname($testVMDir) . "/test_vm_master";
    my $masterVM = $masterVMDir . "/" . basename($testVM);

    # Create the master VM.
    $som = $stub->fullCloneVM(src_config => $testVM, dest_dir => $masterVMDir);

    # Wait a small amount of time for the asynchronous clone
    # to complete.
    sleep (60);

    # The master VM should be on.
    $som = $stub->getStateVM(config => $masterVM);

    # Since the master VM doesn't have an OS installed on it,
    # the VM may be considered stuck.  Go ahead and answer
    # this question, if need be.
    if ($som->result == VM_EXECUTION_STATE_STUCK) {
        $som = $stub->answerVM(config => $masterVM);
    }

    HoneyClient::Manager::VM->destroy();
    sleep (1);

    # Create a generic clone, with test state data.
    my $clone = HoneyClient::Manager::VM::Clone->new(test => 1, master_vm_config => $masterVM);
    is($clone->{test}, 1, "new(test => 1, master_vm_config => '$masterVM')") or diag("The new() call failed.");
    isa_ok($clone, 'HoneyClient::Manager::VM::Clone', "new(test => 1, master_vm_config => '$masterVM')") or diag("The new() call failed.");

    # Destroy the master VM.
    $som = $stub->destroyVM(config => $masterVM);
};

# Kill the child daemon, if it still exists.
HoneyClient::Manager::VM->destroy();
sleep (1);

# Report any failure found.
if ($@) {
    fail($@);
}
}




1;
