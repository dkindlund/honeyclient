#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Regkey
# File:        Regkey.pm
# Description: Honeyclient Database schema class for Regkeys changes that occur
# at the time of a system compromise
#
# CVS: $Id: DB.pm 830 2007-09-17 17:58:49Z mbriggs $
#
# @author mbriggs, kindlund
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

package HoneyClient::DB::Regkey;

use base("HoneyClient::DB");

BEGIN {

    our %fields = (
        string => {
            key_name => {
                required => 1,
            },
            event_type => {
                required => 1,
            },
            value_type => {
                required => 1,
            },
        },
		text => ['value_name','value'], 
       	ref => {
			time => {
           		objclass => 'HoneyClient::DB::Time',
       		},
		},
    );
}

1;
