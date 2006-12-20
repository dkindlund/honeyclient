###############################################################################
# Created on:  May 11, 2006
# Package:     HoneyClient::Agent::Driver::FF
# File:        FF.pm
# Description: A specific driver for automating an instance of
#              the Firefox browser, running inside a
#              HoneyClient VM.
#
# @author knwang, xkovah, kindlund, ttruong
#
# Copyright (C) 2006 The MITRE Corporation.  All rights reserved.
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
###############################################################################

package HoneyClient::Agent::Driver::FF;

# XXX: Disabled version check, Honeywall does not have Perl v5.8 installed.
#use 5.008006;
use strict;
use warnings;
use Carp ();
use Config;
use Win32::Job;          #For starting browser
use HTML::LinkExtor;     #For extracting links from HTML
use HTML::HeadParser;    #For extracting the meta w/ URL that LinkExtor misses
use LWP::UserAgent;      #Perl-based "browser"
use URI;                 #For absolutizing relative URLs
#use Data::Dumper;		 #For Debugging

# Traps signals, allowing END: blocks to perform cleanup.
use sigtrap qw(die untrapped normal-signals error-signals);

###############################################################################
# Module Initialization                                                       #
###############################################################################

BEGIN {

	# Defines which functions can be called externally.
	require Exporter;
	our ( @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION );

	# Set our package version.
	$VERSION = 0.9.2;

	# Define inherited modules.
	use HoneyClient::Agent::Driver;

	@ISA = qw(Exporter HoneyClient::Agent::Driver);

	# Symbols to export on request
	# Note: Since this module is object-oriented, we do *NOT* export
	# any functions other than "new" to call statically.  Each function
	# for this module *must* be called as a method from a unique
	# object instance.
	@EXPORT = qw();

	# Items to export into callers namespace by default. Note: do not export
	# names by default without a very good reason. Use EXPORT_OK instead.
	# Do not simply export all your public functions/methods/constants.

	# This allows declaration use HoneyClient::Agent::Driver::FF ':all';
	# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
	# will save memory.

	# Note: Since this module is object-oriented, we do *NOT* export
	# any functions other than "new" to call statically.  Each function
	# for this module *must* be called as a method from a unique
	# object instance.
	%EXPORT_TAGS = ( 'all' => [qw()], );

	# Symbols to autoexport (:DEFAULT tag)
	@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

	$SIG{PIPE} = 'IGNORE';    # Do not exit on broken pipes.
}
our ( @EXPORT_OK, $VERSION );

###############################################################################

# Include the Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Use ISO 8601 DateTime Libraries
use DateTime::HiRes;

# Use Storable Library
use Storable qw(dclone);

