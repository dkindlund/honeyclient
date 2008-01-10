use strict;

use YAML qw'freeze thaw Bless';
use XML::RPC;

package HoneyClient::Manager::Database;

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

#TODO: Implement this method to retrieve web links to visit.
sub retrieve_urls {
	my ($client_id,$count) = @_;
}

#TODO: Implement this method to submit a list of web links to the queue.
sub submit_urls {
}
