#!/usr/bin/perl -w -Ilib

# Helper script, designed to identify unregistered clone VMs
# and clone VMs that have been marked to be deleted on a given
# VMware ESX Server.

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
	client_id => $ARGV[0], 
};

my $datastore_path = getVar(name => "datastore_path", namespace => "HoneyClient::Manager::VM");
my $snapshot_path = getVar(name => "snapshot_path", namespace => "HoneyClient::Manager::VM");

exit HoneyClient::Manager::Database::client_exists($args);