my %PARAMS = (

	# This is a hashtable of fully qualified URLs
	# to visit by the browser.  Specifically, the 'key' is
	# the absolute URL and the 'value' is always 1.
	links_to_visit => {},

	# This is a hashtable of fully qualified URLs that the
	# browser has already visited.  Specifically, the
	# 'key' is the absolute URL and the 'value' is a string
	# representing the date and time of when the link was visited.
	#
	# Note: See _getTimestamp() for the corresponding date/time
	# format.
	links_visited => {},

	# This is a hashtable of URLs that the browser has found
	# during its traversal process, but the browser could not
	# access the link.
	#
	# Links could be added to this list if access requires any type of
	# authentication, or if the link points to a non-HTTP or HTTPS
	# resource (i.e., "javascript:doNetDetect()").
	#
	# The 'key' is the absolute URL and the 'value' is a string
	# representing the date and time of when the link was visited.
	#
	# Note: See _getTimestamp() for the corresponding date/time
	# format.
	links_ignored => {},

	# This is a hashtable of fully qualified URLs
	# that all share a common *hostname*.  This hashtable should be
	# initially empty.  As the driver extracts and removes new URLs
	# off the 'links_to_visit' hashtable, driving the browser to each URL,
	# any *relative* links found are added into this hashtable; any
	# *external* links found are added back into the 'links_to_visit'
	# hashtable.
	#
	# When navigating to the next link, this hashtable is exhausted prior
	# to the main 'links_to_visit' hashtable.  This allows a
	# browser to navigate to all links hosted on the same server, prior
	# to contacting a different server.
	#
	# Specifically, the 'key' is the absolute URL and the 'value'
	# is always 1.
	relative_links_to_visit => {},

	# This is a scalar that contains the next URL to visit.
	# It is updated dynamically, any time _dep_getNextLink() is called.
	# When the browser is ready to drive to the next link,
	# 'next_link_to_visit' is checked.  If that value is undef, then
	# the 'relative_links_to_visit' hashtable is checked next.
	# If that hashtable is empty, then finally the 'links_to_visit'
	# hashtable is checked.
	next_link_to_visit => undef,

	# This is a hashtable of URLs that the browser has found
	# during its traversal process, but the browser could not
	# access the resource due to the operation timing out.
	#
	# The 'key' is the absolute URL and the 'value' is a string
	# representing the date and time of when the link was visited.
	#
	# Note: See _getTimestamp() for the corresponding date/time
	# format.
	links_timed_out => {},

	# Absolute path to firefox executable. Needs to be in Windows
	# path format not Cygwin, because it's used in Win32::Job
	ff_exec => getVar(name => "ff_exec"),

	# Hashtable used to hold hostnames and ports for any other sites which may
	# need to be looked up (for instance external image URLs)
	# Entries are in the form
	# {hostname => port, ...}
	hosts_to_resolve => {},

	# A switch which can be turned off (set to 0) to decide NOT to drive ff
	# to a particularly instance of a URL. For instance because the URL in
	# question actually redirects somewhere else and you don't want to get
	# a false positive on the firewall.
	drive_ff => 0,

	# Because the FF.pm drive() function actually uses the perl LWP::UserAgent
	# to actually process a page and find links, there are actually two things
	# going on inside this function. Because of the interaction between next()
	# and drive() it is therefore necessary to pop back out of the drive()
	# after it's got the links but before it drives ff, so that the data can
	# be used by next() and given back to the firewall before it drives ff.
	# This toggle lets every other instance of drive() either use the
	# LWP::UserAgent or Firefox.
	flip_flop => 0,

    # An integer, representing how many relative links the browser
    # should continue to drive to, before moving onto another
    # website.  If negative, then the browser will exhaust all possible
    # relative links, before moving on.  (This internal variable should
    # never be modified externally.)
	max_relative_links_to_visit => getVar(name => "max_relative_links_to_visit"),

	# NOTE: Don't delete me unless you delete max_relative_links_to_visit
	# An integer, representing the maximum number of relative links that
    # the browser should visit, before moving onto another website.  If
    # negative, then the browser will exhaust all possible relative links
    # found, before moving on.  This functionality is best effort; it's
    # possible for the browser to visit new links on previously visited
    # websites.
	_remaining_number_of_relative_links_to_visit => getVar(name => "max_relative_links_to_visit"),
	
    #COPY DARIEN'S COMMENTS! YAY! (or not, boo!))
    _next_connections => {},

    #This is here so that it doesn't have to do a getVar every time it wants to run 
    # the LWP stuff. Can maybe be moved into the big datastructure.
    http_proxy => getVar(name => "http_proxy"), 

);

###############################################################################
# Private Methods Implemented                                                 #
###############################################################################

# Helper function designed to retrieve the next link for the browser
# to navigate to.
#
# Note: Calling this function will implicitly remove the next link from
#       any and all applicable hashtables/scalars.
#
# When getting the next link, 'next_link_to_visit' is checked first.
# If that value is undef, then the 'relative_links_to_visit' hashtable
# is checked next.  If that hashtable is empty, then finally the
# 'links_to_visit' hashtable is checked.
#
# Inputs: HoneyClient::Agent::Driver::FF object
# Outputs: link, or undef if all applicable scalars/hashtables are empty
sub _getNextLink {

	# Get the object state.
	my $self = shift;

	# Set the link to find as undef, initially.
	my $link = undef;

	while ( !defined($link) or ($link eq "") ) {

		# Try getting the next link from the next link
		# scalar.
		$link = $self->next_link_to_visit;
		$self->{next_link_to_visit} = undef;

		# If the next link scalar is empty, try
		# getting a link from the relative hashtable.
		unless ( defined($link) ) {
			$link = _pop( $self->relative_links_to_visit );
		}

		# If the relative hashtable is empty, try getting one
		# from the external hashtable.
		unless ( defined($link) ) {
			$link = _pop( $self->links_to_visit );
		}

		# If all hashtables/scalars were empty, immediately return an
		# undef value.
		unless ( defined($link) ) {
			return $link;
		}

		# Now, make sure the link is valid, before we return
		# it; if it's not valid, we simply move on to the next
		# one in our hashtables.
		#$link = $self->_validateLink($link);
	}

	# Return the next link found.
	return $link;
}
###############################################################################

# Helper function designed to get a current timestamp from
# the system OS.
#
# Note: This timestamp is in ISO 8601 format.
#
# Inputs: none
# Outputs: timestamp
sub _getTimestamp {
	my $dt = DateTime::HiRes->now();
	return $dt . "." . $dt->nanosecond();
}
###############################################################################
# Helper function designed to "pop" a key off a given hashtable.
# When given a hashtable reference, this function will extract a valid key
# from the hashtable and delete the (key, value) pair from the
# hashtable.
#
# Note: There is no guaranteed order about how this function picks
# keys from the hashtable.
#
# Inputs: hashref
# Outputs: valid key, or undef if the hash is empty
sub _pop {

	# Get supplied hash reference.
	my $hash = shift;

	# Get a new key.
	my @keys = keys( %{$hash} );
	my $key  = pop(@keys);

	# Delete the key from the hashtable.
	if ( defined($key) ) {
		delete $hash->{$key};
	}
##	print "in pop " . Dumper($hash);

	# Return the key found.
	return $key;
}

