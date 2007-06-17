#!/usr/bin/perl

#########################################################
#                                                       #
# Note: This code is untested, an is a work in progress #
#                                                       #
#########################################################

##############################################################################
# Package:     HoneyClient::Manager::DB 
# $LastChangedRevision: 1841 $
# File:        DB.pm
# Description: A module server that provides an interface to the Honeyclient DB
# Author:      mbriggs
#
# CVS:         $Id: DB.pm 1841 2007-01-24 04:13:58Z mbriggs $
#
# Copyright (C) 2006 The MITRE Corporation.  All rights reserved.
#
# This program is free software; you can redistribute it and/or modify it under 
# the terms of the GNU General Public License as published by the Free Software
# Foundation, using version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
# Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
##############################################################################

=pod

=head1 NAME

HoneyClient::Manager::DB - Access, Query, and Manipulate the HoneyClient Database

=head1 VERSION

This documentation refers to HoneyClient::Manager::DB version 0.5.

=head1 SYNOPSIS

use HoneyClient::Manager:DB;

my $h_server = {
    dsn      => "DBI:mysql:database=ExploitDB;host=localhost",
    username => "root",
    password => ""
}
my $hdb = new HoneyClient::Manager::DB();


The HoneyClient database provides storage for fingerprints (or fingerprints) of the Exploits
detected by HoneyClients as well as data about sites visited. HoneyClient::Manager::DB
provides an interface to the data which can be used by the HoneyClient Exploit collection
facilities as well as analysts.

=cut

package HoneyClient::Manager::DB;

#########################
# Module Initialization #
#########################

BEGIN {
    use strict;
    use warnings;
    use Carp ();
    use HoneyClient::Util::Config;
    use Relations::Query;
    use Relations::Abstract;
	use Data::Dumper;

    # Traps signals, allowing END: blocks to perform cleanup.
    use sigtrap qw(die untrapped normal-signals error-signals);
    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.
    
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, $VERSION);
    # Constants for RegKey status field
    our ($KEY_DELETED, $KEY_ADDED, $KEY_MODIFIED) = (0,1,2);
    @ISA = qw(Exporter);
    @EXPORT = qw(new deploy Status Insert Select CheckFingerprint);
    $VERSION = 0.9;
}

####################
# Global Variables #
####################

# The following variables define the variables used to verify the table fields

our %tables = (
    Fingerprints => {
        fields => {
            numfiles     => 1,
            numregkeys   => 1,
            numprocs     => 1,
            vmid         => 1,
            datedetected => 0,
            CVENum       => 0,
            lasturl      => 1,
            notes        => 0,
        },
        selectFunc => \&_SelectFingerprint,
        insertFunc => \&_InsertFingerprint,
    },
    Files => {
        fields => {
        	content => {
        		md5         => 1,
        		sha1        => 1,
        		size        => 1,
        		type        => 1,
        		notes       => 0,
        	},
            path        => 1,
            name        => 1,
            datecreated => 0,
        },
        selectFunc => \&_SelectFiles,
        insertFunc => \&_InsertFile,
    },
    RegKeys => {
        fields => {
            key_name    => 1,
            status		=> 1,
            entries		=> {
            	name    => 1,
            	new_value	=> 1,
            	old_value	=> 0,
            },
            datecreated => 0,
            notes       => 0,
        },
        selectFunc => \&_SelectRegKeys,
        insertFunc => \&_InsertRegKey,
    },
    Procs => {
        fields => {
            name        => 1,
            datecreated => 0,
            notes       => 0,
        },
        selectFunc => undef,
        insertFunc => \&_InsertProc,
    }
);

our %required_fields;

our $threshold=.2;

###################
# Private Methods #
###################

# _InsertFile - Inserts records into the Files and FileContent table.  
# A File should be inserted into the database using the Insert method.
# Returns ID of Inserted File

