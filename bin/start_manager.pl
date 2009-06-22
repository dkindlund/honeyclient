#!perl -Ilib
#######################################################################
# Created on:  Apr 08, 2008
# File:        start_manager.pl
# Description: Start up script for manager-based operations.
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

start_manager.pl - Perl script to start the Manager on the
host system.

=head1 SYNOPSIS

 start_manager.pl [options] 

 Options:
 --help               This help message.
 --man                Print full man page.

=head1 OPTIONS

=over 4

=item B<--help>

Print a brief help message and exits.

=back

=head1 DESCRIPTION

This program starts the Manager on the host system.

This program will run until manually terminated by the user, by
pressing CTRL-C.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 AUTHORS

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

Kathy Wang, E<lt>knwang@mitre.orgE<gt>

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

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Include Manager Library
use HoneyClient::Manager;

GetOptions('man'                  => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
           'version'              => sub {
                                        print "MITRE HoneyClient Project (http://www.honeyclient.org)\n" .
                                              "------------------------------------------------------\n" .
                                              $0  . " (v" . $VERSION . ")\n";
                                        exit(0);
                                     }) or pod2usage(2);

# Start the Manager.
HoneyClient::Manager->run();
