use strict;
use HoneyClient::DB;
use HoneyClient::DB::SystemConfig::Patch;

package HoneyClient::DB::SystemConfig::Application;
use base("HoneyClient::DB");

our %fields = (
    string => {
        manufacturer => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        name => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        major_version => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
		minor_version => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
		}
    },
    array => {
        patches => {
            objclass => "HoneyClient::DB::SystemConfig::Patch",
        },
    }
);

1;
