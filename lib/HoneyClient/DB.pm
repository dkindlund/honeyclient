#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB
# File:        DB.pm
# Description: Abstract class for controlling HoneyClient Database Access
#
# CVS: $Id$
#
# @author mbriggs, kindlund
#
# Copyright (C) 2007 The MITRE Corporation.  All rights reserved.
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

=head1 NAME

HoneyClient::DB - Abstract HoneyClient Database Class

=head1 SYNOPSIS

HoneyClient::DB is an abstract class that is used to store HoneyClient
compromise data, system configurations, network traffic, or any other desired
data. A class can be created as follows:
  
  use HoneyClient::DB;
  package HoneyClient::DB::SuperHero::Ability;
  use base("HoneyClient::DB");
   
  our %fields => {
  	  string => {
  	  	  name => {
  	  	  	  required => 1,
  	  	  },
          real_name => {
              required => 1
          }
  	  },
  	  text => {
  	  	  description => {
  	  	  },
  	  },
  	  int => [recharge_time],
  };
   
  package HoneyClient::DB::SuperHero;
  use base("HoneyClient::DB");
   
  our %fields => {
  	  string => {
  	  	  name => {
  	  	  	  required => 1,
  	  	  },
  	  	  real_name => {},
  	  },
  	  int => [height,weight],
  	  array => {
  	  	  abilities => {
  	  	  	  objclass=> "HoneyClient::DB::SuperPower",
  	  	  },
  	  },
  	  timestamp => {
  	  	  birth_date => {
  	  	    required => 1,
  	  	  },
  	  },
  };

  use HoneyClient::DB::SuperHero;

  my $hero = { 
      name => 'Superman',
      real_name => 'Clark Kent'
      weight => 225,
      height => 75,
      birth_date => '06011938 12:34:56',
      ability => [
          {
              name => 'Super Strength',
              description => 'More powerful than a locomotive',
          },
          {
              name => 'Flight',
              description => 'It's a bird, it's a plane...',
          },
          {
              name => 'Heat Vision',
              recharge_time => 5,
          },
      ]
  };

  my $hero = HoneyClient::DB::SuperHero->new($hero);
  
  $hero->insert();

  my $filter = {
      name => 'Superman',
  };

  my $hero1 = HoneyClient::DB::SuperHero->select($filter);

=head1 DESCRIPTION

B<HoneyClient::DB> is an abstract class used to access the HoneyClient
Database. The class is not to be used directly, but can be used to derive
classes of objects that will be inserted into the HoneyClient Database during
the operation of a HoneyClient component.

B<NOTE:> It is important to note that HoneyClient::DB will die if it is used
without the prior existence of the database described in /etc/honeyclient.xml or
if the module cannot establish a connection.

=head1 CONFIG

Configuration options used by HoneyClient::DB to establish connections are
stored in /etc/honeyclient.xml.

=cut

package HoneyClient::DB;

use strict 'vars', 'subs';
use warnings;

BEGIN {
    #Dependencies
    use DBI;
    use Carp ();
    use HoneyClient::Util::Config;
    use DateTime::Format::ISO8601;
	use Data::Dumper;
	use Math::BigInt;
	require Exporter;

    # Traps signals, allowing END: blocks to perform cleanup.
    use sigtrap qw(die untrapped normal-signals error-signals);
    $SIG{PIPE} = 'IGNORE'; # Do not exit on broken pipes.

    #Globals
    our @ISA = qw(Exporter);
    our @EXPORT = qw();
    our @EXPORT_OK;
    our $VERSION = 0.9;

    my $database_version; #  = $dbh->get_info(  18 ); # SQL_DBMS_VER
}

our $dbhandle;
# To be used ONLY INTERNALLY!
our (%_types,%_check,%_required,%_init_val,%_keys,%defaults);
# %fields must be defined by all children classes
our %fields;