###############################################################################

# Helper function, designed to extract the hostname
# (and, if it exists, the port number) from a given
# URL.
#
# For example, if "http://hostname.com:80/path/index.html"
# is given, then "hostname:80" would be returned.
#
# Inputs: URL
# Outputs: hostname[:port]
sub _extractHostname {

    # Sanity check.
    my $arg = shift();

    if (!defined($arg)) {
        return "";
    }

	# Get the URL supplied.
	my $url = $arg;

	# Note: The '?' chars make a critical difference
	# in how this regex operates.
	$url =~ s/.*?\/\/(.*?)\/.*/$1/;

	# Return the extracted hostname.
	return $url;
}
###############################################################################

# Helper function, designed to process all links found at a
# given URL, once the browser has been driven to that URL
# and has collected all corresponding links.
#
# When supplied with the array of URLs
# this function will categorize them
# as follows:
#
# "New" links are those we've never driven the browser to.
# "Old" links are those we've driven the browser to before.
#
# - If a link is new and "invalid", then it gets added to
#   the 'links_ignored' hashtable.
#
# - If a link is old and "invalid", then it gets
#   ignored.
#
# - If a link is old and "valid", then it gets ignored.
#
# - If a link is new and "valid", then we check to see if
#   the referring URL's hostname[:port] and the link's
#   hostname[:port] match.  If they match, then the link
#   is added to the 'relative_links_to_visit' hash.
#   Otherwise, the link is added to the 'links_to_visit'
#   hash.
#
# Inputs: HoneyClient::Agent::Driver::FF object,
#         referring URL,
#         array of LinkExtor link arrays
# Outputs: HoneyClient::Agent::Driver::FF object

sub _processLinks {

	# Get the object state.
	my $self = shift;

	# Get the referrer and the corresponding array of links.
	my ( $base_url, @links ) = @_;

	# Sanity check: Make sure we've been fed an object.
	unless ( ref($self) ) {
		Carp::croak "Error: Function must be called in reference to a "
		  . __PACKAGE__
		  . "->new() object!\n";
	}

	foreach my $link (@links) {

		#format of this array (pointed to by the $link ref) is
		# like ("img", "src", "$url") or ("a", "href", "$url")

		#skip some link types for now
		if (   @{$link}[0] eq "form"
			|| @{$link}[0] eq "input"
			|| @{$link}[0] eq "script"
			|| @{$link}[0] eq "td"
			|| @{$link}[0] eq "table" )
		{
			next;
		}

	#Need to put these in a bucket so the firewall knows to allow access to them
		if (   @{$link}[0] eq "img"
			|| @{$link}[0] eq "object"
			|| @{$link}[0] eq "embed" )
		{

			# lazy way, just absolutize right away incased it's a relative URL
			# this should catch any time a base href is actually used
			my $tmp_hn =
			  _extractHostname( URI->new_abs( "@{$link}[2]", "$base_url" ) );
##			print "@{$link}[0] @{$link}[2] $tmp_hn\n";
			my $tmp_port;

	#if it already has a port appended use that, otherwise set it to the default
			if ( $tmp_hn =~ /.*?:(.*)/ ) {
				$tmp_port = $1;
			}
			else {

				#Can you have image links to other protocols?
				#if(@{$link}[2] =~ /^ftp/) {$tmp_port = 21;}
				if ( @{$link}[2] =~ /^http/ )  { $tmp_port = 80; }
				if ( @{$link}[2] =~ /^https/ ) { $tmp_port = 443; }
				else { $tmp_port = 80; }
			}
			if(!exists($self->{hosts_to_resolve}{$tmp_hn})){
				$self->{hosts_to_resolve}{$tmp_hn} = $tmp_port;
				print "adding $tmp_hn to hosts_to_resolve bucket in _processLinks\n";
			}
			
			next;

		}

		if (   @{$link}[0] ne "a"
			&& @{$link}[0] ne "link"
			&& @{$link}[0] ne "area"
			&& @{$link}[0] ne "iframe" )
		{
			print "new type of link!: @{$link}\n";
			$self->links_ignored->{ @{$link}[2] } = _getTimestamp();
			next;
		}

		#strip anchors
		@{$link}[2] =~ s/\#.*//;

		#trying to avoid links already in the buckets
		if (   $self->_preexisting( @{$link}[2] )
			|| @{$link}[2]    eq $self->next_link_to_visit
			|| "@{$link}[2]/" eq $self->next_link_to_visit )
		{
			next;
		}

		#		print "@{$link}\n";

	   #starts with http(s)://
	   # Check to make sure it's not an absolute link to a site we're already on
	   # The second case of the if() is "the slashdot exception" ;)
		if ( @{$link}[2] =~ /^http[s]?:\/\//i || @{$link}[2] =~ /^\/\//i ) {
			my $tmp_url;
			if ( _extractHostname( @{$link}[2] ) eq
				_extractHostname( $self->{next_link_to_visit} ) )
			{
                # URI->new_abs() will never return undef; however,
                # it could die if invalid parameters are supplied.
				$tmp_url = URI->new_abs( "@{$link}[2]", "$base_url" );
				$self->relative_links_to_visit->{$tmp_url} = 1;
				next;
			}
			else {
                # URI->new_abs() will never return undef; however,
                # it could die if invalid parameters are supplied.
				$tmp_url = URI->new_abs( "@{$link}[2]", "$base_url" );
				$self->links_to_visit->{$tmp_url} = 1;
				next;
			}
		}

		#ignore mailto and javascript links
		if (   @{$link}[2] =~ /^mailto/
			|| @{$link}[2] =~ /;$/
			|| @{$link}[2] =~ /^javascript:/ )
		{
			$self->links_ignored->{ @{$link}[2] } = _getTimestamp();
			next;
		}

	   #ignore any other URI types for now since we've already got http(s) links
		if ( @{$link}[2] =~ /^\w*:\/\// ) {
			$self->links_ignored->{ @{$link}[2] } = _getTimestamp();
			next;
		}

	   #From here on out it should be a relative link, so first we absolutize it
        # URI->new_abs() will never return undef; however,
        # it could die if invalid parameters are supplied.
		my $uri = URI->new_abs( "@{$link}[2]", "$base_url" );

	  # Then we check to make sure the absolute link isn't a variant of the page
	  # we got it from, and not already visited
		if (   $uri ne $base_url
			&& $uri    ne "$base_url/"
			&& $uri    ne $self->next_link_to_visit
			&& "$uri/" ne $self->next_link_to_visit )
		{

			if ( !$self->_preexisting($uri) ) {

#				print "2 adding (formerly) relative link $uri to the relative links to visit\n";
				$self->relative_links_to_visit->{$uri} = 1;
			}
		}

	}

	# Return the modified object state.
	return $self;
}

