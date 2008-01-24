use strict;

use YAML qw'freeze thaw Bless';
use XML::RPC;

package HoneyClient::Manager::Database;

our $AUTOLOAD;

sub AUTOLOAD {
	my $obj = shift;
	my $obj_yaml = YAML::freeze($obj);
	my $name = $AUTOLOAD;
	$name =~  s/.*://;
	
	my $xmlrpc = XML::RPC->new('http://localhost:3000/hc_database/api');
	return $xmlrpc->call($name,$obj_yaml);
}

sub insert {
	my ($class,$obj) = @_;
	my $obj_yaml = freeze($obj);

	# Execute insert via XML-RPC and return id
	eval {
		my $xmlrpc = XML::RPC->new('http://localhost:3000/hc_database/api');
		return $xmlrpc->call("insert",$class,$obj_yaml);
	};
	if ($@) {
		return 0;
	}
}

1;
