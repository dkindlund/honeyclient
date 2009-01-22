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

HoneyClient::Manager::Firewall - Perl extension to provide programmatic
access to all IPTables interface on the local system.

=head1 VERSION

This documentation refers to HoneyClient::Manager::Firewall version 1.02.

=head1 SYNOPSIS

  use HoneyClient::Manager::Firewall;

  # To deny all VM-specific traffic.
  if (HoneyClient::Manager::Firewall->denyAllTraffic()) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # To allow all VM-specific traffic.
  if (HoneyClient::Manager::Firewall->allowAllTraffic()) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # To allow specific VM traffic.
  my $chain_name = "1ea37e398a4d1d0314da7bdee8";
  my $mac_address = "00:0c:29:c5:11:c7";
  my $ip_address = "10.0.0.254";
  my $protocol = "tcp";
  my $port = [ 80, 443 ];

  my $result = HoneyClient::Manager::Firewall->allowVM(
      chain_name => $chain_name,
      mac_address => $mac_address,
      ip_address => $ip_address,
      protocol => $protocol,
      port => $port,
  );
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

  # Then, to deny specific VM traffic.
  $result = HoneyClient::Manager::Firewall->denyVM(chain_name => $chain_name);
  if ($result) {
      print "Success!\n";
  } else {
      print "Fail!\n";
  }

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

