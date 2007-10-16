use strict;
use HoneyClient::DB;
use HoneyClient::DB::SystemConfig::Patch;
use HoneyClient::DB::SystemConfig::Application;

package HoneyClient::DB::SystemConfig;
use base("HoneyClient::DB");

our %fields = (
    string => {
        name => {
            key => $HoneyClient::DB::KEY_UNIQUE,
            required => 1,
        },
        os_name => {
            required => 1,
        },
        os_version => {
            required => 1,
        },
    },
    array => {
        applications => {
            objclass => "HoneyClient::DB::SystemConfig::Application",
        },
        os_patches => {
            objclass => "HoneyClient::DB::SystemConfig::Patch",
        },
    },
);

1;
