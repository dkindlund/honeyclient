#######################################################################
# Created on:  Jul 1, 2008
# Package:     HoneyClient::Manager::ESX
# File:        ESX.pm
# Description: A module that provides programmatic access to VMware
#              ESX Server virtual machines.
#
# CVS: $Id$
#
# @author jpuchalski, kindlund
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

HoneyClient::Manager::ESX - Perl extension to provide programmatic
access to all VM clients within the locally running VMware ESX server.

=head1 VERSION

This documentation refers to HoneyClient::Manager::ESX version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::ESX;

  # Create a new session to interact with the ESX server.
  my $session = HoneyClient::Manager::ESX->login();

  # Assume we have a particular VM registered on
  # the ESX server.  We assume each VM has a UNIQUE name.
  my $testVM = "Test VM";

  # See if a particular VM is registered.
  my $result = undef;
  ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
  if ($result) {
      print "Yes, the VM is registered.";
  } else {
      print "No, the VM is not registered.";
  }

  # Register a particular VM.
  my $config = "[datastore] Test_VM/Test_VM.vmx";
  $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }

  # Unregister a particular VM.
  ($session, $result) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
  if ($result) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }

  # Get the state of a particular VM.
  my $state = undef;
  ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);
  print "VM State: " . $state . "\n";

  # Start a particular VM.
  $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }
  
  # Stop a particular VM.
  $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }
  
  # Reboot a particular VM.
  $session = HoneyClient::Manager::ESX->resetVM(session => $session, name => $testVM);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }
  
  # Suspend a particular VM.
  $session = HoneyClient::Manager::ESX->suspendVM(session => $session, name => $testVM);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }

  # After starting a particular VM, if the VM's
  # state is STUCK, we can try automatically answering
  # any pending questions that the VMware ESX Server
  # is waiting for.
  #
  # Note: In most cases, this call doesn't need to
  # be made, since startVM/stopVM/resetVM will try this call
  # automatically, if needed.
  $session = HoneyClient::Manager::ESX->answerVM(session => $session, name => $testVM);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }

  # Create a new full clone from a particular VM 
  # and put the clone in the "Clone_VM" directory.
  my $cloneVM = "Clone_VM";
  my $cloneConfig = undef;
  ($session, $cloneConfig) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM, dst_name => $cloneVM);
  if ($cloneConfig) {
      print "Successfully created clone VM at ($cloneConfig)!\n";
  } else {
      print "Failed to create clone!\n";
  }
  
  # Create a new quick clone from a particular VM
  # and put the clone in the "Clone_VM" directory.
  my $cloneVM = "Clone_VM";
  my $cloneConfig = undef;
  ($session, $cloneConfig) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM, dst_name => $cloneVM);
  if ($cloneConfig) {
      print "Successfully created clone VM at ($cloneConfig)!\n";
  } else {
      print "Failed to create clone!\n";
  }

  # Check to see if a particular VM is a quick clone.
  my $result = undef;
  ($session, $result) = HoneyClient::Manager::ESX->isQuickCloneVM(session => $session, name => $testVM);
  if ($result) {
      print "VM is a quick clone.\n";
  } else {
      print "VM is NOT a quick clone.\n";
  }
  
  # Check to see how much free space (in bytes) is left on the VM's backing datastore.
  my $space_free = undef;
  ($session, $space_free) = HoneyClient::Manager::ESX->getDatastoreSpaceAvailableESX(session => $session, name => $testVM);
  print "VM's datastore free space is: " . $space_free . ".\n";
  
  # Get the hostname of the ESX server.
  my $hostname = undef;
  ($session, $hostname) = HoneyClient::Manager::ESX->getHostnameESX(session => $session);
  print "ESX hostname is: " . $hostname . ".\n";
  
  # Get the IP of the ESX server.
  my $ip = undef;
  ($session, $ip) = HoneyClient::Manager::ESX->getIPaddrESX(session => $session);
  print "ESX IP is: " . $ip . ".\n";
  
  # Get the MAC address of a particular VM's first NIC.
  my $mac_address = undef;
  ($session, $mac_address) = HoneyClient::Manager::ESX->getMACaddrVM(session => $session, name => $testVM);
  if ($mac_address) {
      print "VM MAC Address: \"$mac_address\"\n";
  } else {
      print "Failed to get VM MAC address!\n";
  }
  
  # Get the IP address of a particular VM's first NIC.
  my $ip_address = undef;
  ($session, $ip_address) = HoneyClient::Manager::ESX->getIPaddrVM(session => $session, name => $testVM);
  if ($ip_address) {
      print "VM IP Address: \"$ip_address\"\n";
  } else {
      print "Failed to get VM IP address!\n";
  }

  # Get the configuration filename of a particular VM.
  my $config = undef;
  ($session, $config) = HoneyClient::Manager::ESX->getConfigVM(session => $session, name => $testVM);
  if ($config) {
      print "VM Config: \"$config\"\n";
  } else {
      print "Failed to get VM config!\n";
  }

  # Destroy a particular VM.
  $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $testVM);
  if ($session) {
      print "Success!\n";
  } else {
      print "Failed!\n";
  }

  # Save a snapshot of a particular VM, saving the
  # snapshot using the name of "Snapshot".
  ($session, $result) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $testVM, snapshot_name => "Snapshot");
  if ($result) {
      print "Successfully snapshotted VM using snapshot name: ($result)!\n";
  } else {
      print "Failed to snapshot VM!\n";
  }

  # Revert a particular VM back to a previous snapshot.
  $session = HoneyClient::Manager::ESX->revertVM(session => $session, name => $testVM, snapshot_name => "Snapshot");
  if ($session) {
      print "Successfully reverted VM!\n";
  } else {
      print "Failed to revert VM!\n";
  }

  # Rename "Snapshot" to "Snapshot2" on a particular VM.
  ($session, $result) = HoneyClient::Manager::ESX->renameSnapshotVM(session => $session, name => $testVM, old_snapshot_name => "Snapshot", new_snapshot_name => "Snapshot2");
  if ($result) {
      print "Successfully renamed snapshot on VM to: ($result)!\n";
  } else {
      print "Failed to rename snapshot on VM!\n";
  }
  
  # Remove "Snapshot2" on a particular VM.
  $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $testVM, snapshot_name => "Snapshot2");
  if ($session) {
      print "Successfully removed snapshot on VM!\n";
  } else {
      print "Failed to removed snapshot on VM!\n";
  }

  # End the session.
  HoneyClient::Manager::ESX->logout(session => $session);

=head1 DESCRIPTION

This library provides static calls to control a remote VMware ESX
server remotely via web services (SOAP).  Each call reuses existing 
sessions with the VMware ESX server (in order to remain thread-safe)
and provides direct manipulation of VMs running on this VMware ESX
server.

=cut

package HoneyClient::Manager::ESX;

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

    # This allows declaration use HoneyClient::Manager::ESX ':all';
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

# Generate a notice, to clarify our assumptions.
diag("About to run basic unit tests.");

