#!/usr/bin/perl -w

##################################################################################################
# Created on: 	February 27th, 2006
# Package:    	HoneyClient::Manager::Firewall::FW
# File:       	startHCFW.pl
# Description:	A perl script to start the honeyclient firewall listener.  It initially loads the default
#               firewall ruleset and listens for remote calls from the overall manager.
# @author jdurick
##################################################################################################

use strict;
use warnings;
use Test::More 'no_plan';
use Data::Dumper;
my $VERSION = 0.2;

# Make sure HoneyClient::Util::Config loads properly
BEGIN { use_ok("HoneyClient::Util::Config"), or diag("Can't load HoneyClient::Util::Config package. Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
use HoneyClient::Util::Config qw(getVar);

# Make sure IPTables::IPv4 loads
BEGIN { use_ok("IPTables::IPv4"), or diag("Can't load IPTables::IPv4 package. Check to make sure the package library is correctly listed within the path."); }
require_ok('IPTables::IPv4');
use IPTables::IPv4;

# Make sure HoneyClient::Manager::Firewall::FW can load
BEGIN { use_ok("HoneyClient::Manager::FW"), or diag("Can't load HoneyClient::Manager::FW package. Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Manager::FW');
use HoneyClient::Manager::FW;

# Make sure HoneyClient::Util::SOAP loads properly
BEGIN { use_ok("HoneyClient::Util::SOAP"), or diag("Can't load HoneyClient::Util::SOAP packa
ge. Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');

package HoneyClient::Manager::FW;
use HoneyClient::Util::SOAP qw(getClientHandle getServerHandle);
my $daemon = getServerHandle();
$daemon->handle;
