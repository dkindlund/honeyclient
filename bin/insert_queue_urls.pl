#!/usr/bin/perl -w -Ilib

# $Id$

use strict;
use warnings;

use Data::Dumper;
use HoneyClient::Manager::Database;
use HoneyClient::Util::Config qw(getVar);

my $urls = {
    'source_type'            => 'command_line',
    'source_name'            => getVar(name => "organization", namespace => "HoneyClient"),
    'http://www.google.com/' => 1,
    'http://www.mitre.org/'  => 1,
};

my $output = HoneyClient::Manager::Database::insert_queue_urls($urls);
print Dumper($output) . " URL(s) inserted.\n";