my $question = prompt("# Do you want to run basic tests?", "yes");
if ($question !~ /^y.*/i) { exit; }

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
BEGIN { use_ok('HoneyClient::Manager::ESX') or diag("Can't load HoneyClient::Manager::ESX package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::ESX');
use HoneyClient::Manager::ESX;

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname basename)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
can_ok('File::Basename', 'basename');
use File::Basename qw(dirname basename);

# Make sure Digest::MD5 loads.
BEGIN { use_ok('Digest::MD5', qw(md5_hex)) or diag("Can't load Digest::MD5 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Digest::MD5');
can_ok('Digest::MD5', 'md5_hex');
use Digest::MD5 qw(md5_hex);

# Make sure DateTime::HiRes loads.
BEGIN { use_ok('DateTime::HiRes') or diag("Can't load DateTime::HiRes package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure DateTime::Duration loads.
BEGIN { use_ok('DateTime::Duration') or diag("Can't load DateTime::Duration package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::Duration');
use DateTime::Duration;

# Make sure VMware::VIRuntime loads.
BEGIN { use_ok('VMware::VIRuntime') or diag("Can't load VMware::VIRuntime package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('VMware::VIRuntime');
use VMware::VIRuntime;

diag("About to run extended tests.");
diag("Warning: These tests will take significant time to complete (10-20 minutes).");
diag("");
diag("Note: These tests expect VMware ESX Server to be accessible at the following location,");
diag("using the following credentials:");
diag("   service_url: " . getVar(name => "service_url", namespace => "HoneyClient::Manager::ESX"));
diag("   username:    " . getVar(name => "user_name", namespace => "HoneyClient::Manager::ESX"));
diag("   password:    " . getVar(name => "password", namespace => "HoneyClient::Manager::ESX"));
diag("");
diag("Also, these tests expect the following test VM to be registered and powered off on the VMware ESX");
diag("Server:");
diag("   test_vm_name: " . getVar(name => "test_vm_name", namespace => "HoneyClient::Manager::ESX::Test"));
diag("");

# TODO: Provide a URL where users can download, extract, and install the Test_VM.

$question = prompt("# Do you want to run extended tests?", "no");
if ($question !~ /^y.*/i) { exit; }

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

# Include File/Directory Manipulation Libraries
use File::Basename qw(dirname basename);

# Include the VMware APIs
use VMware::VIRuntime;

# Include MD5 Libraries
use Digest::MD5 qw(md5_hex);

# Include ISO8601 Date/Time Libraries
use DateTime::HiRes;
use DateTime::Duration;

# The maximum length of any VMID generated.
our $VM_ID_LENGTH = getVar(name => "vm_id_length");

#######################################################################
# Private Functions                                                   #
#######################################################################

# Helper function, designed to generate a new unique VM ID that persists
# across snapshot operations and any other VM migrations.
#
# Note: This code was taken from the Apache::SessionX::Generate::MD5
# package.  It was replicated here, to avoid unwanted dependencies.
#
# The resultant VMID is a hexadecimal string of length $VM_ID_LENGTH
# (where this length is between 1 and 32, inclusive).  These VMIDs
# are supposed to be unique, so it is recommended that $VM_ID_LENGTH
# be as large as possible.
#
# The VMIDs are generated using a two-round MD5 of a random number,
# the time since the epoch, the process ID, and the address of an
# anonymous hash.  The resultant VMID string is highly entropic on
# Linux and other platforms that have good random number generators.
#
# Input:  None
# Output: vmID
sub _generateVMID {
    return (substr(md5_hex(md5_hex(time(), {}, rand(), $$)), 0, $VM_ID_LENGTH));
}

# Helper function that handles retrieval of any view object from the
# VMware ESX server.  This function assumes that a connection to the ESX
# web service already exists.
#
# Inputs:
#     session - the VIM session object (required)
#     name    - name of the view object (required if type is 'VirtualMachine')
#     type    - type of the view object (required)
# Output: (the session object, the view object)
sub _getViewObject {

    # Extract arguments.
    my (%args) = @_;
    
    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'session'}) ||
        !defined($args{'session'})) {
        $LOG->fatal("Unable to retrieve view - no session specified.");
        Carp::croak "Unable to retrieve view - no session specified.";
    }
    
    if (!exists($args{'type'}) ||
        !defined($args{'type'})) {
        $LOG->fatal("Unable to retrieve view - no type specified.");
        Carp::croak "Unable to retrieve view - no type specified.";
    }
   
    # Validate current session, if older than the given threshold.
    if ((DateTime::HiRes->now() - DateTime::Duration->new(seconds => getVar(name => "session_timeout"))) > $args{'session'}->{'_updated_at'}) {
        if (!_isSessionValid(%args)) {
            # Relogin, if session is invalid.
            $args{'session'} = login();
        } else {
            # Session remains valid; update timestamp.
            $args{'session'}->{'_updated_at'} = DateTime::HiRes->now();
        }
    }
 
    my $view;

    # Retrieve the view object after doing any necessary checks.
    if ($args{'type'} eq 'VirtualMachine') {

        # Sanity check.
        # A 'name' argument is required if the type is 'VirtualMachine'
        if (!exists($args{'name'}) || !defined($args{'name'})) {
            $LOG->fatal("Unable to retrieve view - no name specified.");
            Carp::croak "Unable to retrieve view - no name specified.";
        }
        
        $view = $args{'session'}->find_entity_view(view_type => $args{'type'}, filter => {'name' => $args{'name'}});
    } else {
        $view = $args{'session'}->find_entity_view(view_type => $args{'type'});
    }

    return ($args{'session'}, $view);
}

# Helper function that handles retrieval of a VM view object from the
# VMware ESX server.  This function assumes that a connection to the ESX
# web service already exists.  If the VM view object is not found, then
# the function will croak.
#
# Inputs:
#     session - the VIM session object (required)
#     name    - name of the view object (required)
# Output: (the session object, the view object) if found; croaks otherwise.
sub _getViewVM {

    # Extract arguments.
    my (%args) = @_;

    # Get the VM object.
    $args{'type'} = "VirtualMachine";
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewObject(%args);
    if (!defined($vm_view)) {
        $LOG->error("Unable to locate VM (" . $args{'name'} . ").");
        Carp::croak "Unable to locate VM (" . $args{'name'} . ").";
    }
    return ($args{'session'}, $vm_view);
}

# Helper function that returns a list of all VirtualMachineSnapshotTree views
# across all VirtualMachine objects registered on the system.
#
# Inputs:
#     session - the VIM session object (required)
# Output: an array reference of VirtualMachineSnapshotTree objects
sub _getViewVMSnapshotTrees {
    # Extract arguments.
    my (%args) = @_;

    # Get all the VM snapshot info objects.
    my $snapshot_views = [ ];
    my $vm_views = $args{'session'}->find_entity_views(view_type => "VirtualMachine");
    foreach my $view (@{$vm_views}) {
        if (defined($view->snapshot) &&
            defined($view->snapshot->rootSnapshotList)) {
            push(@{$snapshot_views}, @{$view->snapshot->rootSnapshotList});
        }
    }

    return $snapshot_views;
}

# Helper function that finds a snapshot by name in the snapshot tree
# by performing a depth-first search.  Each snapshot list passed in
# contains one or more snapshot trees, where each snapshot tree has
# a single snapshot as its root and a snapshot list of its children,
# where each child is also a snapshot tree with the child as the root.
#
# Inputs:
#   snapshot_name - the name of the snapshot to find
#   snapshot_list - the initial list in which to search
#
# Output: the first matching snapshot if found, else undef
sub _findSnapshot {
    my ($snapshot_name, $snapshot_list) = @_;
    my $found_snapshot = undef;   
 
    foreach my $snapshot_tree (@{$snapshot_list}) {
        # Check if this child matches.
        if ($snapshot_tree->name eq $snapshot_name) {
            $found_snapshot = $snapshot_tree;
            last;
        # Check the child's children.
        } elsif (defined($snapshot_tree->childSnapshotList) &&
                 (scalar(@{$snapshot_tree->childSnapshotList}) > 0)) {
            $found_snapshot = _findSnapshot($snapshot_name, $snapshot_tree->childSnapshotList);
            if (defined($found_snapshot)) {
                last;
            }
        }
    }
    return $found_snapshot;
}

# Helper function that copies the full contents of the specified source VM
# to a destination directory.
# Note: This function assumes that the source VM is registered
# and powered off or suspended.  Lastly, this function assumes that the
# destination directory name does not currently exist.
# 
# Inputs:
#   session  - the VIM session object
#   src_name - the name of the source VM
#   dst_name - the name of the destination VM
# Output: the full path to the destination VM's .vmx file
#
# Notes:
# - If the source VM virtual disks have any snapshots, then
# the corresponding destination VM virtual disks will have
# the same contents as the current snapshot -- but all other
# snapshot data will not be copied to the destination VM.
sub _fullCopyVM {
    # Extract arguments.
    my (%args) = @_;
    
    $args{'name'} = $args{'src_name'};
   
    # Get the service content.
    my $service_content = $args{'session'}->get_service_content();

    # Get the file and virtual disk managers.
    my $file_mgr = $args{'session'}->get_view(mo_ref => $service_content->fileManager);
    my $vdisk_mgr = $args{'session'}->get_view(mo_ref => $service_content->virtualDiskManager);
    
    # Get the datacenter view object.
    $args{'type'} = "Datacenter";
    my $datacenter_view = undef;
    ($args{'session'}, $datacenter_view) = _getViewObject(%args);
    
    # Get a view object for the source VM.
    $args{'type'} = "VirtualMachine";
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewObject(%args);
    
    # Get the name of the datastore that holds the source VM
    # XXX: We assume the source VM is located on only one datastore.
    my $datastore_view = $args{'session'}->get_view(mo_ref => $vm_view->datastore->[0]);
    my $datastore_name = $datastore_view->info->name;

    # Make the destination VM directory.
    eval {
        $file_mgr->MakeDirectory(
            name => "[" . $datastore_name . "] " . $args{'dst_name'},
            datacenter => $datacenter_view
        );
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
        Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
    }

    # --- Iterate through each virtual disk associated with the source VM and copy it. ---
    # Get the name of the adapter type for the source VM.  In order
    # to do this, we first need to get the disk device for the VM,
    # access its parent controller, and massage the name of that
    # controller into a valid format for the virtual disk spec
    # adapter type.
    my $source_vmdk = undef;
    my $controller_key = undef;;
    foreach my $dev (@{$vm_view->config->hardware->device}) {
        if (ref($dev) eq 'VirtualDisk') {
            # Get the controller key.
            $controller_key = $dev->controllerKey;
            
            # Make sure the disk type is something we can copy; otherwise, croak.
            my $vdisk_format = ref($dev->backing);

            if (($vdisk_format ne 'VirtualDiskFlatVer1BackingInfo') && 
                ($vdisk_format ne 'VirtualDiskFlatVer2BackingInfo')) {

                $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Unsupported virtual disk format - " . $vdisk_format);
                Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Unsupported virtual disk format - " . $vdisk_format;
            }

            # Identify the backing VMDK filename for this virtual disk.
            my $source_vmdk = $dev->backing->fileName;

            # Construct the destination VMDK filename for this virtual disk.
            my $dest_vmdk = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . basename($source_vmdk);
 
            # Figure out the SCSI adapter associated with this virtual disk.
            my $adapter_type = undef;
            foreach my $dev (@{$vm_view->config->hardware->device}) {
                if ($dev->key == $controller_key) {
                    $adapter_type = $dev->deviceInfo->summary;
                    # Remove all spaces.
                    $adapter_type =~ s/\s//g;
                    # Convert the first 3 chars to lowercase.
                    $adapter_type =~ /([A-Za-z]{3})(.*)/;
                    $adapter_type = lc($1) . $2;
                    last;
                }
            }

            # Now that we know the adapter type,
            # create a virtual disk spec using the retrieved adapter type.
            my $vdisk_spec = VirtualDiskSpec->new();
            $vdisk_spec->diskType("");
            $vdisk_spec->adapterType($adapter_type);

            # Now, copy the virtual disk.
            eval {
                $vdisk_mgr->waitForTask($vdisk_mgr->CopyVirtualDisk_Task(
                    sourceName => $source_vmdk,
                    sourceDatacenter => $datacenter_view,
                    destName => $dest_vmdk,
                    destDatacenter => $datacenter_view,
                    destSpec => $vdisk_spec,
                ));
            };
            if ($@) {
                my $detail = $@;
                if (ref($detail) eq 'SoapFault') {
                    $detail = $detail->fault_string;
                }
                $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
                Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
            }
        }
    }
    
    # --- Copy the other files associated with the source VM. ---
    # Get the nvram/vmss files associated with the source VM and construct
    # the nvram/vmss files associated with the destination VM.
    my $source_nvram = undef;
    my $dest_nvram = undef;
    my $source_vmss = undef;
    my $dest_vmss = undef;
    foreach my $entry (@{$vm_view->config->extraConfig}) {
        if (($entry->key eq 'nvram') &&
            ($entry->value ne '')) {
            $source_nvram = dirname($vm_view->config->files->vmPathName) . "/" . $entry->value;
            $dest_nvram = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . $entry->value;
        }
        if (($entry->key eq 'checkpoint.vmState') &&
            ($entry->value ne '')) {
            $source_vmss = $vm_view->config->files->suspendDirectory . "/" . $entry->value;
            $dest_vmss = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . $entry->value;
        }
        if (defined($source_nvram) &&
            defined($dest_nvram) &&
            defined($source_vmss) &&
            defined($dest_vmss)) {
            last;
        }
    }

    # Get the source configuration filename.
    my $source_vmx = $vm_view->config->files->vmPathName;
    # Construct the destination configuration filename for this VM.
    my $dest_vmx = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . basename($source_vmx);

    eval {
        # Copy the nvram file (if applicable).
        if (defined($source_nvram) && defined($dest_nvram)) {
            $file_mgr->waitForTask($file_mgr->CopyDatastoreFile_Task(
                sourceName => $source_nvram,
                sourceDatacenter => $datacenter_view,
                destinationName => $dest_nvram,
                destinationDatacenter => $datacenter_view,
            ));
        }

        # Copy the vmss file (if applicable).
        if (defined($source_vmss) && defined($dest_vmss)) {
            $file_mgr->waitForTask($file_mgr->CopyDatastoreFile_Task(
                sourceName => $source_vmss,
                sourceDatacenter => $datacenter_view,
                destinationName => $dest_vmss,
                destinationDatacenter => $datacenter_view,
            ));
        }

        # Copy the configuration file.
        $file_mgr->waitForTask($file_mgr->CopyDatastoreFile_Task(
            sourceName => $source_vmx,
            sourceDatacenter => $datacenter_view,
            destinationName => $dest_vmx,
            destinationDatacenter => $datacenter_view,
        ));
    };

    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
        Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
    }

    return $dest_vmx;
}

# Helper function that copies the minimal contents of the specified source VM
# to a destination directory.
# Note: This function assumes that the source VM is registered
# and powered off or suspended.  Lastly, this function assumes that the
# destination directory name does not currently exist.
# 
# Inputs:
#   session  - the VIM session object
#   src_name - the name of the source VM
#   dst_name - the name of the destination VM
# Output: the full path to the destination VM's .vmx file
sub _quickCopyVM {
    # Extract arguments.
    my (%args) = @_;
    
    $args{'name'} = $args{'src_name'};
   
    # Get the service content.
    my $service_content = $args{'session'}->get_service_content();

    # Get the file and virtual disk managers.
    my $file_mgr = $args{'session'}->get_view(mo_ref => $service_content->fileManager);
    
    # Get the datacenter view object.
    $args{'type'} = "Datacenter";
    my $datacenter_view = undef;
    ($args{'session'}, $datacenter_view) = _getViewObject(%args);
    
    # Get a view object for the source VM.
    $args{'type'} = "VirtualMachine";
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewObject(%args);
    
    # Get the name of the datastore that holds the source VM
    # XXX: We assume the source VM is located on only one datastore.
    my $datastore_view = $args{'session'}->get_view(mo_ref => $vm_view->datastore->[0]);
    my $datastore_name = $datastore_view->info->name;

    # Make the destination VM directory.
    eval {
        $file_mgr->MakeDirectory(
            name => "[" . $datastore_name . "] " . $args{'dst_name'},
            datacenter => $datacenter_view
        );
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
        Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
    }

    # --- Copy the other files associated with the source VM. ---
    # Get the nvram/vmss files associated with the source VM and construct
    # the nvram/vmss files associated with the destination VM.
    my $source_nvram = undef;
    my $dest_nvram = undef;
    my $source_vmss = undef;
    my $dest_vmss = undef;
    foreach my $entry (@{$vm_view->config->extraConfig}) {
        if (($entry->key eq 'nvram') &&
            ($entry->value ne '')) {
            $source_nvram = dirname($vm_view->config->files->vmPathName) . "/" . $entry->value;
            $dest_nvram = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . $entry->value;
        }
        if (($entry->key eq 'checkpoint.vmState') &&
            ($entry->value ne '')) {
            $source_vmss = $vm_view->config->files->suspendDirectory . "/" . $entry->value;
            $dest_vmss = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . $entry->value;
        }
        if (defined($source_nvram) &&
            defined($dest_nvram) &&
            defined($source_vmss) &&
            defined($dest_vmss)) {
            last;
        }
    }

    # Get the source configuration filename.
    my $source_vmx = $vm_view->config->files->vmPathName;
    # Construct the destination configuration filename for this VM.
    my $dest_vmx = "[" . $datastore_name . "] " . $args{'dst_name'} . "/" . basename($source_vmx);

    eval {
        # Copy the nvram file (if applicable).
        if (defined($source_nvram) && defined($dest_nvram)) {
            $file_mgr->waitForTask($file_mgr->CopyDatastoreFile_Task(
                sourceName => $source_nvram,
                sourceDatacenter => $datacenter_view,
                destinationName => $dest_nvram,
                destinationDatacenter => $datacenter_view,
            ));
        }

        # Copy the vmss file (if applicable).
        if (defined($source_vmss) && defined($dest_vmss)) {
            $file_mgr->waitForTask($file_mgr->CopyDatastoreFile_Task(
                sourceName => $source_vmss,
                sourceDatacenter => $datacenter_view,
                destinationName => $dest_vmss,
                destinationDatacenter => $datacenter_view,
            ));
        }

        # Copy the configuration file.
        $file_mgr->waitForTask($file_mgr->CopyDatastoreFile_Task(
            sourceName => $source_vmx,
            sourceDatacenter => $datacenter_view,
            destinationName => $dest_vmx,
            destinationDatacenter => $datacenter_view,
        ));
    };

    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
        Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
    }

    return $dest_vmx;
}

# Helper function that unregisters a VM and then deletes all the files
# in the specified VM's directory.  This function is significantly
# different than automatically destroying a VM through the VIM API,
# in that this function will NOT delete any data that resides outside
# of the VM's directory.
#
# Specifically, quick clone VMs reference VMDK files of master VMs. 
# Calling destroy on a quick clone would also (inadvertantly) obliterate
# the master VM's VMDK files as well.  As a result, this function does
# not do that and will instead just delete files within the quick clone
# VM's directory.
#
# Inputs:
#   session  - the VIM session object
#   name     - the name of the VM to delete
# Output: true if successful; croaks otherwise 
#
# Notes:
# - This function assumes all the data associated with the specified VM
# is centrally located within a single subdirectory.  Otherwise, if the
# VM data is split across multiple datastores, then this call will fail
# to delete all the files.
sub _deleteFilesVM {
    # Extract arguments.
    my (%args) = @_;

    # Get the VM's view.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Now, unregister the VM.
    my $config = undef;
    ($args{'session'}, $config) = unregisterVM(undef, %args);

    # Get the service content.
    my $service_content = $args{'session'}->get_service_content();

    # Get the file manager.
    my $file_mgr = $args{'session'}->get_view(mo_ref => $service_content->fileManager);
    
    # Get the datacenter view object.
    $args{'type'} = "Datacenter";
    my $datacenter_view = undef;
    ($args{'session'}, $datacenter_view) = _getViewObject(%args);


    foreach my $datastore (@{$vm_view->datastore}) {
        my $datastore_view = $args{'session'}->get_view(mo_ref => $datastore);
        my $browser_view = $args{'session'}->get_view(mo_ref => $datastore_view->browser);

        eval {
            # Create a new file list.
            my $file_list = [];

            # Figure out the VM's directory.
            my $vm_dirname = dirname($vm_view->config->files->vmPathName);

            # Push the VM directory onto the array.
            push(@{$file_list}, $vm_dirname);
            my $results = $browser_view->waitForTask($browser_view->SearchDatastoreSubFolders_Task(
                datastorePath => $vm_dirname,
                searchSpec => HostDatastoreBrowserSearchSpec->new(sortFoldersFirst => 1),
            ));

            # Push all the files onto the array.
            foreach my $entry (@{$results}) {
                foreach my $file_info (@{$entry->file}) {
                    push(@{$file_list}, $entry->folderPath . "/" . $file_info->path);
                }
            }

            # Delete each file/directory, but do so in REVERSE order (since directories are
            # listed at the top).
            while (scalar(@{$file_list}) > 0) {
                my $file = pop(@{$file_list});
                $file_mgr->waitForTask($file_mgr->DeleteDatastoreFile_Task(
                    name       => $file, 
                    datacenter => $datacenter_view,
                ));
            }

        };

        if ($@) {
            my $detail = $@;
            if (ref($detail) eq 'SoapFault') {
                $detail = $detail->fault_string;
            }
            $LOG->fatal("Unable to delete all of VM (" . $args{'name'} . ") datastore files: " . $detail);
            Carp::croak "Unable to delete all of VM (" . $args{'name'} . ") datastore files: " . $detail;
        }
    }

    return (1);
}

# Helper function to check if the current session on the VMware
# ESX Server is valid or not.
#
# Inputs:
#   session  - the VIM session object
# Output: true if session is valid; false if invalid
sub _isSessionValid {
    # Extract arguments.
    my (%args) = @_;
    
    # Get the service content.
    my $service_instance = $args{'session'}->get_service_instance();

    # Get the current time.
    my $ret = undef;
    eval {
        $ret = $service_instance->CurrentTime();
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            if ($detail->name eq 'NotAuthenticatedFault') {
                # Then session is invalid.
                return (0);
            }
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Unable to validate current session: " . $detail);
        Carp::croak "Unable to validate current session: " . $detail;
    }
    if (!defined($ret)) {
        $LOG->fatal("Unable to validate current session.");
        Carp::croak "Unable to validate current session.";
    }
    # Then session is valid.
    return (1);
}

#######################################################################
# Public Functions                                                    #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

=head2 login()

=over 4

Logs into the VMware ESX Server using the credentials specified in
the <HoneyClient/><Manager/><ESX/> section of the etc/honeyclient.xml
configuration file.

I<Inputs>: None.

I<Output>: Returns a valid Vim session object upon successful login;
croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Validate the session.
    ok((ref($session) eq 'Vim'), "login()") or diag("The login() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub login {
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

    # Create a connection to the ESX server
    my $session = Vim->new(service_url => getVar(name => "service_url"));
    # Record when this object was updated.
    $session->{'_updated_at'} = DateTime::HiRes->now();
    $session->login(user_name => getVar(name => "user_name"),
                    password  => getVar(name => "password"));

    return $session;
}

=pod

=head2 logout(session => $session)

=over 4

Logs out of the VMware ESX Server using the specified Vim session object.

I<Inputs>: 
 B<$session> is the Vim current session object.

I<Output>: Returns true if successfully logs out;
croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Destroy the session.
    my $result = HoneyClient::Manager::ESX->logout(session => $session);
    ok($result, "logout()") or diag("The logout() call failed.");
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub logout {
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check.
    if (!scalar(%args) ||
        !exists($args{'session'}) ||
        !defined($args{'session'})) {
        $LOG->fatal("Unable to logout - no session specified.");
        Carp::croak "Unable to logout - no session specified.";
    }
    if (ref($args{'session'}) ne 'Vim') {
        $LOG->fatal("Unable to logout - invalid session specified.");
        Carp::croak "Unable to logout - invalid session specified.";
    }
 
    $args{'session'}->logout();
    $args{'session'} = undef;

    return (1);
}

=pod

=head2 fullCloneVM(session => $session, src_name => $src_name, dst_name => $dst_name)

=over 4

Completely clones the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$src_name> is the source VM to clone.
 B<$dst_name> is an optional argument, specifying the
name of the cloned VM.

I<Output>: (The Vim session, The name of the cloned VM), if successful; croaks otherwise.

I<Notes>:
If B<$dst_name> is not specified, then the cloned VM 
will have a randomly generated name, where the format will
be a randomly generated hexadecimal string of the length
$VM_ID_LENGTH.

Full cloning VMs can be a time consuming operation, 
depending on how big the VM is.  This is because the entire
VM data is cloned, including the hard disk.

Once cloned, the new VM will be automatically
started, in order to update the VM's unique UUID and
the VM's network MAC address.

Thus, it is recommended that once a fullCloneVM() operation
is performed, you call getStateVM() on the cloned VM's
configuration file to make sure the VM is powered on,
B<prior> to performing B<any additional operations> on
the cloned VM.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Start the test VM.
    HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);
    ok($cloneVM, "fullCloneVM(src_name => '$testVM')") or diag("The fullCloneVM() call failed.");

    # Get the power state of the clone VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $cloneVM);

    # The clone VM should be powered on.
    is($state, "poweredon", "fullCloneVM(name => '$testVM')") or diag("The fullCloneVM() call failed.");
   
    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub fullCloneVM {
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
        !exists($args{'src_name'}) ||
        !defined($args{'src_name'})) {
        $LOG->fatal("Error cloning VM - no source VM name specified.");
        Carp::croak "Error cloning VM - no source VM name specified.";
    }

    # Figure out if the destination was specified.
    my $isRegisteredVM = undef;
    if (!exists($args{'dst_name'}) ||
        !defined($args{'dst_name'})) {
        # If it wasn't specified, then generate a new destination VM name,
        # and make sure it isn't already used.
        do {
            $args{'dst_name'} = _generateVMID();
            $args{'name'} = $args{'dst_name'};
            ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        } while ($isRegisteredVM ||
                 # Make sure our newly generated name doesn't conflict
                 # with any existing snapshot names.
                 defined(_findSnapshot($args{'name'}, _getViewVMSnapshotTrees(%args))));
    } else {
        # The destination was specified, so make sure that name does not already exist.
        $args{'name'} = $args{'dst_name'};
        ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        if ($isRegisteredVM) {
            $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") - destination VM name (" . $args{'dst_name'} . ") already exists.");
            Carp::croak "Error cloning VM (" . $args{'src_name'} . ") - destination VM name (" . $args{'dst_name'} . ") already exists.";
        }
        if (defined(_findSnapshot($args{'dst_name'}, _getViewVMSnapshotTrees(%args)))) {
            $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") - a snapshot named (" . $args{'dst_name'} . ") already exists.");
            Carp::croak "Error cloning VM (" . $args{'src_name'} . ") - a snapshot named (" . $args{'dst_name'} . ") already exists.";
        }
    }

    # Check to make sure source VM is either off or suspended.
    $args{'name'} = $args{'src_name'};
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Only clone source VMs that are powered off or suspended.
    if (($powerState ne 'poweredoff') &&
        ($powerState ne 'suspended')) {

        # If the VM is not powered off, then try suspending it.
        $args{'session'} = suspendVM($class, %args);

        # Refresh the power state.
        ($args{'session'}, $powerState) = getStateVM($class, %args);

        # Check of the source VM is powered off or suspended.
        if (($powerState ne 'poweredoff') &&
            ($powerState ne 'suspended')) {

            $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Source VM power state is '" . $powerState . "'");
            Carp::croak "Error cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Source VM power state is '" . $powerState . "'";
        }
    }

    $LOG->info("Full cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . ").");

    # Clone the source VM.
    $args{'config'} = _fullCopyVM(%args);

    # Register clone VM.
    $args{'name'} = $args{'dst_name'};
    $args{'session'} = registerVM($class, %args);

    # Power on clone VM.
    $args{'session'} = startVM($class, %args);

    # If the source VM was suspended, then this clone will awake
    # from a suspended state.  We'll still need to issue a full reboot,
    # in order for the clone to get assigned a new network MAC address.
    if ($powerState eq 'suspended') {
        $args{'session'} = resetVM($class, %args);
    }

    return ($args{'session'}, $args{'dst_name'});
}

