#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Analyst
# File:        Analyst.pm
# Description: Honeyclient Database schema class for Honeyclient analysts. The 
# analysts table will be used to assign jobs to individuals, and attribute
# comments about Honeyclient activity.
#
# CVS: $Id$
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

package HoneyClient::DB::Analyst;

use base ("HoneyClient::DB");

BEGIN {
    our %fields = (
        string => {
            name => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
                required => 1,
            },
            organization => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
                required => 1,
            },
            email_address => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
    );
}

1;
