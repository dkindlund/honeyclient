#######################################################################
# Created on:  Nov 17, 2008
# Package:     HoneyClient::Manager::Firewall
# File:        Firewall.pm
# Description: A module that provides programmatic access to the
#              IPTables interface on the local system.
#
# CVS: $Id$
#
# @author kindlund
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

HoneyClient::Manager::Firewall - Perl extension to provide programmatic
access to all IPTables interface on the local system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Firewall version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::Firewall;

# TODO: Fix this.


=head1 DESCRIPTION

This library provides static calls to control the IPTables interface on the 
local system.  This library only alters the existing firewall ruleset on the
host system; it does not create or delete any base rules defined by the
host system.

Specifically, this library assumes that the host system already has all
the necessary static firewall rules in place to 'deny all' VM traffic.
As such, the library saves this firewall state of the 'filter' table,
using the '/sbin/iptables-save' command.

Then, upon exit or reset, the library restores this state of the 'filter'
table back to this 'deny all' mode, using the '/sbin/iptables-restore'
command.

Note: This code assumes that the IPTables 'filter' table on the host system was 
configured using the standared Uncomplicated Firewall (UFW) framework that is
packaged with the Ubuntu Linux distribution.  As such, the code relies
on UFW to have setup and established the basic 'ufw-*' chain names
within the 'filter' table.

=cut

