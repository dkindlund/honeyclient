#!/usr/bin/perl -w -Ilib
#######################################################################
# Created on:  Apr 08, 2008
# File:        cleanup.pl
# Description: Helper script, designed to clean up and delete
# unregistered clone VMs and snapshots, as well as clone VMs and
# snapshots that have been marked to be deleted on a given
# VMware ESX Server.
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

start_manager.pl - Perl script to cleanup clone VMs and snapshots on
VMware ESX Servers.

=head1 SYNOPSIS

 cleanup.pl [options] --service_url='https://127.0.0.1/sdk/vimService' --user_name='root' --password='password' --drone_url='http://127.0.0.1' --client_status='error'

 Options:
 --help               This help message.
 --man                Print full man page.
 --unknown            Cleanup unknown/unregistered snapshots/VMs (don't use while Workers are running).
 --force              Don't prompt for unknown snapshots/VMs; just delete.

 Required Arguments:
 --service_url=       URL to the VIM webservice on the VMware ESX Server.
 --user_name=         User name to authenticate to the VIM webservice.
 --password=          Password to authenticate to the VIM webservice.
 --drone_url=         URL to the Drone webservice.
 --client_status=     The client status type to delete.

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

=item B<--drone_url=>

Specifies the URL of the Drone webservice.
This option is required.

=item B<--client_status=>

Specifies that all VMs with the corresponding status type will
be deleted.  This option is required.

=item B<--unknown>

Cleanup unknown/unregistered snapshots/VMs.
WARNING: Do not use this option while Workers are running on the
VMware ESX Server; otherwise, the system will become unstable!

=item B<--force>

Don't prompt for unknown snapshots/VMs; just delete.

=back

=head1 DESCRIPTION

This program cleans up clone VMs and snapshots on the VMware ESX
Servers.

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

use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;
use HoneyClient::Util::Config qw(getVar);
use HoneyClient::Manager::ESX;
use HoneyClient::Util::EventEmitter;

use REST::Client;
use JSON::XS qw(encode_json decode_json);
use Pod::Usage;
use Getopt::Long qw(:config auto_help ignore_case_always);
use Data::Dumper;
use Log::Log4perl qw(:easy);
use ExtUtils::MakeMaker qw(prompt);

our $LOG = get_logger();

$Data::Dumper::Indent = 1;
$Data::Dumper::Terse  = 0;

my $UNKNOWN;
my $FORCE;
my $SERVICE_URL   = undef;
my $USER_NAME     = undef;
my $PASSWORD      = undef;
my $DRONE_URL     = undef;
my $CLIENT_STATUS = undef;
GetOptions('unknown'              => \$UNKNOWN,
           'force'                => \$FORCE,
           'service_url=s'        => \$SERVICE_URL,
           'drone_url=s'          => \$DRONE_URL,
           'user_name=s'          => \$USER_NAME,
           'password=s'           => \$PASSWORD,
           'client_status=s'      => \$CLIENT_STATUS,
           'man'                  => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
           'version'              => sub {
                                        print "MITRE HoneyClient Project (http://www.honeyclient.org)\n" .
                                              "------------------------------------------------------\n" .
                                              $0  . " (v" . $VERSION . ")\n";
                                        exit(0);
                                     }) or pod2usage(2);

# Sanity check.
if (!defined($SERVICE_URL) ||
    !defined($USER_NAME) ||
    !defined($PASSWORD) ||
    !defined($CLIENT_STATUS) ||
    !defined($DRONE_URL)) {
    pod2usage(2);
}

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# Given the valid parameters, this function will return an array
# containing the corresponding list of VMs that match the supplied params.
#
# Inputs:
#  - rest_client (required)
#  - status (optional)
#  - hostname (optional)
#  - quick_clone_name (optional)
#  - snapshot_name (optional)
sub _get_clients {

    # Extract arguments.
    my (%args) = @_;

    my $final_query = '';
    my $response = undef;

    if (exists($args{'status'}) &&
        defined($args{'status'})) {
        # Figure out the corresponding status ID.
        $args{'rest_client'}->GET('/client_statuses/list.json?status=' . $args{'status'});
        $response = decode_json($args{'rest_client'}->responseContent());

        # Sanity check.
        if (@{$response} <= 0) {
            return [];
        }
        my $client_status_id = shift(@{$response})->{'client_status'}->{'id'};

        if ($final_query eq '') {
            $final_query .= '?';
        } else {
            $final_query .= '&';
        }
        $final_query .= 'client_status_id=' . $client_status_id;
    }
    
    if (exists($args{'hostname'}) &&
        defined($args{'hostname'})) {
        # Figure out the corresponding host ID.
        $args{'rest_client'}->GET('/hosts/list.json?hostname=' . $args{'hostname'});
        $response = decode_json($args{'rest_client'}->responseContent());

        # Sanity check.
        if (@{$response} <= 0) {
            return [];
        }
        my $host_id = shift(@{$response})->{'host'}->{'id'};

        if ($final_query eq '') {
            $final_query .= '?';
        } else {
            $final_query .= '&';
        }
        $final_query .= 'host_id=' . $host_id;
    }

    if (exists($args{'quick_clone_name'}) &&
        defined($args{'quick_clone_name'})) {

        if ($final_query eq '') {
            $final_query .= '?';
        } else {
            $final_query .= '&';
        }
        $final_query .= 'quick_clone_name=' . $args{'quick_clone_name'};
    }

    if (exists($args{'snapshot_name'}) &&
        defined($args{'snapshot_name'})) {

        if ($final_query eq '') {
            $final_query .= '?';
        } else {
            $final_query .= '&';
        }
        $final_query .= 'snapshot_name=' . $args{'snapshot_name'};
    }

    $args{'rest_client'}->GET('/clients/list.json' . $final_query);
    $response = decode_json($args{'rest_client'}->responseContent());
    return $response;
}

#######################################################################

# Create a new REST client to access the Drone webserver.
my $rest_client = REST::Client->new({
    host => $DRONE_URL,
});

# Create a new session to interact with the ESX server.
my $session = HoneyClient::Manager::ESX->login(
                  service_url => $SERVICE_URL,
                  user_name   => $USER_NAME,
                  password    => $PASSWORD,
              );

# Get a list of all VMs marked as 'bug' in the database that
# pertain to this ESX server.
my $hostname = undef;
($session, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $session),
my $to_be_deleted_vm_list = _get_clients(rest_client => $rest_client, status => $CLIENT_STATUS, hostname => $hostname);

# Get all the VMs registered on the ESX server.
my $vm_list_arr = [];
($session, $vm_list_arr) = HoneyClient::Manager::ESX->getAllVM(session => $session);
my %vm_list_hash = map { $_ => 1 } @{$vm_list_arr};

# Snapshot Variables
my $snapshot_list_arr = [];
my %snapshot_list_hash = ();

# Go through the list of to be deleted VMs and delete the corresponding
# data.
foreach my $client (@{$to_be_deleted_vm_list}) {

    # Extract any snapshot name, if found.
    my $quick_clone_vm_name = $client->{'client'}->{'quick_clone_name'};
    my $snapshot_name       = $client->{'client'}->{'snapshot_name'};

    # Make sure the VM is present on the server.
    if (exists($vm_list_hash{$quick_clone_vm_name})) {

        if (defined($snapshot_name)) {
            # Check if the snapshot exists in the VM.
            ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);
            %snapshot_list_hash = map { $_ => 1 } @{$snapshot_list_arr};

            if (exists($snapshot_list_hash{$snapshot_name})) {
                $LOG->info("[" . $hostname . "] Removing snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ").");
                $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $quick_clone_vm_name, snapshot_name => $snapshot_name);
            } else {
                $LOG->warn("Snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ") does not exist on (" . $hostname . ").");
            }
        }

        # Refresh the list of snapshots with this VM.
        ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);

        # If there's zero or only one snapshot left, assume it's the 'defalt_quick_clone_snapshot_name'
        # and go ahead and destroy the clone VM.
        if (scalar(@{$snapshot_list_arr}) <= 1) {
            $LOG->info("[" . $hostname . "] Deleting VM (" . $quick_clone_vm_name . ").");
            $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
        }
    } else {
        $LOG->warn("VM (" . $quick_clone_vm_name . ") does not exist on (" . $hostname . ").");
    }

    $LOG->info("[" . $hostname . "] Marking client (" . $client->{'client'}->{'id'} . ") as deleted.");
    # Change client status to deleted.
    my $message = HoneyClient::Message::Client->new({
        quick_clone_name => $client->{'client'}->{'quick_clone_name'},
        snapshot_name    => $client->{'client'}->{'snapshot_name'},
        client_status    => {
            status       => "deleted",
        },
    });
    HoneyClient::Util::EventEmitter->Client(action => 'find_and_update.client_status', message => $message);
}

