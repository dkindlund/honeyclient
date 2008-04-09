#######################################################################
# Created on:  April 02, 2008
# Package:     HoneyClient::Agent
# File:        Agent.pm
# Description: Central library used for agent-based operations.
#
# CVS: $Id$
#
# @author knwang, ttruong, kindlund
#
# Copyright (C) 2007-2008 The MITRE Corporation.  All rights reserved.
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

HoneyClient::Agent - Perl extension to instantiate a SOAP server
that provides a central interface for all agent-based HoneyClient
operations.

=head1 VERSION

This documentation refers to HoneyClient::Agent version 1.02.

=head1 SYNOPSIS

=head2 CREATING THE SOAP SERVER

  use HoneyClient::Agent;

  # Handle SOAP requests on the default address:port.
  my $URL = HoneyClient::Agent->init();

  # Handle SOAP requests on TCP port localhost:9090
  my $URL = HoneyClient::Agent->init(address => "localhost",
                                     port    => 9090);

  print "Server URL: " . $URL . "\n";

  # Create a cleanup function, to execute whenever
  # the SOAP server needs to be destroyed.
  sub cleanup {
      HoneyClient::Agent->destroy();
      exit;
  }

  # Install the cleanup handler, in case parent process
  # dies unexpectedly.
  $SIG{HUP}       = \&cleanup;
  $SIG{INT}       = \&cleanup;
  $SIG{QUIT}      = \&cleanup;
  $SIG{ABRT}      = \&cleanup;
  $SIG{PIPE}      = \&cleanup;
  $SIG{TERM}      = \&cleanup;

  # Catch all parent code errors, in order to perform cleanup
  # on all child processes before exiting.
  eval {
      # Do rest of the parent processing here...
  };

  # We assume you still want to still want to "die" on
  # any errors found within the eval block.
  if ($@) {
      HoneyClient::Agent->destroy();
      die $@;
  }

  # Even if no errors occurred, initiate cleanup.
  cleanup();

=head2 INTERACTING WITH THE SOAP SERVER

  use HoneyClient::Util::SOAP qw(getClientHandle);
  use Data::Dumper;
  use MIME::Base64 qw(encode_base64 decode_base64);
  use Storable qw(thaw);
  $Storable::Deparse = 1;
  $Storable::Eval = 1;

  # Create a new SOAP client, to talk to the HoneyClient::Agent
  # module.
  my $stub = getClientHandle(namespace => "HoneyClient::Agent",
                             address   => "localhost");
  my $som;

  # Get the properties of the Agent OS and driven application.
  $som = $stub->getProperties(driver_name => "HoneyClient::Agent::Driver::Browser::IE");
  print Dumper($som->result()) . "\n";

  # Drive HoneyClient::Agent::Driver::Browser::IE to a website.
  $som = $stub->drive(driver_name => "HoneyClient::Agent::Driver::Browser::IE",
                      parameters  => encode_base64("http://www.mitre.org"));

  # Check the result to see if any compromise was found.
  # Look for the 'fingerprint' key in the resulting hastable.
  print Dumper(thaw(decode_base64($som->result()))) . "\n"; 

=head1 DESCRIPTION

This library creates a SOAP server within the HoneyClient VM, allowing
the HoneyClient::Manager to perform agent-based operations within the
VM.

=cut

package HoneyClient::Agent;

use strict;
use warnings FATAL => 'all';
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

    # This allows declaration use HoneyClient::Agent ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = (
        'all' => [ qw() ],
    );

    # Symbols to autoexport (when qw(:all) tag is used)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

    # Check to make sure our environment is Cygwin-based.
    if ($Config{osname} !~ /^cygwin$/) {
        Carp::croak "Error: " . __PACKAGE__ . " will only run in Cygwin environments!\n";
    }

    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.
}
our (@EXPORT_OK, $VERSION);

=pod

=begin testing


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
BEGIN {
    # Check to make sure we're in a suitable environment.
    use Config;
    SKIP: {
        skip 'HoneyClient::Agent only works in Cygwin environment.', 1 if ($Config{osname} !~ /^cygwin$/);
    
        use_ok('HoneyClient::Agent') or diag("Can't load HoneyClient::Agent package.  Check to make sure the package library is correctly listed within the path.");
    }
}

# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'HoneyClient::Agent only works in Cygwin environment.', 3 if ($Config{osname} !~ /^cygwin$/);

    require_ok('HoneyClient::Agent');
    can_ok('HoneyClient::Agent', 'init');
    can_ok('HoneyClient::Agent', 'destroy');
    if ($Config{osname} =~ /^cygwin$/) {
        require HoneyClient::Agent;
    }
}

# Make sure HoneyClient::Util::SOAP loads.
BEGIN { use_ok('HoneyClient::Util::SOAP', qw(getServerHandle getClientHandle)) or diag("Can't load HoneyClient::Util::SOAP package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::SOAP');
can_ok('HoneyClient::Util::SOAP', 'getServerHandle');
can_ok('HoneyClient::Util::SOAP', 'getClientHandle');
use HoneyClient::Util::SOAP qw(getServerHandle getClientHandle);

# Make sure HoneyClient::Agent::Integrity loads.
BEGIN { use_ok('HoneyClient::Agent::Integrity') or diag("Can't load HoneyClient::Agent::Integrity package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent::Integrity');
use HoneyClient::Agent::Integrity;

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(nfreeze thaw)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
use Storable qw(nfreeze thaw);

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

# Make sure DateTime::HiRes loads.
BEGIN { use_ok('DateTime::HiRes') or diag("Can't load DateTime::HiRes package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('DateTime::HiRes');
use DateTime::HiRes;

# Make sure Data::Dumper loads.
BEGIN { use_ok('Data::Dumper') or diag("Can't load Data::Dumper package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

BEGIN {

    # Check to make sure we're in a suitable environment.
    use Config;
    SKIP: {
        skip 'Win32 libraries only work in a Cygwin environment.', 1 if ($Config{osname} !~ /^cygwin$/);
   
        # Make sure Win32::Job loads.
        use_ok('Win32::Job') or diag("Can't load Win32::Job package.  Check to make sure the package library is correctly listed within the path.");
    }
}

# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'Win32 libraries only work in a Cygwin environment.', 1 if ($Config{osname} !~ /^cygwin$/);

    require_ok('Win32::Job');
    if ($Config{osname} =~ /^cygwin$/) {
        require Win32::Job;
    }
}

# Global test variables.
our $PORT = getVar(name      => "port",
                   namespace => "HoneyClient::Agent");
our ($stub, $som);

=end testing

=cut

#######################################################################

# Include the SOAP Utility Library
use HoneyClient::Util::SOAP qw(getClientHandle getServerHandle);

# Include Integrity Library
use HoneyClient::Agent::Integrity;

# Include utility access to global configuration.
use HoneyClient::Util::Config qw(getVar);

# Include Dumper Library
use Data::Dumper;

# Include Hash Serialization Utility Libraries
use Storable qw(nfreeze thaw);
$Storable::Deparse = 1;
$Storable::Eval = 1;

# Include Base64 Libraries
use MIME::Base64 qw(encode_base64 decode_base64);

# Include Win32 Libraries
use Win32::Job;

# Use ISO 8601 DateTime Libraries
use DateTime::HiRes;

# Include Logging Library
use Log::Log4perl qw(:easy);

# The global logging object.
our $LOG = get_logger();

# Complete URL of SOAP server, when initialized.
our $URL_BASE       = undef;
our $URL            = undef;

# The process ID of the SOAP server daemon, once created.
our $DAEMON_PID     = undef;

#######################################################################
# Daemon Initialization / Destruction                                 #
#######################################################################

=pod

=head1 LOCAL FUNCTIONS

The following init() and destroy() functions are the only direct
calls required to startup and shutdown the SOAP server.

All other interactions with this daemon should be performed as
C<SOAP::Lite> function calls, in order to ensure consistency across
client sessions.  See the L<"EXTERNAL SOAP FUNCTIONS"> section, for
more details.

=head2 HoneyClient::Agent->init(address => $localAddr, port => $localPort, ...)

=over 4

Starts a new SOAP server, within a child process.

I<Inputs>:
 B<$localAddr> is an optional argument, specifying the IP address for the SOAP server to listen on.
 B<$localPort> is an optional argument, specifying the TCP port for the SOAP server to listen on.

 Here is an example set of arguments:

   HoneyClient::Agent->init(
       address => '127.0.0.1',
       port    => 9000,
   );

 
I<Output>: The full URL of the web service provided by the SOAP server.

=back

=begin testing

# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'HoneyClient::Agent only works in Cygwin environment.', 1 if ($Config{osname} !~ /^cygwin$/);

    our $URL = HoneyClient::Agent->init();
    our $PORT = getVar(name      => "port", 
                       namespace => "HoneyClient::Agent");
    our $HOST = getVar(name      => "address",
                       namespace => "HoneyClient::Agent");
    is($URL, "http://$HOST:$PORT/HoneyClient/Agent", "init()") or diag("Failed to start up the VM SOAP server.  Check to see if any other daemon is listening on TCP port $PORT.");
}

=end testing

=cut

sub init {
    # Extract arguments.
    # Hash-based arguments are used, since HoneyClient::Util::SOAP is unable to handle
    # hash references directly.  Thus, flat hashtables are used throughout the code
    # for consistency.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check.  Make sure the daemon isn't already running.
    if (defined($DAEMON_PID)) {
        $LOG->fatal("Error: " . __PACKAGE__ . " daemon is already running (PID = " . $DAEMON_PID .")!");
        Carp::croak "Error: " . __PACKAGE__ . " daemon is already running (PID = $DAEMON_PID)!\n";
    }

    my $argsExist = scalar(%args);

    if (!($argsExist && 
          exists($args{'address'}) &&
          defined($args{'address'}))) {
        $args{'address'} = getVar(name => "address");
    }

    if (!($argsExist && 
          exists($args{'port'}) &&
          defined($args{'port'}))) {
        $args{'port'} = getVar(name => "port");
    }

    $URL_BASE = "http://" . $args{'address'} . ":" . $args{'port'};
    $URL = $URL_BASE . "/" . join('/', split(/::/, __PACKAGE__));

    my $pid = undef;
    if ($pid = fork()) {
        # Wait at least a second, in order to initialize the daemon.
        sleep (1);
        # We use a local variable to get the pid, and then we set the global
        # DAEMON_PID variable after the fork().  This is intentional, because
        # it seems the Win32 version of fork() doesn't seem to be an atomic
        # operation.
        $DAEMON_PID = $pid;
        $LOG->debug("Initializing Agent daemon at PID: " . $DAEMON_PID);
        return $URL;
   
    } else {
        # Make sure the fork was successful.
        if (!defined($pid)) {
            $LOG->fatal("Error: Unable to fork child process. $!");
            Carp::croak "Error: Unable to fork child process.\n$!";
        }

        our $daemon = getServerHandle(address => $args{'address'},
                                      port    => $args{'port'});

        # Unbind port, if we're shutting down.
        sub shutdown {
            $daemon->shutdown(2);
            exit;
        };
        $SIG{HUP}  = \&shutdown;
        $SIG{INT}  = \&shutdown;
        $SIG{QUIT} = \&shutdown;
        $SIG{ABRT} = \&shutdown;
        $SIG{TERM} = \&shutdown;

        for (;;) {
            $daemon->handle();
        }
    }
}

=pod

=head2 HoneyClient::Agent->destroy()

=over 4

Terminates the SOAP server within the child process.

I<Output>: True if successful, false otherwise.

=back

=begin testing

# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'HoneyClient::Agent only works in Cygwin environment.', 1 if ($Config{osname} !~ /^cygwin$/);

    is(HoneyClient::Agent->destroy(), 1, "destroy()") or diag("Unable to terminate Agent SOAP server.  Be sure to check for any stale or lingering processes.");
}

=end testing

=cut

sub destroy {

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper();
    });

    my $ret = undef;
    # Make sure the PID is defined and not
    # the parent process...
    if (defined($DAEMON_PID) && $DAEMON_PID) {
        $LOG->debug("Destroying Agent daemon at PID: " . $DAEMON_PID);
        
        require Win32::Process;
        Win32::Process::KillProcess($DAEMON_PID, 0);
        $ret = 1;
    }
    if ($ret) {
        $DAEMON_PID = undef;
    }
    return $ret;
}

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# Helper function designed to get a current timestamp from
# the system OS.
#
# Note: This timestamp is in ISO 8601 format.
#
# Inputs: none
# Outputs: timestamp
sub _getTimestamp {
    my $dt = DateTime::HiRes->now(time_zone => "local");
    return $dt->ymd('-') . " " .
           $dt->hms(':') . "." .
           $dt->nanosecond();
}

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 EXTERNAL SOAP FUNCTIONS

=head2 drive(driver_name => $driverName, parameters => $params, timeout => $timeout)

=over 4

Runs the Agent for one cycle.  In this cycle, the following happens:

=over 4

=item 1)

The specified target application (Driver) is driven for a single work unit,
by executing the application with the supplied arguments for a specified
period of time.

=item 2)

Once the specified driver has stopped, the Agent performs a corresponding
Integrity check.

=item 3)

