use strict;
use HoneyClient::DB;
use HoneyClient::DB::Time;
use HoneyClient::DB::File::Content;

package HoneyClient::DB::File;

use base("HoneyClient::DB");

BEGIN {

    our %fields = (
        string => {
            name => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            event_type => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
        ref => {
            contents => {
                objclass => 'HoneyClient::DB::File::Content',
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            time => {
           		objclass => 'HoneyClient::DB::Time',
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
    );
}

1;
