use strict;
use HoneyClient::DB;
use HoneyClient::DB::Time;

package HoneyClient::DB::Regkey;

use base("HoneyClient::DB");

BEGIN {

    our %fields = (
        string => {
            key_name => {
                required => 1,
            },
            event_type => {
                required => 1,
            },
            value_type => {
                required => 1,
            },
        },
		text => ['value_name','value'], 
       	ref => {
			time => {
           		objclass => 'HoneyClient::DB::Time',
       		},
		},
    );
}

1;
