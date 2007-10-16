use strict;
use HoneyClient::DB;

package HoneyClient::DB::File::Content;

use base ("HoneyClient::DB");

BEGIN {
    our %fields = (
        string => {
            md5 => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            sha1 => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            type => {
                required => 1,
            }
        },
        uint => {
            size => {
                required => 1,
            }
        },
    );
}

1;
