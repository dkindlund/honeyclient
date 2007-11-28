#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Client
# File:        Client.pm
# Description: Honeyclient Database schema class for Client systems. This refers
# to the system accessing the malicious web resources. Client objects refer to
# their host, configuration, resources visited, and Compromise Information.
#
# CVS: $Id: DB.pm 830 2007-09-17 17:58:49Z mbriggs $
#
# @author mbriggs
#
# Copyright (C) 2007 The MITRE Corporation.  All rights reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, using version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
#######################################################################

use strict;
use HoneyClient::DB;
use HoneyClient::DB::Time;
use HoneyClient::DB::Server;
use HoneyClient::DB::Fingerprint;
use HoneyClient::DB::SystemConfig;
use HoneyClient::DB::Url::History;

package HoneyClient::DB::Client;
use base("HoneyClient::DB");

our ($STATUS_RUNNING,$STATUS_CLEAN,$STATUS_COMPROMISED) = (0,1,2);
our @statusStrings = ['Running','Clean','Compromised'];

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