###############################################################################

# returns 1 if a URI exists somewhere in the buckets
# otherwise returns 0

# All the commented out code is related to whether we should test for the
# existence of a link that is the same as the current link except possibly
# having or missing a trailing slash.
# Currently that code is not used, and therefore it will treat
# http://www.foo.com/bar
# as a different link than
# http://www.foo.com/bar/
# And therefore go to both link independantly
# Comments on whether this should be the case or not are greatly appreciated

sub _preexisting {
	my $self = shift;
	my $uri  = shift;

	#		if($uri !~ /\/$/){
	#try as is only (currently...and with trailing slash maybe later)
	if (
		exists( $self->links_to_visit->{$uri} )
		||

		#					$self->links_to_visit->{"$uri/"} ||
		exists( $self->relative_links_to_visit->{$uri} ) ||

		#					$self->relative_links_to_visit->{"$uri/"} ||
		exists( $self->links_ignored->{$uri} ) ||

		#					$self->links_ignored->{"$uri/"} ||
		exists( $self->links_visited->{$uri} )
	  )
	{

		#					$self->links_visited->{"$uri/"} ){
		return 1;
	}

	#		}
	#		else{
	#try without a trailing slash
	#			$uri =~ s/\/$//;
	#			if(    $self->links_to_visit->{$uri} ||
	#				   $self->relative_links_to_visit->{$uri} ||
	#				   $self->links_ignored->{$uri} ||
	#				   $self->links_visited->{$uri} ){
	#				return 1;
	#			}
	#		}

	return 0;
}

###############################################################################
# Public Methods Implemented                                                  #
###############################################################################

=pod

=head1 METHODS IMPLEMENTED

The following functions have been implemented by the FF driver.  Many
of these methods were implementations of the parent Driver interface.

As such, the following code descriptions pertain to this particular 
Driver implementation.  For further information about the generic
Driver interface, see the L<HoneyClient::Agent::Driver> documentation.

=head2 HoneyClient::Agent::Driver::FF->new($param => $value, ...)

=over 4

Creates a new FF driver object, which contains a hashtable
containing any of the supplied "param => value" arguments.

I<Inputs>:
 B<$param> is an optional parameter variable.
 B<$value> is $param's corresponding value.
 
Note: If any $param(s) are supplied, then an equal number of
corresponding $value(s) B<must> also be specified.

I<Output>: The instantiated FF driver B<$object>, fully initialized.

=back

=begin testing

# XXX: Add this.
1;

=end testing

=cut

