#!/usr/bin/perl

#Run like:
#./UpdateBundleChecksum.pl ../cpan/sources/authors/id/M/MI/MITREHC/

use CPAN::Checksums qw(updatedir);
my $success = updatedir($ARGV[0]);
