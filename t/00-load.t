#!perl -T

use Test::More tests => 5;

BEGIN {
	use_ok( 'HoneyClient' );
	use_ok( 'HoneyClient::Agent' );
	use_ok( 'HoneyClient::Manager' );
	use_ok( 'HoneyClient::Manager::Firewall' );
	use_ok( 'HoneyClient::Manager::VM' );
}

diag( "Testing HoneyClient $HoneyClient::VERSION, Perl $], $^X" );
