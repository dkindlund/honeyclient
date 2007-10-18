#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Analyst::Job
# File:        Job.pm
# Description: Honeyclient Database schema class for Honeyclient analysis jobs.
# The table will store pending Honeyclient analysis jobs, and refer to the
# responsible analyst.
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

package HoneyClient::DB::Analyst::Job;

use base ("HoneyClient::DB");
our ($STATUS_CLOSED,$STATUS_OPEN);
our (@STATUS_MESSAGE) = ('open','closed');

BEGIN {
    our %fields = (
        },
        int => {
            status => {
                init_val => $STATUS_OPEN,
        },
        ref => {
            client => {
                objclass => 'HoneyClient::DB::Client',
                required => 1,
            },
            analyst => {
                objclass => 'HoneyClient::DB::Analyst',
                init_val => {
                    name => 'anonymous',
                    organization => 'anonymous',
                },
                required => 1,
            },
        	start_date => {
                objclass => 'HoneyClient::DB::Time',
			},
			end_date => {
                objclass => 'HoneyClient::DB::Time',
			},
        },
    );
}

1;
