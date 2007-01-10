###############################################################################
# Created on:  May 11, 2006
# Package:     HoneyClient::Agent::Driver::FF
# File:        FF.pm
# Description: A specific driver for automating an instance of
#              the Firefox browser, running inside a
#              HoneyClient VM.
#
# @author knwang, xkovah, kindlund, ttruong
#
# Copyright (C) 2006 The MITRE Corporation.  All rights reserved.
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
###############################################################################

package HoneyClient::Agent::Driver::FF;

# XXX: Disabled version check, Honeywall does not have Perl v5.8 installed.
#use 5.008006;
use strict;
use warnings;
use Config;
use Carp ();

# Traps signals, allowing END: blocks to perform cleanup.
use sigtrap qw(die untrapped normal-signals error-signals);

#######################################################################
# Module Initialization                                               #
#######################################################################

BEGIN {

	# Defines which functions can be called externally.
	require Exporter;
	our ( @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION );

	# Set our package version.
	$VERSION = 0.9;

	# Define inherited modules.
	use HoneyClient::Agent::Driver::Browser;

	@ISA = qw(Exporter HoneyClient::Agent::Driver::Browser);

	# Symbols to export on request
	# Note: Since this module is object-oriented, we do *NOT* export
	# any functions other than "new" to call statically.  Each function
	# for this module *must* be called as a method from a unique
	# object instance.
	@EXPORT = qw();

	# Items to export into callers namespace by default. Note: do not export
	# names by default without a very good reason. Use EXPORT_OK instead.
	# Do not simply export all your public functions/methods/constants.

	# This allows declaration use HoneyClient::Agent::Driver::Browser::IE ':all';
	# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
	# will save memory.

	# Note: Since this module is object-oriented, we do *NOT* export
	# any functions other than "new" to call statically.  Each function
	# for this module *must* be called as a method from a unique
	# object instance.
	%EXPORT_TAGS = ( 'all' => [qw()], );

	# Symbols to autoexport (:DEFAULT tag)
	@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

# XXX: Fix this!
# Check to make sure our OS is Windows-based.
#if ($Config{osname} !~ /^MSWin32$/) {
#    Carp::croak "Error: " . __PACKAGE__ . " will only run on Win32 platforms!\n";
#}

	$SIG{PIPE} = 'IGNORE';    # Do not exit on broken pipes.
}
our ( @EXPORT_OK, $VERSION );

#TODO: Rewrite the test module

=pod

=begin testing

=end testing

=cut

#######################################################################

#TODO: Remove any of these use statements that aren't needed

# Include the Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Use ISO 8601 DateTime Libraries
use DateTime::HiRes;

# Use fractional second sleeping.
# TODO: Need unit testing.
use Time::HiRes qw(sleep);

# Use Storable Library
use Storable qw(dclone);

# Use threads Library
# TODO: Need unit testing.
use threads;

# TODO: Need unit testing.
use threads::shared;

# TODO: Need unit testing.
use HoneyClient::Util::SOAP qw(getClientHandle);

# TODO: Need unit testing.
use Win32::Job;

# TODO: clean this up.
#my %PARAMS = (
#);

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

#sub new {
#	
#    # - This function takes in an optional hashtable,
#    #   that contains various key => 'value' configuration
#    #   parameters.
#    #
#    # - For each parameter given, it overwrites any corresponding
#    #   parameters specified within the default hashtable, %PARAMS,
#    #   with custom entries that were given as parameters.
#    #
#    # - Finally, it returns a blessed instance of the
#    #   merged hashtable, as an 'object'.
#
#    # Get the class name.
#    my $self = shift;
#
#    # Get the rest of the arguments, as a hashtable.
#    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
#    # hash references directly.  Thus, flat hashtables are used throughout the code
#    # for consistency.
#    my %args = @_;
#
#    # Check to see if the class name is inherited or defined.
#    my $class = ref($self) || $self;
#
#    # Initialize default parameters.
#    my %params = %{dclone(\%PARAMS)};
#    $self = $class->SUPER::new();
#    @{$self}{keys %params} = values %params;
#
#    # Now, overwrite any default parameters that were redefined
#    # in the supplied arguments.
#    @{$self}{keys %args} = values %args;
#
#    # Now, assign our object the appropriate namespace.
#    bless $self, $class;
#
#    # Finally, return the blessed object.
#    return $self;
#}

sub drive {

    # Extract arguments.
	my ($self, %args) = @_;

    # Sanity check: Make sure we've been fed an object.
    unless (ref($self)) {
        Carp::croak "Error: Function must be called in reference to a " .
                    __PACKAGE__ . "->new() object!\n";
    }

    # Sanity check, don't get the next link, if
    # we've been fed a url.
    my $argsExist = scalar(%args);
    if (!$argsExist ||
        !exists($args{'url'}) ||
        !defined($args{'url'})) {
        # Get the next URL from our hashtables.
        $args{'url'} = $self->_getNextLink();
    }

	# Drive the generic browser before opening with IE
	$self = $self->SUPER::drive(%args);

    # Sanity check: Make sure our next URL is defined.
    unless (defined($args{'url'})) {
        Carp::croak "Error: Unable to drive browser - 'links_to_visit' " .
                    "hashtable is empty!\n";
    }

    # Indicates how long we wait for each drive operation to complete,
    # before registering attempt as a failure.
    my $timeout : shared = $self->timeout();

    # Create a new Job.
    my $job = Win32::Job->new();

    # Sanity check.
    if (!defined($job)) {
        Carp::croak "Error: Unable to spawn new job - " . $^E . ".\n";
    }

    # Spawn the job.
    $job->spawn(undef, "\"C:\\Program Files\\Mozilla Firefox\\firefox.exe\"" . $args{'url'});

    # TODO: check to see if spawn fails.

    # Run the job.
    $job->run($timeout);

    # TODO: check to see if run fails.

    # Return the modified object state.
    return $self;
}

#######################################################################

1;