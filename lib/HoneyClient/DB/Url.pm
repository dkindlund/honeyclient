#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB::Url
# File:        Url.pm
# Description: Honeyclient Database schema class for Urls visited by web
# browsing Honeyclients.
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
package HoneyClient::DB::Url;
use base("HoneyClient::DB");

use Data::Validate::URI qw(is_uri);
use URI::URL;
use HoneyClient::DB;
use HoneyClient::Util::Config;
use Log::Log4perl qw(:easy);
our $LOG = get_logger();

our %fields = (
    string => {
        protocol => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        domain => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        rel_path => {
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
    },
    int => {
        visits => {
            init_val => 1,
        },
    },
);
# process_url accepts a url string and returns a 
sub process_url {
	my $url = shift;
    if (is_uri($url)) {
        my $url_obj = URI::URL->new($url);
        $url = {
            protocol => $url_obj->scheme(),
            domain => $url_obj->netloc(),
        };
		# mailto: URLs don't have a query component
		eval {
			my $rel_path = $url_obj->path_query();
			$url->{rel_path} = ($rel_path or '');
		};
		return $url;
    }
	else {
		return undef;
	}
}

sub new {
    my ($class,$self) = @_;
    if (!ref $self) {
        # Assume a Url string has been passed
		my $url = $self;
		unless ($self = process_url($url)) {
		# The URL is undefined or of an incorrect format. Force to {} to prevent crash.
			$LOG->warn("Url: $url is improper and thus won't be created/inserted correctly");
			return undef;
		}
    }
    $class->SUPER::new($self);
}

sub select_full_url {
	my $class = shift;
    push @_,('id','protocol','domain','rel_path');
    my @results = $class->SUPER::select(@_);
    foreach my $row (@results) {
        $row->{'url'} = delete $row->{'protocol'};
        ($row->{'url'} eq 'mailto') ? $row->{'url'} .= ':' : $row->{'url'} .= '://';
        $row->{'url'} .= delete $row->{'domain'};
        $row->{'url'} .= delete $row->{'rel_path'};
    }
    return @results;
}

sub insert {
	my $self = shift;
    my $url_id = $self->SUPER::insert();
	#TODO: Logic for array of Urls inserted
    if ($HoneyClient::DB::LAST_ERROR == $HoneyClient::DB::ERROR_DUPLICATE_FOUND) {
        HoneyClient::DB::Url->incrementColumn(
            '-column'   => 'visits',
            '-where' => {'id'=>$url_id},
        );
    }
    return $url_id;
}

1;
