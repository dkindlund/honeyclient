#!/usr/bin/perl -w -Ilib

# Helper script, designed to identify unregistered clone VMs
# and snapshots, as well as clone VMs and snapshots that have
# been marked to be deleted on a given VMware ESX Server.

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

# Snapshot Variables
my $snapshot_list_arr = [];
my %snapshot_list_hash = ();

# Go through the list of 'bug' VMs and delete the corresponding
# data.
while (my ($unique_name, $id) = each %{$bug_vm_list}) {

    # Extract any snapshot name, if found.
    my ($quick_clone_vm_name, $snapshot_name) = split(/:/, $unique_name);

    # Make sure the VM is present on the server.
    if (exists($vm_list_hash{$quick_clone_vm_name})) {

        if (defined($snapshot_name)) {
            # Check if the snapshot exists in the VM.
            ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);
            %snapshot_list_hash = map { $_ => 1 } @{$snapshot_list_arr};

            if (exists($snapshot_list_hash{$snapshot_name})) {
                $LOG->info("Removing snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ").");
                $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $quick_clone_vm_name, snapshot_name => $snapshot_name);
            } else {
                $LOG->warn("Snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ") does not exist on (" . $hostname . ").");
            }
        }

        # Refresh the list of snapshots with this VM.
        ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);

        # If there's zero or only one snapshot left, assume it's the 'defalt_quick_clone_snapshot_name'
        # and go ahead and destroy the clone VM.
        if (scalar(@{$snapshot_list_arr}) <= 1) {
            $LOG->info("Deleting VM (" . $quick_clone_vm_name . ").");
            $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        }
    } else {
        $LOG->warn("VM (" . $quick_clone_vm_name . ") does not exist on (" . $hostname . ").");
    }

    $LOG->info("Marking client (" . $id . ") as deleted.");
    HoneyClient::Manager::Database::set_client_deleted($id);
}

# Refresh list of VMs registered on the ESX server. 
($session, $vm_list_arr) = HoneyClient::Manager::ESX->getAllVM(session => $session);

# Go through the list of registered VMs and see if there are any quick clones 
# and snapshots that are not referenced in the database.  If we find any, then
# prompt to have them deleted.
foreach my $quick_clone_vm_name (@{$vm_list_arr}) {

    # Only check VMs that appear to be quick clones...
    if (length($quick_clone_vm_name) == getVar(name => "vm_id_length", namespace => "HoneyClient::Manager::ESX")) {
        # Check if the VM has any snapshots.
        ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);

        # If the VM has no snapshots, then check the base VM to see if it's referenced in the database.
        if (scalar(@{$snapshot_list_arr}) <= 0) {
            if (!HoneyClient::Manager::Database::client_exists({client_id => $quick_clone_vm_name})) {
                # If the registered VM looks like a quick clone and has no references in the database,
                # Then prompt for deletion.
                $LOG->info("VM (" . $quick_clone_vm_name . ") appears to be a quick clone, but it is not referenced in the database.");
                my $question = prompt("Do you want to delete VM (" . $quick_clone_vm_name . ")?", "yes");
                if ($question =~ /^y.*/i) {
                    $LOG->info("Deleting VM (" . $quick_clone_vm_name . ").");
                    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
                }
            }
        } else {
            # The VM has snapshots, so iterate through all of them.
            foreach my $snapshot_name (@{$snapshot_list_arr}) {
                if (($snapshot_name ne getVar(name => "default_quick_clone_snapshot_name", namespace => "HoneyClient::Manager::ESX")) &&
                    !HoneyClient::Manager::Database::client_exists({client_id => $quick_clone_vm_name, snapshot_name => $snapshot_name})) {
                    # If the registered VM's snapshot has no references in the database,
                    # Then prompt for deletion.
                    $LOG->info("VM (" . $quick_clone_vm_name . ") has snapshot (" . $snapshot_name . "), but it is not referenced in the database.");
                    my $question = prompt("Do you want to remove snapshot (" . $snapshot_name . ")?", "yes");
                    if ($question =~ /^y.*/i) {
                        $LOG->info("Removing snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ").");
                        $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $quick_clone_vm_name, snapshot_name => $snapshot_name);
                    }
                }
            }

            # Once all the snapshots have been analyzed; go back and see if the VM has any remaining snapshots (aside from the initial snapshot).
            # If not, then figure out if the base VM is still referenced in the database; if not, then prompt for deletion.
            # Refresh the list of snapshots with this VM.
            ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);

            # If there's zero or only one snapshot left, assume it's the 'defalt_quick_clone_snapshot_name'
            # and go ahead and destroy the clone VM.
            if ((scalar(@{$snapshot_list_arr}) <= 1) &&
                !HoneyClient::Manager::Database::client_exists({client_id => $quick_clone_vm_name})) {
                $LOG->info("VM (" . $quick_clone_vm_name . ") appears to be a quick clone, but it is not referenced in the database.");
                my $question = prompt("Do you want to delete VM (" . $quick_clone_vm_name . ")?", "yes");
                if ($question =~ /^y.*/i) {
                    $LOG->info("Deleting VM (" . $quick_clone_vm_name . ").");
                    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
                }
            }
        }
    }
}

# End the session.
HoneyClient::Manager::ESX->logout(session => $session);
