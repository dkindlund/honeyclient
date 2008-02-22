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

#my ($cid, $id);
while (my ($cid, $id) = each %{$clients}) {

    $LOG->info("Deleting VM (" . $cid . ")");

    print "Executing: vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.vmx\n";
    system("vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.vmx");

    print "Executing: vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.cfg\n";
    system("vmware-cmd -s unregister " . $datastore_path . "/" . $cid . "/*.cfg");
    
    print "Executing: rm -rf " . $datastore_path . "/" . $cid . "\n";
    system("rm -rf " . $datastore_path . "/" . $cid);

    print "Executing: rm -f " . $snapshot_path . "/" . $cid . "*\n";
    system("rm -f " . $snapshot_path . "/" . $cid . "*");

    HoneyClient::Manager::Database::set_client_deleted($id);

    print "\n";
}