sub new {

	# - This function takes in an optional hashtable,
	#   that contains various key => 'value' configuration
	#   parameters.
	#
	# - For each parameter given, it overwrites any corresponding
	#   parameters specified within the default hashtable, %PARAMS,
	#   with custom entries that were given as parameters.
	#
	# - Finally, it returns a blessed instance of the
	#   merged hashtable, as an 'object'.

	# Get the class name.
	my $self = shift;

	# Get the rest of the arguments, as a hashtable.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
	my %args = @_;

	# Check to see if the class name is inherited or defined.
	my $class = ref($self) || $self;

	# Initialize default parameters.
	my %params = %{ dclone( \%PARAMS ) };
	$self = $class->SUPER::new();
	@{$self}{ keys %params } = values %params;

	# Now, overwrite any default parameters that were redefined
	# in the supplied arguments.
	@{$self}{ keys %args } = values %args;

	# Now, assign our object the appropriate namespace.
	bless $self, $class;
	
	#bla
	$self->{_remaining_number_of_relative_links_to_visit} = 
		$self->{max_relative_links_to_visit};

	# Finally, return the blessed object.
	return $self;
}

###############################################################################

=pod

=head2 $object->drive()

=over 4

Drives an instance of Firefox for one iteration,
navigating to the next URL and updating the driver's corresponding
internal hashtables accordingly.

For a description of which hashtable is consulted upon each
iteration of drive(), see the L<next_link_to_visit> documentation, in
the "DEFAULT PARAMETER LIST" section.

Once a drive() iteration has completed, the corresponding Firefox browser 
process is terminated.  Thus, each call to drive() invokes a new instance of 
the browser.

I<Output>: The updated FF driver B<$object>, containing state information
from driving Firefox for one iteration.

B<Warning>: This method will B<croak> if the FF driver object is B<unable>
to navigate to a new link, because its list of links to visit is empty. 

=back

=begin testing

# XXX: Test this.
1;

=end testing

=cut

