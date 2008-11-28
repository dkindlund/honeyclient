#!/usr/bin/perl -w -Ilib

# Helper script, designed to identify unregistered clone VMs
# and clone VMs that have been marked to be deleted on a given
# VMware ESX Server.

# $Id$

use strict;
use warnings;

use HoneyClient::Util::Config qw(getVar);
use HoneyClient::Manager::ESX;
use HoneyClient::Manager::Database;

use Data::Dumper;
use Log::Log4perl qw(:easy);
use ExtUtils::MakeMaker qw(prompt);

our $LOG = get_logger();

# Create a new session to interact with the ESX server.
my $session = HoneyClient::Manager::ESX->login();

# Get a list of all VMs marked as 'bug' in the database that
# pertain to this ESX server.
my $hostname = undef;
($session, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $session),
my $bug_vm_list = HoneyClient::Manager::Database::get_broken_clients({hostname => $hostname});

# Get all the VMs registered on the ESX server.
my $vm_list_arr = [];
($session, $vm_list_arr) = HoneyClient::Manager::ESX->getAllVM(session => $session);
my %vm_list_hash = map { $_ => 1 } @{$vm_list_arr};

# Go through the list of 'bug' VMs and delete the corresponding
# data.
# XXX: Need to account for SNAPSHOT ID!
while (my ($quick_clone_vm_name, $id) = each %{$bug_vm_list}) {

    # Make sure the VM is present on the server.
    if (exists($vm_list_hash{$quick_clone_vm_name})) {

        # Check if the snapshot exists in the VM.
        # If so, then delete the snapshot.

        # Then check to see if the VM has any other quick clone snapshots.
        # If so, then don't delete the VM.
        # If not, then delete the VM.
        $LOG->info("Deleting VM (" . $quick_clone_vm_name . ")");
        #$session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
    } else {
        $LOG->warn("VM (" . $quick_clone_vm_name . ") does not exist on (" . $hostname . ").");
    }

    $LOG->info("Marking client (" . $id . ") as deleted.");
    HoneyClient::Manager::Database::set_client_deleted($id);
}

# Refresh list of VMs registered on the ESX server. 
($session, $vm_list_arr) = HoneyClient::Manager::ESX->getAllVM(session => $session);

# Go through the list of registered VMs and see if there are any quick clones that
# are not referenced in the database.  If we find any, then prompt to have them
# deleted.
foreach my $quick_clone_vm_name (@{$vm_list_arr}) {
    if (!HoneyClient::Manager::Database::client_exists({client_id => $quick_clone_vm_name}) &&
        (length($quick_clone_vm_name) == getVar(name => "vm_id_length", namespace => "HoneyClient::Manager::ESX"))) {

        # If the registered VM looks like a quick clone and has no references in the database,
        # Then prompt for deletion.
        $LOG->info("VM (" . $quick_clone_vm_name . ") appears to be a quick clone, but it is not referenced in the database.");
        my $question = prompt("Do you want to delete VM (" . $quick_clone_vm_name . ")?", "yes");
        if ($question =~ /^y.*/i) {
            $LOG->info("Deleting VM (" . $quick_clone_vm_name . ")");
            $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        }
    }
}

# End the session.
HoneyClient::Manager::ESX->logout(session => $session);
