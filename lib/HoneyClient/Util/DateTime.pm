#######################################################################
# Created on:  Jan 22, 2009
# Package:     HoneyClient::Util::DateTime
# File:        DateTime.pm
# Description: Standard library used to generate date/timestamps throughout
#              the codebase.
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

=pod

=head1 NAME

HoneyClient::Util::DateTime - Perl extension to provide a generic method
for generating consistent date/timestamps across the HoneyClient
codebase.

=head1 VERSION

This documentation refers to HoneyClient::Util::DateTime version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Util::DateTime;

  # Print the current time in ISO 8601 format.
  print HoneyClient::Util::DateTime->now() . "\n";

=head1 DESCRIPTION

This library allows any HoneyClient module to quickly generate
a consistent date/timestamp that is compatible with ISO 8601
format.

=cut

package HoneyClient::Util::DateTime;

use strict;
use warnings;
use Carp ();

#######################################################################
# Module Initialization                                               #
#######################################################################

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION);

    # Set our package version.
    $VERSION = 1.02;

    @ISA = qw(Exporter);

    # Symbols to export automatically
    @EXPORT = qw();

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Util::DateTime ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = (
        'all' => [ qw() ],
    );

    # Symbols to autoexport (when qw(:all) tag is used)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.
}
our (@EXPORT_OK, $VERSION);

=pod

=begin testing

# Make sure Log::Log4perl loads
BEGIN { use_ok('Log::Log4perl', qw(:nowarn))
        or diag("Can't load Log::Log4perl package. Check to make sure the package library is correctly listed within the path.");
       
        # Suppress all logging messages, since we need clean output for unit testing.
        Log::Log4perl->init({
            "log4perl.rootLogger"                               => "DEBUG, Buffer",
            "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
            "log4perl.appender.Buffer.min_level"                => "fatal",
            "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
            "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
        });
}
require_ok('Log::Log4perl');
use Log::Log4perl qw(:easy);

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar))
        or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path.");

        # Suppress all logging messages, since we need clean output for unit testing.
        Log::Log4perl->init({
            "log4perl.rootLogger"                               => "DEBUG, Buffer",
            "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
            "log4perl.appender.Buffer.min_level"                => "fatal",
            "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
            "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
        });
}
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Util::DateTime') 
        or diag("Can't load HoneyClient::Util::DateTime package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::DateTime');
use HoneyClient::Util::DateTime;

# Make sure DateTime::HiRes loads
BEGIN { use_ok('DateTime::HiRes')
        or diag("Can't load DateTime::HiRes package. Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure DateTime::Format::ISO8601 loads
BEGIN { use_ok('DateTime::Format::ISO8601')
        or diag("Can't load DateTime::Format::ISO8601 package. Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::Format::ISO8601');
use DateTime::Format::ISO8601;

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

=end testing

=cut

#######################################################################
# Path Variables                                                      #
#######################################################################

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include Data Dumper API
use Data::Dumper;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Make Dumper format more terse.
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

#######################################################################

# Include DateTime::HiRes Library
use DateTime::HiRes;

# Include ISO8601 Parsing Library
use DateTime::Format::ISO8601;

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXPORTS

=head2 now(time_zone => $time_zone)

=over 4

Returns the current system time in ISO 8601 format, using the specified
time zone or the time zone specified in the HoneyClient
etc/honeyclient.xml configuration file.

I<Input>:
 B<$time_zone> is an optional argument, specifying that the current time
formatted according to the time zone specified.

I<Output>: A string representing the current time in ISO 8601 format.

=back

=begin testing

my $timestamp = HoneyClient::Util::DateTime->now();
like($timestamp, qr/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d.\d\d\d\d\d\d\d\d{0,1}/, "now()") or diag("The now() call failed.");

=end testing

=cut

sub now {

    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'time_zone'}) ||
        !defined($args{'time_zone'})) {
        $args{'time_zone'} = getVar(name => "time_zone");
    }

    my $dt = DateTime::HiRes->now(%args);
    return $dt->ymd('-') . " " .
           $dt->hms(':') . "." .
           $dt->nanosecond() . " " .
           $dt->time_zone()->name();
}

=pod

=head2 epoch(time_zone => $time_zone, time_at => $time_at)

=over 4

Returns the current (or supplied) system time as a floating point number
representing the epoch, using the specified time zone or the time zone
specified in the HoneyClient etc/honeyclient.xml configuration file.

I<Input>:
 B<$time_zone> is an optional argument, specifying that the current time
formatted according to the time zone specified.
 B($time_at> is an optional argument, specifying the time to convert instead of
the current time.

I<Output>: A floating point number representing the current (or supplied)
time in epoch format.

=back

=begin testing

my $timestamp = HoneyClient::Util::DateTime->epoch();
like($timestamp, qr/\d*\.\d*/, "epoch()") or diag("The epoch() call failed.");

=end testing

=cut

sub epoch {

    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'time_zone'}) ||
        !defined($args{'time_zone'})) {
        $args{'time_zone'} = getVar(name => "time_zone");
    }

    my $dt = undef;
    if (scalar(%args) &&
        exists($args{'time_at'}) &&
        defined($args{'time_at'})) {
        $args{'time_at'} =~ s/ /T/;
        $dt = DateTime::Format::ISO8601->parse_datetime($args{'time_at'});
    } else {
        $dt = DateTime::HiRes->now(%args);
    }
    return $dt->hires_epoch();
}

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

XML::XPath

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