sub _quote {
	my ($self,$ref) = @_;
	if (!ref $ref) {
		return $self->{dbh}->quote($ref);
	}
	elsif (ref $ref eq 'HASH') {
		my %hash = %{$ref};
		foreach (keys %hash) {
			$hash{$_} = $self->_quote($hash{$_});
		}
		return \%hash;
	}
	elsif (ref $ref eq 'ARRAY') {
		my @arr = @$ref;
		foreach (@arr) {
			$_ = $self->_quote($_);
		}
		return \@arr;
	}
	elsif (ref $ref eq 'SCALAR') { 
			$_ = $self->_quote($_);
	}
	else {Carp::croak(__PACKAGE__."->_quote was passed an illegal reference type: ".ref $ref);}
}

sub _InsertFile {
    my ($self,$h_file,$serial) = @_;
    my ($contentid,$rc,%file);
    eval {
        
        if (!$self->_VerifyHash($h_file,$tables{Files}{fields},1)) {return;}
		%file = %{$self->_quote($h_file)};
		%fileContent = %{ delete $file{content} };
        
        my $abstract = new Relations::Abstract($self->{dbh});
        # Check for existence of file content in Database
        my $query = new Relations::Query(
            -select => 'id',
            -from   => 'FileContent',
            -where  => {md5 => $fileContent{md5}, sha1 => $fileContent{sha1}}
        );
        my $row = $self->{dbh}->selectrow_hashref($query->get());
    	# If content found, record instance only and link to file content
        if (defined($row) && $row > 0) {
        	$file{contentid}  = $row->{id};
        }
        else {
            $file{contentid} = $abstract->insert_id(
                -id    => 'id',
                -table => 'FileContent',
                -set   => \%fileContent);
        }
        $file{serial} = $self->_quote($serial);
    	$rc = $abstract->insert_id(
                -id    => 'id',
                -table => 'Files',
                -set   => \%file
        );
    };
    if ($@) {
        Carp::croak "__PACKAGE__->_InsertFile Failed:\n\t$@";
    }
    return $rc;
}

# _InsertProc - Inserts a record into the Procs Table. A Process should be inserted
# into the database using the Insert method.

sub _InsertProc {
    my ($self,$h_proc,$serial) = @_;
    my $rc;
    eval {
        if (!$self->_VerifyHash($h_proc,$tables{Procs}{fields},1)) {return;}
        my $abstract = new Relations::Abstract($self->{dbh});
        
		my %proc = %{$self->_quote($h_proc)};
        $proc{serial} = $self->_quote($serial);
    
        $rc = $abstract->insert_id(
            -id    => 'id',
            -table => 'Procs',
            -set   => \%proc
        );
    };
    if ($@) {
        Carp::croak "__PACKAGE__->_InsertProc Failed:\n\t$@";
    }
    return $rc;
}

# _InsertRegKey - Inserts a record into the RegKey Table. A RegKey should be inserted
# into the database using the Insert method.

sub _InsertRegKey {
    my ($self,$h_regkey,$serial) = @_;
    my $id;
    eval {
        if (!$self->_VerifyHash($h_regkey,$tables{RegKeys}{fields},1)){return;}
        my $abstract = new Relations::Abstract($self->{dbh});
        
		my %regkey = %{$self->_quote($h_regkey)};
        $regkey{serial} = $self->_quote($serial);
		my @entries = @{delete $regkey{entries}} if (exists $regkey{entries});
        $id = $abstract->insert_id(
            -id    => 'id',
            -table => 'RegKeys',
            -set   => \%regkey
        );
        foreach (@entries) {
			$_->{rkid} = $id;
        	$abstract->insert_id(
        		-id		=> 'id',
        		-table	=> 'RKEntries',
        		-set	=> $_
        	) or Carp::croak __PACKAGE__."->_InsertRegKey Failed: Insert returned a NULL ID";
        }
    };
    if ($@) {
        Carp::croak "__PACKAGE__->_InsertRegKey Failed:\n\t$@";
    }
    return $id;
    
}

# This subroutine is utilized by the new function. The mysql_auto_reconnect attribute
# will refresh the connection should it be dropped.

