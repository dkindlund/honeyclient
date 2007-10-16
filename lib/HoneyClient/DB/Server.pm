use strict;
use HoneyClient::DB;

package HoneyClient::DB::Server;
use base("HoneyClient::DB");

our %fields = (
    string => {
        organization => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            required => 1,
        },
        host_name => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        ip_address => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
    },
);

1;
