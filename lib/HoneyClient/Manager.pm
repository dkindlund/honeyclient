#######################################################################
# Created on:  May 11, 2006
# Package:     HoneyClient::Manager
# File:        Manager.pm
# Description: Central library used for manager-based operations.
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

=pod

=head1 NAME

HoneyClient::Manager - Perl extension to manage Agent VMs on the
host system.

=head1 VERSION

This documentation refers to HoneyClient::Manager version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager;

  # Start the Manager.
  HoneyClient::Manager->run();

=head1 DESCRIPTION

This module provides centralized control obtaining work from the Drone
webservice and routing that work to different Workers running on the
host system.

=cut

package HoneyClient::Manager;

use strict;
use warnings;
use Config;
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

    # This allows declaration use HoneyClient::Manager ':all';
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

# Make sure ExtUtils::MakeMaker loads.
BEGIN { use_ok('ExtUtils::MakeMaker', qw(prompt)) or diag("Can't load ExtUtils::MakeMaker package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('ExtUtils::MakeMaker');
can_ok('ExtUtils::MakeMaker', 'prompt');
use ExtUtils::MakeMaker qw(prompt);

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
BEGIN { use_ok('HoneyClient::Manager') or diag("Can't load HoneyClient::Manager package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager');
use HoneyClient::Manager;

# Make sure the Virtualization Library loads.
my $VM_MODE = getVar(name => "virtualization_mode", namespace => "HoneyClient::Manager") . "::Clone";
require_ok($VM_MODE);
eval "require $VM_MODE";

# Make sure HoneyClient::Manager::Firewall::Client loads.
BEGIN { use_ok('HoneyClient::Manager::Firewall::Client') or diag("Can't load HoneyClient::Manager::Firewall::Client package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall::Client');
use HoneyClient::Manager::Firewall::Client;

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure HoneyClient::Manager::Database loads.
BEGIN { use_ok('HoneyClient::Manager::Database') or diag("Can't load HoneyClient::Manager::Database package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Database');
use HoneyClient::Manager::Database;

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Sys::Hostname loads.
BEGIN { use_ok('Sys::Hostname') or diag("Can't load Sys::Hostname package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Sys::Hostname');
use Sys::Hostname;

# Make sure Sys::HostIP loads.
BEGIN { use_ok('Sys::HostIP') or diag("Can't load Sys::HostIP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Sys::HostIP');
use Sys::HostIP;

# Make sure Net::Stomp loads.
BEGIN { use_ok('Net::Stomp') or diag("Can't load Net::Stomp package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Net::Stomp');
use Net::Stomp;

# Make sure HoneyClient::Message loads.
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
BEGIN { use_ok('HoneyClient::Message') or diag("Can't load HoneyClient::Message package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Message');
use HoneyClient::Message;

# Make sure Data::UUID loads.
BEGIN { use_ok('Data::UUID') or diag("Can't load Data::UUID package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::UUID');
use Data::UUID;

# Make sure HoneyClient::Util::DateTime loads.
BEGIN { use_ok('HoneyClient::Util::DateTime') or diag("Can't load HoneyClient::Util::DateTime package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::DateTime');
use HoneyClient::Util::DateTime;

=end testing

=cut

#######################################################################

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);

# Include the VM Utility Libraries
my $VM_MODE = getVar(name => "virtualization_mode") . "::Clone";
eval "require $VM_MODE";

# Include Firewall Library
use HoneyClient::Manager::Firewall::Client;

# Include Database Libraries
use HoneyClient::Manager::Database;

# Use Hostname Libraries
use Sys::Hostname::Long;

# Use HostIP Libraries
use Sys::HostIP;

# Use Dumper Library
use Data::Dumper;

# Make Dumper format more verbose.
$Data::Dumper::Terse = 0;
$Data::Dumper::Indent = 2;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Include STOMP Client Library
use Net::Stomp;

# Include UUID Generator
use Data::UUID;

# Include Protobuf Libraries
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;

# Include DateTime Library
use HoneyClient::Util::DateTime;

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# TODO: Needed?
END {
}

# Helper function designed to "pop" a (key, value) pair off a given hashtable.
# When given a hashtable reference, this function will extract a valid (key, value)
# pair from the hashtable and delete the (key, value) pair from the
# hashtable.  The (key, value) pair with the highest score is returned.
#
# Inputs: hashref
# Outputs: valid (key, val) hashref or undef if the hash is empty
sub _pop {

    # Get supplied hash reference.
    my $hash = shift;

    # Get the highest score.
    my @array = sort {$$hash{$b} <=> $$hash{$a}} keys %{$hash};
    my $topkey = $array[0];

    if (defined($topkey)) {
        # Delete the key from the hashtable.
        # Return the (key, val) pair found.
        return { $topkey => delete($hash->{$topkey}) };
    } else {
        return undef;
    }
}

# Helper function designed to take in specified work
# and split up that work evenly amongst the specified
# number of clones by creating individual "buckets"
# for each clone, adding non-empty buckets to the
# work queue.
#
# Inputs: work_queue, wait_queue, work, num_simultaneous_clones
# Outputs: None.
sub _divide_work {

    # Extract arguments.
    my (%args) = @_;

    # Initalize buckets - 1 bucket per client.
    my $buckets = [ ];
    for (my $counter = 0; $counter < $args{'num_simultaneous_clones'}; $counter++) {
        $buckets->[$counter] = { };
    }

    # Divide up the work evenly across each bucket.
    while (scalar(%{$args{'work'}})) {
        for (my $counter = 0; $counter < $args{'num_simultaneous_clones'}; $counter++) {
            my $item = _pop($args{'work'});
            if (defined($item)) {
                $buckets->[$counter] = { %{$buckets->[$counter]}, %{$item} };
            } else {
                # We have no more work to place into any bucket,
                # so exit the loop.
                last;
            }
        }
    }

    # Place the contents of each bucket onto the work queue,
    # but ignore empty buckets.
    my $tid = undef;
    for (my $counter = 0; $counter < $args{'num_simultaneous_clones'}; $counter++) {
        if (scalar %{$buckets->[$counter]}) {

            # For each bucket inserted into the work queue, delete a corresponding
            # signal from the wait queue -- if there is a signal on the wait queue.
            if (defined($tid = $args{'wait_queue'}->dequeue_nb)) {
        
                # Sanity check: Make sure the thread is still alive.
                if (!defined(threads->object($tid))) {
                    $LOG->error("Thread ID (" . $tid . "): Unexpectedly terminated.");
                    Carp::croak "Thread ID (" . $tid . "): Unexpectedly terminated.";
                }

            }
            $args{'work_queue'}->enqueue(nfreeze($buckets->[$counter]));
        }
    }
}

# Helper function designed to get new URLs from the Drone
# database.  If it's the first attempt at obtaining URLs,
# then it will ask the Drone database for any existing,
# pre-assigned URLs.  Otherwise, it will ask the Drone
# database for new, unassigned URLs.
#
# Inputs: first_attempt
# Outputs: Hashref of (url => priority) pairs.
sub _get_urls {

    # Extract arguments.
    my (%args) = @_;

    # Returned argument.
    my $ret = { };

    # If this is the first attempt, then get any pre-assigned URLs.
    if ($args{'first_attempt'}) {
        $ret = HoneyClient::Manager::Database::get_queue_urls_by_hostname(Sys::Hostname::Long::hostname_long);
    } else {
        # XXX: Need to specify num_urls_to_process per worker thread.
        $ret = HoneyClient::Manager::Database::get_new_queue_urls(Sys::Hostname::Long::hostname_long, getVar(name => "num_urls_to_process"));
    }
    return $ret;
}

# Signal handler to help give user immediate feedback during
# shutdown process.
sub _shutdown {
    my $LOG = get_logger();
    $LOG->warn("Process ID (" . $$ . "): Received termination signal.  Shutting down manager (please wait).");
    exit;
};
$SIG{HUP}  = \&_shutdown;
$SIG{INT}  = \&_shutdown;
$SIG{QUIT} = \&_shutdown;
$SIG{ABRT} = \&_shutdown;
$SIG{TERM} = \&_shutdown;

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXPORTS

=head2 run(stomp_address => $stomp_address, stomp_port => $stomp_port, stomp_user_name => $stomp_user_name, stomp_password => $stomp_password, stomp_virtual_host => $stomp_virtual_host)

=over 4

Runs the Manager code, using the specified arguments.

I<Inputs>: 
 B<$stomp_address> is an optional argument, specifying the IP address
of the STOMP server this component should connect to.
 B<$stomp_port> is an optional argument, specifying the TCP port of the
STOMP server this component should connect to.
 B<$stomp_user_name> is an optional argument, specifying the user name
used to authenticate to the STOMP server.
 B<$stomp_password> is an optional argument, specifying the password
used to authenticate to the STOMP server.
 B<$stomp_virtual_host> is an optional argument, specifying the virtual
host used to authenticate to the STOMP server.

=back

=begin testing

SKIP: {
    skip "HoneyClient::Manager->run() can't be easily tested, yet.", 1;
}

=end testing

=cut

sub run {

    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;

    $LOG->info("Process ID (" . $$ . "): Starting manager.");

    # Sanity check.
    if (!getVar(name      => "enable",
                namespace => "HoneyClient::Manager::Database")) {
        $LOG->info("Process ID (" . $$ . "): Unable to run without database support. Shutting down manager.");
    }

    my $argsExist = scalar(%args);
    my $arg_names = [ 'stomp_address',
                      'stomp_port',
                      'stomp_user_name',
                      'stomp_password',
                      'stomp_virtual_host', ];

    # Parse optional arguments.
    foreach my $name (@{$arg_names}) {
        if (!($argsExist &&
            exists($args{$name}) &&
            defined($args{$name}))) {
            $args{$name} = getVar(name => $name);
        }
    }


    # Register the host system with the database.
    my $host = {
        org => getVar(name => "organization"),
        hostname => Sys::Hostname::Long::hostname_long,
        ip => Sys::HostIP->ip,
    };
    HoneyClient::Manager::Database::insert_host($host);

    # STOMP client handle.
    my $stomp = undef;
    my $frame = undef;

    # Variable to hold the URLs received from the database.
    my $queue_url_list = {};
    # Indicates this is the first time connecting to the database to obtain URLs.
    my $first_access_attempt = 1;

    eval {

        # Initialize the STOMP client handle.
        $stomp = Net::Stomp->new({
                     'hostname'  =>  $args{'stomp_address'},
                     'port'      =>  $args{'stomp_port'},
                 });

        # Connect to the STOMP server.
        $stomp->connect({
                    'login'         =>  $args{'stomp_user_name'},
                    'passcode'      =>  $args{'stomp_password'},
                    'virtual-host'  =>  $args{'stomp_virtual_host'},
        });

        # Create a new UUID generator.
        my $generator = Data::UUID->new();

# TODO: Delete this.
#my $COUNT = 0;

        # Get URLs from the database.
        while (1) {

            $LOG->info("Process ID (" . $$ . "): Waiting for new URLs from database.");

            while (!scalar(%{$queue_url_list})) {
                # XXX: Trap/ignore all errors and simply retry.
                eval {
                    $queue_url_list = _get_urls(first_attempt => $first_access_attempt);
                    $first_access_attempt = 0;
                };

                # If we're retrying, then sleep for a bit, before trying again to contact the database.
                if (!scalar(%{$queue_url_list})) {
                    sleep(getVar(name => "database_retry_delay"));
                }
            }
            $LOG->info("Process ID (" . $$ . "): Received new work and updating the workers.");

            # Collect the list of URLs.
            foreach my $url (keys(%{$queue_url_list})) {
                my $job_urls = [];
                my $entry = {
                    name   => $url,
                    status => HoneyClient::Message::Url::Status::NOT_VISITED,
                };
                push(@{$job_urls}, $entry);

                # Create a (relatively) unique job.
                my $job = HoneyClient::Message::Job->new({
                    uuid => $generator->create_str(),
                    created_at => HoneyClient::Util::DateTime->now(),
                    total_num_urls => scalar(@{$job_urls}),
                    url => $job_urls,
                });

                $LOG->info("Process ID (" . $$ . "): Constructing job.");
                # TODO: Delete this, eventually.
                $Data::Dumper::Terse = 0;
                $Data::Dumper::Indent = 1;
                print Dumper($job->to_hashref) . "\n";

                $stomp->send({
                    'exchange'        =>  getVar(name => 'exchange_name', namespace => 'HoneyClient::Manager::Worker'),
                    'delivery-mode'   =>  2, # Make sure the message is durable.
                    'destination'     =>  getVar(name => 'routing_key',   namespace => 'HoneyClient::Manager::Worker'),
	                'body'            =>  $job->pack(),
                });
                # TODO: Delete this.
#                $COUNT++;
#                if ($COUNT >= 20) {
#                    print "\n\nQUITTING!\n\n";
#sleep(10);
#                    return;
#                }
            }
            $queue_url_list = {};
print "Sleeping for 1s...\n";
sleep(1);
            # Loop forever, since we have a database connection.
        }
    };
    # Report when a fault occurs.
    if ($@) {
        $LOG->error("Process ID (" . $$ . "): Encountered an error. Shutting down manager. " . $@);
    }

    # Cleanup - Close STOMP connection.
    if (defined($stomp) &&
        (ref($stomp) eq "Net::Stomp")) {
        $stomp->disconnect();
    }
}

#######################################################################

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 BUGS & ASSUMPTIONS

Currently the documentation in the "EXPORTED FUNCTIONS" and
"EXPORTS" sections are both incomplete; these sections are still
a work-in-progress.

This module relies on various libraries, which may have their own
set of issues.  As such, see the following sections:

=over 4

=item *

L<HoneyClient::Manager::ESX::Clone/"BUGS & ASSUMPTIONS">

=back

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Paul Kulchenko for developing the SOAP::Lite module.

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