sub _Connect {
	my ($self) = @_;
	my $dsn = "DBI:".$self->{driver}.":database=".$self->{dbname}.";host=".$self->{host};
    my $dbh = DBI->connect($dsn,$self->{user},$self->{pass},{'RaiseError' => 1});

    if ($dbh ne '') {
        $dbh->{'AutoCommit'} = 0; # In order to use Auto_Reconnect
        #$dbh->{mysql_auto_reconnect} = 1;
#        _SigSetup(); # Signal handling if necessary
    }
    else {
        Carp::croak "__PACKAGE__->_Connect Failed: $DBI::errstr";
    }
    return $dbh;
}

# _VerifyHash - Used to determine if a record represented by a hash reference
#     is in the proper format.
# Input:
# {
#      fields => $a_fields, # Allowable fields in record type 
#      hash => $h_record
# }
# Output: Returns 1 if Hash is in proper format, 0 if not.

# _VerifyHash

sub _VerifyHash {
    my ($self, $hash, $h_fields, $required) = @_;
    my %fields = %$h_fields;
    my $key;
 
    foreach $key (keys %{$hash}) {
    	if (ref $fields{$key}) {
			my $rc = 0;
			if (ref $hash->{$key} eq 'HASH') {
				eval {$self->_VerifyHash($hash->{$key},$h_fields->{$key},$required)};
				if ($@) {
            		Carp::croak($@);
				}
	    	}
    		if (ref $hash->{$key} eq 'ARRAY') {
				foreach (@{$hash->{$key}}) {
					eval {$self->_VerifyHash($_,$h_fields->{$key},$required)};
					if ($@) {
            			Carp::croak($@);
					}
				}
			}
		}
        elsif (exists $fields{$key}) {
            delete $fields{$key};
        }
        else {
            Carp::croak("Invalid Record. $key is not a member of the Table\n");
        }
    }

    if (keys %fields && $required) {
		my @missing;
        foreach $key (keys %fields) {
    		if (!exists $hash->{$key} && $fields{$key}) {
                push @missing, $key;
            }
        }
		if (scalar @missing) {
			Carp::croak("Invalid Record . Missig the following keys:\n\t@missing");
		}
    }
    return 1;
}

##################
# Public Methods #
##################

=item new

Creates a new instance of a DB object which contains a Database Handle {dbh}.

begin testing

#TODO: Add new() test (?)

end testing

=cut

sub new {
    my ($class) = @_;
    my $self = {};              # Anonymous Hash from which to create DB instance
    bless $self, $class;
    $self->{dbname} = getVar(name => "dbname", namespace => "HoneyClient::Manager::DB");
    $self->{host} = getVar(name => "host", namespace => "HoneyClient::Manager::DB");
    $self->{user} = getVar(name => "user", namespace => "HoneyClient::Manager::DB");
    $self->{pass} = getVar(name => "pass", namespace => "HoneyClient::Manager::DB");
    # TODO: Driver Support not supported
    # $self->{driver} = getVar(name => "driver", namespace => "HoneyClient::Manager::DB");
    $self->{driver} = "mysql";
	$self->deploy();
	$self->{dbh} = $self->_Connect();
    return $self;
}

sub DESTROY {
    my $self = shift;
    if ($self->{dbh}) {
        $self->{dbh}->disconnect();
    }
    delete $self->{dbh};
}

=item deploy

=begin testing

	use HoneyClient::Manager::DB;

    my $h_server = {
            dsn=>'DBI:mysql:mysql;host=localhost',
            username=>'root',
            password=>''
    };
    my $hcdb = new HoneyClient::Manager::DB($h_server);
    
    is($hcdb->deploy(), 1, "deploy()") or diag("Unable to deploy Honey Client Database. Ensure the database service is running.");
    
=end testing

=cut

