#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
# Do testing here...
my $foo = HoneyClient::Something->blah(...);
dies_ok {$foo->dosomething()} 'dosomething()' or diag("The issomething() call failed.
  Expected dosomething() to throw an exception.");
}




1;
