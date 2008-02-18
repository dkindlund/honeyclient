#!/usr/bin/perl -w -Ilib

use strict;
use warnings;

use Data::Dumper;
use HoneyClient::Manager::Database;

my $urls = {
    'http://www.cpan.org/' => 20,
    'http://www.craigslist.org/' => 100,
};

my $output = HoneyClient::Manager::Database::insert_queue_urls($urls);
print Dumper($output) . " URL(s) inserted.\n";
