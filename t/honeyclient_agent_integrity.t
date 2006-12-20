#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
# Make sure HoneyClient::Agent::Integrity loads.
BEGIN { use_ok('HoneyClient::Agent::Integrity', qw(initAll checkAll initRegistry checkRegistry initFileSystem checkFileSystem)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent::Integrity');
#can_ok('HoneyClient::Agent::Integrity', 'new');
can_ok('HoneyClient::Agent::Integrity', 'initAll');
can_ok('HoneyClient::Agent::Integrity', 'checkAll');
can_ok('HoneyClient::Agent::Integrity', 'initFileSystem');
can_ok('HoneyClient::Agent::Integrity', 'checkFileSystem');
use HoneyClient::Agent::Integrity qw(initAll checkAll initFileSystem checkFileSystem);

# Make sure HoneyClient::Util::Config loads.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar)) or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
use HoneyClient::Util::Config qw(getVar);

# Make sure File::Find loads.
BEGIN { use_ok('File::Find', qw(find)) or diag("Can't load File::Find package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Find');
can_ok('File::Find', 'find');
use File::Find;

# Make sure Digest::MD5 loads.
#BEGIN { use_ok('Digest::MD5', qw(new)) or diag("Can't load Digest::MD5 package.  Check to make sure the package library is correctly listed within the path."); }
#require_ok('Digest::MD5');
#use Digest::MD5;

# Make sure MIME::Base64 loads.
BEGIN { use_ok('MIME::Base64', qw(encode_base64 decode_base64)) or diag("Can't load MIME::Base64 package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('MIME::Base64');
can_ok('MIME::Base64', 'encode_base64');
can_ok('MIME::Base64', 'decode_base64');
use MIME::Base64 qw(encode_base64 decode_base64);

# Make sure Storable loads.
BEGIN { use_ok('Storable', qw(dclone nfreeze thaw)) or diag("Can't load Storable package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'dclone');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
use Storable qw(dclone nfreeze thaw);

###Testing Globals###
# Directory where the known-good test files are stored
$test_dir = getVar(name => "test_dir");

# List of files and directories to check during filesystem checking
$file_checklist = getVar(name => "file_checklist");

# List of files or directories to exclude if found in subdirs during
# filesystem check.
$file_exclude = getVar(name => "file_exclude");

# File where found changes are written to
$change_file = getVar(name => "change_file");
}



# =begin testing
{
#Testing initFileSystem();

my $ob = HoneyClient::Agent::Integrity->new();

system("mkdir /tmp/hc_test_dir");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/hi.txt > $file_checklist");
system("echo /tmp/hc_test_dir/hi.txt > $file_exclude");
$ob->initFileSystem();
open (FILE, "cleanfile.txt") or die "Can't check the cleanfile.txt\n";
@result = <FILE>;
close FILE;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initFileSystem: Explicit Filesystem Omission');

system("rm $file_exclude");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/hi.txt > $file_checklist");
system("echo /tmp/hc_test_dir/ > $file_exclude");
$ob->initFileSystem();
open (FILE, "cleanfile.txt") or die "Can't check the cleanfile.txt\n";
@result = <FILE>;
close FILE;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initFileSystem: Directory Filesystem Omission');

system("rm $file_exclude");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/hi.txt > $file_checklist");
$ob->initFileSystem();
open (DIFF, "diff $test_dir/fs1.txt cleanfile.txt |") or die "Can't check the cleanfile.txt\n";
@result = <DIFF>;
close DIFF;
#Bad test because it will be empty in the case of an error anyway?
is(scalar(@result), 0, 'initFileSystem: Known-good file hash');

system("rm -rf /tmp/hc_test_dir/");
system("rm $file_checklist");
}



# =begin testing
{
#Testing that checkFileSystem()

my $ob = HoneyClient::Agent::Integrity->new();
my @result;

#add
system("rm $change_file");
system("mkdir /tmp/hc_test_dir/");
system("echo hi > /tmp/hc_test_dir/hi.txt");
system("echo /tmp/hc_test_dir/ > $file_checklist");
$ob->initFileSystem();
system("echo hi > /tmp/hc_test_dir/hi2.txt");
$ob->checkFileSystem();
open(CHECK, "diff $test_dir/fs2.txt $change_file |") or die "There was a problem doing the fs2.txt diff"; 
#XXX Won't the die statement just be masked by the redirection of stdout/stderr?
@result = <CHECK>;
close(CHECK);
is(scalar(@result), 0, "checkFileSystem: Files added");


#delete
system("rm $change_file");
system("rm /tmp/hc_test_dir/hi.txt");
$ob->checkFileSystem();
open(CHECK, "diff $test_dir/fs3.txt $change_file |") or die "There was a problem doing the fs2.txt diff"; 
#XXX Won't the die statement just be masked by the redirection of stdout/stderr?
@result = <CHECK>;
close(CHECK);
is(scalar(@result), 0, "checkFileSystem: Files deleted");

#change
system("rm $change_file");
system("echo again >> /tmp/hc_test_dir/hi.txt");
$ob->checkFileSystem();
open(CHECK, "diff $test_dir/fs4.txt $change_file |") or die "There was a problem doing the fs2.txt diff"; 
#XXX Won't the die statement just be masked by the redirection of stdout/stderr?
@result = <CHECK>;
close(CHECK);
is(scalar(@result), 0, "checkFileSystem: Files changed");

system("rm -rf /tmp/hc_test_dir/");
system("rm $file_checklist");
}




1;