The results of this Integrity check are then returned.

=back 

I<Inputs>: 
 B<$driverName> is the name of the Driver to use, when running this 
cycle.
 B<$params> are the optional parameters to supply to the driven
application, as arguments.  If supplied, then this data MUST be base64
encoded.
 B<$timeout> is an optional argument, specifying how long the Agent
should wait after executing the driven application before it performs
an Integrity check.

I<Output>:
 A nfreezed, base64 encoded hashtable containing the following
 information:

 {
     # Status information about the Win32::Job.
     'status' => {
         # The PID of the job, when it was ran.
         '21252' => {
             # How much time the job consumed...
             'time' => {
                 # ... in kernel space.
                 'kernel' => '0.801152',
                 # ... in user space.
                 'user' => '0.3304752',
                 # ... total elapsed.
                 'elapsed' => '20.1489728'
             },
             'exitcode' => '293'
         }
     },
     # Any fingerprint information, if the job caused
     # an integrity check failure.
     'fingerprint' => {
         'os_processes' => []
     },
     # Time inside VM when job was executed.
     'time_at' => '2008-04-02 22:17:00.889667987'
 };

=back

=begin testing

# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'HoneyClient::Agent only works in Cygwin environment.', 11 if ($Config{osname} !~ /^cygwin$/);

    # Shared test variables.
    my ($stub, $som, $URL);

    # Catch all errors, in order to make sure child processes are
    # properly killed.
    eval {

        $URL = HoneyClient::Agent->init();

        # Connect to daemon as a client.
        $stub = getClientHandle(namespace => "HoneyClient::Agent",
                                address   => "localhost");

        # Make sure the realtime_changes_file exists and is 0 bytes.
        my $realtime_changes_file = getVar(name      => 'realtime_changes_file',
                                           namespace => 'HoneyClient::Agent::Integrity');
        unlink($realtime_changes_file);
        open(REALTIME_CHANGES_FILE, ">", $realtime_changes_file);
        close(REALTIME_CHANGES_FILE); 

        diag("Driving HoneyClient::Agent::Driver::Browser::IE with no parameters and no changes...");

        # Drive the Agent using IE.
        $som = $stub->drive(driver_name => "HoneyClient::Agent::Driver::Browser::IE");

        # Verify changes.
        my $changes = thaw(decode_base64($som->result()));

        # Check to see if the drive operation completed properly. 
        ok($changes, "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($changes->{'status'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($changes->{'time_at'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($changes->{'fingerprint'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        # Check that os_processes is empty.
        ok(!scalar(@{$changes->{'fingerprint'}->{os_processes}}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        diag("Driving HoneyClient::Agent::Driver::Browser::IE with no parameters and artificial changes...");
        
        my $test_realtime_changes_file = getVar(name      => 'realtime_changes_file',
                                                namespace => 'HoneyClient::Agent::Integrity::Test');

        system("cp " . $test_realtime_changes_file . " " . $realtime_changes_file); 
        
        my $expectedFingerprint = {
          'os_processes' => [
            {
              'parent_name' => 'C:\\WINDOWS\\explorer.exe',
              'name' => 'C:\\WINDOWS\\system32\\notepad.exe',
              'created' => '2008-04-02 21:44:40.376',
              'stopped' => '2008-04-02 21:44:57.94',
              'pid' => '2496',
              'regkeys' => [
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'Recent',
                  'value' => 'C:\\Documents and Settings\\Administrator\\Recent',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:48.985'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'BaseClass',
                  'value' => 'Drive',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{259bda13-8b6f-11d7-9c24-806d6172696f}',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.32'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'BaseClass',
                  'value' => 'Drive',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{1bdee3a6-fbab-11dc-9af4-806d6172696f}',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.32'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'BaseClass',
                  'value' => 'Drive',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{259bda11-8b6f-11d7-9c24-806d6172696f}',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.32'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'BaseClass',
                  'value' => 'Drive',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{86efd67e-0a06-11dc-97a7-806d6172696f}',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.32'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'Personal',
                  'value' => 'C:\\Documents and Settings\\Administrator\\My Documents',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.329'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'Common Documents',
                  'value' => 'C:\\Documents and Settings\\All Users\\Documents',
                  'name' => 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.329'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'Desktop',
                  'value' => 'C:\\Documents and Settings\\Administrator\\Desktop',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.344'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'Common Desktop',
                  'value' => 'C:\\Documents and Settings\\All Users\\Desktop',
                  'name' => 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.344'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'Favorites',
                  'value' => 'C:\\Documents and Settings\\Administrator\\Favorites',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:49.797'
                },
                {
                  'value_type' => 'REG_BINARY',
                  'value_name' => 'b',
                  'value' => '6e06f07406507006106402e0650780650004303a05c06307906707706906e05c06806f06d06505c04106406d06906e06907307407206107406f07205c07407207506e06b02d07207705c04306107007407507206503205c06306107007407507206502d06306c06906506e07402d07806506e06f02d06d06f06405c06906e07307406106c06c000',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\LastVisitedMRU',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.79'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'MRUList',
                  'value' => 'bac',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\LastVisitedMRU',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.79'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'a',
                  'value' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\txt',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.94'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'MRUList',
                  'value' => 'a',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\txt',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.94'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'e',
                  'value' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\*',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.94'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'MRUList',
                  'value' => 'edcbjihagf',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\*',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.94'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfEscapement',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfOrientation',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfWeight',
                  'value' => '190',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfItalic',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfUnderline',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfStrikeOut',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfCharSet',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfOutPrecision',
                  'value' => '3',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfClipPrecision',
                  'value' => '2',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfQuality',
                  'value' => '1',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'lfPitchAndFamily',
                  'value' => '31',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iPointSize',
                  'value' => '8c',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'fWrap',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'StatusBar',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'fSaveWindowPositions',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'lfFaceName',
                  'value' => 'Lucida Console',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'szHeader',
                  'value' => '&f',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'szTrailer',
                  'value' => 'Page &p',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iMarginTop',
                  'value' => '3e8',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iMarginBottom',
                  'value' => '3e8',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iMarginLeft',
                  'value' => '2ee',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iMarginRight',
                  'value' => '2ee',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'fMLE_is_broken',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iWindowPosX',
                  'value' => 'fffffff9',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iWindowPosY',
                  'value' => '38',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iWindowPosDX',
                  'value' => '40c',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'iWindowPosDY',
                  'value' => '299',
                  'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:57.63'
                }
              ],
              'parent_pid' => '1380',
              'process_files' => [
                {
                  'name' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                  'time_at' => '2008-04-02 21:44:54.79',
                  'event' => 'Delete'
                },
                {
                  'name' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                  'file_content' => {
                    'sha1' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt2008-04-02 21:44:54.172',
                    'md5' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt2008-04-02 21:44:54.172',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.172',
                  'event' => 'Write'
                }
              ]
            },
            {
              'regkeys' => [],
              'pid' => '984',
              'name' => 'C:\\WINDOWS\\system32\\svchost.exe',
              'process_files' => [
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\SendTo',
                  'file_content' => {
                    'sha1' => 'C:\\Documents and Settings\\Administrator\\SendTo2008-04-02 21:44:42.766',
                    'md5' => 'C:\\Documents and Settings\\Administrator\\SendTo2008-04-02 21:44:42.766',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:42.766',
                  'event' => 'Write'
                },
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data',
                  'file_content' => {
                    'sha1' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data2008-04-02 21:44:42.782',
                    'md5' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data2008-04-02 21:44:42.782',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:42.782',
                  'event' => 'Write'
                }
              ]
            },
            {
              'regkeys' => [
                {
                  'value_type' => 'REG_EXPAND_SZ',
                  'value_name' => 'CachePath',
                  'value' => '%USERPROFILE%\\Local Settings\\History\\History.IE5\\MSHist012008040220080403',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.376'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'CachePrefix',
                  'value' => ':2008040220080403: ',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.376'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'CacheLimit',
                  'value' => '2000',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.376'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'CacheOptions',
                  'value' => 'b',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.376'
                },
                {
                  'value_type' => 'REG_EXPAND_SZ',
                  'value_name' => 'CachePath',
                  'value' => '%USERPROFILE%\\Local Settings\\History\\History.IE5\\MSHist012008040220080403',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.376'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'CacheRepair',
                  'value' => '0',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:44:54.376'
                }
              ],
              'pid' => '1380',
              'name' => 'C:\\WINDOWS\\explorer.exe',
              'process_files' => [
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk',
                  'file_content' => {
                    'sha1' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.282',
                    'md5' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.282',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.282',
                  'event' => 'Write'
                },
                {
                  'name' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                  'file_content' => {
                    'sha1' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.516',
                    'md5' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.516',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.516',
                  'event' => 'Write'
                },
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                  'time_at' => '2008-04-02 21:44:54.516',
                  'event' => 'Delete'
                },
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                  'file_content' => {
                    'sha1' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.547',
                    'md5' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.547',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.547',
                  'event' => 'Write'
                }
              ]
            },
            {
              'regkeys' => [],
              'pid' => '4',
              'name' => 'System',
              'process_files' => [
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk',
                  'file_content' => {
                    'sha1' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.579',
                    'md5' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.579',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.579',
                  'event' => 'Write'
                },
                {
                  'name' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                  'file_content' => {
                    'sha1' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                    'md5' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.579',
                  'event' => 'Write'
                },
                {
                  'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                  'file_content' => {
                    'sha1' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                    'md5' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                    'mime_type' => 'UNKNOWN',
                    'size' => -1
                  },
                  'time_at' => '2008-04-02 21:44:54.579',
                  'event' => 'Write'
                }
              ]
            },
            {
              'parent_name' => 'C:\\WINDOWS\\explorer.exe',
              'name' => 'C:\\WINDOWS\\regedit.exe',
              'created' => '2008-04-02 21:45:07.829',
              'stopped' => '2008-04-02 21:45:22.344',
              'pid' => '2648',
              'regkeys' => [
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'New Value #1',
                  'value' => '',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:45:15.985'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'foo',
                  'value' => '',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:45:17.266'
                },
                {
                  'value_type' => 'REG_NONE',
                  'value_name' => 'New Value #1',
                  'value' => '',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                  'event' => 'DeleteValueKey',
                  'time_at' => '2008-04-02 21:45:17.266'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'foo',
                  'value' => 'bar',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:45:19.204'
                },
                {
                  'value_type' => 'REG_BINARY',
                  'value_name' => 'View',
                  'value' => '2c00000001000ffffffffffffffffffffffffffffffff500005c000c43008f200d8000c200078000201001000',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:45:22.344'
                },
                {
                  'value_type' => 'REG_DWORD',
                  'value_name' => 'FindFlags',
                  'value' => 'e',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:45:22.344'
                },
                {
                  'value_type' => 'REG_SZ',
                  'value_name' => 'LastKey',
                  'value' => 'My Computer\\HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                  'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                  'event' => 'SetValueKey',
                  'time_at' => '2008-04-02 21:45:22.344'
                }
              ],
              'parent_pid' => '1380',
              'process_files' => []
            }
          ],
          'time_at' => '2008-04-02 21:44:40.376'
        };

        # Drive the Agent using IE.
        $som = $stub->drive(driver_name => "HoneyClient::Agent::Driver::Browser::IE");

        # Verify changes.
        $changes = thaw(decode_base64($som->result()));
   
        # Check to see if the drive operation completed properly. 
        ok($changes, "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($changes->{'status'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($changes->{'time_at'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($changes->{'fingerprint'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        # Check that os_processes is not empty.
        ok(scalar(@{$changes->{'fingerprint'}->{os_processes}}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        # Check that fingerprint matches.
        is_deeply($expectedFingerprint, $changes->{'fingerprint'}, "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        # Delete the mock realtime_changes_file.
        unlink($realtime_changes_file);
    };

    # Kill the child daemon, if it still exists.
    HoneyClient::Agent->destroy();

    # Report any failure found.
    if ($@) {
        fail($@);
    }
}

=end testing

=cut

sub drive {
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check.  Make sure we get a valid argument.
    my $argsExist = scalar(%args);
    if (!$argsExist ||
        !exists($args{'driver_name'}) ||
        !defined($args{'driver_name'})) {

        # Die if no valid argument is supplied.
        $LOG->error("No Driver name specified.");
        die SOAP::Fault->faultcode(__PACKAGE__ . "->drive()")
                       ->faultstring("No Driver name specified.");
    }

    # Sanity check.  Make sure the driver name specified is
    # on our allowed list.
    my @drivers_found = grep(/^$args{'driver_name'}$/, @{getVar(name => 'allowed_drivers')->{name}});
    my $driverName = pop(@drivers_found);
    unless (defined($driverName)) {
        $LOG->error("Not allowed to run Driver (" . $args{'driver_name'} . ").");
        die SOAP::Fault->faultcode(__PACKAGE__ . "->drive()")
                       ->faultstring("Not allowed to run Driver (" . $args{'driver_name'} . ").");
    }
   
    # Sanity check for optional arguments.
    if (!$argsExist ||
        !exists($args{'parameters'}) ||
        !defined($args{'parameters'})) {
        $args{'parameters'} = "";
    } else {
        $args{'parameters'} = decode_base64($args{'parameters'});
    }

    if (!$argsExist ||
        !exists($args{'timeout'}) ||
        !defined($args{'timeout'})) {
        $args{'timeout'} = getVar(name => "timeout",
                                  namespace => $args{'driver_name'});
    }

    # Construct the output hashtable.
    my $ret = {
        # Time when application was driven.
        'time_at'   => _getTimestamp(),

        # Fingerprint information found (if any).
        'fingerprint' => undef,

        # Status information about the Win32::Job call.
        'status'      => undef,
    };

    # Create a new Job.
    my $job = Win32::Job->new();

    # Sanity check.
    if (!defined($job)) {
        $LOG->error("Error: Unable to spawn a new process - " . $^E . ".");
        die SOAP::Fault->faultcode(__PACKAGE__ . "->drive()")
                       ->faultstring("Error: Unable to spawn a new process - " . $^E . ".");
    }

    # Spawn the job.
    my $processExec = getVar(name => "process_exec",
                             namespace => $args{'driver_name'});
    my $processName = getVar(name => "process_name",
                             namespace => $args{'driver_name'});
    my $status = $job->spawn($processExec, $processName . " " . $args{'parameters'});

    # Sanity check.
    if (!defined($status)) {
        $LOG->error("Error: Unable to execute '" . $processExec . "'");
        die SOAP::Fault->faultcode(__PACKAGE__ . "->drive()")
                       ->faultstring("Error: Unable to execute '" . $processExec . "'");
    }

    $LOG->info($args{'driver_name'} . " - Driving To Resource: " . $args{'parameters'});

    # Run the job.
    $job->run($args{'timeout'});

    # Check to see if run fails.
    $status = $job->status();
    $ret->{'status'} = $status;

    # Sanity check.
    if (!defined($status) ||
        !scalar(%{$status})) {
        $LOG->error("Error: Unable to retrieve job status from spawned process.");
        die SOAP::Fault->faultcode(__PACKAGE__ . "->drive()")
                       ->faultstring("Error: Unable to retrieve job status from spawned process.");
    }

    # Figure out the correct Process ID.
    my @keys = keys(%{$status});
    my $processID = pop(@keys);

    # Sanity checks.
    if (!defined($processID) ||
        !exists($status->{$processID}->{'exitcode'}) ||
        !defined($status->{$processID}->{'exitcode'})) {
        $LOG->error("Error: Unable to retrieve job status from spawned process.");
        die SOAP::Fault->faultcode(__PACKAGE__ . "->drive()")
                       ->faultstring("Error: Unable to retrieve job status from spawned process.");
    }

    # Check to make sure the exitcode is '293', meaning, that the
    # application didn't unexpectedly die early.
    if ($status->{$processID}->{'exitcode'} != 293) {
        $LOG->warn("Unexpected: '" . $processName . "' process (ID = " . $processID . ") terminated early!");
    }

    # Perform an integrity check, if desired.
    if (getVar(name => "perform_integrity_checks")) {
        my $integrity = HoneyClient::Agent::Integrity->new();
        $ret->{'fingerprint'} = $integrity->check();
        if (scalar(@{$ret->{'fingerprint'}->{os_processes}})) {
            $LOG->warn($args{'driver_name'} . " - Integrity Check: FAILED");
        } else {
            $LOG->info($args{'driver_name'} . " - Integrity Check: PASSED");
        }
    }
 
    return encode_base64(nfreeze($ret));
}

=pod

=head2 getProperties(driver_name => $driverName)

=over 4

Retrieves properties about the Agent's OS and target driver application,
if specified.

I<Inputs>: 
 B<$driverName> an optional argument, indicating the Driver proprties to
return.

I<Output>:
 A hashtable containing the following information:

 {
     # Short name of the OS.
     'shortname' => 'Microsoft Windows',
     # Version of the OS.
     'version' => '5.1.2600.2.2.0.256.1',
     # Formal name of the OS.
     'name' => 'Windows XP Service Pack 2',
     # The targeted application(s) being driven, if driver_name was specified.
     'os_applications' => [
         {
             # The short name of the app.
             'shortname' => 'Internet Explorer',
             # The manufacturer of the app.
             'manufacturer' => 'Microsoft Corporation',
             # The app version.
             'version' => '7.0.6000.16608'
         }
     ]
 };

=back

=begin testing

# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'HoneyClient::Agent only works in Cygwin environment.', 5 if ($Config{osname} !~ /^cygwin$/);

    # Shared test variables.
    my ($stub, $som, $URL);

    # Catch all errors, in order to make sure child processes are
    # properly killed.
    eval {

        $URL = HoneyClient::Agent->init();

        # Connect to daemon as a client.
        $stub = getClientHandle(namespace => "HoneyClient::Agent",
                                address   => "localhost");

        # Drive the Agent using IE.
        $som = $stub->getProperties(driver_name => "HoneyClient::Agent::Driver::Browser::IE");

        # Verify output.
        my $output = $som->result();

        # Check to see if the operation completed properly. 
        ok($output, "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The getProperties() call failed.");
        ok(exists($output->{'shortname'}), "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($output->{'version'}), "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($output->{'name'}), "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($output->{'os_applications'}), "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

    };

    # Kill the child daemon, if it still exists.
    HoneyClient::Agent->destroy();

    # Report any failure found.
    if ($@) {
        fail($@);
    }
}

=end testing

=cut

sub getProperties {
    
    # Extract arguments.
    my ($class, %args) = @_;

    # Log resolved arguments.
    $LOG->debug(sub {
        # Make Dumper format more terse.
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        Dumper(\%args);
    });

    # Sanity check.  Make sure we get a valid argument.
    my $argsExist = scalar(%args);
    if (!$argsExist ||
        !exists($args{'driver_name'}) ||
        !defined($args{'driver_name'})) {

        $args{'driver_name'} = undef;
    }

    # Get OS Properties
    require Win32;
    my @os_name = Win32::GetOSName();
    my @os_vers = Win32::GetOSVersion();

    # Translate known OS names.
    my $name = $os_name[0];
    $name =~ s/^WinXP.*/Windows XP/;
    $name .= " " . $os_name[1];

    # Get rid of any 'Service Pack' identifiers.
    shift(@os_vers);
    my $version = join('.', @os_vers); 

    # Construct initial output.
    my $ret = {
        shortname => 'Microsoft Windows',
        name => $name,
        version => $version,
        os_applications => [],
    };

    if (defined($args{'driver_name'})) {
        # Get Driver Application Properties
        require Win32::Exe;
        my $process_exec = getVar(name      => 'process_exec',
                                  namespace => $args{'driver_name'});
        my $exe = Win32::Exe->new($process_exec);
        my $exe_name = $exe->version_info->get('FileDescription');
        my $exe_comp = $exe->version_info->get('CompanyName');
        my $exe_vers = $exe->version_info->get('ProductVersion');

        # Translate commas into periods.
        $exe_vers =~ s/,/./g;

        my $app_properties = {
            manufacturer => $exe_comp,
            shortname    => $exe_name,
            version      => $exe_vers,
        };

        push(@{$ret->{os_applications}}, $app_properties);
    }

    return $ret;
}

#######################################################################

1;

#######################################################################
# Additional Module Documentation                                     #
#######################################################################

__END__

=head1 BUGS & ASSUMPTIONS

If, at any time, the Manager's SOAP connection to the Agent
is disrupted during a drive() operation, then the Manager should assume
that the VM has been compromised and proceed to handle the VM as such.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Paul Kulchenko for developing the SOAP::Lite module.

=head1 AUTHORS

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

Kathy Wang, E<lt>knwang@mitre.orgE<gt>

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