=pod

=head2 startVM(session => $session, name => $name)

=over 4

Powers on the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: The Vim session object if successful, croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    ok($session, "startVM(name => '$testVM')") or diag("The startVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be on.
    is($state, "poweredon", "startVM(name => '$testVM')") or diag("The startVM() call failed.");

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub startVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });
   
    # Only start VMs that are powered off or suspended.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Check to see if the VM is stuck, first...
    if ($powerState eq 'pendingquestion') {
        # If so, try answering the question...
        $args{'session'} = answerVM($class, %args);
        # Refresh the power state.
        ($args{'session'}, $powerState) = getStateVM($class, %args);
    }

    if ($powerState eq 'poweredon') {
        # The VM is already powered on.
        return $args{'session'};
    } elsif (($powerState eq 'poweredoff') ||
             ($powerState eq 'suspended')) {

        my $vm_view = undef;
        ($args{'session'}, $vm_view) = _getViewVM(%args);
        eval {
            $LOG->info("Starting VM (" . $args{'name'} . ").");

# TODO: May need to create an async thread to monitor for stuck state.

            # Helper callback function to check for a stuck VM.
            my $checkForStuckVM = sub {
                my $percent_complete = shift;
 
                # Make sure we don't check the state too soon. 
                if ($percent_complete > 75) {
                    sleep(2);
                }
              
                ($args{'session'}, $powerState) = getStateVM($class, %args);
                # Check to see if the VM is stuck at all.
                if ($powerState eq 'pendingquestion') {
                    # If so, try answering the question...
                    $args{'session'} = answerVM($class, %args);
                    # Refresh the power state.
                    ($args{'session'}, $powerState) = getStateVM($class, %args);
                }
            };
            $vm_view->waitForTask($vm_view->PowerOnVM_Task(), $checkForStuckVM);

            # Okay, now make sure the VM is powered on.
            ($args{'session'}, $powerState) = getStateVM($class, %args);
            if ($powerState ne 'poweredon') {
                $LOG->fatal("Error starting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
                Carp::croak "Error starting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
            }
        };
        if ($@) {
            my $detail = $@;
            if (ref($detail) eq 'SoapFault') {
                $detail = $detail->fault_string;
            }
            $LOG->fatal("Error starting VM (" . $args{'name'} . "): " . $detail);
            Carp::croak "Error starting VM (" . $args{'name'} . "): " . $detail;
        }
    } else {
        # The VM is in a state that cannot be powered on.
        $LOG->fatal("Error starting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
        Carp::croak "Error starting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
    }

    return $args{'session'};
}

=pod

=head2 stopVM(session => $session, name => $name)

=over 4

Powers off the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: The Vim session object if successful, croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);
    ok($session, "stopVM(name => '$testVM')") or diag("The stopVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be off.
    is($state, "poweredoff", "stopVM(name => '$testVM')") or diag("The stopVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub stopVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });
   
    # Only stop VMs that are powered on or stuck.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Check to see if the VM is stuck, first...
    if ($powerState eq 'pendingquestion') {
        # If so, try answering the question...
        $args{'session'} = answerVM($class, %args);
        # Refresh the power state.
        ($args{'session'}, $powerState) = getStateVM($class, %args);
    }
    
    if (($powerState eq 'poweredoff') ||
        ($powerState eq 'suspended')) {
        # The VM is already powered off or suspended.
        # We consider suspended VMs to already be 'off'.
        return $args{'session'};
    } elsif ($powerState eq 'poweredon') {

        my $vm_view = undef;
        ($args{'session'}, $vm_view) = _getViewVM(%args);
        eval {
            $LOG->info("Stopping VM (" . $args{'name'} . ").");

# TODO: May need to create an async thread to monitor for stuck state.

            # Helper callback function to check for a stuck VM.
            my $checkForStuckVM = sub {
                my $percent_complete = shift;

                # Make sure we don't check the state too soon. 
                if ($percent_complete > 75) {
                    sleep(2);
                }
                
                ($args{'session'}, $powerState) = getStateVM($class, %args);
                # Check to see if the VM is stuck at all.
                if ($powerState eq 'pendingquestion') {
                    # If so, try answering the question...
                    $args{'session'} = answerVM($class, %args);
                    # Refresh the power state.
                    ($args{'session'}, $powerState) = getStateVM($class, %args);
                }
            };
            $vm_view->waitForTask($vm_view->PowerOffVM_Task(), $checkForStuckVM);

            # Okay, now make sure the VM is powered off.
            ($args{'session'}, $powerState) = getStateVM($class, %args);
            if ($powerState ne 'poweredoff') {
                $LOG->fatal("Error stopping VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
                Carp::croak "Error stopping VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
            }
        };
        if ($@) {
            my $detail = $@;
            if (ref($detail) eq 'SoapFault') {
                $detail = $detail->fault_string;
            }
            $LOG->fatal("Error stopping VM (" . $args{'name'} . "): " . $detail);
            Carp::croak "Error stopping VM (" . $args{'name'} . "): " . $detail;
        }
    } else {
        # The VM is in a state that cannot be powered off.
        $LOG->fatal("Error stopping VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
        Carp::croak "Error stopping VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
    }

    return $args{'session'};
}

=pod

=head2 resetVM(session => $session, name => $name)

=over 4

Resets the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: The Vim session object if successful, croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Suspend the test VM.
    $session= HoneyClient::Manager::ESX->resetVM(session => $session, name => $testVM);
    ok($session, "resetVM(name => '$testVM')") or diag("The resetVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be powered on.
    is($state, "poweredon", "resetVM(name => '$testVM')") or diag("The resetVM() call failed.");
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub resetVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });
   
    # Only reset VMs that are powered on or stuck.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Check to see if the VM is stuck, first...
    if ($powerState eq 'pendingquestion') {
        # If so, try answering the question...
        $args{'session'} = answerVM($class, %args);
        # Refresh the power state.
        ($args{'session'}, $powerState) = getStateVM($class, %args);
    }
    
    if ($powerState eq 'poweredon') {

        my $vm_view = undef;
        ($args{'session'}, $vm_view) = _getViewVM(%args);
        eval {
            $LOG->info("Resetting VM (" . $args{'name'} . ").");

# TODO: May need to create an async thread to monitor for stuck state.

            # Helper callback function to check for a stuck VM.
            my $checkForStuckVM = sub {
                my $percent_complete = shift;
                
                # Make sure we don't check the state too soon. 
                if ($percent_complete > 75) {
                    sleep(2);
                }

                ($args{'session'}, $powerState) = getStateVM($class, %args);
                # Check to see if the VM is stuck at all.
                if ($powerState eq 'pendingquestion') {
                    # If so, try answering the question...
                    $args{'session'} = answerVM($class, %args);
                    # Refresh the power state.
                    ($args{'session'}, $powerState) = getStateVM($class, %args);
                }
            };
            $vm_view->waitForTask($vm_view->ResetVM_Task(), $checkForStuckVM);

            # Okay, now make sure the VM is powered on.
            ($args{'session'}, $powerState) = getStateVM($class, %args);
            if ($powerState ne 'poweredon') {
                $LOG->fatal("Error resetting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
                Carp::croak "Error resetting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
            }
        };
        if ($@) {
            my $detail = $@;
            if (ref($detail) eq 'SoapFault') {
                $detail = $detail->fault_string;
            }
            $LOG->fatal("Error resetting VM (" . $args{'name'} . "): " . $detail);
            Carp::croak "Error resetting VM (" . $args{'name'} . "): " . $detail;
        }
    } else {
        # The VM is in a state that cannot be reset.
        $LOG->fatal("Error resetting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
        Carp::croak "Error resetting VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
    }

    return $args{'session'};
}

=pod

=head2 suspendVM(session => $session, name => $name)

=over 4

Suspends the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: The Vim session object if successful, croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Suspend the test VM.
    $session = HoneyClient::Manager::ESX->suspendVM(session => $session, name => $testVM);
    ok($session, "suspendVM(name => '$testVM')") or diag("The suspendVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be suspended.
    is($state, "suspended", "suspendVM(name => '$testVM')") or diag("The suspendVM() call failed.");
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub suspendVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });
   
    # Only suspend VMs that are powered on or stuck.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Check to see if the VM is stuck, first...
    if ($powerState eq 'pendingquestion') {
        # If so, try answering the question...
        $args{'session'} = answerVM($class, %args);
        # Refresh the power state.
        ($args{'session'}, $powerState) = getStateVM($class, %args);
    }
    
    if (($powerState eq 'poweredoff') ||
        ($powerState eq 'suspended')) {
        # The VM is already powered off or suspended.
        # We consider powered off VMs to already be 'suspended'.
        return $args{'session'};
    } elsif ($powerState eq 'poweredon') {

        my $vm_view = undef;
        ($args{'session'}, $vm_view) = _getViewVM(%args);
        eval {
            $LOG->info("Suspending VM (" . $args{'name'} . ").");

# TODO: May need to create an async thread to monitor for stuck state.

            # Helper callback function to check for a stuck VM.
            my $checkForStuckVM = sub {
                my $percent_complete = shift;
                
                # Make sure we don't check the state too soon. 
                if ($percent_complete > 75) {
                    sleep(2);
                }

                ($args{'session'}, $powerState) = getStateVM($class, %args);
                # Check to see if the VM is stuck at all.
                if ($powerState eq 'pendingquestion') {
                    # If so, try answering the question...
                    $args{'session'} = answerVM($class, %args);
                    # Refresh the power state.
                    ($args{'session'}, $powerState) = getStateVM($class, %args);
                }
            };
            $vm_view->waitForTask($vm_view->SuspendVM_Task(), $checkForStuckVM);

            # Okay, now make sure the VM is suspended.
            ($args{'session'}, $powerState) = getStateVM($class, %args);
            if ($powerState ne 'suspended') {
                $LOG->fatal("Error suspending VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
                Carp::croak "Error suspending VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
            }
        };
        if ($@) {
            my $detail = $@;
            if (ref($detail) eq 'SoapFault') {
                $detail = $detail->fault_string;
            }
            $LOG->fatal("Error suspending VM (" . $args{'name'} . "): " . $detail);
            Carp::croak "Error suspending VM (" . $args{'name'} . "): " . $detail;
        }
    } else {
        # The VM is in a state that cannot be suspended.
        $LOG->fatal("Error suspending VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.");
        Carp::croak "Error suspending VM (" . $args{'name'} . "): Power state is '" . $powerState . "'.";
    }

    return $args{'session'};
}

=pod

=head2 destroyVM(session => $session, name => $name)

=over 4

Destroys the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: The Vim session object if successful, croaks otherwise.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    ok($session, "destroyVM(name => '$cloneVM')") or diag("The destroyVM() call failed.");
   
    # The clone VM should no longer be registered.
    my $isRegisteredVM = undef;
    ($session, $isRegisteredVM) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $cloneVM);
    ok(!$isRegisteredVM, "destroyVM(name => '$cloneVM')") or diag ("The destroyVM() call failed.");
 
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub destroyVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Only destroy VMs that are powered off or suspended.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Check to see if the VM is on, first.
    if (($powerState ne 'suspended') ||
        ($powerState ne 'poweredoff')) {
        # If so, then power it off.
        $args{'session'} = stopVM($class, %args);
    }

    # Figure out if the VM is a quick clone.
    my $isQuickCloneVM = undef;
    ($args{'session'}, $isQuickCloneVM) = isQuickCloneVM($class, %args);
    if ($isQuickCloneVM) {
        $LOG->info("Destroying VM (" . $args{'name'} . ").");
        _deleteFilesVM(%args);
        return $args{'session'};
    }

    # Okay, so this VM is not a quick clone; go ahead and destroy it
    # like normal.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);
    eval {
        $LOG->info("Destroying VM (" . $args{'name'} . ").");
        # This call is asynchronous, since we never use this VM again after destroying it.
        $vm_view->Destroy_Task();
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error destroying VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error destroying VM (" . $args{'name'} . "): " . $detail;
    }
    return $args{'session'};
}

