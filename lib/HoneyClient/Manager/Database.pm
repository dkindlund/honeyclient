use strict;

use YAML;
use XML::RPC;
use Carp qw();
use Data::Dumper;
use Data::Structure::Util;

package HoneyClient::Manager::Database;

our $AUTOLOAD;

sub AUTOLOAD {
	my $obj = shift;
	my $obj_yaml = YAML::freeze(Data::Structure::Util::unbless($obj));
	my $name = $AUTOLOAD;
	$name =~  s/.*://;
	
	my $xmlrpc = XML::RPC->new('http://172.16.164.103:3000/hc_database/api');
    
	my $ret = $xmlrpc->call($name,$obj_yaml);

    # XXX: Make this more robust.
    # Need to check if arguments are like "faultCode" or "errString", I believe.
    # Error checking.
    if (ref($ret) eq "HASH") {
        Carp::croak("Error: " . Data::Dumper::Dumper($ret));
    }

	return $ret;
}

sub insert {
	my ($class,$obj) = @_;
	my $obj_yaml = YAML::freeze(Data::Structure::Util::unbless($obj));

	# Execute insert via XML-RPC and return id
	eval {
		my $xmlrpc = XML::RPC->new('http://172.16.164.103:3000/hc_database/api');
		return $xmlrpc->call("insert",$class,$obj_yaml);
	};
	if ($@) {
		return 0;
	}
}

1;
