#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::File::Content
# File:        Content.pm
# Description: Honeyclient Database schema class used by HoneyClient::DB::File
# to store information about File Content (MD5, SHA1, size, and type)
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

package HoneyClient::DB::File::Content;

use base ("HoneyClient::DB");

BEGIN {
    our %fields = (
        string => {
            md5 => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            sha1 => {
                required => 1,
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
            type => {
                required => 1,
            }
        },
        uint => {
            size => {
                required => 1,
            }
        },
    );
}

1;
