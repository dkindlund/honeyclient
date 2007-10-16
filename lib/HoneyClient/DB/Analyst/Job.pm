use strict;
use HoneyClient::DB;

package HoneyClient::DB::Analyst::Job;

use base ("HoneyClient::DB");
our ($STATUS_CLOSED,$STATUS_OPEN);
our (@STATUS_MESSAGE) = ('open','closed');

BEGIN {
    our %fields = (
        },
        int => {
            status => {
                init_val => $STATUS_OPEN,
        },
        ref => {
            client => {
                objclass => 'HoneyClient::DB::Client',
                required => 1,
            },
            analyst => {
                objclass => 'HoneyClient::DB::Analyst',
                init_val => {
                    name => 'anonymous',
                    organization => 'anonymous',
                },
                required => 1,
            },
        	start_date => {
                objclass => 'HoneyClient::DB::Time',
			},
			end_date => {
                objclass => 'HoneyClient::DB::Time',
			},
        },
    );
}

1;
