#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::File
# File:        File.pm
# Description: Honeyclient Database schema class for Processes exhibiting
# unusual  behavior at the time of a system compromise. Processes refer to
# system changes they have made, (except process create/kill events which can
# be understood through parent-child relationships of processes).
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
