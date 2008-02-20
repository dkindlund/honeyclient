#!/usr/bin/perl

use CPAN::Checksums qw(updatedir);
my $success = updatedir($ARGV[0]);
