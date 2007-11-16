#!perl -w -Ilib

# $Id$

use strict;
use warnings;
use Carp ();

# Include Dumper Library
use Data::Dumper;

# Include Hash Serialization Utility Libraries
use Storable qw(nfreeze thaw);

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Include Getopt Parser
use Getopt::Long;

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);

# Include Manager Library
use HoneyClient::Manager;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# We expect that the user will supply a single argument to this script.
# Namely, the initial set of URLs that they want the Agent to use.

# Change to 'HoneyClient::Agent::Driver::Browser::IE' or
#           'HoneyClient::Agent::Driver::Browser::FF'
my $driver = undef;
my $config = undef;
my $maxrel = undef;
my $nexturl = "";
my $urllist= "";

# TODO: Need --help option, along with sanity checking.
# TODO: Also need a decent POD for this code.
GetOptions('driver=s'             => \$driver,
           'master_vm_config=s'   => \$config,
           'url_list=s'           => \$urllist,
           'max_relative_links:i' => \$maxrel);

# Sanity Check.  Make sure $driver is set.
unless (defined($driver)) {
    $driver = getVar(name      => "default_driver",
                     namespace => "HoneyClient::Agent");
}

# Sanity Check.  Make sure $max_relative_links is set.
unless (defined($maxrel)) {
    $maxrel = getVar(name      => "max_relative_links_to_visit",
                     namespace => "HoneyClient::Agent::Driver::Browser");
}

# Go through the list of urls to create the array
# Anything not associated with an option is a URL
# Grab those first and then get the ones from the file specified
my @urls;
push( @urls, @ARGV ); 
if( -e $urllist ){
    open URL, $urllist;
    push(@urls, <URL>);
}

# Get the first url from the list
# Create a hashtable in the form: url => 1 for links_to_visit 
chomp @urls;
my $firsturl = shift @urls;
my %remaining_urls;
foreach(@urls){
    # We assign our initial list of URLs a priority of 1000, so that
    # they'll be (likely to be) selected first, before going to any other
    # external URLs found from subsequent drive operations.
    $remaining_urls{$_} = 1000;
}

my $agentState = HoneyClient::Manager->run(
                    driver           => $driver,
                    master_vm_config => $config,
                    agent_state      => encode_base64(nfreeze({
                        $driver => {
                            next_link_to_visit => $firsturl,
                            max_relative_links_to_visit => $maxrel,
                            links_to_visit => \%remaining_urls,
                         },
                    })), 
                 );

