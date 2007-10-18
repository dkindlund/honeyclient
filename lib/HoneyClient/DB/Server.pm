#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Server
# File:        Server.pm
# Description: Honeyclient Database schema class to describe systems hosting
# Honeyclients (Managers).
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

package HoneyClient::DB::Server;
use base("HoneyClient::DB");

our %fields = (
    string => {
        organization => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            required => 1,
        },
        host_name => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        ip_address => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
    },
);

1;
