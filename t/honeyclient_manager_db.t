#!/usr/bin/perl -w

use strict;
use Test::More 'no_plan';
$| = 1;



# =begin testing
{
	use HoneyClient::Manager::DB;

    my $h_server = {
            dsn=>'DBI:mysql:mysql;host=localhost',
            username=>'root',
            password=>''
    };
    my $hcdb = new HoneyClient::Manager::DB($h_server);
    
    is($hcdb->deploy(), 1, "deploy()") or diag("Unable to deploy Honey Client Database. Ensure the database service is running.");
    
}



# =begin testing
{
	use HoneyClient::Manager::DB;

	print "Test 2\n";

    my $h_server = {
        dsn=>'DBI:mysql:database=HoneyClient;host=localhost',
        username=>'root',
        password=>''
    };
    
    my $hcdb = new HoneyClient::Manager::DB ($h_server);
    
    my (@Files, @RegKeys, @Procs);
    
    push @Files, {
        path => 'c:\windows\system32',
        name => 'calc.exe',
        content => {
        	md5  => '82da9a561687f841a61e752e401471d2',
        	sha1 => '7552ad083713e6d6b79539b64d598d4dcadfba35',
			size => 114688,
			type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
		}
    };
    push @Files, {
    	path => 'c:\windows\system32',
        name => 'msgina.dll',
        content => {
	        md5  => 'bab513fc028515389eb6b2ad16e35ad2',
    	    sha1 => 'c5597928b22d2c49a41510d6ab11d8f19bfab0af',
        	size => 994304,
        	type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
        }
    };
    push @Files, {
        path => 'c:\windows\system32',
        name => 'drwatson.exe',
        content => {
        	md5  => '37564f065866fa7215453e72f1264f4b',
	        sha1 => '7144ee8b57f3fcae6870f452b140365f75b5265c',
    	    size => 28112,
        	type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
        }
    };
    push @RegKeys, {
        key_name => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        status => 1,
        entries => [
        	{
        		name => 'QuickTime Task',
        		new_value => '"C:\Program Files\QuickTime\qttask.exe" -atboottime'
			}
		]
    };
    push @Procs, {
        name => 'calc'
    };
    push @Procs, {
        name => 'drwatson'
    };
    
    my $exploit1 = {
        Files => \@Files,
        RegKeys => \@RegKeys,
        Procs => \@Procs
    };
    $exploit1->{vmid} = 'VMTest1'; 
    my $exploit2 = {
        Files => [ $Files[0],$Files[1] ],
        RegKeys => \@RegKeys,
        Procs => [ $Procs[0] ]
    };
    $exploit2->{vmid} = 'VMTest2';
    my $exploit3 = {
        RegKeys => \@RegKeys
    };
    $exploit3->{vmid} = 'VMTest3';
    my $exploit4 = {
        Files => [ {md5=>'FailureTestMD5'} ]
    };
    $exploit4->{vmid} = 'VMTest4';
    
	cmp_ok($hcdb->Insert($exploit1,'Fingerprints'),'>',0,"Fingerprint1 Insert()");
	cmp_ok($hcdb->Insert($exploit2,'Fingerprints'),'>',0,"Fingerprint2 Insert()");
	cmp_ok($hcdb->Insert($exploit3,'Fingerprints'),'>',0,"Fingerprint3 Insert()");
	is($hcdb->Insert($exploit4,'Fingerprints'),undef,"Fingerprint4 Insert() Failure");
}



# =begin testing
{
	use HoneyClient::Manager::DB;

    my $h_server = {
        dsn=>'DBI:mysql:database=HoneyClient;host=localhost',
        username=>'root',
        password=>''
    };
    
    my $hcdb = new HoneyClient::Manager::DB ($h_server);
    
    my (@Files, @RegKeys, @Procs);
    
    push @Files, {
        path => 'c:\windows\system32',
        name => 'calc.exe',
        content => {
        	md5  => '82da9a561687f841a61e752e401471d2',
        	sha1 => '7552ad083713e6d6b79539b64d598d4dcadfba35',
			size => 114688,
			type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
		}
    };
    push @Files, {
    	path => 'c:\windows\system32',
        name => 'msgina.dll',
        content => {
	        md5  => 'bab513fc028515389eb6b2ad16e35ad2',
    	    sha1 => 'c5597928b22d2c49a41510d6ab11d8f19bfab0af',
        	size => 994304,
        	type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
        }
    };
    push @Files, {
        path => 'c:\windows\system32',
        name => 'drwatson.exe',
        content => {
        	md5  => '37564f065866fa7215453e72f1264f4b',
	        sha1 => '7144ee8b57f3fcae6870f452b140365f75b5265c',
    	    size => 28112,
        	type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
        }
    };
    push @RegKeys, {
        key_name => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        status => 1,
        entries => [
        	{
        		name => 'QuickTime Task',
        		new_value => '"C:\Program Files\QuickTime\qttask.exe" -atboottime'
			}
		]
    };
    push @Procs, {
        name => 'calc'
    };
    
    my $exploit5 = {
        Files => [ $Files[0],$Files[1] ],
        RegKeys => \@RegKeys,
        Procs => [ $Procs[0] ]
    };
    $exploit5->{vmid} = 'VMTest5';
    my $exploit6 = {
        Files => [ $Files[2] ]
    };
    $exploit6->{vmid} = 'VMTest6';
    
    my $scores = {};
	cmp_ok($hcdb->CheckFingerprint($exploit5,$scores),'>',0,"CheckFingerprint() Success");
	use Data::Dumper; $Data::Dumper::Indent = 1;
	#print 'Scores Debug: '.Dumper($scores)."\n";

	is($hcdb->CheckFingerprint($exploit6,$scores),0,"CheckFingerprint() Fail");
	use Data::Dumper; $Data::Dumper::Indent = 1;
	#print 'Scores Debug: '.Dumper($scores)."\n";
}



# =begin testing
{
	use HoneyClient::Manager::DB;
	#use Relations::Abstract;

    my $h_server = {
            dsn=>'DBI:mysql:mysql;host=localhost',
            username=>'root',
            password=>''
    };
    my $hcdb = new HoneyClient::Manager::DB($h_server);
	
	my $abstract = new Relations::Abstract($hcdb->{dbh});
    
    #is($abstract->run_query("DROP DATABASE HoneyClient"), 1, "DB Cleanup") or diag("Unable to drop Honey Client Database. Ensure the database service is running.");
}




1;