#constants
our ($STATUS_DELETED, $STATUS_ADDED, $STATUS_MODIFIED) = (0,1,2); # Integrity status field
our ($KEY_NONE,$KEY_INDEX,$KEY_UNIQUE,$KEY_UNIQUE_MULT) = (0,1,2,3); # Uniqueness of Attributes
our $debug = 0;
# Initialize Connection
our %config;
$config{driver} = "mysql";
$config{host} = getVar(name => "host", namespace => "HoneyClient::DB");
$config{port} = getVar(name => "port", namespace => "HoneyClient::DB");
$config{user} = getVar(name => "user", namespace => "HoneyClient::DB");
$config{pass} = getVar(name => "pass", namespace => "HoneyClient::DB");
$config{dbname} = getVar(name => "dbname", namespace => "HoneyClient::DB");

if (!db_exists(%config)) {
    die;
}

END {
    $dbhandle->disconnect() if $dbhandle;
}

=head1 METHODS

=head2 Object Creation

=over 4

=item new HoneyClient::DB

new Receives an unblessed hash, imports the schema (if necessary), checks that
required fields contain the proper data, and returns the blessed object.

It must be called using an object class derived from HoneyClient::DB.
For Example:

  $my_obj = new HoneyClient::DB::SomeObj->new({
  	field_a => "foo",
  	field_b => "bar"
  });

=cut

sub new {
    my ($class,$self) = @_;
    
    bless($self,$class);
    # Check if Schema has been imported
    if (!exists($_types{$class})) {
        _import_schema($class);
    }
    # Make sure required Attributes are set. Fail if not.
	my @missing = $self->_check_required();
    if (scalar @missing) {
        Carp::croak("Object missing required attribute(s): ".join(', ',@missing).'.\n\t');
    }

    # Check if ref and array objects have been initialized. If not call new
    foreach my $key (keys %$self){
    	eval {
	    	if ($self->{$key}) {
                $self->{$key} = $_check{$class}{$key}->($self->{$key});
            }
	    };
	    if ($@) {
	    	Carp::croak "Invalid Object!\n\t$@";
	    }
        if ($_types{$class}{$key} =~ m/(array|ref):(.*)/) {
        	my $ref = ref ($self->{$key});
            my $childType = $1;
            my $childClass = $2;
            if ($childClass->can('new')) {
            	if( $ref eq 'HASH' and $childType eq 'ref') {
                    $self->{$key} = $childClass->new($self->{$key});
                }
                if ($ref eq 'ARRAY' and $childType eq 'array') {
            		foreach my $obj (@{$self->{$key}}) {
    	                $obj = $childClass->new($obj);
    	            }
                }
			}
            else {
               	Carp::croak "Invalid Object! $childType does not exist";
            }
        }
    }
    return $self;
}

################# Initialization Helper Functions #################

sub _check_required {
    my $self = shift;
    my $class = ref $self;
    # make sure field is not undef if 'required' option is set
    if (exists $_required{$class}) {
	    my @missing;
	    foreach ( keys %{$_required{$class}} ) {
            push(@missing, $_) if (!defined($self->{$_}) or ($self->{$_} eq ""));
	    }
	    return @missing;
    }
    return;
}

sub _import_schema {
    my $class = shift;
    my $schema = \%{$class."::fields"};
    # Parase Attributes; store types and options.
    while(my ($type,$attrib) = each(%$schema)) {
        my $ref = ref $attrib;
        # Attributes in array format use default options
        if($ref eq 'ARRAY') {
            foreach (@{$attrib}) {
                $_types{$class}{$_}=$type;
                if ($type =~ m/(ref|array)/) {
                    delete $_types{$class};
                    Carp::croak "Invalid Object Type. ref AND array types must ".
                        "be defined as a hash containing 'objclass'";
                }
                $_check{$class}{$_} = $defaults{$type}{check_func} or
                    $_check{$class}{$_} = \&check_nothing;
            }
        }
        # Parse options for attributes in hash table format
        elsif ($ref eq 'HASH') {
            while (my ($a,$opts) = each %$attrib) {
                $_types{$class}{$a} = $type;
                if ($opts->{required}) {
                    $_required{$class}{$a} = 1;
                }
                # array and ref types require the objclass option
                if ($type =~ m/^(array|ref)$/) {
                	die "$1 of unknown class: $a" if(!exists $opts->{objclass});
                    if (!exists $_types{$opts->{objclass}}) {
                        _import_schema($opts->{objclass});
                    }
                    $_types{$class}{$a} .= ':'.$opts->{objclass};
                }
                # Check function will ensure data is of proper format
                if ($opts->{check_func}) {
                    $_check{$class}{$a} = $opts->{check_func};
                }
                else {
                    $_check{$class}{$a} = $defaults{$type}{check_func} or
                        $_check{$class}{$a} = \&check_nothing;
                }
                # key option determines if attribute is an index
                if ($opts->{key}) {
                	$_keys{$class}{$a} = $opts->{key};
                }
                if ($opts->{init_val}) {
                	$_init_val{$class}{$a} = $opts->{key};
                }
            }
        }
        else {
            Carp::carp("$class\{$type\} is defined improperly");
        }
    }
    # Add the table to the DB if necessary
    # TODO: Move to install script??
    $class->deploy_table() or Carp::croak("${class}->_import_schema: ".
    	"Failed to deploy table");
}

