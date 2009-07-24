#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
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

# Make sure HoneyClient::Util::DateTime loads.
BEGIN { use_ok('HoneyClient::Util::DateTime') or diag("Can't load HoneyClient::Util::DateTime package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::DateTime');
use HoneyClient::Util::DateTime;

# Make sure Compress::Zlib loads.
BEGIN { use_ok('Compress::Zlib')
        or diag("Can't load Compress::Zlib package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Compress::Zlib');
use Compress::Zlib;

# Make sure Imager::Screenshot loads.
BEGIN { use_ok('Imager::Screenshot', qw(screenshot)) or diag("Can't load Imager::Screenshot package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Imager::Screenshot');
can_ok('Imager::Screenshot', 'screenshot');
use Imager::Screenshot qw(screenshot);

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
}



# =begin testing
{
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
}



# =begin testing
{
# Check to make sure we're in a suitable environment.
use Config;
SKIP: {
    skip 'HoneyClient::Agent only works in Cygwin environment.', 1 if ($Config{osname} !~ /^cygwin$/);

    is(HoneyClient::Agent->destroy(), 1, "destroy()") or diag("Unable to terminate Agent SOAP server.  Be sure to check for any stale or lingering processes.");
}
}



# =begin testing
{
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
        ok(exists($changes->{'screenshot'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        # Check that os_processes is empty.
        ok(!scalar(@{$changes->{'fingerprint'}->{os_processes}}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

        diag("Driving HoneyClient::Agent::Driver::Browser::IE with no parameters and artificial changes...");
        
        my $test_realtime_changes_file = getVar(name      => 'realtime_changes_file',
                                                namespace => 'HoneyClient::Agent::Integrity::Test');

        system("cp " . $test_realtime_changes_file . " " . $realtime_changes_file); 
        
        my $expectedFingerprint = {
           'time_at' => '1207172680.376',
           'os_processes' => [
             {
               'stopped' => '2008-04-02 21:44:57.94',
               'created' => '2008-04-02 21:44:40.376',
               'process_registries' => [
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Recent',
                   'value' => 'C:\\Documents and Settings\\Administrator\\Recent',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172688.985',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{259bda13-8b6f-11d7-9c24-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{1bdee3a6-fbab-11dc-9af4-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{259bda11-8b6f-11d7-9c24-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{86efd67e-0a06-11dc-97a7-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Personal',
                   'value' => 'C:\\Documents and Settings\\Administrator\\My Documents',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.329',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Common Documents',
                   'value' => 'C:\\Documents and Settings\\All Users\\Documents',
                   'name' => 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.329',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Desktop',
                   'value' => 'C:\\Documents and Settings\\Administrator\\Desktop',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Common Desktop',
                   'value' => 'C:\\Documents and Settings\\All Users\\Desktop',
                   'name' => 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Favorites',
                   'value' => 'C:\\Documents and Settings\\Administrator\\Favorites',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.797',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_BINARY',
                   'value_name' => 'b',
                   'value' => '6e06f07406507006106402e0650780650004303a05c06307906707706906e05c06806f06d06505c04106406d06906e06907307407206107406f07205c07407207506e06b02d07207705c04306107007407507206503205c06306107007407507206502d06306c06906506e07402d07806506e06f02d06d06f06405c06906e07307406106c06c000',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\LastVisitedMRU',
                   'time_at' => '1207172694.79',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'MRUList',
                   'value' => 'bac',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\LastVisitedMRU',
                   'time_at' => '1207172694.79',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'a',
                   'value' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\txt',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'MRUList',
                   'value' => 'a',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\txt',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'e',
                   'value' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\*',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'MRUList',
                   'value' => 'edcbjihagf',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\*',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfEscapement',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfOrientation',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfWeight',
                   'value' => '190',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfItalic',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfUnderline',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfStrikeOut',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfCharSet',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfOutPrecision',
                   'value' => '3',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfClipPrecision',
                   'value' => '2',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfQuality',
                   'value' => '1',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfPitchAndFamily',
                   'value' => '31',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iPointSize',
                   'value' => '8c',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'fWrap',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'StatusBar',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'fSaveWindowPositions',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'lfFaceName',
                   'value' => 'Lucida Console',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'szHeader',
                   'value' => '&f',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'szTrailer',
                   'value' => 'Page &p',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginTop',
                   'value' => '3e8',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginBottom',
                   'value' => '3e8',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginLeft',
                   'value' => '2ee',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginRight',
                   'value' => '2ee',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'fMLE_is_broken',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosX',
                   'value' => 'fffffff9',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosY',
                   'value' => '38',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosDX',
                   'value' => '40c',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosDY',
                   'value' => '299',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 }
               ],
               'pid' => '2496',
               'parent_name' => 'C:\\WINDOWS\\explorer.exe',
               'parent_pid' => '1380',
               'name' => 'C:\\WINDOWS\\system32\\notepad.exe',
               'process_files' => [
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'event' => 'Delete',
                   'time_at' => '1207172694.79'
                 },
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'file_content' => {
                     'sha1' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt2008-04-02 21:44:54.172',
                     'md5' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt2008-04-02 21:44:54.172',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.172'
                 }
               ]
             },
             {
               'process_registries' => [],
               'pid' => '984',
               'name' => 'C:\\WINDOWS\\system32\\svchost.exe',
               'process_files' => [
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\SendTo',
                   'file_content' => {
                     'sha1' => 'C:\\Documents and Settings\\Administrator\\SendTo2008-04-02 21:44:42.766',
                     'md5' => 'C:\\Documents and Settings\\Administrator\\SendTo2008-04-02 21:44:42.766',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172682.766'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data',
                   'file_content' => {
                     'sha1' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data2008-04-02 21:44:42.782',
                     'md5' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data2008-04-02 21:44:42.782',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172682.782'
                 }
               ]
             },
             {
               'process_registries' => [
                 {
                   'value_type' => 'REG_EXPAND_SZ',
                   'value_name' => 'CachePath',
                   'value' => '%USERPROFILE%\\Local Settings\\History\\History.IE5\\MSHist012008040220080403',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'CachePrefix',
                   'value' => ':2008040220080403: ',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'CacheLimit',
                   'value' => '2000',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'CacheOptions',
                   'value' => 'b',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_EXPAND_SZ',
                   'value_name' => 'CachePath',
                   'value' => '%USERPROFILE%\\Local Settings\\History\\History.IE5\\MSHist012008040220080403',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'CacheRepair',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
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
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.282'
                 },
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.516',
                     'md5' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.516',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.516'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'event' => 'Delete',
                   'time_at' => '1207172694.516'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'b843cb7863d3ded872899f165246c0fcc73f77e2',
                     'md5' => '6267979a84cb1060edab7b0664c419fb',
                     'size' => '986',
                     'mime_type' => 'application/octet-stream'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.547'
                 }
               ]
             },
             {
               'process_registries' => [],
               'pid' => '4',
               'name' => 'System',
               'process_files' => [
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk',
                   'file_content' => {
                     'sha1' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.579',
                     'md5' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.579',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.579'
                 },
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                     'md5' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.579'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'b843cb7863d3ded872899f165246c0fcc73f77e2',
                     'md5' => '6267979a84cb1060edab7b0664c419fb',
                     'size' => '986',
                     'mime_type' => 'application/octet-stream'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.579'
                 }
               ]
             },
             {
               'stopped' => '2008-04-02 21:45:22.344',
               'created' => '2008-04-02 21:45:07.829',
               'process_registries' => [
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'New Value #1',
                   'value' => '',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172715.985',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'foo',
                   'value' => '',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172717.266',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_NONE',
                   'value_name' => 'New Value #1',
                   'value' => '',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172717.266',
                   'event' => 'DeleteValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'foo',
                   'value' => 'bar',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172719.204',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_BINARY',
                   'value_name' => 'View',
                   'value' => '2c00000001000ffffffffffffffffffffffffffffffff500005c000c43008f200d8000c200078000201001000',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                   'time_at' => '1207172722.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'FindFlags',
                   'value' => 'e',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                   'time_at' => '1207172722.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'LastKey',
                   'value' => 'My Computer\\HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                   'time_at' => '1207172722.344',
                   'event' => 'SetValueKey'
                 }
               ],
               'pid' => '2648',
               'parent_name' => 'C:\\WINDOWS\\explorer.exe',
               'parent_pid' => '1380',
               'name' => 'C:\\WINDOWS\\regedit.exe',
               'process_files' => []
             }
           ]
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
        ok(exists($changes->{'screenshot'}), "drive(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

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
}



# =begin testing
{
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
        ok(exists($output->{'os'}), "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");
        ok(exists($output->{'application'}), "getProperties(driver_name => 'HoneyClient::Agent::Driver::Browser::IE')") or diag("The drive() call failed.");

    };

    # Kill the child daemon, if it still exists.
    HoneyClient::Agent->destroy();

    # Report any failure found.
    if ($@) {
        fail($@);
    }
}
}



# =begin testing
{
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

        diag("Performing Integrity check with no changes...");

        # Perform check.
        $som = $stub->check();

        # Verify changes.
        my $changes = thaw(decode_base64($som->result()));

        # Check to see if the check operation completed properly. 
        ok($changes, "check()") or diag("The check() call failed.");
        ok(exists($changes->{'time_at'}), "check()") or diag("The check() call failed.");
        ok(exists($changes->{'fingerprint'}), "check()") or diag("The check() call failed.");

        # Check that os_processes is empty.
        ok(!scalar(@{$changes->{'fingerprint'}->{os_processes}}), "check()") or diag("The check() call failed.");

        diag("Performing Integrity check with artificial changes...");
        
        my $test_realtime_changes_file = getVar(name      => 'realtime_changes_file',
                                                namespace => 'HoneyClient::Agent::Integrity::Test');

        system("cp " . $test_realtime_changes_file . " " . $realtime_changes_file); 
        
        my $expectedFingerprint = {
           'time_at' => '1207172680.376',
           'os_processes' => [
             {
               'stopped' => '2008-04-02 21:44:57.94',
               'created' => '2008-04-02 21:44:40.376',
               'process_registries' => [
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Recent',
                   'value' => 'C:\\Documents and Settings\\Administrator\\Recent',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172688.985',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{259bda13-8b6f-11d7-9c24-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{1bdee3a6-fbab-11dc-9af4-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{259bda11-8b6f-11d7-9c24-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'BaseClass',
                   'value' => 'Drive',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MountPoints2\\{86efd67e-0a06-11dc-97a7-806d6172696f}',
                   'time_at' => '1207172689.32',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Personal',
                   'value' => 'C:\\Documents and Settings\\Administrator\\My Documents',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.329',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Common Documents',
                   'value' => 'C:\\Documents and Settings\\All Users\\Documents',
                   'name' => 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.329',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Desktop',
                   'value' => 'C:\\Documents and Settings\\Administrator\\Desktop',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Common Desktop',
                   'value' => 'C:\\Documents and Settings\\All Users\\Desktop',
                   'name' => 'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'Favorites',
                   'value' => 'C:\\Documents and Settings\\Administrator\\Favorites',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders',
                   'time_at' => '1207172689.797',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_BINARY',
                   'value_name' => 'b',
                   'value' => '6e06f07406507006106402e0650780650004303a05c06307906707706906e05c06806f06d06505c04106406d06906e06907307407206107406f07205c07407207506e06b02d07207705c04306107007407507206503205c06306107007407507206502d06306c06906506e07402d07806506e06f02d06d06f06405c06906e07307406106c06c000',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\LastVisitedMRU',
                   'time_at' => '1207172694.79',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'MRUList',
                   'value' => 'bac',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\LastVisitedMRU',
                   'time_at' => '1207172694.79',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'a',
                   'value' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\txt',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'MRUList',
                   'value' => 'a',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\txt',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'e',
                   'value' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\*',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'MRUList',
                   'value' => 'edcbjihagf',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ComDlg32\\OpenSaveMRU\\*',
                   'time_at' => '1207172694.94',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfEscapement',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfOrientation',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfWeight',
                   'value' => '190',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfItalic',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfUnderline',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfStrikeOut',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfCharSet',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfOutPrecision',
                   'value' => '3',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfClipPrecision',
                   'value' => '2',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfQuality',
                   'value' => '1',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'lfPitchAndFamily',
                   'value' => '31',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iPointSize',
                   'value' => '8c',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'fWrap',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'StatusBar',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'fSaveWindowPositions',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'lfFaceName',
                   'value' => 'Lucida Console',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'szHeader',
                   'value' => '&f',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'szTrailer',
                   'value' => 'Page &p',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginTop',
                   'value' => '3e8',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginBottom',
                   'value' => '3e8',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginLeft',
                   'value' => '2ee',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iMarginRight',
                   'value' => '2ee',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'fMLE_is_broken',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosX',
                   'value' => 'fffffff9',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosY',
                   'value' => '38',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosDX',
                   'value' => '40c',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'iWindowPosDY',
                   'value' => '299',
                   'name' => 'HKCU\\Software\\Microsoft\\Notepad',
                   'time_at' => '1207172697.63',
                   'event' => 'SetValueKey'
                 }
               ],
               'pid' => '2496',
               'parent_name' => 'C:\\WINDOWS\\explorer.exe',
               'parent_pid' => '1380',
               'name' => 'C:\\WINDOWS\\system32\\notepad.exe',
               'process_files' => [
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'event' => 'Delete',
                   'time_at' => '1207172694.79'
                 },
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt',
                   'file_content' => {
                     'sha1' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt2008-04-02 21:44:54.172',
                     'md5' => 'C:\\cygwin\\home\\Administrator\\trunk-rw\\Capture2\\capture-client-xeno-mod\\install\\foo.txt2008-04-02 21:44:54.172',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.172'
                 }
               ]
             },
             {
               'process_registries' => [],
               'pid' => '984',
               'name' => 'C:\\WINDOWS\\system32\\svchost.exe',
               'process_files' => [
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\SendTo',
                   'file_content' => {
                     'sha1' => 'C:\\Documents and Settings\\Administrator\\SendTo2008-04-02 21:44:42.766',
                     'md5' => 'C:\\Documents and Settings\\Administrator\\SendTo2008-04-02 21:44:42.766',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172682.766'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data',
                   'file_content' => {
                     'sha1' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data2008-04-02 21:44:42.782',
                     'md5' => 'C:\\Documents and Settings\\Administrator\\Local Settings\\Application Data2008-04-02 21:44:42.782',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172682.782'
                 }
               ]
             },
             {
               'process_registries' => [
                 {
                   'value_type' => 'REG_EXPAND_SZ',
                   'value_name' => 'CachePath',
                   'value' => '%USERPROFILE%\\Local Settings\\History\\History.IE5\\MSHist012008040220080403',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'CachePrefix',
                   'value' => ':2008040220080403: ',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'CacheLimit',
                   'value' => '2000',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'CacheOptions',
                   'value' => 'b',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_EXPAND_SZ',
                   'value_name' => 'CachePath',
                   'value' => '%USERPROFILE%\\Local Settings\\History\\History.IE5\\MSHist012008040220080403',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'CacheRepair',
                   'value' => '0',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\5.0\\Cache\\Extensible Cache\\MSHist012008040220080403',
                   'time_at' => '1207172694.376',
                   'event' => 'SetValueKey'
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
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.282'
                 },
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.516',
                     'md5' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.516',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.516'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'event' => 'Delete',
                   'time_at' => '1207172694.516'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'b843cb7863d3ded872899f165246c0fcc73f77e2',
                     'md5' => '6267979a84cb1060edab7b0664c419fb',
                     'size' => '986',
                     'mime_type' => 'application/octet-stream'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.547'
                 }
               ]
             },
             {
               'process_registries' => [],
               'pid' => '4',
               'name' => 'System',
               'process_files' => [
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk',
                   'file_content' => {
                     'sha1' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.579',
                     'md5' => 'C:\\Documents and Settings\\Administrator\\Recent\\foo.txt.lnk2008-04-02 21:44:54.579',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.579'
                 },
                 {
                   'name' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                     'md5' => 'C:\\cygwin\\home\\Administrator\\src\\honeyclient-trunk\\thirdparty\\capture-mod\\logs\\deleted_files\\C\\Documents and Settings\\Administrator\\Recent\\install.lnk2008-04-02 21:44:54.579',
                     'size' => -1,
                     'mime_type' => 'UNKNOWN'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.579'
                 },
                 {
                   'name' => 'C:\\Documents and Settings\\Administrator\\Recent\\install.lnk',
                   'file_content' => {
                     'sha1' => 'b843cb7863d3ded872899f165246c0fcc73f77e2',
                     'md5' => '6267979a84cb1060edab7b0664c419fb',
                     'size' => '986',
                     'mime_type' => 'application/octet-stream'
                   },
                   'event' => 'Write',
                   'time_at' => '1207172694.579'
                 }
               ]
             },
             {
               'stopped' => '2008-04-02 21:45:22.344',
               'created' => '2008-04-02 21:45:07.829',
               'process_registries' => [
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'New Value #1',
                   'value' => '',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172715.985',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'foo',
                   'value' => '',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172717.266',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_NONE',
                   'value_name' => 'New Value #1',
                   'value' => '',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172717.266',
                   'event' => 'DeleteValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'foo',
                   'value' => 'bar',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'time_at' => '1207172719.204',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_BINARY',
                   'value_name' => 'View',
                   'value' => '2c00000001000ffffffffffffffffffffffffffffffff500005c000c43008f200d8000c200078000201001000',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                   'time_at' => '1207172722.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_DWORD',
                   'value_name' => 'FindFlags',
                   'value' => 'e',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                   'time_at' => '1207172722.344',
                   'event' => 'SetValueKey'
                 },
                 {
                   'value_type' => 'REG_SZ',
                   'value_name' => 'LastKey',
                   'value' => 'My Computer\\HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer',
                   'name' => 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Applets\\Regedit',
                   'time_at' => '1207172722.344',
                   'event' => 'SetValueKey'
                 }
               ],
               'pid' => '2648',
               'parent_name' => 'C:\\WINDOWS\\explorer.exe',
               'parent_pid' => '1380',
               'name' => 'C:\\WINDOWS\\regedit.exe',
               'process_files' => []
             }
           ]
        };

        # Drive the Agent using IE.
        $som = $stub->check();

        # Verify changes.
        $changes = thaw(decode_base64($som->result()));

        # Check to see if the check operation completed properly. 
        ok($changes, "check()") or diag("The check() call failed.");
        ok(exists($changes->{'time_at'}), "check()") or diag("The check() call failed.");
        ok(exists($changes->{'fingerprint'}), "check()") or diag("The check() call failed.");

        # Check that os_processes is not empty.
        ok(scalar(@{$changes->{'fingerprint'}->{os_processes}}), "check()") or diag("The check() call failed.");

        # Check that fingerprint matches.
        is_deeply($expectedFingerprint, $changes->{'fingerprint'}, "check()") or diag("The check() call failed.");

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
}




1;
