use strict;
use HoneyClient::DB;
use HoneyClient::DB::Time;
use HoneyClient::DB::Analyst;

package HoneyClient::DB::Note;

use base ("HoneyClient::DB");

BEGIN {
    our %fields = (
        text => {
            note => {
                required => 1,
            },
        },
        string => {
            category => {
                init_val => 'none',
                required => 1,
            },
        },
        ref => {
            analyst => {
                objclass => 'HoneyClient::DB::Analyst',
                init_val => {
                    name => 'anonymous',
                    organization => 'anonymous',
                },
                required => 1,
            },
            time => {
           		objclass => 'HoneyClient::DB::Time',
            },
        },
    );
}

1;
