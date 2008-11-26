#!/usr/bin/perl -w -Ilib

# $Id: migrate_clients.pl 1343 2008-03-07 20:19:24Z kindlund $

use strict;
use warnings;

use Data::Dumper;
use HoneyClient::Util::Config qw(getVar);
use HoneyClient::Manager::Database;
use Sys::Hostname::Long;
use Log::Log4perl qw(:easy);

our $LOG = get_logger();

my $args = {
    hostname => Sys::Hostname::Long::hostname_long,
};

my $old_datastore_path = "/vm.old/clones";
my $old_snapshot_path = "/vm.old/snapshots";
my $datastore_path = getVar(name => "datastore_path", namespace => "HoneyClient::Manager::VM");
my $snapshot_path = getVar(name => "snapshot_path", namespace => "HoneyClient::Manager::VM");
my $suspicious_path = "/vm/suspicious";

my $clients = HoneyClient::Manager::Database::get_not_deleted_clients($args);

while (my ($cid, $id) = each %{$clients}) {

    $LOG->info("Migrating VM (" . $cid . ")");

    #$LOG->info("Executing: vmware-cmd " . $datastore_path . "/" . $cid . "/*.vmx stop hard");
    #system("vmware-cmd " . $datastore_path . "/" . $cid . "/*.vmx stop hard");

    #$LOG->info("Executing: vmware-cmd " . $datastore_path . "/" . $cid . "/*.cfg stop hard");
    #system("vmware-cmd " . $datastore_path . "/" . $cid . "/*.cfg stop hard");

    $LOG->info("Executing: vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.vmx");
    system("vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.vmx");

    $LOG->info("Executing: vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.cfg");
    system("vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.cfg");
    
    $LOG->info("Executing: mv " . $datastore_path . "/" . $cid . " " . $suspicious_path);
    system("mv " . $datastore_path . "/" . $cid . " " . $suspicious_path);

    $LOG->info("Executing: vmware-cmd -s register " . $suspicious_path . "/" . $cid . "/*.vmx");
    system("vmware-cmd -s register " . $suspicious_path . "/" . $cid . "/*.vmx");
    
    $LOG->info("Executing: vmware-cmd -s register " . $suspicious_path . "/" . $cid . "/*.cfg");
    system("vmware-cmd -s register " . $suspicious_path . "/" . $cid . "/*.cfg");
    
    #$LOG->info("Executing: cp -Rp " . $old_datastore_path . "/" . $cid . " " . $datastore_path);
    #system("cp -Rp " . $old_datastore_path . "/" . $cid . " " . $datastore_path);

    #$LOG->info("Executing: cp -Rp " . $old_snapshot_path . "/" . $cid . "* " . $snapshot_path);
    #system("cp -Rp " . $old_snapshot_path . "/" . $cid . "* " . $snapshot_path);
    
    #$LOG->info("Executing: vmware-cmd -s register " . $datastore_path . "/" . $cid . "/*.vmx");
    #system("vmware-cmd -s register " . $datastore_path . "/" . $cid . "/*.vmx");

    #$LOG->info("Executing: vmware-cmd -s register " . $datastore_path . "/" . $cid . "/*.cfg");
    #system("vmware-cmd -s register " . $datastore_path . "/" . $cid . "/*.cfg");

    #HoneyClient::Manager::Database::set_client_deleted($id);

    #print "\n";
}