=back

=head2 Database Operations

=over 4

=item insert

Creates and executes a SQL INSERT statement for the referenced object. The
object must be initialized at the time this method is called.

  $my_obj->insert();

=cut

sub insert {
    my $obj = shift;
    my $id = undef;
    
    $dbhandle = HoneyClient::DB::_connect(%config);
    # Attempt insert; commit if succeeds, else rollback
    eval {
        $id = _insert($obj, undef);
    };
    if($@) {
    	Carp::carp ("insert failed, Rolling Back: $@"); 
    	$dbhandle->rollback();
    }
    else {
       $dbhandle->commit();
    }
    print "\n" if ($debug);
    $dbhandle->disconnect() if $dbhandle;
    return $id;
}

##################### Insert Helper Functions #####################

sub _insert {
    my ($obj, $fk_col, $fk_id) = @_;
    my $ref = ref $obj;

    if ($ref eq 'ARRAY') {
        return _insert_array($obj, $fk_col, $fk_id);
    }
    elsif (exists $_types{$ref}) {
        return _insert_obj($obj, $fk_col, $fk_id);
    }
    elsif ($ref) {
        Carp::carp ("Can't insert object of type $ref");
    }
    else {
        Carp::carp ("Attempted to insert scalar value into the database");
    }
    return undef;
}
sub _insert_array {
    my ($obj, $fk_col, $fk_id) = @_;
    my @entries;
    foreach (@$obj) {
        my $id = _insert($_, $fk_col, $fk_id);
        ref ($id) eq 'ARRAY' ? push(@entries,@$id) : push(@entries,$id);
    }#}
    return \@entries;
}
sub _insert_obj {
    my ($obj, $fk_col, $fk_id) = @_;
    my ($class, $table) = (ref($obj), _get_table($obj));
    my ($id, %insert, %index, %children);
	# Process object attributes
    while (my ($col,$data) = each %$obj) {
        if (!$_types{$class}{$col}) {
           Carp::carp ("$col=>$data is not a valid field in $class");
           delete $obj->{$col}; #XXX: Yes or no?
        }
        # Store Arrays of child objects to insert later
        elsif ($_types{$class}{$col} =~ m/(array)/) {
        	$children{$col} = $data;
        }
        # Insert child w/ 1 to 1 relationships and create a foreign key to it
        elsif ($_types{$class}{$col} =~ m/ref:(.*)/) {
        	if (my $ft = $1->_get_table()) {$insert{$ft.'_fk'} = _insert($data)};
        }
        # Add scalar attribute insert hash to be used @ INSERT time
        else {
            $insert{$col} = $dbhandle->quote($data);
        }
    }
    # In case this is a child object, add the foreign key to parent
    $insert{$fk_col} = $fk_id if ($fk_col && $fk_id);
    # Generate and execute SQL INSERT statement
    my $sql = "INSERT INTO $table (".join(',',keys %insert).") VALUES (".join(',',values(%insert)).')';
    eval {
       	print $sql."\n" if ($debug);
       	$dbhandle->do($sql);
    };
    # Handle DB errors. If 1062 (collision) get the ID of pre-existing row
    if ($@) {
    	if($dbhandle->err == 1062) {
    		my $filter;
    		while ( my ($col, $key_type) = each %{$_keys{$class}} ){
    			if ($key_type == $KEY_UNIQUE || $key_type == $KEY_UNIQUE_MULT) {
    				$filter->{$col} = $obj->{$col};
    			}
    		}
    		my $row = $class->_select($filter,'id');
    		#TODO: Handle select failure
    		$id = $row->{id};
    	}
    	else {
    		die "Error: ".$dbhandle->errno.": $@";
    	}
    }
    else {
    	$id = $dbhandle->{'mysql_insertid'};
    }
    # Insert Children
    foreach (keys %children) {
        my $rv = _insert($children{$_}, $table.'_fk', $id);
        #TODO: Handle Insert Failure
    }
    return $id;
}

