#!/usr/bin/perl -w

use strict;
use warnings;
use Carp ();

use Data::Dumper;

# Include Hash Serialization Utility Libraries
use Storable qw(nfreeze thaw);

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

use HoneyClient::Manager;

# We expect that the user will supply a single argument to this script.
# Namely, the initial URL that they want the Agent to use.

my $agentState = HoneyClient::Manager->run(
                    driver           => 'IE', # Change to 'IE' or 'FF'
                    master_vm_config => '/vm/Agent.Master-2/winXPPro.cfg',
                    agent_state      => encode_base64(nfreeze({
                        IE => { # Change to 'IE' or 'FF'
                            next_link_to_visit => $ARGV[0],
                            # Enable this line, if you want to only go to the
                            # first 5 links for each domain.
                            #max_relative_links_to_visit => 5,
                         },
                    })), 
                 );