=pod

=head2 getStateVM(session => $session, name => $name)

=over 4

Gets the powered state of a specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, One of the following string constants:)
 poweredon
 poweredoff
 suspended
 unknown
 pendingquestion

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # The test VM should be off.
    is($state, "poweredoff", "getStateVM(name => '$testVM')") or diag("The getStateVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getStateVM {
    # Extract arguments.
    my ($class, %args) = @_;
    
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);
    my $state = "unknown";

    # Check to see if there is a pending question.
    if (defined($vm_view->runtime->question)) {
        $state = "pendingquestion";
    } elsif (defined($vm_view->runtime->powerState->val)) {
        $state = $vm_view->runtime->powerState->val;
    } else {
        $LOG->error("Could not get execution state of VM (" . $args{'name'} . ").");
        Carp::croak "Could not get execution state of VM (" . $args{'name'} . ").";
    }

    return ($args{'session'}, lc($state));
}

=pod

=head2 isQuickCloneVM(session => $session, name => $name)

=over 4

Determines if the specified VM is a quick clone.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, True if the VM is a quick clone; false otherwise)

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);

    # Verify that the clone VM is a quick clone.
    my $isQuickCloneVM = undef;
    ($session, $isQuickCloneVM) = HoneyClient::Manager::ESX->isQuickCloneVM(session => $session, name => $cloneVM);
    ok($isQuickCloneVM, "isQuickCloneVM(name => '$cloneVM')") or diag("The isQuickCloneVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub isQuickCloneVM {
    # Extract arguments.
    my ($class, %args) = @_;
    
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Helper function that searches all the backing files of each virtual
    # disk and determines if any of them are located outside the VM's main
    # directory.
    # 
    # Inputs: the VM's configuration
    # Outputs: true if the VM is a quick clone; false otherwise
    sub _isBackingQuickClone {
        my $config = shift;

        my $vm_dirname = dirname($config->files->vmPathName);

        # Iterate through each virtual disk associated with the configuration
        # and check if the backing virtual disks reside outside the VM's directory.
        foreach my $dev (@{$config->hardware->device}) {
            if (ref($dev) eq 'VirtualDisk') {
            
                my $vdisk_format = ref($dev->backing);
                if (($vdisk_format ne 'VirtualDiskFlatVer1BackingInfo') && 
                    ($vdisk_format ne 'VirtualDiskFlatVer2BackingInfo')) {

                    # If the disk format isn't file-based, then it's definately a
                    # quick clone.
                    return 1;
                } 
                my $backing_dirname = dirname($dev->backing->fileName);
                if ($vm_dirname ne $backing_dirname) {
                    # If the backing directory is different than the VM's
                    # directory, then it's a quick clone.
                    return 1;
                }
 
            }
        }

        return (0);
    }

    # Check the current VM's configuration.
    if (_isBackingQuickClone($vm_view->config)) {
        return ($args{'session'}, 1);
    }

    # Helper function that searches all the snapshots of a VM and determines
    # if any of the backing virtual disks are located outside the VM's main
    # directory.
    # 
    # Inputs: snapshot_list
    # Outputs: true if the VM is a quick clone; false otherwise
    sub _findQuickCloneSnapshots {
        my ($session, $snapshot_list) = @_;

        foreach my $snapshot_tree (@{$snapshot_list}) {

            my $snapshot_view = $session->get_view(mo_ref => $snapshot_tree->snapshot);

            # Check if this child is a quick clone.
            if (_isBackingQuickClone($snapshot_view->config)) {
                return (1);
            # Check the child's children.
            } elsif (defined($snapshot_tree->childSnapshotList) &&
                     (scalar(@{$snapshot_tree->childSnapshotList}) > 0) &&
                     _findQuickCloneSnapshots($session, $snapshot_tree->childSnapshotList)) {
                return (1);
            }
        }

        return (0);
    }

    # Now, go through all the VM's other configurations -- including
    # snapshot configurations.
    if (defined($vm_view->snapshot) &&
        defined($vm_view->snapshot->rootSnapshotList) &&
        _findQuickCloneSnapshots($args{'session'}, $vm_view->snapshot->rootSnapshotList)) {
        return ($args{'session'}, 1);
    }

    # If we get to here, then the VM is not a quick clone.
    return ($args{'session'}, 0);
}