=item select

Creates and executes a SQL SELECT statement and returns an array of hash refs
containing all of the non-array fields by default. The first parameter is a hash
reference to a query filter. The filter may be followed by a list of field names
to retrieve.

  $my_filter{
  	field_a => "bar"
  };
  @my_objects = HoneyClient::DB::SomeObj->select($my_filter);

=cut
sub select {
    my @results = undef;
    eval {
        $dbhandle = HoneyClient::DB::_connect(%config);
        @results = _select(@_);
        $dbhandle->disconnect() if $dbhandle;
    };
    if($@) {
    	Carp::carp ("select error: $@"); 
    }
    return @results;
}
sub _select {
	my ($class,$filter,@fields) = @_;
	# Prepare SQL statements
	my $sql = "SELECT ". join(',',@fields) .#join(',',$class->get_fields()).
			  " FROM " . $class->_get_table() ." WHERE ";
	my @conditions;
	# Set condition statements
	while (my ($col,$data) = each %$filter) {
		if (!exists $_types{$class}{$col}) {
			# TODO: Handle non-existent field
		}
		elsif ($_types{$class}{$col} =~ /array:.*/) {
			@$data = map $dbhandle->quote($_), @$data;
			push(@conditions, 'id IN (' . join(',',@$data) . ')') if (scalar(@$data));
		}
		elsif ($_types{$class}{$col} =~ /ref:(.*)/) {
			push @conditions, ($1->_get_table().'_fk='.$dbhandle->quote($data));
		}
		else {
			push @conditions, ($col.'='.$dbhandle->quote($data));
		}
	}
	$sql .= join(' AND ',@conditions);

   	print "${sql}\n" if ($debug);
	my @results;
	my $sth = $dbhandle->prepare($sql);
	$sth->execute();
	return ($sth->fetchrow_hashref()) unless wantarray();
	while ($sth->fetchrow_hashref()) {
		push @results,$_;
	}
	return @results;
}
sub includes {
	my @ids;
	foreach (@_) {
		push (@ids, $_) if (!(ref $_) && ($_ =~ /^\d+$/));
		if (exists $_->{id}) {
			push @ids, $_->{id};
		}
		else {
			next; #push @ids, $_->_get_id();
		}
	}
	return \@ids;
}
sub _get_table {
    my $class = shift;
    my ($table,$ref);
    ($ref = ref ($class)) ? ($table = $ref) : ($table = $class);
    $table =~ s/HoneyClient::DB:://g;
    $table =~ s/::/_/g;
    $table;
}

=back

=head2 Utility Functions

=over 4

=item get_fields

Retrieves a list of fields as defined by the schema, excluding array fields. Can
be used in conjunction with calls to HoneyClient::DB::select to execute a SELECT
query that retrieves all fields.

=back

=cut

sub get_fields {
	my $self = shift;
	my $class = (ref($self) or $self);

	my @fields;
	foreach (keys %{$_types{$class}}) {
		if ($_types{$class}{$_} !~ m/array:.*/) {
			if($_types{$class}{$_} =~ m/ref:(.*)/) {
				push(@fields,$1->_get_table.'_fk');
			}
			else {push @fields, $_;}
		}
	}
	return @fields;
}
sub _connect {
	my %conf = @_;
	my $dsn = "DBI:".$conf{driver}.":database=".$conf{dbname}.";host=".$conf{host}.";port=".$conf{port};
    my $dbh = DBI->connect_cached($dsn,$conf{user},$conf{pass},
        {'RaiseError' => 1,'PrintError' => 0});

    if ($dbh ne '') {
        $dbh->{'AutoCommit'} = 0; # In order to use Auto_Reconnect
        #$dbh->{mysql_auto_reconnect} = 1;
#        _SigSetup(); # Signal handling if necessary
		return $dbh;
    }
    else {
        Carp::croak "__PACKAGE__->_Connect Failed: $DBI::errstr";
    }
}

