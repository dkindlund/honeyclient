use strict;
use HoneyClient::DB;
use HoneyClient::DB::Time;
use HoneyClient::DB::Server;
use HoneyClient::DB::Fingerprint;
use HoneyClient::DB::SystemConfig;

package HoneyClient::DB::Client;
use base("HoneyClient::DB");

our ($STATUS_RUNNING,$STATUS_CLEAN,$STATUS_COMPROMISED) = (0,1,2);
our @statusStrings = ['Running','Compromised','Clean'];

our %fields = (
    string => {
        system_id => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
    },
    integer => {
        status => {
            required => 1,
        }
    },
    ref => {
        fingerprint => {
            objclass => 'HoneyClient::DB::Fingerprint',
        },
        host => {
            objclass => 'HoneyClient::DB::Server',
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            required => 1,
        },
        config => {
            objclass => 'HoneyClient::DB::SystemConfig',
            required => 1,
        },
        client_app => {
            objclass => 'HoneyClient::DB::SystemConfig::Application',
            required => 1,
        },
		start_time => {
            objclass => 'HoneyClient::DB::Time',
		},
		compromise_time => {
            objclass => 'HoneyClient::DB::Time',
		}, 
	},
	array => {
        url_history => {
            objclass => 'HoneyClient::DB::Url::History',
        },
	},
);

1;
