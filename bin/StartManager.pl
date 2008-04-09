#!perl -Ilib
#######################################################################
# Created on:  Apr 08, 2008
# File:        StartManager.pl
# Description: Start up script for manager-based operations.
#
# CVS: $Id$
#
# @author knwang, kindlund
#
# Copyright (C) 2007-2008 The MITRE Corporation.  All rights reserved.
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

StartManager.pl - Perl script to start the Manager on the
host system.

=head1 SYNOPSIS

 StartManager.pl [options] [http://www.google.com http://www.cnn.com ...]

 Options:
 --help               This help message.
 --man                Print full man page.
 --driver_name=       Name of driver to use.
 --master_vm_config=  Absolute path to the master VM configuration to use.
 --url_list=          File containing newline separated URLs to use.

=head1 OPTIONS

=over 4

=item B<--help>

Print a brief help message and exits.

=item B<--driver_name=>

Specifies the driver name to use.  If none is specified, the
default will be used.

=item B<--master_vm_config=>

Specifies the master VM configuration file to use.  If none
is specified, the default will be used.

=item B<--url_list=>

If specified, the newline separated URLs inside this file will
be parsed and fed into the Manager upon startup.

=back

=head1 DESCRIPTION

This program starts the Manager on the host system.  If URLs
are specified on the command-line, the program will 
assign a base priority to each URL and feed them into the Manager
for additional processing.

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

Copyright (C) 2007-2008 The MITRE Corporation.  All rights reserved.

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

# Include Hash Serialization Utility Libraries
use Storable qw(nfreeze thaw);

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Include Getopt Parser
use Getopt::Long qw(:config auto_help ignore_case_always);

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);


# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# We expect that the user will supply a single argument to this script.
# Namely, the initial set of URLs that they want the Agent to use.

# Inputs.
my $driver_name = undef;
my $master_vm_config = undef;
my $url_list= "";

GetOptions('driver_name=s'        => \$driver_name,
           'master_vm_config=s'   => \$master_vm_config,
           'url_list=s'           => \$url_list,
           'man'                  => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
           'version'              => sub {
                                        print "MITRE HoneyClient Project (http://www.honeyclient.org)\n" .
                                              "------------------------------------------------------\n" .
                                              $0  . " (v" . $VERSION . ")\n";
                                        exit(0);
                                     }) or pod2usage(2);

# Go through the list of urls to create the array
# Anything not associated with an option is a URL
# Grab those first and then get the ones from the file specified
my @urls;
push( @urls, @ARGV ); 
if( -e $url_list ){
    open URL, $url_list;
    push(@urls, <URL>);
}

# Get the base priority.
my $priority = getVar(name      => "command_line_base_priority",
                      namespace => "HoneyClient::Manager");

# Create a hashtable in the form: url => priority.
my $work = {};
foreach(@urls){
    # We assign our initial list of URLs a priority of 1000, so that
    # they'll be (likely to be) selected first, before going to any other
    # external URLs found from subsequent drive operations.
    chomp;
    if ($_ ne "") {
        $work->{$_} = $priority;
    }
}

# Start the Manager.
require HoneyClient::Manager;
HoneyClient::Manager->run(
    driver_name      => $driver_name,
    master_vm_config => $master_vm_config,
    work             => $work,
);