package HoneyClient::Manager::Firewall;

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
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION, $INIT_FILTER_RULES);

    # Set our package version.
    $VERSION = 1.02;

    @ISA = qw(Exporter);

    # Symbols to export automatically
    @EXPORT = qw();

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Manager::Firewall ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = ( 
        'all' => [ qw() ],
    );

    # Symbols to autoexport (when qw(:all) tag is used)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.

    # Sanity check: Make sure we have authorization to access the IPTables
    # interface.
    require IPTables::ChainMgr;
    my $chain_mgr = new IPTables::ChainMgr() or
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables -t filter -L');
    if (!$ret) {
        Carp::croak "Error: Unable to access the IPTables interface - " . join(' ', @{$err_ar});
    }

    # Now, we record the current state of the 'filter' table and we assume
    # this state is 'deny all'.
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables-save -t filter');
    if (!$ret) {
        Carp::croak "Error: Unable to access the IPTables 'filter' table - " . join(' ', @{$err_ar});
    }
    # Collapse all output.
    $INIT_FILTER_RULES = join('', @{$out_ar});
    # Escape all double quotes.
    $INIT_FILTER_RULES =~ s/"/\\"/g;
}
our (@EXPORT_OK, $VERSION, $INIT_FILTER_RULES);

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

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure threads loads.
BEGIN { use_ok('threads') or diag("Can't load threads package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads');
use threads;

# Make sure threads::shared loads.
BEGIN { use_ok('threads::shared') or diag("Can't load threads::shared package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('threads::shared');
use threads::shared;

# Make sure IPTables::ChainMgr loads.
BEGIN { use_ok('IPTables::ChainMgr') or diag("Can't load IPTables::ChainMgr package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IPTables::ChainMgr');
use IPTables::ChainMgr;

diag("About to run extended tests.");
diag("Warning: These tests may alter the host system's firewall.");
diag("As such, Running these tests via a remote session is NOT advised.");
diag("");

my $question = prompt("# Do you want to run extended tests?", "yes");
if ($question !~ /^y.*/i) { exit; }

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Manager::Firewall') or diag("Can't load HoneyClient::Manager::Firewall package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::Firewall');
use HoneyClient::Manager::Firewall;

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

# Include Thread Libraries
use threads;
use threads::shared;

# Include IPTables Libraries
use IPTables::ChainMgr;

# Globally shared variable, containing the 'filter'
# table ruleset to 'deny all'.
our $DENY_ALL_RULES : shared;
$DENY_ALL_RULES = $INIT_FILTER_RULES;

# TODO: Delete this, eventually.
#print $DENY_ALL_RULES . "\n";

END {
    # Upon any shutdown, restore the 'filter' table ruleset back to the
    # 'deny all' default.
    require IPTables::ChainMgr;
    my $chain_mgr = new IPTables::ChainMgr() or
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];

    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/bin/echo "' . $DENY_ALL_RULES . '" | /sbin/iptables-restore');
    if (!$ret) {
        Carp::croak "Error: Unable to restore the original the IPTables 'filter' table ruleset - " . join(' ', @{$err_ar});
    }
}

#######################################################################
# Private Functions                                                   #
#######################################################################

# Helper function designed to 'reset' the 'filter' table to the default
# 'deny all' state.
#
# Inputs: None.
# Outputs: Returns true if successful; croaks otherwise.
sub _clear {
    my $chain_mgr = new IPTables::ChainMgr() or
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];

    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/bin/echo "' . $DENY_ALL_RULES . '" | /sbin/iptables-restore');
    if (!$ret) {
        Carp::croak "Error: Unable to restore the original the IPTables 'filter' table ruleset - " . join(' ', @{$err_ar});
    }
    return $ret;
}


#######################################################################
# Public Functions                                                    #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

=head2 denyAllTraffic()

=over 4

Clears all existing VM-specific chains and denies all future traffic
through the firewall.

I<Inputs>: None.

I<Output>: Returns true if successful; croaks otherwise.

=back

=begin testing

# TODO: Fix this.

eval {
    # Deny all traffic.
    my $result = HoneyClient::Manager::Firewall->denyAllTraffic();

    # Validate the result.
    ok($result, "denyAllTraffic()") or diag("The denyAllTraffic() call failed.");
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub denyAllTraffic {
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

    return _clear();
}

=pod

=head2 allowAllTraffic()

=over 4

Clears all existing VM-specific chains and allows all future traffic
through the firewall.

I<Inputs>: None.

I<Output>: Returns true, if successful; croaks otherwise.

=back

#=begin testing

# TODO: Fix this.

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::Firewall->login();

    # Destroy the session.
    my $result = HoneyClient::Manager::Firewall->logout(session => $session);
    ok($result, "logout()") or diag("The logout() call failed.");
};

# Report any failure found.
if ($@) {
    fail($@);
}

#=end testing

=cut

sub allowAllTraffic {
    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

# TODO: Fix this.

    return 1;
}

=pod

=head2 allowVM(chain_name => $chain_name, mac_address => $mac_address, ip_address => $ip_address, protocol => $protocol, ports => $ports)

=over 4

Updates the firewall to allow the specified client's MAC/IP address to
have limited network connectivity.

I<Inputs>:
 B<$chain_name> is the name of the IPTables chain name to use for this access.
 B<$mac_address> is the client's MAC address.
 B<$ip_address> is the client's IP address.
 B<$protocol> is the allowed protocol for this client.
 B<$ports> is an array reference, containing the list of ports to be allowed.

I<Output>: Returns true, if successful; croaks otherwise.

I<Notes>:
If allowVM() is called multiple times successively, then the previous rules associated
with this chain will be purged.

=back

#=begin testing

# TODO: Fix this.

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::Firewall->login();
   
    # Start the test VM.
    HoneyClient::Manager::Firewall->startVM(session => $session, name => $testVM);

    # Clone the test VM.
    my $cloneVM = undef;
    ($session, $cloneVM) = HoneyClient::Manager::Firewall->fullCloneVM(session => $session, src_name => $testVM);
    ok($cloneVM, "fullCloneVM(src_name => '$testVM')") or diag("The fullCloneVM() call failed.");

    # Get the power state of the clone VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::Firewall->getStateVM(session => $session, name => $cloneVM);

    # The clone VM should be powered on.
    is($state, "poweredon", "fullCloneVM(name => '$testVM')") or diag("The fullCloneVM() call failed.");
   
    # Destroy the clone VM. 
    $session = HoneyClient::Manager::Firewall->destroyVM(session => $session, name => $cloneVM);
    
    # Start the test VM.
    $session = HoneyClient::Manager::Firewall->startVM(session => $session, name => $testVM);
    
    # Stop the test VM.
    $session = HoneyClient::Manager::Firewall->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::Firewall->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

#=end testing

=cut

sub allowVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

# TODO: Fix this.

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

=head2 denyVM(chain_name => $chain_name)

=over 4

Updates the firewall to deny the specified client's network
connectivity by deleting the corresponding chain.

I<Inputs>:
 B<$chain_name> is the name of the IPTables chain name to delete.

I<Output>: Returns true, if successful; croaks otherwise.

=back

#=begin testing

# TODO: Fix this.

eval {
    # Create a new session.
    my $session = HoneyClient::Manager::Firewall->login();
    
    # Start the test VM.
    $session = HoneyClient::Manager::Firewall->startVM(session => $session, name => $testVM);
    ok($session, "startVM(name => '$testVM')") or diag("The startVM() call failed.");

    # Get the power state of the test VM.
    my $state = undef;
    ($session, $state) = HoneyClient::Manager::Firewall->getStateVM(session => $session, name => $testVM);

    # The test VM should be on.
    is($state, "poweredon", "startVM(name => '$testVM')") or diag("The startVM() call failed.");

    # Stop the test VM.
    $session = HoneyClient::Manager::Firewall->stopVM(session => $session, name => $testVM);

    # Destroy the session.
    HoneyClient::Manager::Firewall->logout(session => $session);
};

# Report any failure found.
if ($@) {
    fail($@);
}

#=end testing

=cut

sub denyVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

# TODO: Fix this.
   
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

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 TODO

Develop a 'monitor' capability, in order to detect suspicious network
activity eminating from any of the allowed VMs.  The assumption is that
while malware inside a VM could change the VM's MAC address, VMware will
only allow packets through the network if they match the MAC address
assigned to that VM.  Therefore, all packets coming from the honeyclient
network should correlate with any of the active VMs.

Thus, we need to develop a new call:
checkVM(mac_address => ...), which would

1) check the logs for any suspicious activity
2) if activity is found, then figure out if that VM is responsible
3) if the VM is responsible, return 1; otherwise, return 0

This will require updating the syslog-ng.conf file, in order to
create dedicated logs for 1) IP-to-MAC mappings and 2) Forward block
entries.

=head1 BUGS & ASSUMPTIONS

Upon package inclusion (via 'use' or 'require'), this library assumes
that the host system already has all the necessary static firewall rules
in place in order to 'deny all' VM traffic.  As such, the library saves
the firewall state of the 'filter' table, using the '/sbin/iptables-save'
command.

Then, upon exit or reset, the library restores this state of the 'filter'
table back to the original 'deny all' mode, by using the '/sbin/iptables-restore'
command.

This code assumes that the IPTables 'filter' table on the host system was 
configured using the standared Uncomplicated Firewall (UFW) framework that is
packaged with the Ubuntu Linux distribution.  As such, the code relies
on UFW to have setup and established the basic 'ufw-*' chain names
within the 'filter' table.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

IPTables::ChainMgr

L<http://www.cipherdyne.org/modules/>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Michael Rash E<lt>mbr@cipherdyne.orgE<gt>, for using his
IPTables::ChainMgr code to control IPTables via perl.

=head1 AUTHORS

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