# Make sure IPTables::ChainMgr loads.
BEGIN { use_ok('IPTables::ChainMgr') or diag("Can't load IPTables::ChainMgr package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('IPTables::ChainMgr');
use IPTables::ChainMgr;

diag("About to run extended tests.");
diag("Warning: These tests may alter the host system's firewall.");
diag("NOTE: The UFW service MUST already be running; if unsure, type '/etc/init.d/ufw restart' as root.");
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

# Include IPTables Libraries
use IPTables::ChainMgr;

# Globally shared variable, containing the 'filter'
# table ruleset to 'deny all'.
our $DENY_ALL_RULES = $INIT_FILTER_RULES;

END {
    # Upon any shutdown, restore the 'filter' table ruleset back to the
    # 'deny all' default.
    require IPTables::ChainMgr;
    my $chain_mgr = new IPTables::ChainMgr();
    if (!defined($chain_mgr)) {
        $LOG->error("Error: Unable to create an IPTables::ChainMgr object.");
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    }
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];

    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/bin/echo "' . $DENY_ALL_RULES . '" | /sbin/iptables-restore');
    if (!$ret) {
        $LOG->error("Error: Unable to restore the original the IPTables 'filter' table ruleset - " . join(' ', @{$err_ar}));
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

    my $chain_mgr = new IPTables::ChainMgr();
    if (!defined($chain_mgr)) {
        $LOG->error("Error: Unable to create an IPTables::ChainMgr object.");
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    }
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];

    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/bin/echo "' . $DENY_ALL_RULES . '" | /sbin/iptables-restore');
    if (!$ret) {
        $LOG->error("Error: Unable to restore the original the IPTables 'filter' table ruleset - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to restore the original the IPTables 'filter' table ruleset - " . join(' ', @{$err_ar});
    }
    return $ret;
}

# Make sure we reset the 'filter' table before exiting -- even on a
# CTRL-C.
$SIG{INT} = sub {
    _clear();
    exit;
};

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

eval {
    # Deny all traffic.
    my $result = HoneyClient::Manager::Firewall->denyAllTraffic();

    # Validate the result.
    ok($result, "denyAllTraffic()") or diag("The denyAllTraffic() call failed.");

    # Restore the default ruleset.
    HoneyClient::Manager::Firewall->_clear();
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub denyAllTraffic {
    # Log resolved arguments.
    $LOG->info(sub {
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

=begin testing

eval {
    # Allow all traffic.
    my $result = HoneyClient::Manager::Firewall->allowAllTraffic();

    # Validate the result.
    ok($result, "allowAllTraffic()") or diag("The allowAllTraffic() call failed.");
    
    # Restore the default ruleset.
    HoneyClient::Manager::Firewall->_clear();
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub allowAllTraffic {
    # Log resolved arguments.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });
    
    my $chain_mgr = new IPTables::ChainMgr();
    if (!defined($chain_mgr)) {
        $LOG->error("Error: Unable to create an IPTables::ChainMgr object.");
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    }
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];

    # Flush all rules in the 'filter' table.
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables -t filter -F');
    if (!$ret) {
        $LOG->error("Error: Unable to allow all traffic - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow all traffic - " . join(' ', @{$err_ar});
    }

    # Delete all custom chains in the 'filter' table.
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables -t filter -X');
    if (!$ret) {
        $LOG->error("Error: Unable to allow all traffic - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow all traffic - " . join(' ', @{$err_ar});
    }

    # Make sure the default policy in the INPUT chain in the 'filter' table is ACCEPT.
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables -t filter -P INPUT ACCEPT');
    if (!$ret) {
        $LOG->error("Error: Unable to allow all traffic - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow all traffic - " . join(' ', @{$err_ar});
    }

    # Make sure the default policy in the OUTPUT chain in the 'filter' table is ACCEPT.
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables -t filter -P OUTPUT ACCEPT');
    if (!$ret) {
        $LOG->error("Error: Unable to allow all traffic - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow all traffic - " . join(' ', @{$err_ar});
    }
    
    # Make sure the default policy in the FORWARD chain in the 'filter' table is ACCEPT.
    ($ret, $out_ar, $err_ar) = $chain_mgr->run_ipt_cmd('/sbin/iptables -t filter -P FORWARD ACCEPT');
    if (!$ret) {
        $LOG->error("Error: Unable to allow all traffic - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow all traffic - " . join(' ', @{$err_ar});
    }
    return $ret;
}

=pod

=head2 allowVM(chain_name => $chain_name, mac_address => $mac_address, ip_address => $ip_address, protocol => $protocol, port => $port)

=over 4

Updates the firewall to allow the specified client's MAC/IP address to
have limited network connectivity.

I<Inputs>:
 B<$chain_name> is the name of the IPTables chain name to use for this access.
 B<$mac_address> is the client's MAC address.
 B<$ip_address> is the client's IP address.
 B<$protocol> is the protocol to be allowed.
 B<$port> is an array reference, containing the list of ports to be allowed.

I<Output>: Returns true, if successful; croaks otherwise.

I<Notes>:
If allowVM() is called multiple times successively, then the previous rules associated
with this chain will be purged.

=back

=begin testing

eval {
    # Allow VM traffic.
    my $chain_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address = "00:0c:29:c5:11:c7";
    my $ip_address = "10.0.0.254";
    my $protocol = "tcp";
    my $port = [ 80, 443 ];

    my $result = HoneyClient::Manager::Firewall->allowVM(
        chain_name => $chain_name,
        mac_address => $mac_address,
        ip_address => $ip_address,
        protocol => $protocol,
        port => $port,
    );

    # Validate the result.
    $Data::Dumper::Terse = 1;
    $Data::Dumper::Indent = 0;
    ok($result, "allowVM(chain_name => '$chain_name', mac_address => '$mac_address', ip_address => '$ip_address', protocol => '$protocol', port => '" . Dumper($port) . "')") or diag("The allowVM() call failed.");

    # Restore the default ruleset.
    HoneyClient::Manager::Firewall->_clear();
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub allowVM {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'chain_name'}) ||
        !defined($args{'chain_name'})) {
        $LOG->error("Error allowing VM network - no chain name specified.");
        Carp::croak "Error allowing VM network - no chain name specified.";
    }

    if (!exists($args{'mac_address'}) ||
        !defined($args{'mac_address'})) {
        $LOG->error("Error allowing VM network - no MAC address specified.");
        Carp::croak "Error allowing VM network - no MAC address specified.";
    }

    if (!exists($args{'ip_address'}) ||
        !defined($args{'ip_address'})) {
        $LOG->error("Error allowing VM network - no IP address specified.");
        Carp::croak "Error allowing VM network - no IP address specified.";
    }

    if (!exists($args{'protocol'}) ||
        !defined($args{'protocol'})) {
        $LOG->error("Error allowing VM network - no protocol specified.");
        Carp::croak "Error allowing VM network - no protocol specified.";
    }

    if (!exists($args{'port'}) ||
        !defined($args{'port'})) {
        $LOG->error("Error allowing VM network - no port specified.");
        Carp::croak "Error allowing VM network - no ports specified.";
    }


    my $chain_mgr = new IPTables::ChainMgr();
    if (!defined($chain_mgr)) {
        $LOG->error("Error: Unable to create an IPTables::ChainMgr object.");
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    }

    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];
    my $rule_num = 0;
    my $num_rules_in_chain = 0;

    # Check to see if the custom chain already exists.
    ($ret, $out_ar, $err_ar) = $chain_mgr->chain_exists('filter', $args{'chain_name'});
    if ($ret) {

        # Delete the JUMP rule in our FORWARD chain, so that there's no interruption
        # in connectivity for other traffic.
        ($rule_num, $num_rules_in_chain) = $chain_mgr->find_ip_rule("0.0.0.0/0",
                                                                    "0.0.0.0/0",
                                                                    'filter',
                                                                    'FORWARD',
                                                                    $args{'chain_name'},
                                                                    {});
        # If our JUMP rule already exists, then delete it.
        if ($rule_num) {
            ($ret, $out_ar, $err_ar) = $chain_mgr->delete_ip_rule("0.0.0.0/0",
                                                                  "0.0.0.0/0",
                                                                  'filter',
                                                                  'FORWARD',
                                                                  $args{'chain_name'},
                                                                  {});
            if (!$ret) {
                $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
                Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
            }
        }

        # Chain exists, so flush it.
        ($ret, $out_ar, $err_ar) = $chain_mgr->flush_chain('filter', $args{'chain_name'});
        if (!$ret) {
            $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
            Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
        }
    } else {
        # Chain doesn't exist, so create it.
        ($ret, $out_ar, $err_ar) = $chain_mgr->create_chain('filter', $args{'chain_name'});
        if (!$ret) {
            $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
            Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
        }
    }

    # Create a single incoming rule in this chain.
    ($ret, $out_ar, $err_ar) = $chain_mgr->append_ip_rule("0.0.0.0/0",
                                                          $args{'ip_address'},
                                                          'filter',
                                                          $args{'chain_name'},
                                                          "ACCEPT",
                                                          { 'protocol'   => $args{'protocol'}, });
    if (!$ret) {
        $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
    }

    # For each port number listed...
    foreach my $port (@{$args{'port'}}) {

        # Create a new outgoing rule in the chain.
        ($ret, $out_ar, $err_ar) = $chain_mgr->append_ip_rule($args{'ip_address'},
                                                              "0.0.0.0/0",
                                                              'filter',
                                                              $args{'chain_name'},
                                                              "ACCEPT",
                                                              { 'protocol'   => $args{'protocol'},
                                                                'd_port'     => $port, 
                                                                'mac_source' => $args{'mac_address'}, }
        );
        if (!$ret) {
            $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
            Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
        }
    }

    # Allow the VM to ping any remote host, in order to signify to the VM that it has network connectivity.
    ($ret, $out_ar, $err_ar) = $chain_mgr->append_ip_rule($args{'ip_address'},
                                                          "0.0.0.0/0",
                                                           'filter',
                                                           $args{'chain_name'},
                                                           "ACCEPT",
                                                            { 'protocol'   => "icmp",
                                                              'mac_source' => $args{'mac_address'}, }
    );
    if (!$ret) {
        $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
    }
    
    # Allow any host to reply to VM pings, in order to signify to the VM that it has network connectivity.
    ($ret, $out_ar, $err_ar) = $chain_mgr->append_ip_rule("0.0.0.0/0",
                                                          $args{'ip_address'},
                                                           'filter',
                                                           $args{'chain_name'},
                                                           "ACCEPT",
                                                            { 'protocol'   => "icmp", }
    );
    if (!$ret) {
        $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
        Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
    }

    # Once the chain has been created, then link the chain to our standard FORWARD chain.
    ($rule_num, $num_rules_in_chain) = $chain_mgr->find_ip_rule("0.0.0.0/0",
                                                                "0.0.0.0/0",
                                                                'filter',
                                                                'FORWARD',
                                                                $args{'chain_name'},
                                                                {});

    # If our JUMP rule does not already exist, then add it to the second position of the FORWARD chain (UFW-specific).
    if (!$rule_num) {
        ($ret, $out_ar, $err_ar) = $chain_mgr->add_jump_rule('filter',
                                                             'FORWARD',
                                                             2,
                                                             $args{'chain_name'});
        if (!$ret) {
            $LOG->error("Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
            Carp::croak "Error: Unable to allow VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
        }
    }

    return (1);
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

=begin testing

eval {
    # Allow VM traffic.
    my $chain_name = "1ea37e398a4d1d0314da7bdee8";
    my $mac_address = "00:0c:29:c5:11:c7";
    my $ip_address = "10.0.0.254";
    my $protocol = "tcp";
    my $port = [ 80, 443 ];

    HoneyClient::Manager::Firewall->allowVM(
        chain_name => $chain_name,
        mac_address => $mac_address,
        ip_address => $ip_address,
        protocol => $protocol,
        port => $port,
    );

    # Then, deny VM traffic.
    my $result = HoneyClient::Manager::Firewall->denyVM(chain_name => $chain_name);

    # Validate the result.
    $Data::Dumper::Terse = 1;
    $Data::Dumper::Indent = 0;
    ok($result, "denyVM(chain_name => '$chain_name')") or diag("The denyVM() call failed.");
    
    # Restore the default ruleset.
    HoneyClient::Manager::Firewall->_clear();
};

# Report any failure found.
if ($@) {
    fail($@);
}

=end testing

=cut

sub denyVM {
    # Extract arguments.    
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->info(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check the arguments.
    if (!scalar(%args) ||
        !exists($args{'chain_name'}) ||
        !defined($args{'chain_name'})) {
        $LOG->error("Error denying VM network - no chain name specified.");
        Carp::croak "Error denying VM network - no chain name specified.";
    }


    my $chain_mgr = new IPTables::ChainMgr();
    if (!defined($chain_mgr)) {
        $LOG->error("Error: Unable to create an IPTables::ChainMgr object.");
        Carp::croak "Error: Unable to create an IPTables::ChainMgr object.\n";
    }
    my $ret = 0;
    my $out_ar = [];
    my $err_ar = [];
    my $rule_num = 0;
    my $num_rules_in_chain = 0;

    # Check to see if the custom chain already exists and delete only if it exists.
    ($ret, $out_ar, $err_ar) = $chain_mgr->chain_exists('filter', $args{'chain_name'});
    if ($ret) {
        # Delete the JUMP rule in our FORWARD chain, so that there's no interruption
        # in connectivity for other traffic.
        ($rule_num, $num_rules_in_chain) = $chain_mgr->find_ip_rule("0.0.0.0/0",
                                                                    "0.0.0.0/0",
                                                                    'filter',
                                                                    'FORWARD',
                                                                    $args{'chain_name'},
                                                                    {});

        # If our JUMP rule already exists, then delete it.
        if ($rule_num) {
            ($ret, $out_ar, $err_ar) = $chain_mgr->delete_ip_rule("0.0.0.0/0",
                                                                  "0.0.0.0/0",
                                                                  'filter',
                                                                  'FORWARD',
                                                                  $args{'chain_name'},
                                                                  {});
            if (!$ret) {
                $LOG->error("Error: Unable to deny VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
                Carp::croak "Error: Unable to deny VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
            }
        }

        # Chain exists, so flush it and then delete it.
        ($ret, $out_ar, $err_ar) = $chain_mgr->flush_chain('filter', $args{'chain_name'});
        if (!$ret) {
            $LOG->error("Error: Unable to deny VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
            Carp::croak "Error: Unable to deny VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
        }
        ($ret, $out_ar, $err_ar) = $chain_mgr->delete_chain('filter', 'FORWARD', $args{'chain_name'});
        if (!$ret) {
            $LOG->error("Error: Unable to deny VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar}));
            Carp::croak "Error: Unable to deny VM traffic for chain (" . $args{'chain_name'} . ") - " . join(' ', @{$err_ar});
        }
    }
    return (1);  
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
