#!/usr/bin/perl -w -Ilib

# $Id$

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

my $datastore_path = getVar(name => "datastore_path", namespace => "HoneyClient::Manager::VM");
my $snapshot_path = getVar(name => "snapshot_path", namespace => "HoneyClient::Manager::VM");

my $clients = HoneyClient::Manager::Database::get_broken_clients($args);

while (my ($cid, $id) = each %{$clients}) {

    $LOG->info("Deleting VM (" . $cid . ")");

    $LOG->info("Executing: vmware-cmd " . $datastore_path . "/" . $cid . "/*.vmx stop hard");
    system("vmware-cmd " . $datastore_path . "/" . $cid . "/*.vmx stop hard");

    $LOG->info("Executing: vmware-cmd " . $datastore_path . "/" . $cid . "/*.cfg stop hard");
    system("vmware-cmd " . $datastore_path . "/" . $cid . "/*.cfg stop hard");

    $LOG->info("Executing: vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.vmx");
    system("vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.vmx");

    $LOG->info("Executing: vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.cfg");
    system("vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.cfg");
    
    $LOG->info("Executing: rm -rf " . $datastore_path . "/" . $cid);
    system("rm -rf " . $datastore_path . "/" . $cid);

    $LOG->info("Executing: rm -f " . $snapshot_path . "/" . $cid . "*");
    system("rm -f " . $snapshot_path . "/" . $cid . "*");

    HoneyClient::Manager::Database::set_client_deleted($id);

    print "\n";
}

