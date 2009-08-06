#!/usr/bin/perl -w -Ilib

#######################################################################
# Created on:  Jan 27, 2009
# File:        submit_job.pl
# Description: Helper script, designed to submit pending jobs to the
#              HoneyClient system via the RabbitMQ server.
#
# CVS: $Id$
#
# @author knwang, kindlund
#
# Copyright (C) 2007-2009 The MITRE Corporation.  All rights reserved.
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

BEGIN {
    our $VERSION = 1.02;
}
our ($VERSION);

=pod

=head1 NAME

submit_job.pl - Perl script to submit a new job to the HoneyClient system.

=head1 SYNOPSIS

 submit_job.pl [options] [http://www.google.com http://www.cnn.com ...]

 Options:
 --help               This help message.
 --man                Print full man page.
 --version            Print version.
 --verbose            Print verbose messages.

=head1 OPTIONS

=over 4

=item B<--help>

Print a brief help message and exits.

=back

=head1 DESCRIPTION

When URLs are specified on the command-line, the program will 
assign a single job to all URLs provided, allowing a single
HoneyClient to visit all URLs in a single VM.  URLs will be visited
in the order they are supplied in the command-line; the first URL
listed will be visited first, etc.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 AUTHORS

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2007-2009 The MITRE Corporation.  All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, using version 2
of the License.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.

=cut

use strict;
use warnings;
use Carp ();

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Include Getopt Parser
use Getopt::Long qw(:config auto_help ignore_case_always);

use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;
use Pod::Usage;
use Data::Dumper;
use Data::UUID;
use Sys::Hostname::Long;
use HoneyClient::Util::DateTime;
use HoneyClient::Util::Config qw(getVar);
use HoneyClient::Util::EventEmitter;

my $verbose = 0;
GetOptions('verbose!'             => \$verbose,
           'man'                  => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
           'version'              => sub {
                                        print "MITRE HoneyClient Project (http://www.honeyclient.org)\n" .
                                              "------------------------------------------------------\n" .
                                              $0  . " (v" . $VERSION . ")\n";
                                        exit(0);
                                     }) or pod2usage(2);

# Sanity check.
if (scalar(@ARGV) <= 0) {
    pod2usage(2);
    exit 0;
}

# Create the initial data.
my $data = {
    job => {
        created_at => HoneyClient::Util::DateTime->now(),
        uuid       => lc(Data::UUID->new()->create_str()),
        job_source => {
            name     => Sys::Hostname::Long::hostname_long,
            protocol => "command_line",
        },
        urls       => [],
    },
};

# Collect the list of URLs.
my $priority = @ARGV;
foreach my $url (@ARGV) {
    my $entry = {
        priority                      => $priority,
        url                           => $url,
        url_status                    => {status => "queued"},
        screenshot_id                 => 1,  # Take screenshots.
        wait_id                       => 60, # Wait (at most) 60s between visits.
        end_early_if_load_complete_id => 1,  # Complete a visit early, if it looks like the application has loaded all content.
        reuse_browser_id              => 0,  # Reuse browser (don't start/stop the browser between URLs).
        always_fingerprint_id         => 0,  # Always record PCAP information for every URL (suspicious AND visited).
    };
    $priority--;
    push(@{$data->{'job'}->{'urls'}}, $entry);
}

my $job = HoneyClient::Message::Job->new($data->{'job'});

if ($verbose) {
    $LOG->info("Constructing job.");
    $Data::Dumper::Terse = 0;
    $Data::Dumper::Indent = 1;
    $LOG->info(Dumper($job->to_hashref));
}

HoneyClient::Util::EventEmitter->Job(action => 'create.job.urls.job_alerts', message => $job, priority => getVar(name => "default_priority", namespace => "HoneyClient::Util::EventEmitter"));

$LOG->info($job->urls_size() . " URL(s) Submitted.");
