#######################################################################
# Created on:  Jan 25, 2008
# Package:     HoneyClient::Manager::Database
# File:        Database.pm
# Description: XML-RPC client interface to access HoneyClient data within
#              the Hive web service.
#
# CVS: $Id: Database.pm 994 2007-11-08 20:30:12Z kindlund $
#
# @author mbriggs, kindlund
#
# Copyright (C) 2008 The MITRE Corporation.  All rights reserved.
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

HoneyClient::Manager::Database - Perl extension to provide an abstract
interface for storing/accessing HoneyClient within the Hive web service.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Database version 1.02.

=head1 SYNOPSIS

  # XXX: Need to fill this in.

=head1 DESCRIPTION

This library is an abstract interface to access and store HoneyClient
data within the Hive web service.

# XXX: Need further descriptions.

=cut

package HoneyClient::Manager::Database;

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
    # Note: Since this module is object-oriented, we do *NOT* export
    # any functions other than "new" to call statically.  Each function
    # for this module *must* be called as a method from a unique
    # object instance.
    @EXPORT = qw();

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Manager::Database ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    # Note: Since this module is object-oriented, we do *NOT* export
    # any functions other than "new" to call statically.  Each function
    # for this module *must* be called as a method from a unique
    # object instance.
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

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::Database') or diag("Can't load HoneyClient::Manager::Database package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Database');
use HoneyClient::Manager::Database;

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure we use the exception testing library.
require_ok('Test::Exception');
can_ok('Test::Exception', 'dies_ok');
use Test::Exception;

# Make sure YAML::XS loads.
BEGIN { use_ok('YAML::XS') or diag("Can't load YAML::XS package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('YAML::XS');
use YAML::XS;

# Make sure XML::RPC loads.
BEGIN { use_ok('XML::RPC') or diag("Can't load XML::RPC package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('XML::RPC');
use XML::RPC;

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure LWP::UserAgent loads.
BEGIN { use_ok('LWP::UserAgent') or diag("Can't load LWP::UserAgent package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('LWP::UserAgent');
use LWP::UserAgent;

# Make sure Data::Structure::Util loads.
BEGIN { use_ok('Data::Structure::Util', qw(unbless)) or diag("Can't load Data::Structure::Util package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Structure::Util');
can_ok('Data::Structure::Util', 'unbless');
use Data::Structure::Util;

=end testing

=cut

#######################################################################

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include Parsing Library
use YAML::XS;

# Include Communications Library
use XML::RPC;

# Include Dumper Library
use Data::Dumper;

# Include Utility Library
use Data::Structure::Util;

# Include Browser Library
use LWP::UserAgent;

# Package Global Variable
our $AUTOLOAD;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# XXX: Comment this.
sub _AUTOLOAD {
    my $name = $AUTOLOAD;
    $name =~  s/.*://;

    # Set a custom timeout.
    my $ua = LWP::UserAgent->new();
    $ua->timeout(getVar(name => "timeout"));
    $ua->env_proxy();

    my %options = (
        lwp_useragent => $ua,
    );

    # Perform the RPC call.
    my $xmlrpc = XML::RPC->new(getVar(name => "url"), %options);
    my $ret = undef;
   
    eval {
        $ret = $xmlrpc->call($name,@_);
    };

    # Error checking.
    if ($@ || !defined($ret)) {
        $LOG->error("Error: RPC communications failure.");
        Carp::croak("Error: RPC communications failure.");
    }

    # Error checking.
    if ((ref($ret) eq "HASH") && (exists($ret->{faultCode}))) {
        $LOG->error("Error: " . $ret->{faultString});
        Carp::croak("Error: " . $ret->{faultString});
    }

    return $ret;
}


#######################################################################
# Public Methods Implemented                                          #
#######################################################################

# XXX: Need to comment this further.
# Helper function designed to programmatically call the Hive web service,
# based upon arbitrary inputs given.
#
# For example, this call:
# my $output = HoneyClient::Manager::Database::foo($bar);
#
# ... will contact the Hive web service using the "foo" function name
# and supply the arguments, specified by $bar.
#
# Note: Errors generated by the web service call will be propagated back
# in the form of croaked exceptions.
# 
# Inputs: the hashtable or object to send 
# Outputs: the returned data from the web service
sub AUTOLOAD {
    my $obj = shift;
    my $obj_yaml = YAML::XS::Dump(Data::Structure::Util::unbless($obj));
    return _AUTOLOAD($obj_yaml);
}

# XXX: Need to comment this further.
sub get_queue_urls {
    $AUTOLOAD = "Database::get_queue_urls";
    # Results from this call are YAML-encoded; need to deserialize them.
    return YAML::XS::Load(_AUTOLOAD(@_));
}

# XXX: Need to comment this further.
sub get_broken_clients {
    $AUTOLOAD = "Database::get_broken_clients";
    my $obj = shift;
    my $obj_yaml = YAML::XS::Dump(Data::Structure::Util::unbless($obj));
    # Results from this call are YAML-encoded; need to deserialize them.
    return YAML::XS::Load(_AUTOLOAD($obj_yaml));
}

# XXX: Need to comment this further.
sub get_not_deleted_clients {
    $AUTOLOAD = "Database::get_not_deleted_clients";
    my $obj = shift;
    my $obj_yaml = YAML::XS::Dump(Data::Structure::Util::unbless($obj));
    # Results from this call are YAML-encoded; need to deserialize them.
    return YAML::XS::Load(_AUTOLOAD($obj_yaml));
}

#######################################################################

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 BUGS & ASSUMPTIONS

# XXX: Fill this in.

=head1 SEE ALSO

L<perltoot/"Autoloaded Data Methods">

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 AUTHORS

Matt Briggs, E<lt>mbriggs@mitre.orgE<gt>

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2008 The MITRE Corporation.  All rights reserved.

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
