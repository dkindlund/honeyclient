#!/usr/bin/perl -w
use strict;

use DBI;
use HoneyClient::Util::Config qw(getVar);

# Retrieve values from HoneyClient config file
my $host = getVar(name => "host", namespace => "HoneyClient::DB");
my $user = getVar(name => "user", namespace => "HoneyClient::DB");
my $pass = getVar(name => "pass", namespace => "HoneyClient::DB");
my $database_name = getVar(name => "dbname", namespace => "HoneyClient::DB");

print "Attempting to Create a HoneyClient database with the name: ".
    "${database_name}\n";
my $r_pass = retrieve_pw();

my $dsn = "DBI:mysql:database=mysql;host=".$host;

eval {
    # Connect and Create Database
    my $dbh = DBI->connect($dsn,'root',$r_pass,{'RaiseError' => 1});
    Carp::croak "Connect Failed: $DBI::errstr" if ($dbh eq ''); 
    
    $dbh->do("CREATE DATABASE ".$database_name);
    
    my $mgr_address = (get_mgr_addr() or '127.0.0.1');
    
    # Create A User Account to Access and Manage Database
    print "Attempting to Create database user: ${user}\n";
    $dbh->do("GRANT ALL PRIVILEGES ON ".$database_name.".* TO '".$user."\'@\'".
        $mgr_address."' IDENTIFIED BY '".$pass."'");
        
    $dbh->disconnect() if $dbh;
};
if ($@) {
    die "Failed to initialize Database Connection:\n\t$@";
}

print "Database and user installed successfully.\n";

# Retrieve a password from the user while hiding it from the display
sub retrieve_pw {
    my $p;
    print "Please enter your database 'root' password: ";
    system("stty -echo");
    chomp($p=<STDIN>);
    print "\n";
    system("stty echo");
    return $p;
}

my $re_ip_num = qr{([01]?\d\d?|2[0-4]\d|25[0-5]|%)};
my $re_ip = qr{^$re_ip_num\.$re_ip_num\.$re_ip_num\.$re_ip_num$};

sub get_mgr_addr {
    print "Will the database and the manager run on the same system? [yes] ";
    while(1) {
        my $in;
		chomp($in = <STDIN>);
        if ($in eq "" or $in eq "yes") {
            return "";
        }
        elsif ($in eq "no") {
            print "Enter the address the manager will connect from.\n".
                "(wildcard is %): ";
            while (1) {
                my $addr;
                chomp($addr = <STDIN>);
                print "\n";
				# TODO: Need to check for a valid IP address/netmask.
                #if ($addr =~ /$re_ip/) {
                    return $addr;
                #}
                print "Invalid Entry. Enter the manager address: ";
            }
        }
        else {
            print "Invalid Entry. (type yes or no): ";
        }
    }
}
