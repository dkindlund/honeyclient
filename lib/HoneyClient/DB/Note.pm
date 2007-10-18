#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Note
# File:        Note.pm
# Description: Honeyclient Database schema class for Analyst notes about
# Honeyclient activity.
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
use HoneyClient::DB::Analyst;

package HoneyClient::DB::Note;

use base ("HoneyClient::DB");

BEGIN {
    our %fields = (
        text => {
            note => {
                required => 1,
            },
        },
        string => {
            category => {
                init_val => 'none',
                required => 1,
            },
        },
        ref => {
            analyst => {
                objclass => 'HoneyClient::DB::Analyst',
                init_val => {
                    name => 'anonymous',
                    organization => 'anonymous',
                },
                required => 1,
            },
            time => {
           		objclass => 'HoneyClient::DB::Time',
            },
        },
    );
}

1;