sub drive {

	# Get the object state.
	my $self     = shift;
	my $base_url = undef;

	#	my $drive_ff = 1;	# To be set to one for some corner cases where
	# we don't want the real browser to visit a site

	# Sanity check: Make sure we've been fed an object.
	unless ( ref($self) ) {
		Carp::croak "Error: Function must be called in reference to a "
		  . __PACKAGE__
		  . "->new() object!\n";
	}

	# Get the next URL from our hashtables.
	my $url = $self->_dep_getNextLink();

	# Sanity check: Make sure our next URL is defined.
	unless ( defined($url) ) {
		Carp::croak "Error: Unable to drive browser - 'links_to_visit' "
		  . "hashtable is empty!\n";
	}

	###########################
	#Drive the LWP-based "browser"
	###########################
	if ( $self->{flip_flop} == 0 ) {
		print "LWP browsing to $url\n";
		$self->{drive_ff} = 1;
		my $ua = LWP::UserAgent->new( "keep_alive" => 300, max_redirect => 0, 
							timeout => $self->{timeout});
 		if($self->{http_proxy} ne 'none'){
                $ua->proxy( 'http', $self->{http_proxy});
		}
		
		#Set up the headers to mimic FF
		#TODO: LWP::UserAgent headers are not *exactly* the same as Firefox still
		# this is because if I turn off the TE header manually in the .pm file
		# and if I set the 'Accept-Encoding' to 'gzip,deflate' (which is what is
		# in the TE header too) it still doesn't process compressed info correctly
		$ua->agent(
'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.5'
		);
		$ua->default_header( 'Accept' =>
'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5'
		);
		$ua->default_header( 'Accept-Language' => 'en-us,en;q=0.5' );
		$ua->default_header(
			'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7' );

		#    $ua->default_header('Accept-Encoding' => 'gzip,deflate');

		# get() returns an HTTP::Response object
		# and the raw html will be in $data->content
		my $data = $ua->get($url);
		if ( !defined($data) ) {
			print "got back a bad HTTP::Response object. Dying\n";
			$self->{next_link_to_visit} = undef;
			exit;
		}

		if ( $data->is_redirect ) {
			print "GOT REDIRECTED trying to go to $url\n";
			$self->links_visited->{$url} = _getTimestamp() . ":http_refresh";
			$self->{drive_ff} = 0;
		}

		if ( $data->content() =~ /^[0-9][0-9][0-9]/ ) {

			# In practice I have only seen an error message starting with 500
			# to get to this case.(when the socket connect fails or your ctrl-c)
			#  - Xeno
			my $tmp = $data->content();
			chomp($tmp);
			print "Error: $tmp. ABORTING\n";
			$self->{next_link_to_visit} = undef;
			return -1;
		}

		#Before we give it to LinkExtor, check for any meta refresh URLs
		my $p = HTML::HeadParser->new();
        # TODO: Check to make sure the parser is functioning properly.
		$p->parse( $data->content() );

		#The HeadParser doesn't get us all the way there, still need regex
###		print "HEADER\n" . Dumper($p->header) . "\n";
		if ( defined( $p->header->{refresh} )
			&& $p->header->{refresh} =~ /.*URL=(.*)/i )
		{
			print "META REFRESH going to $1\n";

			#Just pretend we went there
			#Also absolutize just incase (since I've seen it needed)
            # URI->new_abs() will never return undef; however,
            # it could die if invalid parameters are supplied.
			my $uri = URI->new_abs($1, $url);
			
			$self->links_to_visit->{$uri}  = _getTimestamp();
			$self->links_visited->{$url} = _getTimestamp() . ":meta_refresh";

		   # TODO: Should *really* only not go if the refresh timer is less than
		   # our timeout...Currently it ignores the time alltogether
			$self->{drive_ff} = 0;
			print "GOT METAREFRESH at $url\n";
		}

		#parse the content to get the links
		my $linkextor = HTML::LinkExtor->new();
		$linkextor->parse( $data->content() ) ||
			die "Unable to parse HTTP::Response object. Dying\n";

		# Have to assign links to a tmp var because the call to links() will
		# remove all the links from the object
		my @all_links = $linkextor->links();

		#support the BASE link type
		foreach my $lnk (@all_links) {
			if ( @{$lnk}[0] eq "base" ) {
				$base_url = @{$lnk}[2];
				last;
			}
		}
		if ( defined($base_url) ) {
			$self->_processLinks( $base_url, @all_links );
		}
		else {
			$self->_processLinks( $url, @all_links );
		}
		
		# If we're not going to drive firefox, then we set the
		# $self->next_link_to_visit = undef so that the next time next() is called
		# it will get a new link to visit.
		if($self->{drive_ff} == 0){
			$self->{next_link_to_visit} = undef;
		}
		else{ 
			# we need to add the extra targets to $self->_next_connections so that 
			# the firewall will open up ports for them for when we drive FF.
			my @keyz   = keys( %{ $self->{hosts_to_resolve} } );
			my @valuez = values( %{ $self->{hosts_to_resolve} } );
			for ( my $i = 0 ; $i < scalar(@keyz) ; $i++ ) {
				$self->{_next_connections}->{targets}{ $keyz[$i] } = { tcp => [ $valuez[$i] ] };
			}
#			print "in drive, _next_connections is:\n" . Dumper($self->{_next_connections});
			$self->{hosts_to_resolve} = undef;
		}

	}

	###########################
	#Drive firefox
	###########################

	if ( $self->{drive_ff} && $self->{flip_flop} == 1) {
		print "FF browsing to $url\n";
		my $ffjob   = Win32::Job->new();
        # Sanity check.
        if (!defined($ffjob)) {
            die "Error spawning job: " . $^E;
        }

		my $tmp_str = '"' . $self->ff_exec . "\" $url";
		$ffjob->spawn( undef, $tmp_str );

		# NOTE:If there is already a firefox open, it will open the URL in a
		# tab and then FAIL to quit the browser on the timout.
		# DO NOT have firefox already opened when this starts
        #
        # TODO: Add in code to kill any previously running instances of firefox.
        # TODO: Check to make sure that this process has been killed
        # (i.e., task list query).
		$ffjob->run( $self->{timeout} );

		# If we've gotten this far, then we've successfully visited the URL.
		# Go ahead and add it to our 'links_visited' history.
		$self->links_visited->{$url} = _getTimestamp();

		$self->{next_link_to_visit} = undef;
		
		# If you have max_relative_links_to_visit set to -1 in your
		# honeyclient.xml file it will avoid this section and therefore
		# do an exhaustive spidering of sites before moving on. Otherwise
		# if you set it to something > 0 it will hit this part and only
		# spider as many links per site as you want.
		if ($self->{_remaining_number_of_relative_links_to_visit} > 0){
			$self->{_remaining_number_of_relative_links_to_visit}--;
			if ($self->{_remaining_number_of_relative_links_to_visit} == 0){
				$self->{relative_links_to_visit} = {} ;
				$self->{_remaining_number_of_relative_links_to_visit} = $self->{max_relative_links_to_visit};
			}
		}

		$self->{_next_connections} = {};
	}

	if($self->{flip_flop} == 0){
		$self->{flip_flop} = 1;
	}
	else{
		$self->{flip_flop} = 0;
	}
	# Return the modified object state.
	return $self;
}

###############################################################################

sub _dep_getNextLink {

	# Get the object state.
	my $self = shift;

	# Sanity check: Make sure we've been fed an object.
	unless ( ref($self) ) {
		Carp::croak "Error: Function must be called in reference to a "
		  . __PACKAGE__
		  . "->new() object!\n";
	}

	# Set the link to find as undef, initially.
	my $link = undef;

	# Get the next link.
	$link = $self->_getNextLink();

	# Before returning the link, be sure to set the
	# next link scalar, so that our object consistently
	# returns the same next link via _dep_getNextLink().
	$self->{next_link_to_visit} = $link;

	# Return this link found.
	return $link;
}

###############################################################################

=pod

