#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Agent') or diag("Can't load HoneyClient::Agent package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent');
can_ok('HoneyClient::Agent', 'init');
can_ok('HoneyClient::Agent', 'destroy');
use HoneyClient::Agent;

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getServerHandle getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getServerHandle');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getServerHandle getClientHandle);

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# TODO: Include FF
# Make sure HoneyClient::Agent::Driver::Browser::IE loads.
BEGIN { use_ok('HoneyClient::Agent::Driver::Browser::IE') or diag("Can't load HoneyClient::Agent::Driver::Browser::IE package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent::Driver::Browser::IE');
# TODO: Update this list of function names.
can_ok('HoneyClient::Agent::Driver::Browser::IE', 'new');
can_ok('HoneyClient::Agent::Driver::Browser::IE', 'drive');
can_ok('HoneyClient::Agent::Driver::Browser::IE', 'getNextLink');
can_ok('HoneyClient::Agent::Driver::Browser::IE', 'next');
can_ok('HoneyClient::Agent::Driver::Browser::IE', 'isFinished');
can_ok('HoneyClient::Agent::Driver::Browser::IE', 'status');
use HoneyClient::Agent::Driver::Browser::IE;

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(freeze nfreeze thaw dclone)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'freeze');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
can_ok('Storable', 'dclone');
use Storable qw(freeze nfreeze thaw dclone);

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

#XXX: Check to see if the port number should be externalized.
# Global test variables.
our $PORT = getVar(name      => "port",
                   namespace => "HoneyClient::Agent");
our ($stub, $som);
}



# =begin testing
{
# XXX: Test init() method.
our $URL = HoneyClient::Agent->init();
our $PORT = getVar(name      => "port", 
                   namespace => "HoneyClient::Agent");
our $HOST = getVar(name      => "address",
                   namespace => "HoneyClient::Agent");
is($URL, "http://$HOST:$PORT/HoneyClient/Agent", "init()") or diag("Failed to start up the VM SOAP server.  Check to see if any other daemon is listening on TCP port $PORT.");
}



# =begin testing
{
# XXX: Test destroy() method.
is(HoneyClient::Agent->destroy(), 1, "destroy()") or diag("Unable to terminate Agent SOAP server.  Be sure to check for any stale or lingering processes.");

# TODO: delete this.
#exit;
}




1;
