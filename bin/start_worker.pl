#!/usr/bin/perl -Ilib
#######################################################################
# Created on:  Feb 01, 2009
# File:        start_worker.pl
# Description: Start up script for worker-based operations.
#
# CVS: $Id$
#
# @author kindlund
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

start_worker.pl - Perl script to start a Worker on the
host system.

=head1 SYNOPSIS

 start_worker.pl [options] --service_url='https://127.0.0.1/sdk/vimService' --user_name='root' --password='password'

 Options:
 --help               This help message.
 --man                Print full man page.
 --service_url=       URL to the VIM webservice on the VMware ESX Server.
 --user_name=         User name to authenticate to the VIM webservice.
 --password=          Password to authenticate to the VIM webservice.
 --driver_name=       Name of driver to use.
 --master_vm_name=    The name of the master VM to use.

=head1 OPTIONS

=over 4

=item B<--help>

Print a brief help message and exits.

=item B<--service_url=>

Specifies the URL of the VIM webservice running on the
VMware ESX Server.  This option is required.

=item B<--user_name=>

Specifies the user name used to authenticate to the VIM
webservice running on the VMware ESX Server.  This option
is required.

=item B<--password=>

Specifies the password used to authenticate to the VIM
webservice running on the VMware ESX Server.  This option
is required.

=item B<--driver_name=>

Specifies the driver name to use.  If none is specified, the
default will be used.

=item B<--master_vm_name=>

Specifies the master VM name to use.  If none
is specified, the default will be used.

=back

=head1 DESCRIPTION

This program starts a Worker on the host system.  If URLs
are specified on the command-line, the program will 
assign a base priority to each URL and feed them into the Manager
for additional processing.

This program will run until manually terminated by the user, by
pressing CTRL-C.

To submit URLs to this worker, use the bin/submit_job.pl
script.

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

# Include Pod Library
use Pod::Usage;

# Include Dumper Library
use Data::Dumper;

# Include Getopt Parser
use Getopt::Long qw(:config auto_help ignore_case_always);

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);

# Include Worker Library
use HoneyClient::Manager::Worker;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# We expect that the user will supply a single argument to this script.
# Namely, the initial set of URLs that they want the Agent to use.

# Inputs.
my $driver_name = undef;
my $master_vm_name = undef;
my $service_url;
my $user_name;
my $password;

GetOptions('driver_name:s'        => \$driver_name,
           'master_vm_name:s'     => \$master_vm_name,
           'service_url=s'        => \$service_url,
           'user_name=s'          => \$user_name,
           'password=s'           => \$password,
           'man'                  => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
           'version'              => sub {
                                        print "MITRE HoneyClient Project (http://www.honeyclient.org)\n" .
                                              "------------------------------------------------------\n" .
                                              $0  . " (v" . $VERSION . ")\n";
                                        exit(0);
                                     }) or pod2usage(2);

# Start the Worker.
HoneyClient::Manager::Worker->run(
    driver_name      => $driver_name,
    master_vm_name   => $master_vm_name,
    service_url      => $service_url,
    user_name        => $user_name,
    password         => $password,
);
