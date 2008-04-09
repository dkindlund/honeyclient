#!perl -Ilib

# $Id$

use strict;
use warnings;
use Carp ();

use Term::ReadKey;
use HoneyClient::Util::Config qw(getVar);
use HoneyClient::Agent;
use HoneyClient::Util::SOAP qw(getClientHandle);
use Data::Dumper;
use MIME::Base64 qw(decode_base64 encode_base64);
use Storable qw(thaw nfreeze);
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

our ($stub, $som);
our $URL = HoneyClient::Agent->init();

print "URL: " . $URL. "\n";

# Halt when we get any sort of keyboard input.
my $key;
ReadMode 4; # Turn off controls keys
while (not defined ($key = ReadKey(-1))) {
    # No key yet
}
ReadMode 0; # Reset tty mode before exiting

HoneyClient::Agent->destroy();
