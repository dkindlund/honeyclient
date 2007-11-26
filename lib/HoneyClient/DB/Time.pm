#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Time
# File:        Time.pm
# Description: Honeyclient Database schema class to store and process
# timestamps. This class was designed to assist with storage of timestamps
# calculated to microseconds (which is not supported by the MySQL timestamp
# type).
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

package HoneyClient::DB::Time;

use base("HoneyClient::DB");

BEGIN {

    our %fields = (
        timestamp => {
            time => {
            	required => 1,
            	key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
        },
        int => {
            ms => {
                key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            },
		},
    );
}

sub _where_condition {
	my $class = shift;
	if (!ref($_[0])) {
		return ' WHERE CONCAT_WS('.',Time.time,Time.ms)='.$HoneyClient::DB::dbhandle->quote($_[0]);
	}
	elsif(ref($_[0]) eq 'ARRAY') {
		my @times = @{$_[0]};
		return ' WHERE CONCAT_WS('.',Time.time,Time.ms) BETWEEN '.$HoneyClient::DB::dbhandle->quote($times[0])
			.' AND '.$HoneyClient::DB::dbhandle->quote($times[1]);
	}
	else {
		return $class->SUPER::_where_condition($_[0]);
	}
}

sub parse_time {
	my $time = shift;
	if (!defined $time) {
		return;
	}
	elsif ($time =~ m/(.*?)\.(\d+)$/) {
		return (HoneyClient::DB::check_timestamp($1),substr($2,0,6));
	}
	else {
		return (HoneyClient::DB::check_timestamp($time) ,undef);
	}
}

sub new {
	my ($class,$time) = @_;
	my ($self,$ms);
	if (scalar $time) {
		($time,$ms) = parse_time($time);
		$self->{time} = $time if($time);
		$self->{ms} = $ms if($ms);
	}
	else {
		$self = $time;
	}
	$class->SUPER::new($self);
}

#TODO: Implement Me! 
sub select {
	my $class = shift;
	$class->SUPER::select(@_);
}

1;