=pod

=head2 answerVM(session => $session, name => $name)

=over 4

Automatically answer any normal, pending questions for a specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: The Vim session object if successful, croaks otherwise.

I<Notes>: This function attempts to answer (sanely) most of the 
normal questions that a VMware ESX Server usually asks
when powering on cloned or faulty VMs.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # We assume the test VM is stopped and unregistered.

    # The only consistent way to get a VM into a stuck state,
    # is to manually copy a VM into a new directory, register it,
    # and then proceed to start it.  VMware ESX Server will immediately
    # ask if we'd like to create a new identifier before
    # moving on.
   
    # Generate a new VM name. 
    my $newVM = HoneyClient::Manager::ESX->_generateVMID();

    # Create the new VM.
    my $new_config = HoneyClient::Manager::ESX::_fullCopyVM(
        session => $session,
        src_name => $testVM,
        dst_name => $newVM,
    );

    # Register the new VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $newVM, config => $new_config);

    # Start the new VM and indirectly test the answerVM() method.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $newVM);
    ok($session, "answerVM(name => '$newVM')") or diag("The answerVM() call failed.");

    # Destroy the new VM.
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $newVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub answerVM {
    # Extract arguments.
    my ($class, %args) = @_;
    
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Make sure the VM is stuck.
    my $powerState = undef;
    ($args{'session'} , $powerState) = getStateVM($class, %args);
    if ($powerState ne 'pendingquestion') {
        return $args{'session'};
    }
    
    # Okay, get the pending question...
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);
    my $question = $vm_view->runtime->question;
    my $question_text = $question->text;
    $question_text =~ s/\n/ /g;

    # Extract the message ID from the question text.
    my @message = split(/:/, $question_text);
    my $message_id = shift(@message);
    
    my $choice = undef;
    SWITCH: for ($message_id) {
        # The location of this VM's configuration file has changed since it was
        # last powered on.
        /msg\.uuid\.moved/ &&
            do { $choice = 3; last; }; # Choice 3: Always create a new identifier.

        # One of the virtual disks has an adapter mismatch.
        /msg\.disk\.adapterMismatch/ &&
            do { $choice = 0; last; }; # Choice 0: Yes, change adapter type on affected disk.

        $LOG->fatal("Encountered unknown question for VM (" . $args{'name'} . "). " .
                    "(" . $question_text . ")");
        Carp::croak "Encountered unknown question for VM (" . $args{'name'} . "). " .
                    "(" . $question_text . ")";
    }

    # Now, answer the question accordingly...
    eval {
        $vm_view->AnswerVM(questionId   => $question->id,
                           answerChoice => $choice);
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error answering question on VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error answering question on VM (" . $args{'name'} . "): " . $detail;
    }

    # Wait 2 seconds before return, so that the answer operation completes.
    sleep (2);

    return $args{'session'};
}

=pod

=head2 getMACaddrVM(session => $session, name => $name)

=over 4

Gets the MAC address of the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, The MAC address of the VM, if successful.  Returns undef otherwise.)

I<Notes>:
This function will only return the MAC address of the VM's first 
ethernet interface.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # Wait until the test VM is on.
    while ($state ne 'poweredon') {
        sleep (1);
        ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);
    }
    
    # Get the MAC address of the test VM.
    my $mac_address = undef;
    for (my $counter = 0; $counter < 240; $counter++) {
        ($session, $mac_address) = HoneyClient::Manager::ESX->getMACaddrVM(session => $session, name => $testVM);
        if (defined($mac_address)) {
            last;
        } else {
            sleep (1);
        }
    }

    # The exact MAC address of the VM will change from system to system,
    # so we check to make sure the result looks like a valid MAC address.
    like($mac_address, "/[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]\:[0-9a-f][0-9a-f]/", "getMACaddrVM(name => '$testVM')") or diag("The getMACaddrVM() call failed.  Attempted to retrieve the MAC address of test VM ($testVM).");

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getMACaddrVM {
    # Extract arguments.
    my ($class, %args) = @_;
    
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Check if the VM is powered on.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);
    if ($powerState ne 'poweredon') {
        # VM is not powered on, so return undef.
        return ($args{'session'}, undef);
    }

    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Check to see if VMware Tools is installed inside the VM.
    if (!defined($vm_view->guest->toolsVersion)) {
        # VMware Tools is not installed, so return undef.
        return ($args{'session'}, undef);
    }

    # Check if the MAC address exists and is defined.
    if (exists($vm_view->{'guest'}) &&
        exists($vm_view->guest->{'net'}) &&
        exists($vm_view->guest->net->[0]) &&
        exists($vm_view->guest->net->[0]->{'macAddress'}) &&
        defined($vm_view->guest->net->[0]->macAddress)) {
        return ($args{'session'}, $vm_view->guest->net->[0]->macAddress);
    }

    # The address wasn't defined, so return undef.
    return ($args{'session'}, undef);
}

=pod

=head2 getIPaddrVM(session => $session, name => $name)

=over 4

Gets the IP address of a specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, The IP address of the VM, if successful.  Returns undef otherwise.)

I<Notes>:
This function will only return the IP address of the VM's first 
ethernet interface.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);

    # Wait until the test VM is on.
    while ($state ne 'poweredon') {
        sleep (1);
        ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $testVM);
    }
    
    # Get the IP address of the test VM.
    my $ip_address = undef;
    for (my $counter = 0; $counter < 240; $counter++) {
        ($session, $ip_address) = HoneyClient::Manager::ESX->getIPaddrVM(session => $session, name => $testVM);
        if (defined($ip_address)) {
            last;
        } else {
            sleep (1);
        }
    }

    # The exact IP address of the VM will change from system to system,
    # so we check to make sure the result looks like a valid IP address.
    like($ip_address, "/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/", "getIPaddrVM(name => '$testVM')") or diag("The getIPaddrVM() call failed.  Attempted to retrieve the IP address of test VM ($testVM).");

    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getIPaddrVM {
    # Extract arguments.
    my ($class, %args) = @_;
    
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Check if the VM is powered on.
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);
    if ($powerState ne 'poweredon') {
        # VM is not powered on, so return undef.
        return ($args{'session'}, undef);
    }

    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Check to see if VMware Tools is installed inside the VM.
    if (!exists($vm_view->{'guest'}) ||
        !exists($vm_view->guest->{'toolsVersion'}) || 
        !defined($vm_view->guest->toolsVersion)) {
        # VMware Tools is not installed, so return undef.
        return ($args{'session'}, undef);
    }

    # Check if the IP address exists and is defined.
    if (exists($vm_view->guest->{'ipAddress'}) &&
        defined($vm_view->guest->ipAddress)) {
        return ($args{'session'}, $vm_view->guest->ipAddress);
    }

    # The address wasn't defined, so return undef.
    return ($args{'session'}, undef);
}

=pod

=head2 getConfigVM(session => $session, name => $name)

=over 4

Gets the relative path of a specified VM's configuration file.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, The path of the VM's configuration file, if successful. Returns undef otherwise.)