# Creates the table for the referenced class unless it exists

sub deploy_table {
	my $class = shift;
	my $table = $class->_get_table();
	# Check for existence of table in DB
	if (table_exists($table)){
		Carp::carp "${class}->deploy_table: Table $table exists!!\n";
		return 1;
	};
    $dbhandle = HoneyClient::DB::_connect(%config);
    my (@mult_unique_key,@foreign_keys,%arrays);
    # Create SQL statement to create table
	my $sql = "CREATE TABLE $table (\n".
		"\tid INT UNSIGNED AUTO_INCREMENT PRIMARY KEY";
	# Process each column in the %_types table
	while (my ($col,$type) = each %{$_types{$class}}) {#each %{$class."::fields"}) {
		# Create a foreign key for reference types in new table
		if ($type =~ m/ref:(.*)/) {
			$sql .= ",\n\t".$1->_get_table()."_fk INT UNSIGNED";
			push @foreign_keys, $1;
		}
		# Create a foreign key to new table for array types in the child table
		elsif ($type =~ m/array:(.*)/) {
			$arrays{$col} = $1;
			next;
		}
		# Add column in new table for scalar data types
		else {
			$sql .= ",\n\t$col "._get_db_type($type);
		}
		# Required columns will be added as NOT NULL
		if (exists $_required{$class} && $_required{$class}{$col}) {
			$sql .= " NOT NULL";
		}
		# Initial Values for columns
		if (exists $_init_val{$class} && $_init_val{$class}{$col}) {
            $sql .= " DEFAULT " . $_init_val{$class}{$col};
		}
		# Add Index if necessary
		if (exists $_keys{$class} && exists $_keys{$class}{$col}) {
			if ($_keys{$class}{$col} == $KEY_INDEX) {
				$sql .= " INDEX";
			}
			elsif ($_keys{$class}{$col} == $KEY_UNIQUE) {
				$sql .= " UNIQUE";
			}
			# Prevent collisions between records across several fields
			elsif ($_keys{$class}{$col} == $KEY_UNIQUE_MULT) {
				if ($type =~ m/ref:(.*)/) {
					push @mult_unique_key,$1->_get_table()."_fk";
				}
				else {
					push @mult_unique_key, $col;
				}
			}
		}
	}
	# Create FOREIGN KEY for each onsisting of several fields if necessary
	map {
		$sql .= ",\n\t".$_->sql_foreign_key() #INDEX (".$_->_get_table()."_fk),\n\t".$_->sql_foreign_key()
	} @foreign_keys;
	# Create the UNIQUE Index consisting of several fields if necessary
	if (scalar @mult_unique_key) {
		$sql .= ",\n\tUNIQUE ${table}_unique (".join(',',@mult_unique_key).')';
	}
	# Use InnoDB engine to utilize transactions
	$sql .= "\n) ENGINE=InnoDB";
	# Access DB and CREATE
	eval {
		print $sql."\n\n" if ($debug);
	    $dbhandle->do($sql);
	    while (my ($col,$child_class) = each %arrays) {
	    	_create_array_fk($class,$col,$child_class);
	    }
	};
	if ($@) {
	   Carp::carp ("Failed Creating Table: $@");
	   $dbhandle->rollback();
	   return 0;
	}
	$dbhandle->commit();
    $dbhandle->disconnect() if $dbhandle;
	return 1;
}

sub table_exists {
	my $table = shift;
	my $exists = 0;
    $dbhandle = HoneyClient::DB::_connect(%config);
	my $sth = $dbhandle->prepare("SHOW TABLES");
	$sth->execute();
	while (my $name = $sth->fetchrow_array()) {
    	if ($name eq $table) {
    		$exists = 1;
    		last;
    	}
	}
	$sth->finish();
    $dbhandle->disconnect() if $dbhandle;
	return $exists;
}

