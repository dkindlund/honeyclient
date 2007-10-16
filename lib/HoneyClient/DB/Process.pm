use HoneyClient::DB;
use HoneyClient::DB::File;
use HoneyClient::DB::Regkey;
use HoneyClient::DB::Note;
use strict;

package HoneyClient::DB::Process;

use base("HoneyClient::DB");

BEGIN {

    our %fields = (
        string => {
            name => {
            	required => 1,
            	key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            parent_name => {
#            	required => 1,
            	key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
        int => {
            pid => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            parent_pid => {
#                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
		},
		ref => {
			created_time => {
				key => $HoneyClient::DB::KEY_UNIQUE_MULT,
				objclass => 'HoneyClient::DB::Time',
			},
			terminated_time => {
				key => $HoneyClient::DB::KEY_UNIQUE_MULT,
				objclass => 'HoneyClient::DB::Time',
			},
		},
        array => {
	        file_system => {
                objclass => 'HoneyClient::DB::File',
            },
            registry => {
                objclass => 'HoneyClient::DB::Regkey',
            },
            notes => {
                objclass => 'HoneyClient::DB::Note',
            },
        },
    );
}

1;