if (!$UNKNOWN) {
    # End the session.
    HoneyClient::Manager::ESX->logout(session => $session);
    exit(0);
}

# Figure out the corresponding status ID for 'deleted' status.
my $DELETED_STATUS_ID = 0;
$rest_client->GET('/client_statuses/list.json?status=deleted');
my $response = decode_json($rest_client->responseContent());

# Sanity check.
if (@{$response} > 0) {
    $DELETED_STATUS_ID = shift(@{$response})->{'client_status'}->{'id'};
}

# Refresh list of VMs registered on the ESX server. 
($session, $vm_list_arr) = HoneyClient::Manager::ESX->getAllVM(session => $session);

# Go through the list of registered VMs and see if there are any quick clones 
# and snapshots that are not referenced in the database.  If we find any, then
# prompt to have them deleted.
foreach my $quick_clone_vm_name (@{$vm_list_arr}) {

    # Only check VMs that appear to be quick clones...
    if (length($quick_clone_vm_name) == getVar(name => "vm_id_length", namespace => "HoneyClient::Manager::ESX")) {
        # Check if the VM has any snapshots.
        ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);

        # If the VM has no snapshots, then check the base VM to see if it's referenced in the database.
        if (scalar(@{$snapshot_list_arr}) <= 0) {
            if (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name)} <= 0) {
                # If the registered VM looks like a quick clone and has no references in the database,
                # Then prompt for deletion.
                $LOG->info("[" . $hostname . "] VM (" . $quick_clone_vm_name . ") appears to be a quick clone, but it is not referenced in the database.");
                my $question = 'yes';
                if (!$FORCE) {
                    $question = prompt("[" . $hostname . "] Do you want to delete VM (" . $quick_clone_vm_name . ")?", "yes");
                }
                if ($question =~ /^y.*/i) {
                    $LOG->info("[" . $hostname . "] Deleting VM (" . $quick_clone_vm_name . ").");
                    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
                }
            }
        } else {
            # The VM has snapshots, so iterate through all of them.
            foreach my $snapshot_name (@{$snapshot_list_arr}) {
                if ($snapshot_name ne getVar(name => "default_quick_clone_snapshot_name", namespace => "HoneyClient::Manager::ESX")) {
                    my $clients = _get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, snapshot_name => $snapshot_name);
                    if (@{$clients} <= 0) {
                        # If the registered VM's snapshot has no references in the database,
                        # Then prompt for deletion.
                        $LOG->info("[" . $hostname . "] VM (" . $quick_clone_vm_name . ") has snapshot (" . $snapshot_name . "), but it is not referenced in the database.");
                        my $question = 'yes';
                        if (!$FORCE) {
                            $question = prompt("[" . $hostname . "] Do you want to remove snapshot (" . $snapshot_name . ")?", "yes");
                        }
                        if ($question =~ /^y.*/i) {
                            $LOG->info("[" . $hostname . "] Removing snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ").");
                            $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $quick_clone_vm_name, snapshot_name => $snapshot_name);
                        }
                    } else {
                        # Cross-reference existing VMs with clients that are already marked as deleted. (Do not do this while Manager is operational.)
                        my $status_id = shift(@{$clients})->{'client'}->{'client_status_id'};
                        if ($status_id == $DELETED_STATUS_ID) {
                            $LOG->info("[" . $hostname . "] Removing snapshot (" . $snapshot_name . ") on VM (" . $quick_clone_vm_name . ").");
                            $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $quick_clone_vm_name, snapshot_name => $snapshot_name);
                        }
                    }
                }
            }

            # Once all the snapshots have been analyzed; go back and see if the VM has any remaining snapshots (aside from the initial snapshot).
            # If not, then figure out if the base VM is still referenced in the database; if not, then prompt for deletion.
            # Refresh the list of snapshots with this VM.
            ($session, $snapshot_list_arr) = HoneyClient::Manager::ESX->getAllSnapshotsVM(session => $session, name => $quick_clone_vm_name);

            # If there's zero or only one snapshot left, assume it's the 'defalt_quick_clone_snapshot_name'
            # and go ahead and destroy the clone VM.
            if ((scalar(@{$snapshot_list_arr}) <= 1) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'compromised')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'created')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'error')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'false_positive')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'suspicious')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'suspended')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'unknown')} <= 0) &&
                (@{_get_clients(rest_client => $rest_client, quick_clone_name => $quick_clone_vm_name, status => 'running')} <= 0)) {
                $LOG->info("[" . $hostname . "] VM (" . $quick_clone_vm_name . ") appears to be a quick clone, but it is not referenced in the database.");
                my $question = 'yes';
                if (!$FORCE) {
                    $question = prompt("[" . $hostname . "] Do you want to delete VM (" . $quick_clone_vm_name . ")?", "yes");
                }
                if ($question =~ /^y.*/i) {
                    $LOG->info("[" . $hostname . "] Deleting VM (" . $quick_clone_vm_name . ").");
                    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $quick_clone_vm_name);
                }
            }
        }
    }
}

# End the session.
HoneyClient::Manager::ESX->logout(session => $session);