=head2 $object->next()

=over 4

Returns the next set of server hostnames and/or IP addresses that the
Firefox browser will contact, upon the next call to the B<$object>'s drive() 
method.

Specifically, the returned data is a reference to a hashtable, containing
detailed information about which resources, hostnames, IPs, protocols, and 
ports that the browser will contact upon the next drive() iteration.

Here is an example of such returned data:

  $hashref = {
  
      # The set of servers that the driver will contact upon
      # the next drive() operation.
      servers => {
          # The application will contact 'site.com' using
          # TCP ports 80 and 81.
          'site.com' => {
              'tcp' => [ 80, 81 ],
          },

          # The application will contact '192.168.1.1' using
          # UDP ports 53 and 123.
          '192.168.1.1' => {
              'udp' => [ 53, 123 ],
          },
 
          # Or, more generically:
          'hostname_or_IP' => {
              'protocol_type' => [ portnumbers_as_list ],
          },
      },

      # The set of resources that the driver will operate upon
      # the next drive() operation.
      resources => {
          'http://www.mitre.org/' => 1,
      },
  };

B<Note>: For this implementation of the Driver interface, 
unless _dep_getNextLink() returns undef, the returned hashtable
from this method will B<always> contain only B<one> hostname
or IP address.  Within this single entry, the protocol type
is B<always guaranteed> to be B<TCP>, specifying a
B<single port>.

I<Output>: The aforementioned B<$hashref> containing the next set of
resources that the back-end application will attempt to contact upon
the next drive() iteration.  Returns undef values for both 'targets'
and 'resources' keys, if _dep_getNextLink() also returns undef.

# XXX: Resolve this, per parent Driver description.

=back

=begin testing

# XXX: Test this.
1;

=end testing

=cut

sub next {

	# Get the object state.
	my $self = shift;

	# Sanity check: Make sure we've been fed an object.
	unless ( ref($self) ) {
		Carp::croak "Error: Function must be called in reference to a "
		  . __PACKAGE__
		  . "->new() object!\n";
	}

	# Okay, get the next URL.
	my $nextURL = $self->_dep_getNextLink();

	if(!scalar(%{ $self->{_next_connections} })){

		# Construct an empty hashtable.
		my $nextSite = {
			targets   => undef,
			resources => undef,
		};
	
		# Sanity check: Make sure our next URL is defined.
		unless ( defined($nextURL) ) {
			return $nextSite;
		}
		
		# Now, extract the corresponding hostname[:port]
		my $hostnamePort = _extractHostname($nextURL);
	
		# Now, find the corresponding hostname or IP address.
		my $hostname = $hostnamePort;
		$hostname =~ s/:.*$//;
	
		# Check to see if a TCP port number was provided.
		my $port = $hostnamePort;
		$port =~ s/$hostname:?//;
	
		# If the port was empty, then derive the proper port number
		# to use, based upon whether HTTP or HTTPS was supplied by
		# the URL.
		if ( $port eq '' ) {
			if ( $nextURL =~ /^https.*/i ) {
				$port = 443;
			}
			else {    # Assume HTTP, since it's a valid URL.
				$port = 80;
			}
		}
	
		# Finally, construct the corresponding hash reference.
		$nextSite = {
			targets   => { $hostname => { tcp => [$port], }, },
			resources => { $nextURL  => 1, },
		};
		$self->{_next_connections} = $nextSite;
	}

#	print "next returning whatevz" . Dumper($self->{_next_connections});
	return $self->{_next_connections};
}

###############################################################################

=pod

=head2 $object->isFinished()

=over 4

Indicates if the FF driver B<$object> has driven the Firefox browser to all 
possible links it has found within its hashtables and is unable to navigate 
the browser further without additional, external input.

I<Output>: True if the FF driver B<$object> is finished, false otherwise.

B<Note>: Additional links can be fed to this FF driver at any time, by
simply adding new hashtable entries to the B<links_to_visit> hashtable
within the B<$object>.

For example, if you wanted to add the URL "http://www.mitre.org"
to the FF driver B<$object>, simply use the following code:

  $object->{links_to_visit}->{'http://www.mitre.org'} = 1;

=back

=begin testing

# XXX: Test this.
1;

=end testing

=cut

sub isFinished {

	# Get the object state.
	my $self = shift;

	# Sanity check: Make sure we've been fed an object.
	unless ( ref($self) ) {
		Carp::croak "Error: Function must be called in reference to a "
		  . __PACKAGE__
		  . "->new() object!\n";
	}

	# Return whether or not both '*_to_visit' hashtables are
	# empty.
	return (
		!(    defined(    $self->next_link_to_visit)
			or scalar( %{ $self->{relative_links_to_visit} } )
			or scalar( %{ $self->{links_to_visit} } )
		)
	  )

}
###############################################################################

=pod

=head2 $object->status()

=over 4