I<Notes>:
The format of the output is:
 "[datastore] /relative/path/to/file.vmx"

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Get the VM's configuration file.    
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->getConfigVM(session => $session, name => $testVM);
    ok($config, "getConfigVM(name => '$testVM')") or diag("The getConfigVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getConfigVM {
    # Extract arguments.
    my ($class, %args) = @_;
    
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Check if the VM configuration file exists and is defined.
    if (exists($vm_view->config->files->{'vmPathName'}) &&
        defined($vm_view->config->files->vmPathName)) {
        return ($args{'session'}, $vm_view->config->files->vmPathName);
    }

    # The configuration file wasn't defined, so return undef.
    return ($args{'session'}, undef);
}

=pod

=head2 isRegisteredVM(session => $session, name => $name)

=over 4

Indicates if the specified VM is registered.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, True if registered, false otherwise.)

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check to see if the test VM is registered (should return true).
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
    
    # The test VM should be registered.
    ok($result, "isRegisteredVM(name => '$testVM')") or diag("The isRegisteredVM() call failed.");

    # Unregister the test VM.
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
    
    # Check to see if the test VM is registered (should return false).
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);

    # The test VM should not be registered.
    ok(!$result, "isRegisteredVM(name => '$testVM')") or diag("The isRegisteredVM() call failed.");
    
    # Reregister the test VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
    
    # Check to see if the test VM is registered (should return true).
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
    
    # The test VM should be registered.
    ok($result, "isRegisteredVM(name => '$testVM')") or diag("The isRegisteredVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub isRegisteredVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # We try to retrieve a generic object, since it's possible
    # we may not find a view object.    
    $args{'type'} = "VirtualMachine";
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewObject(%args);

    # If there is a VM view object corresponding to the name provided,
    # then the VM is registered.
    return ($args{'session'}, defined($vm_view) ? 1 : 0);
}

=pod

=head2 getDatastoreSpaceAvailableESX(session => $session, name => $name)

=over 4

Given a specified VM name, this function will return the amount
of unallocated free space (in bytes) that the first datastore has
left.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, Free space (in bytes) of the VM's backing datastore 
if successful; croaks otherwise.)

I<Notes>:
If the specified VM has virtual disks spread across multiple datastores,
then the free space amount return represents the free space of only
the first datastore found -- not all of them.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check the size of the backing datastore.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->getDatastoreSpaceAvailableESX(session => $session, name => $testVM);
    
    # The size returned should be a number.
    like($result, "/[0-9]+/", "getDatastoreSpaceAvailableESX(name => '$testVM')") or diag("The getDatastoreSpaceAvailableESX() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getDatastoreSpaceAvailableESX {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check all arguments.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Get the name of the datastore that holds the source VM
    # XXX: We assume the source VM is located on only one datastore.
    my $datastore_view = $args{'session'}->get_view(mo_ref => $vm_view->datastore->[0]);

    if (!$datastore_view->summary->accessible) {
        $LOG->error("Unable to retrieve free space of datastore (" . $datastore_view->info->name . "): Datastore currently disconnected.");
        Carp::croak "Unable to retrieve free space of datastore (" . $datastore_view->info->name . "): Datastore currently disconnected.";
    }

    # Return the number of bytes free.
    return ($args{'session'}, $datastore_view->summary->freeSpace);
}

=pod

=head2 getHostnameESX(session => $session)

=over 4

Returns the fully qualified hostname of the connected VMware ESX Server.

I<Output>: (The Vim session object, The VMware ESX Server's hostname if successful; croaks otherwise.)

=back

=begin testing

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check the size of the backing datastore.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->getHostnameESX(session => $session);
    
    # The result should be a string.
    ok($result, "getHostnameESX()") or diag("The getHostnameESX() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getHostnameESX {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Get the host system view object.
    $args{'type'} = "HostSystem";
    my $host_system_view = undef;
    ($args{'session'}, $host_system_view) = _getViewObject(%args);

    if (!defined($host_system_view)) {
        $LOG->error("Unable to retrieve hostname of VMware ESX Server.");
        Carp::croak "Unable to retrieve hostname of VMware ESX Server.";
    }

    # Return the hostname of the VMware ESX Server.
    return ($args{'session'}, $host_system_view->summary->config->name);
}

=pod

=head2 getIPaddrESX(session => $session)

=over 4

Returns the IP address of the first management network interface (type: VMKernel) of
the VMware ESX Server.

I<Output>: (The Vim session object, The VMware ESX Server's management IP address if successful;
croaks otherwise.)

=back

=begin testing

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Check the size of the backing datastore.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->getIPaddrESX(session => $session);
    
    # The result should be a real IP address.
    like($result, "/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/", "getIPaddrESX()") or diag("The getIPaddrESX() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub getIPaddrESX {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Get the host system view object.
    $args{'type'} = "HostSystem";
    my $host_system_view = undef;
    ($args{'session'}, $host_system_view) = _getViewObject(%args);

    if (!defined($host_system_view) ||
        !exists($host_system_view->config->network->vnic->[0])) {
        $LOG->error("Unable to retrieve IP address of VMware ESX Server.");
        Carp::croak "Unable to retrieve IP address of VMware ESX Server.";
    }

    # Return the IP address of the VMware ESX Server.
    return ($args{'session'}, $host_system_view->config->network->vnic->[0]->spec->ip->ipAddress);
}

=pod

=head2 registerVM(session => $session, name => $name, config => $config)

=over 4

Registers the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the display name of the VM, once registered.
 B<$config> is the relative path of the VM's configuration file (.vmx),
as it sits on any of the host VMware ESX Server's datastores.

I<Output>: The Vim session object if successful, croaks otherwise.

I<Notes>:
The format of $config is:
 "[datastore] /relative/path/to/file.vmx"

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Unregister the test VM.
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
    
    # Reregister the test VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
    
    # The test VM should be registered.
    ok($session, "registerVM(name => '$testVM', config => '$config')") or diag("The registerVM() call failed.");
    
    # Check to see if the test VM is registered (should return true).
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->isRegisteredVM(session => $session, name => $testVM);
    
    # The test VM should be registered.
    ok($result, "registerVM(name => '$testVM', config => '$config')") or diag("The registerVM() call failed.");

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub registerVM {
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
        !exists($args{'name'}) ||
        !defined($args{'name'})) {
        $LOG->fatal("Error registering VM: No name specified.");
        Carp::croak "Error registering VM: No name specified.";
    }

    if (!exists($args{'name'}) ||
        !defined($args{'name'})) {
        $LOG->fatal("Error registering VM: No config specified.");
        Carp::croak "Error registering VM: No config specified.";
    }

    # Get the datacenter view.
    $args{'type'} = "Datacenter";
    my $datacenter_view = undef;
    ($args{'session'}, $datacenter_view) = _getViewObject(%args);
    if (!defined($datacenter_view)) {
        $LOG->fatal("Error registering VM (" . $args{'name'} . "): No datacenter found.");
        Carp::croak "Error registering VM (" . $args{'name'} . "): No datacenter found.";
    }
   
    # Get the folder view. 
    my $folder_view = $args{'session'}->get_view(mo_ref => $datacenter_view->vmFolder);
    if (!defined($folder_view)) {
        $LOG->fatal("Error registering VM (" . $args{'name'} . "): No folder found.");
        Carp::croak "Error registering VM (" . $args{'name'} . "): No folder found.";
    }

    # Get the host folder view.
    my $host_folder_view = $args{'session'}->get_view(mo_ref => $datacenter_view->hostFolder);
    if (!defined($host_folder_view)) {
        $LOG->fatal("Error registering VM (" . $args{'name'} . "): No host folder found.");
        Carp::croak "Error registering VM (" . $args{'name'} . "): No host folder found.";
    }

    # Get the first compute resource associated with the host folder view.
    my $compute_resource_view = undef;
    foreach my $entry (@{$host_folder_view->childEntity}) {
        if ((ref($entry) eq 'ManagedObjectReference') &&
            ($entry->type eq 'ComputeResource')) {
            $compute_resource_view = $args{'session'}->get_view(mo_ref => $entry);
            last;
        }
    }

    eval {
        $LOG->info("Registering VM (" . $args{'name'} . ").");
        $folder_view->RegisterVM(
            path => $args{'config'},
            name => $args{'name'},
            asTemplate => 'false',
            pool => $compute_resource_view->resourcePool,
        );
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error registering VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error registering VM (" . $args{'name'} . "): " . $detail;
    }

    return $args{'session'};
}

=pod

=head2 unregisterVM(session => $session, name => $name)

=over 4

Unregisters the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.

I<Output>: (The Vim session object, Relative path of the configuration file if successful,
croaks otherwise.)

I<Notes>:
The format of the output is:
 "[datastore] /relative/path/to/file.vmx"

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Unregister the test VM.
    my $config = undef;
    ($session, $config) = HoneyClient::Manager::ESX->unregisterVM(session => $session, name => $testVM);
    
    # The test VM should not be registered.
    ok($config, "unregisterVM(name => '$testVM')") or diag("The unregisterVM() call failed.");
    
    # Reregister the test VM.
    $session = HoneyClient::Manager::ESX->registerVM(session => $session, name => $testVM, config => $config);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub unregisterVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # We try to retrieve a generic object, since it's possible
    # we may not find a view object.    
    $args{'type'} = "VirtualMachine";
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewObject(%args);

    # If we weren't able to find the VM view, then the VM specified
    # is already unregistered.  Return true.
    if (!defined($vm_view)) {
        return ($args{'session'}, undef);
    }

    # Unregister the VM.
    eval {
        $LOG->info("Unregistering VM (" . $args{'name'} . ").");
        $vm_view->UnregisterVM();
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error unregistering VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error unregistering VM (" . $args{'name'} . "): " . $detail;
    }

    return ($args{'session'}, $vm_view->config->files->vmPathName);
}


=pod

=head2 snapshotVM(session => $session, name => $name, snapshot_name => $snapshot_name, snapshot_description => $snapshot_description, ignore_collisions => $ignore_collisions)

=over 4

Create a new snapshot of the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.
 B<$snapshot_name> is an optional argument, specifying 
the name to use for the newly created snapshot.
 B<$snapshot_description> is an optional argument,
specifying the description to use for the newly created
snapshot.
 B<$ignore_collisions> is an optional argument, specifying
that function should ignore any collisions found between
the specified $snapshot_name and any other VM names as well
as between any other snapshot names on any VMs.

I<Output>: (The Vim session object, The name of the snapshot, if successful; croaks otherwise.)

I<Notes>:
If B<$snapshot_name> is not specified, then the snapshot name
will have a randomly generated name, where the format will
be a randomly generated hexadecimal string of the length
$VM_ID_LENGTH.

