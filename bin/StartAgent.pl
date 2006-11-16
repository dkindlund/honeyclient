#!perl -w

use strict;
use warnings;
use Carp ();

use HoneyClient::Agent;
use HoneyClient::Util::SOAP qw(getClientHandle);
use Data::Dumper;
use MIME::Base64 qw(decode_base64 encode_base64);
use Storable qw(thaw nfreeze);

our ($stub, $som);
our $URL = HoneyClient::Agent->init();

our $agentState = undef;
my $tempState = undef;

print "URL: " . $URL. "\n";

sub _watchdogFaultHandler {

    # Extract arguments.
    my ($class, $res) = @_;

    # Construct error message.
    # Figure out if the error occurred in transport or over
    # on the other side.
    my $errMsg = $class->transport->status; # Assume transport error.

    if (ref $res) {
        $errMsg = $res->faultcode . ": ".  $res->faultstring . "\n";
    }

    print "Watchdog fault detected, recovering Agent daemon.\n";
    # XXX: Reenable this, eventually.
#    Carp::carp __PACKAGE__ . "->_watchdogFaultHandler(): Error occurred during processing.\n" . $errMsg;


    # Regardless of the error, destroy the Agent process and reinitialize it.
    # XXX: Sanity check this, eventually.
    HoneyClient::Agent->destroy();

    $URL = HoneyClient::Agent->init();

    # Restore state information.
    $som = $stub->updateState(encode_base64(nfreeze($agentState)));
}

$stub = getClientHandle(address   => 'localhost',
                        namespace => 'HoneyClient::Agent',
                        fault_handler => \&_watchdogFaultHandler);
                
for (;;) {
    # TODO: Make this a programmatic value.
    sleep (5);
    $som = $stub->getState();
    if (defined($som) and (ref($som) eq "SOAP::SOM")) {
        $tempState = $som->result();
        if (defined($tempState)) {
            # Make sure the new state is parsable, before saving it.
            eval {
                $tempState = thaw(decode_base64($tempState));
            };
            if (!$@) {
                $agentState = $tempState;
            }
        }
    }
}

HoneyClient::Agent->destroy();
