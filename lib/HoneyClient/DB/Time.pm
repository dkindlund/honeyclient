use HoneyClient::DB;
use strict;

package HoneyClient::DB::Time;

use base("HoneyClient::DB");

BEGIN {

    our %fields = (
        timestamp => {
            time => {
            	required => 1,
            	key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
        int => {
            ms => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
		},
    );
}

sub parse_time {
	my $time = shift;
	if (!defined $time) {
		return;
	}
	elsif ($time =~ m/(.*?)\.(\d+)$/) {
		return (HoneyClient::DB::check_timestamp($1),substr($2,0,6));
	}
	else {
		return (HoneyClient::DB::check_timestamp($time) ,undef);
	}
}

sub new {
	my ($class,$time) = @_;
	my ($self,$ms);
	if (scalar $time) {
		($time,$ms) = parse_time($time);
		$self->{time} = $time if($time);
		$self->{ms} = $ms if($ms);
	}
	else {
		$self = $time;
	}
	$class->SUPER::new($self);
}

#TODO: Implement Me! 
sub select {
	my $class = shift;
	$class->SUPER::select(@_);
}

1;