sub deploy {
	my $self = shift;
	my $dbname = $self->{dbname};
	$self->{dbname} = 'mysql';
	my $dbh = $self->_Connect();
	#Check if DB exists already:
	my $sth = $dbh->prepare("SHOW DATABASES");
	$sth->execute();
	my $dbexists = 0;
	while (my $row = $sth->fetchrow_array()) {
		if ($row eq 'HoneyClient') {
			$dbexists = 1;
			last;
		}
	}
	$sth->finish();
	if (!$dbexists) {
		my $abstract = new Relations::Abstract($dbh);
	    $abstract->run_query("CREATE DATABASE HoneyClient");
	    $abstract->run_query("USE HoneyClient");
	    $abstract->run_query("
	        CREATE TABLE Fingerprints
	        (
	            serial INT UNSIGNED AUTO_INCREMENT,
	            vmid VARCHAR(26) NOT NULL,
	            datedetected TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	            numfiles INT UNSIGNED,
	            numregkeys INT UNSIGNED,
	            numprocs INT UNSIGNED,
	            notes TEXT,
	            cveid VARCHAR(10),
	            lasturl TEXT,
				PRIMARY KEY (serial)
	        ) ENGINE=InnoDB
	    "); # or die "Failed Creating Fingerprints Table"; not necessary because of RaiseError??
	    $abstract->run_query("
	        CREATE TABLE Files
	        (
    	        id INT UNSIGNED AUTO_INCREMENT,
	            serial INT UNSIGNED NOT NULL,
	            contentid INT UNSIGNED NOT NULL,
	            name VARCHAR(255) NOT NULL,
	            path VARCHAR(255) NOT NULL,
	            datecreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				PRIMARY KEY (id)
	        ) ENGINE=InnoDB
	    "); # or die "Failed Creating Files Table"; not necessary because of RaiseError??
	     $abstract->run_query("
	        CREATE TABLE FileContent
	        (
	            id INT UNSIGNED AUTO_INCREMENT,
	            md5 VARCHAR(32) NOT NULL,
	            sha1 VARCHAR(40) NOT NULL,
	            size INT UNSIGNED,
	            type VARCHAR(255) NOT NULL,
	            notes TEXT,
				PRIMARY KEY (id)
	        ) ENGINE=InnoDB
	    "); # or die "Failed Creating FileContent Table"; not necessary because of RaiseError??
	    $abstract->run_query("
	        CREATE TABLE RegKeys
	        (
	            id INT UNSIGNED AUTO_INCREMENT,
	            serial INT UNSIGNED NOT NULL,
	            key_name VARCHAR(255) NOT NULL,
				status INT UNSIGNED NOT NULL,
	            datecreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	            notes TEXT,
				PRIMARY KEY (id)
	        ) ENGINE=InnoDB
	    "); # or die "Failed Creating RegKeys Table"; not necessary because of RaiseError??
	    $abstract->run_query("
	        CREATE TABLE RKEntries
	        (
	            id INT UNSIGNED AUTO_INCREMENT,
	            rkid INT UNSIGNED NOT NULL,
	            name VARCHAR(255) NOT NULL,
	            new_value LONGBLOB NOT NULL,
	            old_value LONGBLOB,
				PRIMARY KEY (id)
	        ) ENGINE=InnoDB
	    "); # or die "Failed Creating RegKeys Table"; not necessary because of RaiseError??
	    $abstract->run_query("
	        CREATE TABLE Procs
	        (
	            id INT UNSIGNED AUTO_INCREMENT,
	            serial INT UNSIGNED NOT NULL,
	            name VARCHAR(255) NOT NULL,
	            datecreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				notes TEXT,
				PRIMARY KEY (id)
	        ) ENGINE=InnoDB
	    "); # or die "Failed Creating Procs Table"; not necessary because of RaiseError??
	    $abstract->run_query("
	        CREATE FUNCTION objcount (s INT) RETURNS INT DETERMINISTIC
	        BEGIN
	        	DECLARE f,r,p,sum INT;
	        	SET sum = 0;
	        	SELECT numfiles,numregkeys,numprocs INTO f,r,p FROM Fingerprints WHERE serial=s;
	        	SET sum = f + r + p;
	        	RETURN sum;
	        END;
	    "); # or die "Failed Creating Procs Table"; not necessary because of RaiseError??
	}
	$self->{dbname} = $dbname;
	$dbh->disconnect() if ($dbh);
}

=item Insert

Insert is used to insert a new File, Registry Key, or Process into the database.
Returns the ID of the item inserted.
Input: $h_object,$table,$serial

=end Insert

$h_object is a hash reference to an object of type File, RegKey or Proc.
$table is a string which can be: 'Files', 'RegKey' or 'Proc'.
$serial is an integer value which represents the Serial Number of the Exploit Fingerprint.


A File Object is of the form:

=begin FileRef

{
	path => 'c:\Windows',
    name => 'notepad.exe',
    content => {
		md5 => '388b8fbc36a8558587afc90fb23a3b99',
		sha1 => 'ed55ad0a7078651857bd8fc0eedd8b07f94594cc',
		size => '69120',
		type => 'MS-DOS executable (EXE), OS/2 or MS Windows'
	}
}

=end FileRef

A RegKey reference is of the form:

=begin RegKeyRef

{
    key_name => 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\run',
    status => 1, # 0 -> Deleted, 1 -> Added, 2 -> Modified 
    entries => [
    	{
    		name	=> 'notepad',
    		old_value => '',
    		new_value => 'notepad.exe'
    	}
    ]
}

=end RegKeyRef

A Process reference is of the form:

=begin ProcRef

{
    name => 'notepad.exe',
    date => 'Administrator'
}

=end ProcRef

=cut

sub Insert {
    my ($self,$h_object,$table,$serial) = @_;
    my $rc;    
    eval {
        if(!exists $tables{$table}) {
            Carp::carp("Insert Failed: Table is undefined: $table");
            return;
        }
        if ($tables{$table}{insertFunc}) {
            $self->{dbh}->{'AutoCommit'} = 0;
            if ($self->{dbh}->{'AutoCommit'}) {
                Carp::croak("Disabling Autocommit Failed");
            }
            $rc = &{$tables{$table}{insertFunc}}($self,$h_object,$serial);
        }
        else {
            Carp::carp("No Insert function defined for: $table");
            return;
        }
    };
    if ($@) {
        Carp::carp("Insert Failed. Rolling Back Changes:\n\t$@");
        eval { $self->{dbh}->rollback() };
        if ($@) {
            Carp::croak("Rollback failed");
        }
        return;
    }
    else {
        $self->{dbh}->commit();
        #$self->{dbh}->{'AutoCommit'} = 1;
        #if (!$self->{dbh}->{'AutoCommit'}) {
            # TODO: Handle Error
        #}
        return $rc;
    }
}

=pod

=item _InsertFingerprint

_InsertFingerprint is used to insert a new Exploit Fingerprint into the database.
This function is now to be called as follows: Insert($href_fingerprint,'Fingerprints');
The input is a hash reference containing 3 arrays of hash references as follows:

{
    Files = [$h_file1, $h_file2, $h_file3,...],
    RegKeys = [$h_regKey1, $h_regKey2, $h_regKey3,...],
    Procs = [$h_proc1, $h_proc2, $h_proc3,...],
    vmid = 'VMID here'
}

=begin testing

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

=end testing

=cut

sub _InsertFingerprint {
    my ($self,$fpData,$serial) = @_;
    
    eval {
        my $fingerprint = {
            vmid => $self->_quote($fpData->{vmid})
            lasturl => $self->_quote($fpData->{lasturl})
        };
        $fingerprint->{numfiles}   = ref $fpData->{Files} eq 'ARRAY' ? scalar(@{$fpData->{Files}}) : 0;
        $fingerprint->{numregkeys} = ref $fpData->{RegKeys} eq 'ARRAY' ? scalar(@{$fpData->{RegKeys}}) : 0;
        $fingerprint->{numprocs}   = ref $fpData->{Procs} eq 'ARRAY' ? scalar(@{$fpData->{Procs}}) : 0;
        my $abstract = new Relations::Abstract($self->{dbh});
        $serial = $abstract->insert_id(
            -id    => 'serial',
            -table => 'Fingerprints',
            -set   => $fingerprint);
        foreach my $file (@{$fpData->{Files}}) {
            &{$tables{'Files'}{insertFunc}}($self,$file,$serial) or 
                Carp::croak("File insert returned a Null ID for: $file->{md5}");;
        }
        foreach my $regkey (@{$fpData->{RegKeys}}) {
            &{$tables{'RegKeys'}{insertFunc}}($self,$regkey,$serial) or 
                Carp::croak("Registry Key insert returned a Null ID for: $regkey->{key}");
        }
        foreach my $proc (@{$fpData->{Procs}}) {
            &{$tables{'Procs'}{insertFunc}}($self,$proc,$serial) or 
                Carp::croak("UProcess insert returned a Null ID for: $proc->{name}");
        }
    };
    if ($@) {
        Carp::croak "__PACKAGE__->_InsertFingerprint Failed:\n\t$@";
    }
	return $serial;
}

=item CheckFingerprint

When an Exploit is found by a HoneyClient, its Fingerprint can be compared against
existing fingerprints using the CheckFingerprint function to determine if it is new.
The input is a hash reference containing 3 arrays of hash references as follows:

{
    Files = [$h_file1, $h_file2, $h_file3,...],
    RegKeys = [$h_regKey1, $h_regKey2, $h_regKey3,...],
    Procs = [$h_proc1, $h_proc2, $h_proc3,...]
}

=begin testing

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

=end testing

=cut

sub CheckFingerprint {
    my ($self, $h_sigData, $h_scores) = @_;
    
    my $numfiles   = ref $h_sigData->{Files} eq 'ARRAY' ? scalar(@{$h_sigData->{Files}}) : 0;
    my $numregkeys = ref $h_sigData->{RegKeys} eq 'ARRAY' ? scalar(@{$h_sigData->{RegKeys}}) : 0;
    my $numprocs   = ref $h_sigData->{Procs} eq 'ARRAY' ? scalar(@{$h_sigData->{Procs}}) : 0;
    my $objCount= $numfiles + $numregkeys + $numprocs;
    my (%fileMatches,%regMatches,%procMatches);
    my ($i,$rows,$r,$serial);
    for ($i = 0; $i < $numfiles; $i++) {
        $rows = $self->Select({
            table => 'Files',
            where  => {
                'content' => {
                    'md5' => $h_sigData->{Files}->[$i]->{content}->{md5},
                    'sha1' => $h_sigData->{Files}->[$i]->{content}->{sha1},
                }
            }
        });
        foreach (@$rows) {
            $serial = $_->{serial};
            $serial = delete $_->{serial};
            $fileMatches{$serial}{$i} = $_;
        }
	}
    for ($i = 0; $i < $numregkeys; $i++) {
        $rows = $self->Select({
            table => 'RegKeys',
            where  => {'key_name' => $h_sigData->{RegKeys}->[$i]->{key_name},
                       'entries'  => $h_sigData->{RegKeys}->[$i]->{entries},
            }
        });
        while ($r = shift(@$rows)) {
            $serial = delete $r->{serial};
            $regMatches{$serial}{$i} = $r;
        }
    }
    for ($i = 0; $i < $numprocs; $i++) {
        $rows = $self->Select({
            table => 'Procs',
            where  => {'name'  => $h_sigData->{Procs}->[$i]->{name}}
        });
        while ($r = shift(@$rows)) {
            $serial = delete $r->{serial};
            $procMatches{$serial}{$i} = $r;
        }
    }
    my %scores =(); my $key; my @matches;
    
    foreach $key (keys %fileMatches) {
        $scores{$key} += keys %{$fileMatches{$key}};
    }
    foreach $key (keys %regMatches) {
        $scores{$key} += keys %{$regMatches{$key}};
    }
    foreach $key (keys %procMatches) {
        $scores{$key} += keys %{$procMatches{$key}};
    }
    foreach $key (keys %scores) {
        if ($scores{$key}/$objCount < $threshold) {
            delete $fileMatches{$key};
            delete $regMatches{$key};
            delete $procMatches{$key};
            delete $scores{$key};
        }
        elsif ($scores{$key}/$objCount == 1) {
        	my $matchObjCount = $self->{dbh}->selectrow_array("SELECT objcount($key)");
        	if($matchObjCount == $objCount) {push @matches,$key;}
        }
    }
    $h_scores->{Scores}  = \%scores;
    $h_scores->{Files}   = \%fileMatches;
    $h_scores->{RegKeys} = \%regMatches;
    $h_scores->{Procs}   = \%procMatches;
    return @matches;
}

#Todo: Test for Select Function

=item Select

Queries the database for Exploit or Log Records based upon a the Query Hash passed to it.

Returns an array of Records formed as Hash References.

=cut

sub Select {
    my ($self,$h_query) = @_;
    if (!exists $tables{$h_query->{table}}){
        Carp::carp("Attempted query on non-existent table: $h_query->{table}");
        return;
    }
	if (!$self->_VerifyHash($h_query->{where}, $tables{$h_query->{table}}{fields},0) ) {
		my $f = join ',',(keys %{$h_query->{where}});#TODO: Error Handling
       	Carp::carp("Query contains invalid fields $f");
       	return;
   	}
    if ($tables{ $h_query->{table} }{selectFunc}) {
        return &{ $tables{$h_query->{table}}{selectFunc} }($self,$h_query);
    }
    else {
        my $query = new Relations::Query(
            -select => '*',
            -from   => $h_query->{table}
		);
		foreach ('order_by','limit') {
			$query->set("-$_" => $h_query->{$_}) if (defined $h_query->{$_});
		}
    	if ( defined $h_query->{where} ) {
			my %where = %{$self->_quote($h_query->{where})};
			$query->set(-where => \%where);
		}
        return $self->{dbh}->selectall_arrayref($query->get(),{ Slice => {} });
    }
}

# _SelectFiles($h_query) - Private Helper function to Select files
# Creates a SQL Select statement from the Query Hash passed to it.
# Returns - An array reference to an array of file records

sub _SelectFiles {
	my ($self,$q) = @_;
	my (%where,%content);
	my $select = [ 'Files.id','Files.contentid','Files.serial','Files.name',
	   'Files.path','Files.datecreated','FileContent.md5','FileContent.sha1',
	   'FileContent.size','FileContent.type','FileContent.notes'
	];
	my $query = new Relations::Query(
	   -select => $select,
	   -from   => 'Files JOIN FileContent on Files.contentid=FileContent.id',
	);
	if (exists $q->{where}) {
		%where = %{$self->_quote($q->{where})};
		%content = %{delete $where{content}} if (exists $where{content});
		$query->set(-where => \%where) if (keys %where);
		$query->add(-where => \%content) if (keys %content);
	}
	foreach ('order_by','limit') {
	    $query->set("-$_" => $q->{$_}) if( $q->{$_} );
	}
	my $sth = $self->{dbh}->prepare($query->get());
	$sth->execute();
	
	my %file; my @files;	
	map {$file{$_}=''} ('id','contentid','serial','name','path','datecreated');
	map {$file{content}{$_}=undef} ('md5','sha1','size','type','notes');
    eval {
        $sth->bind_columns(
            \($file{id},$file{contentid},$file{serial},$file{name},$file{path},$file{datecreated},$file{content}{md5},
            $file{content}{sha1},$file{content}{size},$file{content}{type},$file{content}{notes})
	    );
    };
    if ($@) {
        Carp::croak($@);
    }

	while ($sth->fetch) {
        my %tempf = %file;
        my %tempc = %{$file{content}};
        $tempf{content} = \%tempc;
		push @files, \%tempf;
	}
	return \@files;
}

# _SelectRegKeys($h_query) - Private Helper function to Select regkeys
# Creates a SQL Select statement from the Query Hash passed to it.
# Returns - An array reference to an array of regkey records

sub _SelectRegKeys {
	#TODO: _SelectRegKeys function
    my ($self,$q) = @_;
    my (@regkeys,%ids,%entries);
    my %rowR = map {$_,undef} ('id','serial','key_name','status','datecreated','notes');
    my %rowE = map {$_,undef} ('name','new_value','old_value','rkid');
    my $query = new Relations::Query();
    if ($q->{where}) {
        my %where = %{$self->_quote($q->{where})};
        if (@entries = @{delete $where{entries}}) {
            $query->set(
                    -select => "RegKeys.*,RKEntries.name,RKEntries.new_value,RKEntries.old_value,RKEntries.rkid",
                    -from   => "RegKeys JOIN RKEntries ON RegKeys.id=RKEntries.rkid"
            );
            foreach my $entry (@entries) {
                $query->set(-where => \%where) if (keys %where);
                $query->add(-where => \%$entry);
                my $sth = $self->{dbh}->prepare($query->get());
                $sth->execute();
                $sth->bind_columns(\$rowR{id},\$rowR{serial},\$rowR{key_name},\$rowR{status},
                        \$rowR{datecreated},\$rowR{notes},\$rowE{name},\$rowE{new_value},
                        \$rowE{old_value},\$rowE{rkid});
                while($sth->fetch()) {
                    if(exists $ids{$rowR{id}}) {
                        my %temp = %rowE;
                        my $id = $ids{$rowR{id}};
                        push @{$regkeys[$id]->{entries}},\%temp;
                    }
                    else {
                        my %tempR = %rowR;
                        push @regkeys, \%tempR;
                        $ids{$rowR{id}} = $#regkeys;
                        my %tempE = %rowE;
                        push @{$regkeys[$#regkeys]->{entries}},\%tempE;
                    }
                }
            }
        }
        else {
            $query->set(
                    -select => "*",
                    -from   => "RegKeys",
                    -where  => $q->{where}
                    );
            @regkeys = @{$self->{dbh}->selectall_arrayref($query->get(),{ Slice => {} })};
            foreach my $row (@regkeys) {
                my $subquery = new Relations::Query(
                        -select => ['name','new_value','old_value'],
                        -from   => 'RKEntries',
                        -where  => {rkid => $row->{id}}
                        );
                $rowE = $self->{dbh}->selectall_arrayref($query->get(),{ Slice => {} });
                if(scalar @{$rowE}) { $row->{entries} = $rowE; }
            }
        }
    }
    return \@regkeys;
}

#_SelectFingerprint - Creates and executes a query for a fingerprint
# Returns hash reference to a fingerprint package, or undef if a failure occurs.

sub _SelectFingerprint {
    my ($self,$q) = @_;
    my $query = new Relations::Query(
        -select => '*',
        -from   => 'Fingerprints',
        -limit  => 1
    );
	if (exists $q->{where} ) {
		my %where = %{$self->_quote($q->{where})};
		$query->set(-where => \%where);
	}
    my $fingerprint = $self->{dbh}->selectrow_hashref($query->get()) or return undef;
    # Get Files
    $fingerprint->{Files} = $self->Select({
            table    => 'Files',
            where    => {serial => $fingerprint->{serial}},
            order_by => {'name'}
    });
    # Get RegKeys
    $fingerprint->{RegKeys} = $self->Select({
            table    => 'RegKeys',
            where    => {serial => $fingerprint->{serial}},
            order_by => {'`key`','name'}
    });
    # Get Procs 
    $fingerprint->{Procs} = $self->Select({
            table    => 'Procs',
            where    => {serial => $fingerprint->{serial}},
            order_by => {'name'}
    });
    return $fingerprint;
}

=item Status

=cut

sub Status {
}

=begin testing

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

=end testing

=cut

1;