##################### Deploy Helper Functions #####################

sub _create_array_fk {
	my ($class,$attrib,$child_class) = @_;
	my $ct = $child_class->_get_table();
	my $pt = $class->_get_table();
	
    # Initialize SQL ALTER TABLE statement to add Foreign Key to Parent Table in Child Table
    my $sql = "ALTER TABLE ${ct} ADD ${pt}_fk INT UNSIGNED,\n\tADD FOREIGN KEY (${pt}_fk) REFERENCES ${pt}(id)";
	my $sql_cols = "";

    eval {
        # DEBUG Output
		print $sql."\n" if ($debug);
        # Execute ADD FOREIGN KEY statement
	    $dbhandle->do($sql);

        # Check to see if a (Multi-field) UNIQUE key exists for Child Table
	    $sql = "SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE K WHERE TABLE_NAME=".
	    	"'${ct}' AND CONSTRAINT_NAME='${ct}_unique' ORDER BY ORDINAL_POSITION";
        
        #DEBUG Output
        print $sql."\n" if ($debug);
        # Prepare and Execute Query
	    my ($col,$sth) = (undef,$dbhandle->prepare($sql));
	    $sth->execute();
	    
        # Process Query Results
        my $rv = $sth->bind_col(1,\$col);
	    while ($sth->fetch()) {
	        $sql_cols .= "${col},";
	    }
        # Modify Child (Multi-field) UNIQUE key if it previously existed
		if ($sql_cols) {
	    	$sql = "ALTER TABLE ${ct} ";
	    	$sql .= "DROP INDEX ${ct}_unique,\n\t";
			$sql .= "Add UNIQUE ${ct}_unique (" . $sql_cols . "${pt}_fk)";

            #DEBUG Output
			print $sql."\n" if ($debug);
            #Execute UNIQUE key statement
			$dbhandle->do($sql);
		}
	};
	if ($@) {
	    Carp::croak($@);
	}
}
sub sql_foreign_key {
	my $class = shift;
	my $table = $class->_get_table();
	my $sql = "FOREIGN KEY (".$table."_fk) REFERENCES ".$table."(id)";
}
sub db_exists {
    my %config = @_;
    eval {
        my $dbh = _connect(%config);
        $dbh->disconnect();
    };
    if ($@) {
        if ($DBI::err == 1049) {
            Carp::carp("DB Error: No database exists with the name ".$config{dbname}
                ." does not exist. Try running '/bin/install_honeyclient_db.pl'.");
        }
        else {
            Carp::carp("Unable to connect to database: ".$config{dbname}."\n$@");
        }
        return 0;
    }
    return 1;
}
sub _get_db_type {
	my $type = shift;
	return uc $type if ($type =~ m/^(int|text|timestamp)$/i);
	return "INT UNSIGNED" if ($type =~ m/^uint$/i);
	return 'VARCHAR(255)' if ($type =~ m/string/i);
	#TODO: Probably should reject this and throw syntax error
	return $type;
}

##################### Data Integrity Functions #####################

%defaults = (
	string => {
		check_func => \&check_string,
	},
	int => {
		check_func => \&check_int,
	},
	text => {
		check_func => \&check_text,
	},
	timestamp => {
		check_func => \&check_timestamp,
	},
);
sub check_nothing {
	return shift;
}
sub check_string {
	my $string = shift;
	if (length $string > 256) {
	    Carp::carp "String has exceeded limit ( of 255 characters): $string";
        $string = substr($string,0,255);
    }
	return $string;
}
sub check_int {
	my $int = shift;
	Carp::croak "Value is not an integer: $int"
		unless (Math::BigInt::is_int($int));
    return $int;
}
sub check_text {
	my $text = shift;
	if (length $text > 65536) {
	    Carp::carp "Text has exceeded limit ( of 65535 characters): ". substr($text,0,64);
        $text = substr($text,0,65535);
    }
	return $text;
}
sub check_timestamp {
	my $time = shift;
	$time =~ s/ /T/;
	eval {
		DateTime::Format::ISO8601->parse_datetime($time);
	};
	if ($@) {
		Carp::croak "Invalid Timestamp Format: ${time}";
	}
	return $time;
}


1;
