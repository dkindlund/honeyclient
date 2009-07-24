#!/usr/bin/perl -Ilib
#######################################################################
# Created on:  Jul 20, 2009
# File:        extract_load_complete_image.pl
# Description: Script designed to extract a PNG image containing the 
#              browser's status bar, when the browser has fully rendered
#              all content on the screen.
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

extract_load_complete_image.pl - Perl script designed to extract a PNG image containing the 
browser's status bar, when the browser has fully rendered all content on the screen.

=head1 SYNOPSIS

 extract_load_complete_image.pl [options] --service_url='https://127.0.0.1/sdk/vimService' --user_name='root' --password='password' --driver_name='HoneyClient::Agent::Driver::Browser::IE' --vm_name='MasterVM' --guest_os_user_name='Administrator' --guest_os_password='password'

 Options:
 --help                This help message.
 --man                 Print full man page.
 --service_url=        URL to the VIM webservice on the VMware ESX Server.
 --user_name=          User name to authenticate to the VIM webservice.
 --password=           Password to authenticate to the VIM webservice.
 --driver_name=        Name of browser to drive.
 --vm_name=            The name of the VM to use.
 --guest_os_user_name= The user name to use when authenticating to the guest OS.
 --guest_os_password=  The password to use when authenticating to the guest OS.

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

=item B<--vm_name=>

Specifies the VM name to use. This option is required.

=item B<--guest_os_user_name=>

Specifies the user name used to authenticate to the 
guest OS in the VM.  This option is required.

=item B<--guest_os_password=>

Specifies the password used to authenticate to the 
guest OS in the VM.  This option is required.

=back

=head1 DESCRIPTION

This program checks if the specified VM is powered on with VMware Tools
running.  Then, it proceeds to load the browser specified in the
'driver_name' argument in maximized form.  Once the browser has completed
rendering a blank page, the script takes a screenshot of the browser's
status bar region as a PNG image and saves it to the location specified in
the <load_complete_image/> variable of the etc/honeyclient.xml file.

Note: This script assumes the specified VM is already powered on with the
specified guest OS user credentials already logged in.

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

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Include URL Parsing Library.
use URI::URL;

# Include VIX Libraries.
use VMware::Vix::Simple;
use VMware::Vix::API::Constants;

# We expect that the user will supply a single argument to this script.
# Namely, the initial set of URLs that they want the Agent to use.

# Inputs.
my $driver_name     = undef;
my $vm_name         = undef;
my $service_url     = undef;
my $user_name       = undef;
my $password        = undef;
my $guest_user_name = undef;
my $guest_password  = undef;

GetOptions('vm_name=s'            => \$vm_name,
           'driver_name:s'        => \$driver_name,
           'service_url=s'        => \$service_url,
           'user_name=s'          => \$user_name,
           'password=s'           => \$password,
           'guest_os_user_name=s' => \$guest_user_name,
           'guest_os_password=s'  => \$guest_password,
           'man'                  => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
           'version'              => sub {
                                        print "MITRE HoneyClient Project (http://www.honeyclient.org)\n" .
                                              "------------------------------------------------------\n" .
                                              $0  . " (v" . $VERSION . ")\n";
                                        exit(0);
                                     }) or pod2usage(2);

# Sanity checks.
if (!defined($vm_name)) {
    $LOG->error("'vm_name' not defined!");
    pod2usage(2);
    exit 0;
}
if (!defined($driver_name)) {
    $driver_name = getVar(name => "default_driver", namespace => "HoneyClient::Agent");
}
if (!defined($service_url)) {
    $LOG->error("'service_url' not defined!");
    pod2usage(2);
    exit 0;
} else {
    $service_url = URI::URL->new_abs("/sdk", URI::URL->new($service_url));
}
if (!defined($user_name)) {
    $LOG->error("'user_name' not defined!");
    pod2usage(2);
    exit 0;
}
if (!defined($password)) {
    $LOG->error("'password' not defined!");
    pod2usage(2);
    exit 0;
}
if (!defined($guest_user_name)) {
    $LOG->error("'guest_os_user_name' not defined!");
    pod2usage(2);
    exit 0;
}
if (!defined($guest_password)) {
    $LOG->error("'guest_os_password' not defined!");
    pod2usage(2);
    exit 0;
}

my $vix_result             = VIX_OK;
my $vix_host_handle        = VIX_INVALID_HANDLE;
my $vix_vm_handle          = VIX_INVALID_HANDLE;
my @vix_process_properties = ();
my $vix_image_size         = undef;
my $vix_image_bytes        = undef;
my @vix_vm_list            = undef;
my $vix_timeout            = 300;
my $vix_tempfile           = undef;

$LOG->info("Obtaining VIX host handle.");
($vix_result, $vix_host_handle) = HostConnect(VIX_API_VERSION,
                                  VIX_SERVICEPROVIDER_VMWARE_VI_SERVER,
                                  $service_url,
                                  $service_url->port,
                                  $user_name,
                                  $password,
                                  0,
                                  VIX_INVALID_HANDLE);

