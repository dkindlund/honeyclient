#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::SystemConfig
# File:        SystemConfig.pm
# Description: Honeyclient Database schema class to describe system
# system configurations for Client systems. Including OS, Applications, and
# patches.
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
use HoneyClient::DB::SystemConfig::Patch;
use HoneyClient::DB::SystemConfig::Application;

package HoneyClient::DB::SystemConfig;
use base("HoneyClient::DB");

our %fields = (
    string => {
        name => {
            key => $HoneyClient::DB::KEY_UNIQUE,
            required => 1,
        },
        os_name => {
            required => 1,
        },
        os_version => {
            required => 1,
        },
    },
    array => {
        applications => {
            objclass => "HoneyClient::DB::SystemConfig::Application",
        },
        os_patches => {
            objclass => "HoneyClient::DB::SystemConfig::Patch",
        },
    },
);

1;