If B<$snapshot_description> is not specified, then the snapshot 
description will have a randomly generated string, where the format
will be a randomly generated hexadecimal string of the length
$VM_ID_LENGTH.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);
    ok($snapshot_name, "snapshotVM(name => '$cloneVM')") or diag("The snapshotVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub snapshotVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check all arguments.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Figure out if the snapshot name was specified.
    $args{'target_name'} = $args{'name'};
    my $isRegisteredVM = undef;
    if (!exists($args{'snapshot_name'}) ||
        !defined($args{'snapshot_name'})) {
        # If it wasn't specified, then generate a new snapshot name,
        # and make sure it isn't already used.
        do {
            $args{'snapshot_name'} = _generateVMID();
            $args{'name'} = $args{'snapshot_name'};
            ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        } while ($isRegisteredVM ||
                 # Make sure our newly generated name doesn't conflict
                 # with any existing snapshot names.
                 defined(_findSnapshot($args{'name'}, _getViewVMSnapshotTrees(%args))));
    } elsif (!exists($args{'ignore_collisions'}) ||
             !defined($args{'ignore_collisions'}) ||
             !$args{'ignore_collisions'}) {
        # The destination was specified, so make sure that name does not already exist.
        $args{'name'} = $args{'snapshot_name'};
        ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        if ($isRegisteredVM) {
            $LOG->fatal("Error creating snapshot on VM (" . $args{'target_name'} . ") - another VM named (" . $args{'snapshot_name'} . ") already exists.");
            Carp::croak "Error creating snapshot on VM (" . $args{'target_name'} . ") - another VM named (" . $args{'snapshot_name'} . ") already exists.";
        }
        if (defined(_findSnapshot($args{'snapshot_name'}, _getViewVMSnapshotTrees(%args)))) {
            $LOG->fatal("Error creating snapshot on VM (" . $args{'target_name'} . ") - another snapshot named (" . $args{'snapshot_name'} . ") already exists.");
            Carp::croak "Error creating snapshot on VM (" . $args{'target_name'} . ") - another snapshot named (" . $args{'snapshot_name'} . ") already exists.";
        }
    }
    $args{'name'} = $args{'target_name'};

    # Figure out if the snapshot description was specified.
    if (!exists($args{'snapshot_description'}) ||
        !defined($args{'snapshot_description'})) {
        $args{'snapshot_description'} = $args{'snapshot_name'};
    }

    eval {
        $LOG->info("Creating snapshot (" . $args{'snapshot_name'}  . ") on VM (" . $args{'name'} . ").");
        $vm_view->CreateSnapshot(name => $args{'snapshot_name'}, description => $args{'snapshot_description'}, memory => 1, quiesce => 1);
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error creating snapshot on VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error creating snapshot on VM (" . $args{'name'} . "): " . $detail;
    }

    return ($args{'session'}, $args{'snapshot_name'});
}

=pod

=head2 revertVM(session => $session, name => $name, snapshot_name => $snapshot_name)

=over 4

Revert the specified VM back to a previous snapshot.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.
 B<$snapshot_name> is the name of the snapshot to which to revert to.

I<Output>: The Vim session object if successful, croaks otherwise.

I<Notes>:
If the VM has B<multiple snapshots of the same name>, then this function will
perform a depth-first search and select the first matching snapshot found.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->fullCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);

    # Wait 2 seconds.
    sleep (2);

    # Revert the clone VM.
    $session = HoneyClient::Manager::ESX->revertVM(session => $session, name => $cloneVM, snapshot_name => $snapshot_name);
    ok($session, "revertVM(name => '$cloneVM', snapshot_name => '$snapshot_name')") or diag("The revertVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub revertVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check all arguments.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Figure out if the snapshot name was specified.
    if (!exists($args{'snapshot_name'}) ||
        !defined($args{'snapshot_name'})) {

        $LOG->fatal("Error reverting VM (" . $args{'name'} . ") - no snapshot_name specified.");
        Carp::croak "Error reverting VM (" . $args{'name'} . ") - no snapshot_name specified.";
    }

    # Find the corresponding snapshot tree.
    my $snapshot_tree = undef;
    if (defined($vm_view->snapshot) &&
        defined($vm_view->snapshot->rootSnapshotList)) {
        $snapshot_tree = _findSnapshot($args{'snapshot_name'}, $vm_view->snapshot->rootSnapshotList);
    }

    # Make sure we found a snapshot.
    if (!defined($snapshot_tree) || !defined($snapshot_tree->snapshot)) {
        $LOG->fatal("Error reverting VM (" . $args{'name'} . ") - snapshot (" . $args{'snapshot_name'} . ") not found.");
        Carp::croak "Error reverting VM (" . $args{'name'} . ") - snapshot (" . $args{'snapshot_name'} . ") not found.";
    }

    # Get the VirtualMachineSnapshot object.
    my $snapshot = $args{'session'}->get_view(mo_ref => $snapshot_tree->snapshot);
    eval {
        $LOG->info("Reverting to snapshot (" . $args{'snapshot_name'}  . ") on VM (" . $args{'name'} . ").");
        $snapshot->RevertToSnapshot();
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error reverting VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error reverting VM (" . $args{'name'} . "): " . $detail;
    }

    return $args{'session'};
}

=pod

=head2 renameSnapshotVM(session => $session, name => $name, old_snapshot_name => $old_snapshot_name, new_snapshot_name => $new_snapshot_name, new_snapshot_description => $new_snapshot_description, ignore_collisions => $ignore_collisions)

=over 4

Renames a snapshot on the specified VM, using the new name and description
provided.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.
 B<$old_snapshot_name> is the original name of this snapshot.
 B<$new_snapshot_name> is the new name to assign to this snapshot.
 B<$new_snapshot_description> is the (optional) new description to assign to this snapshot.
 B<$ignore_collisions> is an (optional) argument, specifying
that function should ignore any collisions found between
the specified $new_snapshot_name and any other VM names as well
as between any other snapshot names on any VMs.

I<Output>: (The Vim session object, The new name of this snapshot, if successful; croaks otherwise.)

I<Notes>:
If the VM has B<multiple snapshots of the same name>, then this function will
perform a depth-first search and select the first matching snapshot found.

If B<$new_snapshot_name> is not specified, then the snapshot name
will have a randomly generated name, where the format will
be a randomly generated hexadecimal string of the length
$VM_ID_LENGTH.

If B<$new_snapshot_description> is not specified, then the snapshot 
description will have a randomly generated string, where the format
will be a randomly generated hexadecimal string of the length
$VM_ID_LENGTH.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);

    # Wait 2 seconds.
    sleep (2);

    # Rename this snapshot on the clone VM.
    my $result = undef;
    ($session, $result) = HoneyClient::Manager::ESX->renameSnapshotVM(session => $session, name => $cloneVM, old_snapshot_name => $snapshot_name);
    ok($result, "renameSnapshotVM(name => '$cloneVM', old_snapshot_name => '$snapshot_name')") or diag("The renameSnapshotVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub renameSnapshotVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check all arguments.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Figure out if the old snapshot name was specified.
    if (!exists($args{'old_snapshot_name'}) ||
        !defined($args{'old_snapshot_name'})) {

        $LOG->fatal("Error renaming snapshot on VM (" . $args{'name'} . ") - no old_snapshot_name specified.");
        Carp::croak "Error renaming snapshot on VM (" . $args{'name'} . ") - no old_snapshot_name specified.";
    }

    # Figure out if the new_snapshot_name was specified.
    $args{'target_name'} = $args{'name'};
    my $isRegisteredVM = undef;
    if (!exists($args{'new_snapshot_name'}) ||
        !defined($args{'new_snapshot_name'})) {
        # If it wasn't specified, then generate a new snapshot name,
        # and make sure it isn't already used.
        do {
            $args{'new_snapshot_name'} = _generateVMID();
            $args{'name'} = $args{'new_snapshot_name'};
            ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        } while ($isRegisteredVM ||
                 # Make sure our newly generated name doesn't conflict
                 # with any existing snapshot names.
                 defined(_findSnapshot($args{'name'}, _getViewVMSnapshotTrees(%args))));
    } elsif (!exists($args{'ignore_collisions'}) ||
             !defined($args{'ignore_collisions'}) ||
             !$args{'ignore_collisions'}) {
        # The destination was specified, so make sure that name does not already exist.
        $args{'name'} = $args{'new_snapshot_name'};
        ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        if ($isRegisteredVM) {
            $LOG->fatal("Error renaming snapshot on VM (" . $args{'target_name'} . ") - another VM named (" . $args{'new_snapshot_name'} . ") already exists.");
            Carp::croak "Error renaming snapshot on VM (" . $args{'target_name'} . ") - another VM named (" . $args{'new_snapshot_name'} . ") already exists.";
        }
        if (defined(_findSnapshot($args{'new_snapshot_name'}, _getViewVMSnapshotTrees(%args)))) {
            $LOG->fatal("Error renaming snapshot on VM (" . $args{'target_name'} . ") - another snapshot named (" . $args{'new_snapshot_name'} . ") already exists.");
            Carp::croak "Error renaming snapshot on VM (" . $args{'target_name'} . ") - another snapshot named (" . $args{'new_snapshot_name'} . ") already exists.";
        }
    }
    $args{'name'} = $args{'target_name'};

    # Figure out if the new_snapshot_description was specified.
    if (!exists($args{'new_snapshot_description'}) ||
        !defined($args{'new_snapshot_description'})) {
        $args{'new_snapshot_description'} = $args{'new_snapshot_name'};
    }

    # Find the corresponding snapshot tree.
    my $snapshot_tree = undef;
    if (defined($vm_view->snapshot) &&
        defined($vm_view->snapshot->rootSnapshotList)) {
        $snapshot_tree = _findSnapshot($args{'old_snapshot_name'}, $vm_view->snapshot->rootSnapshotList);
    }

    # Make sure we found a snapshot.
    if (!defined($snapshot_tree) || !defined($snapshot_tree->snapshot)) {
        $LOG->fatal("Error renaming snapshot on VM (" . $args{'name'} . ") - snapshot (" . $args{'old_snapshot_name'} . ") not found.");
        Carp::croak "Error renaming snapshot on VM (" . $args{'name'} . ") - snapshot (" . $args{'old_snapshot_name'} . ") not found.";
    }

    # Get the VirtualMachineSnapshot object.
    my $snapshot = $args{'session'}->get_view(mo_ref => $snapshot_tree->snapshot);
    eval {
        $LOG->info("Renaming snapshot (" . $args{'old_snapshot_name'}  . ") to (" . $args{'new_snapshot_name'} . ") on VM (" . $args{'name'} . ").");
        $snapshot->RenameSnapshot(
            name        => $args{'new_snapshot_name'},
            description => $args{'new_snapshot_description'},
        );
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error renaming snapshot on VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error renaming snapshot on VM (" . $args{'name'} . "): " . $detail;
    }

    return ($args{'session'}, $args{'new_snapshot_name'});
}

=pod

=head2 removeSnapshotVM(session => $session, name => $name, snapshot_name => $snapshot_name, remove_all_children => $remove_all_children)

=over 4

Removes a snapshot on the specified VM, using the snapshot name provided.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$name> is the name of the virtual machine.
 B<$snapshot_name> is the name of the snapshot to remove.
 B<$remove_all_children> is an (optional) argument, specifying that all
child snapshots be removed as well.

I<Output>: The Vim session object if successful; croaks otherwise.

I<Notes>:
If the VM has B<multiple snapshots of the same name>, then this function will
perform a depth-first search and select the first matching snapshot found.

