use strict;
use HoneyClient::DB;

package HoneyClient::DB::SystemConfig::Patch;
use base("HoneyClient::DB");

our %fields = (
    string => {
        name => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
    },
);

1;
