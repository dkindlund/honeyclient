use strict;
use HoneyClient::DB;
use HoneyClient::DB::Url;
use HoneyClient::DB::Time;
use HoneyClient::DB::Client;

package HoneyClient::DB::Url::History;
use base("HoneyClient::DB");

our ($STATUS_IGNORED,$STATUS_VISITED,$STATUS_TIMED_OUT) = (0,1,2);
our (@URL_STATUS_STRINGS) = ("Ignored","Visited","Timed out");

our %fields = (
    ref => {
        url => {
            objclass => 'HoneyClient::DB::Url',
            required => 1,
        },
        visited => {
        	objclass => 'HoneyClient::DB::Time',
        },
    },
    int => {
        status => {
            required => 1,
        },
    },
);

1;