if ($vix_result != VIX_OK) {
    $LOG->error("VIX::HostConnect() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::HostConnect() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Finding running VMs.");
@vix_vm_list = FindRunningVMs($vix_host_handle, $vix_timeout);
$vix_result = shift(@vix_vm_list);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::FindRunningVMs() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::FindRunningVMs() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Searching running VMs.");
# Identify the first VM that matches the display name.
foreach my $vix_vm_config (@vix_vm_list) {

    ($vix_result, $vix_vm_handle) = VMOpen($vix_host_handle, $vix_vm_config);
    if ($vix_result != VIX_OK) {
        $LOG->error("VIX::VMOpen() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
        Carp::croak("VIX::VMOpen() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    }

    my $display_name = "";
    ($vix_result, $display_name) = VMReadVariable($vix_vm_handle,
                                                  VIX_VM_CONFIG_RUNTIME_ONLY,
                                                  "displayName",
                                                  0); # options
    if ($vix_result != VIX_OK) {
        $LOG->error("VIX::VMReadVariable() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
        Carp::croak("VIX::VMReadVariable() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    }

    if ($display_name eq $vm_name) {
        $LOG->info("Found VM (" . $display_name . ").");
        last;
    }

    ReleaseHandle($vix_vm_handle);
    $vix_vm_handle = undef;
}
if (!defined($vix_vm_handle)) {
    $LOG->error("VM (" . $vm_name . ") not found or not running.");
    Carp::croak("VM (" . $vm_name . ") not found or not running.");
}

$LOG->info("Waiting for VMware Tools.");
$vix_result = VMWaitForToolsInGuest($vix_vm_handle, $vix_timeout);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMWaitForToolsInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMWaitForToolsInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Logging into guest OS.");
$vix_result = VMLoginInGuest($vix_vm_handle, $guest_user_name, $guest_password, VIX_LOGIN_IN_GUEST_REQUIRE_INTERACTIVE_ENVIRONMENT);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMLoginInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMLoginInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Setting application to open in maximized mode.");
($vix_result, $vix_tempfile) = VMCreateTempFileInGuest($vix_vm_handle, 0, VIX_INVALID_HANDLE);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMCreateTempFileInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMCreateTempFileInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}
$vix_result = VMCopyFileFromHostToGuest($vix_vm_handle,
                                        getVar(name => "maximize_registry", namespace => $driver_name),
                                        $vix_tempfile,
                                        0,
                                        VIX_INVALID_HANDLE);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMCopyFileFromHostToGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMCopyFileFromHostToGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}
$vix_result = VMRunProgramInGuest($vix_vm_handle,
                                  'C:\WINDOWS\System32\cmd.exe',
                                  '/C reg import ' . $vix_tempfile,
                                  0,
                                  VIX_INVALID_HANDLE);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMRunProgramInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMRunProgramInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Driving the application.");
$vix_result = VMOpenUrlInGuest($vix_vm_handle, "http://localhost", 0, VIX_INVALID_HANDLE);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMOpenUrlInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMOpenUrlInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

# Wait for the browser to completely render.
sleep(10);

$LOG->info("Taking screenshot.");
($vix_result, $vix_image_size, $vix_image_bytes) = VMCaptureScreenImage($vix_vm_handle,
                                                                        VIX_CAPTURESCREENFORMAT_PNG,
                                                                        VIX_INVALID_HANDLE);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMCaptureScreenImage() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMCaptureScreenImage() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Listing processes in guest OS.");
($vix_result, @vix_process_properties) = VMListProcessesInGuest($vix_vm_handle, 0);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMListProcessesInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMListProcessesInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

foreach my $property (@vix_process_properties) {
    if ($property->{'PROCESS_NAME'} eq getVar(name => "process_name", namespace => $driver_name)) { 
        $LOG->info("Terminating application.");
        $vix_result = VMKillProcessInGuest($vix_vm_handle, $property->{'PROCESS_ID'}, 0);
        if ($vix_result != VIX_OK) {
            $LOG->error("VIX::VMKillProcessInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
            Carp::croak("VIX::VMKillProcessInGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
        }
    }
}

$LOG->info("Logging off guest OS.");
$vix_result = VMLogoutFromGuest($vix_vm_handle);
if ($vix_result != VIX_OK) {
    $LOG->error("VIX::VMLogoutFromGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
    Carp::croak("VIX::VMLogoutFromGuest() Failed (" . $vix_result . "): " . GetErrorText($vix_result) . ".\n");
}

$LOG->info("Releasing VIX handles.");
ReleaseHandle($vix_vm_handle);
HostDisconnect($vix_host_handle);

# Include Image Manipulation Libraries.
require Prima::noX11;
require Image::Match;


$LOG->info("Extracting load complete image.");
open(my $IMAGE_DATA, "<:scalar", \$vix_image_bytes) or
    Carp::croak("Unable to extract image contents. " . $!);
my $screenshot = Prima::Image->load($IMAGE_DATA);
my $status_bar = $screenshot->extract(
                    getVar(name => "load_complete_image", namespace => $driver_name, attribute => "x"),
                    getVar(name => "load_complete_image", namespace => $driver_name, attribute => "y"),
                    getVar(name => "load_complete_image", namespace => $driver_name, attribute => "width"),
                    getVar(name => "load_complete_image", namespace => $driver_name, attribute => "height"));

my $status_bar_filename = getVar(name => "load_complete_image", namespace => $driver_name);
$LOG->info("Saving load complete image to file (" . $status_bar_filename . ").");
$status_bar->save($status_bar_filename);