Returns the current status of the FF driver B<$object>, as it's state
exists, between subsequent calls to $object->driver().

Specifically, the data returned is a reference to a hashtable,
containing specific statistical information about the status
of the FF driver's progress, between iterations of driving the
Firefox browser.

The following is an example hashtable, containing all the
(key => value) pairs that would exist in the output.

  $hashref = {
      'relative_links_remaining' =>       10, # Number of URLs left to
                                              # process, at a given site.
      'links_remaining'          =>       56, # Number of URLs left to 
                                              # process, for all sites.
      'links_processed'          =>       44, # Number of URLs processed.
      'links_total'              =>      100, # Total number of URLs given.
      'percent_complete'         => '44.00%', # Percent complete,
                                              #  (processed / total).
  };

I<Output>: A corresponding B<$hashref>, containing statistical information
about the FF driver's progress, as previously mentioned.

# XXX: Resolve this, per parent Driver description.

=back

=begin testing

# XXX: Test this.
1;

=end testing

=cut

sub status {

	# Get the object state.
	my $self = shift;

	# Sanity check: Make sure we've been fed an object.
	unless ( ref($self) ) {
		Carp::croak "Error: Function must be called in reference to a "
		  . __PACKAGE__
		  . "->new() object!\n";
	}

	# Construct a new status hashtable.
	my $status = {};

	# Set the total number of links processed.
	$status->{links_processed} =
	  scalar( keys( %{ $self->links_visited } ) ) +
	  scalar( keys( %{ $self->links_timed_out } ) ) +
	  scalar( keys( %{ $self->links_ignored } ) );

	# Set the number of relative links to process.
	$status->{relative_links_remaining} =
	  scalar( keys( %{ $self->relative_links_to_visit } ) );

	# Figure out how many total links are left to process.
	$status->{links_remaining} =
	  scalar( keys( %{ $self->relative_links_to_visit } ) ) +
	  scalar( keys( %{ $self->links_to_visit } ) );

	# Set the total number of links in the object's state.
	$status->{links_total} =
	  $status->{links_processed} + $status->{links_remaining};

	# Get the percentage of links complete.
	# Sanity check: Avoid divide by zero.
	if ( $status->{links_total} <= 0 ) {
		$status->{links_total} = 1;
	}
	$status->{percent_complete} = sprintf(
		"%.2f%%",
		(
			( $status->{links_processed} + 0.00 ) /
			  ( $status->{links_total} + 0.00 )
		  ) * 100.00
	);

	# Return status.
	return $status;
}

1;

###############################################################################
# Additional Module Documentation                                             #
###############################################################################

__END__

=head1 BUGS & ASSUMPTIONS

IMPORTANT: Firefox should not be already open when using this module. This is 
because it will then open links in new tabs and Win32::Job will think that it 
has completed the current link instantly. This will lead to many tabs being 
created faster than content is actually loaded which will of course exhause 
memory and cause excessive network traffic.

ASSUMPTION: Firefox needs to be configured to not cache anything, and also 
have automatic updates turned off

In a nutshell, this object is nothing more than a blessed anonymous
reference to a hashtable, where (key => value) pairs are defined in
the L<DEFAULT PARAMETER LIST>, as well as fed via the new() function
during object initialization.  As such, this package does B<not>
perform any rigorous B<data validation> prior to accepting any new
or overriding (key => value) pairs.

In general, the FF driver does B<not> know how many links it will
ultimately end up browsing to, until it conducts an exhaustive
spider of all initial URLs supplied.  As such, expect the output
of $object->status() to change significantly, upon each
$object->drive() iteration.

For example, if at one given point, the status of B<percent_complete> 
is 30% and then this value drops to 15% upon another iteration, then 
this means that the total number of links to drive to has greatly 
increased.

BUG: sometimes I get errors like:
"Parsing of undecoded UTF-8 will give garbage when decoding entities at HoneyClient/Agent/Driver/FF.pm"...
and then the line number following the code
	$p->parse($data->content())
(and another) but I haven't investigated - X

BUG: The way Win32::Job is launching firefox will cause false positives every time it encounters
something which it is prompted to download. These files will be saved to C:\WINDOWS with random-ish
names, and the same filetype (mp3, tar, gz, pdf, zip, dmg, etc). 

=head1 TODO

Get the LWP headers *exactly* the same as FF

Unit tests!

At some point, we may want to replace all the instances of '1' with 
more useful data, such as the link from which URLs are extracted so 
that it can be used for a "referer" HTTP header

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

LWP::UserAgent

HTML::LinkExtor

HTML::HeadParser

URI

HoneyClient::Agent::Driver::IE

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 AUTHORS

Kathy Wang, E<lt>knwang@mitre.orgE<gt>

Xeno Kovah , E<lt>xkovah@mitre.orgE<gt>

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

Thanh Truong, E<lt>ttruong@mitre.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2006 The MITRE Corporation.  All rights reserved.

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