If B<$remove_all_children> is not specified, then only the snapshot found
will be removed - all child snapshots will be preserved.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);
   
    # Snapshot the clone VM.
    my $snapshot_name = undef;
    ($session, $snapshot_name) = HoneyClient::Manager::ESX->snapshotVM(session => $session, name => $cloneVM);

    # Wait 2 seconds.
    sleep (2);

    # Remove this snapshot on the clone VM.
    $session = HoneyClient::Manager::ESX->removeSnapshotVM(session => $session, name => $cloneVM, snapshot_name => $snapshot_name);
    ok($session, "removeSnapshotVM(name => '$cloneVM', snapshot_name => '$snapshot_name')") or diag("The removeSnapshotVM() call failed.");

    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub removeSnapshotVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check all arguments.
    my $vm_view = undef;
    ($args{'session'}, $vm_view) = _getViewVM(%args);

    # Figure out if the snapshot name was specified.
    if (!exists($args{'snapshot_name'}) ||
        !defined($args{'snapshot_name'})) {

        $LOG->fatal("Error removing snapshot on VM (" . $args{'name'} . ") - no snapshot_name specified.");
        Carp::croak "Error removing snapshot on VM (" . $args{'name'} . ") - no snapshot_name specified.";
    }

    # Figure out if the remove_all_children was specified.
    if (!exists($args{'remove_all_children'}) ||
        !defined($args{'remove_all_children'})) {
        $args{'remove_all_children'} = 0;
    }

    # Find the corresponding snapshot tree.
    my $snapshot_tree = undef;
    if (defined($vm_view->snapshot) &&
        defined($vm_view->snapshot->rootSnapshotList)) {
        $snapshot_tree = _findSnapshot($args{'snapshot_name'}, $vm_view->snapshot->rootSnapshotList);
    }

    # Make sure we found a snapshot.
    if (!defined($snapshot_tree) || !defined($snapshot_tree->snapshot)) {
        $LOG->fatal("Error removing snapshot on VM (" . $args{'name'} . ") - snapshot (" . $args{'snapshot_name'} . ") not found.");
        Carp::croak "Error removing snapshot on VM (" . $args{'name'} . ") - snapshot (" . $args{'snapshot_name'} . ") not found.";
    }

    # Get the VirtualMachineSnapshot object.
    my $snapshot = $args{'session'}->get_view(mo_ref => $snapshot_tree->snapshot);
    eval {
        $LOG->info("Removing snapshot (" . $args{'snapshot_name'}  . ") on VM (" . $args{'name'} . ").");
        $snapshot->waitForTask($snapshot->RemoveSnapshot_Task(
            removeChildren => $args{'remove_all_children'},
        ));
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error removing snapshot on VM (" . $args{'name'} . "): " . $detail);
        Carp::croak "Error removing snapshot on VM (" . $args{'name'} . "): " . $detail;
    }

    return $args{'session'};
}

=pod

=head2 quickCloneVM(session => $session, src_name => $src_name, dest_name => $dest_name)

=over 4

Creates a differential clone of the specified VM.

I<Inputs>:
 B<$session> is the Vim current session object.
 B<$src_name> is the source VM to clone.
 B<$dst_name> is an optional argument, specifying the
name of the cloned VM.

I<Output>: (The Vim session object, The name of the cloned VM, if successful; croaks otherwise.)

I<Notes>:
The source VM must not have any snapshots; otherwise this
operation will croak.

If B<$dst_name> is not specified, then the cloned VM 
will have a randomly generated name, where the format will
be a randomly generated hexadecimal string of the length
$VM_ID_LENGTH.

Once cloned, the new VM will be automatically
started, in order to update the VM's unique UUID and
the VM's network MAC address.

Thus, it is recommended that once a quickCloneVM() operation
is performed, you call getStateVM() on the cloned VM's
configuration file to make sure the VM is powered on,
B<prior> to performing B<any additional operations> on
the cloned VM.

=back

=begin testing

my $testVM = getVar(name      => "test_vm_name",
                    namespace => "HoneyClient::Manager::ESX::Test");

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::ESX->login();
   
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::ESX->quickCloneVM(session => $session, src_name => $testVM);
    ok($cloneVM, "quickCloneVM(src_name => '$testVM')") or diag("The quickCloneVM() call failed.");

    # Verify that the clone VM is a quick clone.
    my $isQuickClone = undef;
    ($session, $isQuickClone) = HoneyClient::Manager::ESX->isQuickCloneVM(session => $session, name => $cloneVM);
    ok($isQuickClone, "quickCloneVM(src_name => '$testVM')") or diag("The quickCloneVM() call failed.");

    # Get the power state of the clone VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::ESX->getStateVM(session => $session, name => $cloneVM);

    # The clone VM should be powered on.
    is($state, "poweredon", "quickCloneVM(name => '$testVM')") or diag("The quickCloneVM() call failed.");
   
    # Destroy the clone VM. 
    $session = HoneyClient::Manager::ESX->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::ESX->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::ESX->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::ESX->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub quickCloneVM {
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
        !exists($args{'src_name'}) ||
        !defined($args{'src_name'})) {
        $LOG->fatal("Error cloning VM - no source VM name specified.");
        Carp::croak "Error cloning VM - no source VM name specified.";
    }

    # Figure out if the destination was specified.
    my $isRegisteredVM = undef;
    if (!exists($args{'dst_name'}) ||
        !defined($args{'dst_name'})) {
        # If it wasn't specified, then generate a new destination VM name,
        # and make sure it isn't already used.
        do {
            $args{'dst_name'} = _generateVMID();
            $args{'name'} = $args{'dst_name'};
            ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        } while ($isRegisteredVM ||
                 # Make sure our newly generated name doesn't conflict
                 # with any existing snapshot names.
                 defined(_findSnapshot($args{'name'}, _getViewVMSnapshotTrees(%args))));
    } else {
        # The destination was specified, so make sure that name does not already exist.
        $args{'name'} = $args{'dst_name'};
        ($args{'session'}, $isRegisteredVM) = isRegisteredVM($class, %args);
        if ($isRegisteredVM) {
            $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") - destination VM name (" . $args{'dst_name'} . ") already exists.");
            Carp::croak "Error cloning VM (" . $args{'src_name'} . ") - destination VM name (" . $args{'dst_name'} . ") already exists.";
        }
        if (defined(_findSnapshot($args{'dst_name'}, _getViewVMSnapshotTrees(%args)))) {
            $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") - a snapshot named (" . $args{'dst_name'} . ") already exists.");
            Carp::croak "Error cloning VM (" . $args{'src_name'} . ") - a snapshot named (" . $args{'dst_name'} . ") already exists.";
        }
    }

    # Check to make sure source VM is either off or suspended.
    $args{'name'} = $args{'src_name'};
    my $powerState = undef;
    ($args{'session'}, $powerState) = getStateVM($class, %args);

    # Only clone source VMs that are powered off or suspended.
    if (($powerState ne 'poweredoff') &&
        ($powerState ne 'suspended')) {

        # If the VM is not powered off, then try suspending it.
        $args{'session'} = suspendVM($class, %args);

        # Refresh the power state.
        ($args{'session'}, $powerState) = getStateVM($class, %args);

        # Check of the source VM is powered off or suspended.
        if (($powerState ne 'poweredoff') &&
            ($powerState ne 'suspended')) {

            $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Source VM power state is '" . $powerState . "'");
            Carp::croak "Error cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Source VM power state is '" . $powerState . "'";
        }
    }

    # Make sure the source VM has no snapshots.
    my $src_vm_view = undef;
    ($args{'session'}, $src_vm_view) = _getViewVM(%args);
    if (defined($src_vm_view->snapshot)) {
        $LOG->fatal("Error cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Source VM has snapshots - delete all snapshots and try again.");
        Carp::croak "Error cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Source VM has snapshots - delete all snapshots and try again.";
    }

    $LOG->info("Quick cloning VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . ").");

    # Clone the source VM.
    $args{'config'} = _quickCopyVM(%args);

    # Set a warning annotation on the source VM.
    my $vm_config_spec = VirtualMachineConfigSpec->new();
    $vm_config_spec->annotation(getVar(name => "default_quick_clone_master_annotation"));

    # Now, reconfigure the destination VM's configuration accordingly.
    eval {
        $src_vm_view->waitForTask($src_vm_view->ReconfigVM_Task(
            spec => $vm_config_spec,
        ));
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
        Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
    }

    # Register clone VM.
    $args{'name'} = $args{'dst_name'};
    $args{'session'} = registerVM($class, %args);

    # Reconfigure the clone VM's virtual disk paths, so that they all point to absolute directories of the source VM.
    my $dst_vm_view = undef;
    ($args{'session'}, $dst_vm_view) = _getViewVM(%args);

    # Iterate through each virtual disk associated with the source VM and
    # update the corresponding virtual disk on the destination VM.
    $vm_config_spec = VirtualMachineConfigSpec->new();
    my $vm_device_specs = [];
 
    my $source_vmdk = undef;
    foreach my $src_dev (@{$src_vm_view->config->hardware->device}) {
        if (ref($src_dev) eq 'VirtualDisk') {
            
            # Make sure the disk type is something we can copy; otherwise, croak.
            my $vdisk_format = ref($src_dev->backing);

            if (($vdisk_format ne 'VirtualDiskFlatVer1BackingInfo') && 
                ($vdisk_format ne 'VirtualDiskFlatVer2BackingInfo')) {

                $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Unsupported virtual disk format - " . $vdisk_format);
                Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): Unsupported virtual disk format - " . $vdisk_format;
            }

            # Locate the corresponding virtual disk on the destination VM.
            my $dst_dev = undef;
            foreach my $entry (@{$dst_vm_view->config->hardware->device}) {
                if ($entry->key == $src_dev->key) {
                    $dst_dev = $entry;
                    last;
                }
            }

            # Modify the backing VMDK filename for this virtual disk.
            $dst_dev->{'backing'}->{'fileName'} = $src_dev->backing->fileName;
                
            # Create a virtual device config spec for this virtual disk. 
            my $vm_device_spec = VirtualDeviceConfigSpec->new();
            $vm_device_spec->device($dst_dev);
            $vm_device_spec->operation(VirtualDeviceConfigSpecOperation->new('edit'));

            push(@{$vm_device_specs}, $vm_device_spec);
        }
    }

    # Update our list of changes to be made to the destination VM.
    $vm_config_spec->deviceChange($vm_device_specs);
    $vm_config_spec->annotation("Type: Quick Cloned VM\n" .
                                "Master VM: " . $args{'src_name'});

    # Make sure the new clone always generates a new, unique UUID.
    $vm_config_spec->extraConfig([ OptionValue->new(key => "uuid.action", value => "create"), ]);

    # Now, reconfigure the destination VM's configuration accordingly.
    eval {
        $dst_vm_view->waitForTask($dst_vm_view->ReconfigVM_Task(
            spec => $vm_config_spec,
        ));
    };
    if ($@) {
        my $detail = $@;
        if (ref($detail) eq 'SoapFault') {
            $detail = $detail->fault_string;
        }
        $LOG->fatal("Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail);
        Carp::croak "Error copying VM (" . $args{'src_name'} . ") to (" . $args{'dst_name'} . "): " . $detail;
    }

    # Create a baseline snapshot.
    $args{'snapshot_name'} = getVar(name => "default_quick_clone_snapshot_name");
    $args{'snapshot_description'} = getVar(name => "default_quick_clone_snapshot_description");
    $args{'ignore_collisions'} = 1;
    my $snapshot_name = undef;
    ($args{'session'}, $snapshot_name) = snapshotVM($class, %args);

    # Power on clone VM.
    $args{'session'} = startVM($class, %args);

    # If the Master VM was suspended, then this clone
    # will awake from a suspended state.  We'll still
    # need to issue a full reboot, in order for the
    # clone to get assigned a new network MAC address.
    if ($powerState eq 'suspended') {
        $args{'session'} = resetVM($class, %args);
    }

    return ($args{'session'}, $args{'dst_name'});
}

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 TODO

Need to provide ESX lockdown role instructions.  Specifically, identify
the minimum amount of priviledges required by this library and then
provide documentation on how a user can create (and ultimately use) this
minimal role within ESX.

=head1 BUGS & ASSUMPTIONS

This code assumes the service URL and authentication information listed
in the etc/honeyclient.xml under <Honeyclient/><Manager/><ESX/> is
correct in order to remotely access the VMware ESX server.

Furthermore, this code assumes the user_name and password provided to
access the VMware ESX server has the Administrator role.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

VMware::VIRuntime

L<http://www.vmware.com/support/developer/>

File::Basename

Apache::SessionX::General::MD5

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

VMware, for providing their VMware::VmPerl API code and offering their
VMware ESXi product as freeware.

Jeffrey William Baker E<lt>jwbaker@acm.orgE<gt> and Gerald Richter
E<lt>richter@dev.ecos.deE<gt>, for using core code from their
Apache::Session::Generate::MD5 package to create unique VMIDs.

=head1 AUTHORS

Jeff Puchalski, E<lt>jpuchalski@mitre.orgE<gt>

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

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
