use strict;
use HoneyClient::DB;

package HoneyClient::DB::Analyst;

use base ("HoneyClient::DB");

BEGIN {
    our %fields = (
        string => {
            name => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
                required => 1,
            },
            organization => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
                required => 1,
            },
            email_address => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
    );
}

1;
