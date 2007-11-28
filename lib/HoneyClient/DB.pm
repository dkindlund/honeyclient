#######################################################################
# Created on:  February 17, 2007
# Package:     HoneyClient::DB
# File:        DB.pm
# Description: Abstract class for controlling storage of HoneyClient
#              data into a database.
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

=pod

=head1 NAME

HoneyClient::DB - Perl extension to provide an abstract interface for
storing HoneyClient data into a database.

=head1 VERSION

This documentation refers to HoneyClient::DB version 1.00.

=head1 SYNOPSIS

As a generic example, let's store data about superheroes.

=head2 DEFINE SCHEMAS

  # First, we define a schema for each superhero ability (child object).
  use HoneyClient::DB;
  package HoneyClient::DB::SuperHero::Ability;
  use base("HoneyClient::DB");

  # Define Ability Schema
  our %fields = (
      string => {
          # Each ability should have a name.
          name => {
              # This name should be required.
              required => 1, # Must exist and is not null
          },
      },

      # Each ability may have an optional description.
      text => [ 'description' ],

      # Each ability may have an optional recharge time.
      int  => [ 'recharge_time' ],
  );

  # Next, we define a schema for each superhero (parent object).
  package HoneyClient::DB::SuperHero;
  use base("HoneyClient::DB");

  # Define SuperHero Schema
  our %fields = (
      string => {
          # Each superhero should have a name.
          name => {
              # This name should be required.
              required => 1,
              key => $HoneyClient::DB::KEY_UNIQUE_MULT,
          },
          # Each superhero may have an optional real name.
          real_name => {
              key => $HoneyClient::DB::KEY_UNIQUE_MULT,
          },
          # If 2 SuperHero Objects have the same 'name' and 'real_name'
          # fields, then only the first object will be inserted succesfully
      },

      # Each superhero may have optional height and weight stats.
      int => [ 'height', 'weight' ],

      # Each superhero must have a primary ability.
      ref => {
          primary_ability => {
              # Reference child object type.
              objclass=> "HoneyClient::DB::SuperHero::Ability",

              # This should be required.
              required => 1,
          },
      },

      # Each superhero may have optional abilities.
      array => {
          abilities => {
              # Reference child object type.
              objclass=> "HoneyClient::DB::SuperHero::Ability",
          },
      },

      # Each superhero should have a birth date.
      timestamp => {
          birth_date => {
              required => 1,
          },
      },
  );

  1;

=head2 USE SCHEMAS

  # Now, we start generating data to insert into our database.

  use HoneyClient::DB::SuperHero;
  use Data::Dumper;

  # Create a new superhero.
  my $hero = {
      name       => 'Superman',
      real_name  => 'Clark Kent',
      weight     => 225,
      height     => 75,
      birth_date => '1998-06-01 12:34:56', # YYYY-MM-DD HH:MM:SS
      primary_ability => {
          name              => 'Super Strength',
          description       => 'More powerful than a locomotive.',
      },
      abilities  => [
          {
              name          => 'Flight',
              description   => "It's a bird, it's a plane.",
          },
          {
              name          => 'Heat Vision',
              recharge_time => 5, # in seconds
          },
      ],
  };

  # Instantiate a new SuperHero object.
  # Upon creation, the data will be checked against the schema.
  # This call will croak if any errors occur.
  $hero = HoneyClient::DB::SuperHero->new($hero);

  # Insert the data into the database.
  $hero->insert();

  # Retrieve the superhero.
  my $filter = {
      name => 'Superman',
  };

  # Retrieves rows in the SuperHero table where name is 'Superman'.
  # NOTE: At this time, the returned data is NOT identical to
  # the object inserted.
  my $inserted_hero = HoneyClient::DB::SuperHero->select($filter);

  # Printing the contents of the returned content should clarify
  # how the data looks.
  $Data::Dumper::Indent = 1;
  $Data::Dumper::Terse = 0;
  print Dumper($inserted_hero) . "\n";

=head1 DESCRIPTION

This library is an abstract class used to access and store HoneyClient
within a database. The class is not to be used directly, but can be inherited
by sub-classes, in order to indirectly store specific types of data into a
database.

B<Note>: Any calls made to this library will fail, if a database is not properly
described in the <HoneyClient/><DB/> section of the etc/honeyclient.xml
configuration file or if the library cannot establish a connection to the
database.

=head2 SCHEMA DEFINITION

The schema for a HoneyClient::DB subclass is created from the B<%fields>
variable, a multi-level hash table.

=head3 FIRST LEVEL: DATA TYPE

The keys at the first level of B<%fields> define the data types to be used
for each column, which are named as keys in the second level.  The following
is a list of acceptable data types:

=over 4

=item * B<'int'>

An integer.

=item * B<'string'>

A string no longer than 255 characters.

=item * B<'text'>

A string no longer than 65,535 characters.

=item * B<'timestamp'>

An ISO8601 compliant timestamp (i.e., 'MMDDYYYY HH:MM:SS').

=item * B<'array'>

An array.  Used to represent one-to-many relationships.

B<Note>: If this type is specified, then the L<'objclass'> option
must be set within each column name.

=item * B<'ref'>

A reference.  Used to represent one-to-one relationships.

B<Note>: If this type is specified, then the L<'objclass'> option
must be set within each column name.

=back

=head3 SECOND LEVEL: COLUMN NAMES

Column names are defined as keys in the second level of B<%fields>.  If
each column does not need any special options (e.g., making the column
required), then an array reference can hold all the column names.
For example, the following schema defines 3 default integer fields:

  %our fields = {
      int => [
          'col_a',
          'col_b',
          'col_c',
      ],
  };

However, if some of the columns need special options set (e.g., making 'col_b'
required), then a sub-hash table should be defined instead, as follows:

  %our fields = {
      int => {
          'col_a' => {},
          'col_b' => {
              'required' => 1,
          },
          'col_c' => {},
      },
  };

=head3 THIRD LEVEL: OPTIONS

If needed, options are defined in the third level of B<%fields>.  These
options are described as follows:

=over 4

=item * B<'check_func'>

If defined, then this contains a reference to a subroutine that will
verify the actual column data is in a proper format.  This overrides the
default internal check function for the data type of that column.

=item * B<'init_val'>

If defined, then this value will be the default value that the database
will assign to the column, if empty data is inserted into this column.

=item * B<'key'>

If defined, then this value creates an index for the column.
Possible values are:

=over 4

=item * B<$HoneyClient::DB::KEY_INDEX>

If set, an index will be created in the database to improve the search
time of this column.  This option is only recommended for very frequently
searched columns.

=item * B<$HoneyClient:DB::KEY_UNIQUE>

If set, a UNIQUE index is created for the column. If a record is inserted that
has a match with this column in a previously existing record, the insert will
fail on the database side, but the 'id' of that existing record will be
returned.

=item * B<$HoneyClient:DB::KEY_UNIQUE_MULT>

If set, the column is added to a UNIQUE index comprised of all other columns
with the KEY_UNIQUE_MULT key option. This index is used to ensure ALL VALUES for
the columns in the index are distinct. An insert of a record matching an
existing record will return the ID of that record.

=back

=item * B<'objclass'>

This option is required and only used by the L<'array'> and L<'ref'>
data types.  The value should be a string which contains the package name of
the schema to include as a child.

=item * B<'required'>

If defined and set to 1, then this option will cause all subsequent
B<HoneyClient::DB::*-E<gt>L<new>($data)> operations to fail, if the B<$data>
does not contain the required field.

=back

=head1 DATABASE CONFIGURATION

This library expects to connect to a MySQL v5.0 or greater database.
To specify which database this library should use, see the
<HoneyClient/><DB/> section of the etc/honeyclient.xml configuration file
for further details.

=cut

package HoneyClient::DB;

use Data::Dumper qw(Dumper);
use strict 'vars', 'subs';
use warnings;

BEGIN {

    #Dependencies
    use DBI;
    use Carp ();
    use HoneyClient::Util::Config;
    use DateTime::Format::ISO8601;
    use Math::BigInt;
    use Log::Log4perl qw(:easy);

    require Exporter;

    # Traps signals, allowing END: blocks to perform cleanup.
    use sigtrap qw(die untrapped normal-signals error-signals);
    $SIG{PIPE} = 'IGNORE';    # Do not exit on broken pipes.

    #Globals
    our @ISA    = qw(Exporter);
    our @EXPORT = qw();
    our @EXPORT_OK;
    our $VERSION = 1.00;

    my $database_version;     #  = $dbh->get_info(  18 ); # SQL_DBMS_VER
}

# The global logging object.
our $LOG = get_logger();

our $dbhandle;

# To be used ONLY INTERNALLY!
our ( %_types, %_check, %_required, %_init_val, %_keys, %defaults );
our %display_rank;

# %fields must be defined by all children classes
our %fields;

our $last_error_code;

#constants
# Integrity status field
our ( $STATUS_DELETED, $STATUS_ADDED, $STATUS_MODIFIED ) = ( 0, 1, 2 );
# Uniqueness of Attributes
our ( $KEY_INDEX, $KEY_UNIQUE, $KEY_UNIQUE_MULT ) = ( 0, 1, 2 );
# Option for get_fields()
our ( $FIELDS_ALL, $FIELDS_SEARCH, $FIELDS_DISPLAY ) = ( 0 , 1, 2);
# Error Codes
our ($ERROR_NONE,$ERROR_INSERT_FAILED,$ERROR_DUPLICATE_FOUND,$ERROR_DUPLICATE_UNRESOLVED)
    = (0,1,2,3);
our @ERROR_MESSAGES = (
	"Success",
	"Failed with a fatal error",
	"Duplicate object found. Non-fatal warning",
	"Duplicate object found. Unable to retrieve ID of duplicate record",
);

# Global Status Variables
our $LAST_ERROR = $ERROR_NONE;
our $TRANSACTION_PENDING = 0;

# Initialize Connection
our %config;
$config{driver} = "mysql";
$config{host}   = getVar( name => "host", namespace => "HoneyClient::DB" );
$config{port}   = getVar( name => "port", namespace => "HoneyClient::DB" );
$config{user}   = getVar( name => "user", namespace => "HoneyClient::DB" );
$config{pass}   = getVar( name => "pass", namespace => "HoneyClient::DB" );
$config{dbname} = getVar( name => "dbname", namespace => "HoneyClient::DB" );

if ( !db_exists(%config) ) {
    die;
}

END {
    $dbhandle->disconnect() if $dbhandle;
}

=pod

=head1 METHODS

=head2 Object Creation

=over 4

=item new

Receives an unblessed hash, imports the schema (if necessary), checks that
required fields contain the proper data, and returns the blessed object.

It must be called using an object class derived from HoneyClient::DB.
For Example:

  $my_obj = HoneyClient::DB::SomeObj->new({
          field_a => "foo",
          field_b => "bar"
  });

=cut

sub new {
    my ( $class, $self ) = @_;
    bless( $self, $class );

    # Check if Schema has been imported
    import_schema($class) if ( !exists( $_types{$class} ) );

    # Make sure required Attributes are set. Fail if not.
    my @missing = $self->_check_required();
    if ( scalar @missing ) {
        $LOG->fatal( "$class->new(): Object missing required attribute(s): " .
        	join( ', ', @missing ) . '.' );
        Carp::croak( "$class->new(): Object missing required attribute(s): " .
        	join( ', ', @missing ) . '.\n' );
    }

    # Check data validity. Initialize uninitialized ref and array objects
    foreach my $key ( keys %$self ) {
        eval {
            if ( $self->{$key} )
            {
                $self->{$key} = $_check{$class}{$key}->( $self->{$key} );
            }
        };
        if ($@) {
            $LOG->fatal("Invalid Object $key\t$@");
            Carp::croak "Invalid Object $key\n\t$@";
        }
        if ( $_types{$class}{$key} =~ m/(array|ref):(.*)/ ) {
            my $ref = ref( $self->{$key} );
            my ($childType,$childClass)  = ($1,$2);

            if ( $childClass->can('new') ) {
                if ( $childType eq 'ref' ) {
                    $self->{$key} = $childClass->new( $self->{$key} );
                }
                if ( $ref eq 'ARRAY' and $childType eq 'array' ) {
                    foreach my $obj ( @{ $self->{$key} } ) {
                        $obj = $childClass->new($obj);
                    }
                }
            }
            else {
                $LOG->fatal("Invalid Object! $childType does not exist");
                Carp::croak "Invalid Object! $childType does not exist";
            }
        }
    }
    return $self;
}

################# Initialization Helper Functions #################

sub _check_required {
    my $self  = shift;
    my $class = ref $self;

    # make sure field is not undefined if 'required' option is set
    if ( exists $_required{$class} ) {
        my @missing;
        foreach ( keys %{ $_required{$class} } ) {
            push( @missing, $_ )
              if ( !defined( $self->{$_} ) or ( $self->{$_} eq "" ) );
        }
        return @missing;
    }
    return;
}

sub import_schema {
    my $class  = shift;
    my $schema = \%{ $class . "::fields" };
	my (%rank_display, %rank_search);
	my $MAX_RANK = 10000;

    # Parase Attributes; store types and options.
    while ( my ( $type, $attrib ) = each(%$schema) ) {
        my $ref = ref $attrib;

        # Attributes in array format use default options
        if ( $ref eq 'ARRAY' ) {
            foreach ( @{$attrib} ) {
                $_types{$class}{$_} = $type;
                if ( $type =~ m/(ref|array)/ ) {
                    delete $_types{$class};
                    $LOG->fatal("Invalid Object Type. ref AND array types must "
                      . "be defined as a hash containing 'objclass'");
                    Carp::croak "Invalid Object Type. ref AND array types must "
                      . "be defined as a hash containing 'objclass'";
                }
                $_check{$class}{$_} = $defaults{$type}{check_func}
                  or $_check{$class}{$_} = \&check_nothing;
            }
        }

        # Parse options for attributes in hash table format
        elsif ( $ref eq 'HASH' ) {
            while ( my ( $a, $opts ) = each %$attrib ) {
                $_types{$class}{$a} = $type;
                if ( exists $opts->{required} && $opts->{required}) {
                    $_required{$class}{$a} = 1;
                }

                # array and ref types require the objclass option
                if ( $type =~ m/^(array|ref)$/ ) {
                    if ( !exists $opts->{objclass} ) {
                        $LOG->fatal("$1 of unknown class: $a");
                        Carp::croak "$1 of unknown class: $a";
                    }
                    if ( !exists $_types{ $opts->{objclass} } ) {
                        import_schema( $opts->{objclass} );
                    }
                    $_types{$class}{$a} .= ':' . $opts->{objclass};
                }

                # Check function will ensure data is of proper format
                if ( $opts->{check_func} ) {
                    $_check{$class}{$a} = $opts->{check_func};
                }
                else {
                    $_check{$class}{$a} = $defaults{$type}{check_func}
                      or $_check{$class}{$a} = \&check_nothing;
                }

                # key option determines if attribute is an index
                if ( $opts->{key} ) {
                    $_keys{$class}{$a} = $opts->{key};
                }
                if ( $opts->{init_val} ) {
                    $_init_val{$class}{$a} = $opts->{init_val};
                }
				#DEBUG: Test new code
				if( $opts->{searchable} ) {
					#TODO: $_search_fields{$class}
				}
				if( exists $opts->{display_rank} ) {
					my $rank = $opts->{display_rank};
					if ($opts->{display_rank}) {
						while (exists $rank_display{$rank}) {
								$rank++;
						}
					   	$rank_display{$rank} = $a;
					}
				}
				elsif ($type =~ m/^(array|ref)$/) {}
				else {
					$rank_display{$MAX_RANK++} = $a;
				}
            }
        }
        else {
            $LOG->warn("$class\{$type\} is defined improperly");
        }
    }
	my @temp = map $rank_display{$_}, sort( keys( %rank_display ) );
	$display_rank{$class} = \@temp;

    # Add the table to the DB if necessary
    if (!$class->deploy_table()) {
        $LOG->fatal("${class}->import_schema: " . "Failed to deploy table");
        Carp::croak("${class}->import_schema: " . "Failed to deploy table");
    }
}

=back

=head2 Database Operations

=over 4

=item insert

Creates and executes a SQL INSERT statement for the referenced object. The
object must be initialized at the time this method is called.

  $my_obj->insert();

B<Input>

There are no parameters, however the calling object is used as input for the
insert operation.

B<Return Value>

Returns the 'id' of the (parent) object inserted.

=cut

sub insert {
    my ($id,$error,$objType,$ref,$trans);
	$error = $trans = 0;
	$objType = $ref = ref $_[0];
	if (!$ref) {
		$objType = shift;
		$ref = ref $_[0];
	}
	# Connect unless in the middle of a transaction

    # Attempt insert; commit if succeeds, else rollback
    eval {
		if ( $ref eq 'ARRAY' ) {
    		#$id = _insert_array(@_);
    		return _insert_array(@_);
		}
		#elsif ( exists $_types{$ref} ) {
		if ( exists $_types{$ref} ) {
			eval {
				$trans = begin_transaction();
	    		$id = _insert_obj(@_);
			};
			if ($@) {
        		$error = 1;
				$LOG->error($objType."->insert failed with $@. Rolling Back.");
				Carp::carp($objType."->insert failed with $@. Rolling Back.");
    		}
			# If object is found to be a duplicate, Roll Back changes without warning
			elsif ($LAST_ERROR == $ERROR_DUPLICATE_FOUND) {
				$error = 1 if ($trans);
			}
    		elsif ($LAST_ERROR != $ERROR_NONE) {
    			$error = 1;
				$LOG->error($objType."->insert failed with code #$LAST_ERROR: ".$ERROR_MESSAGES[$LAST_ERROR].". Rolling Back.");
				if ($trans) {
					Carp::carp($objType."->insert failed with code #$LAST_ERROR: ".$ERROR_MESSAGES[$LAST_ERROR].". Rolling Back.");
				}
				else {
					Carp::croak($objType."->insert failed with code #$LAST_ERROR: ".$ERROR_MESSAGES[$LAST_ERROR].". Rolling Back.");
				}
    		}
	# Terminates transaction, unless in the middle of one
			end_transaction($trans,$error);
    		return $id;
		}
    	else {
			#$error = 1;
        	$LOG->error("Can't insert invalid data type");
        	Carp::carp("Can't insert invalid data type");
			return undef;
		}
	};
}

##################### Insert Helper Functions #####################

sub _insert_array {
	my $objects = shift;
    my @entries;
    foreach my $obj (@$objects) {
        my $id = $obj->insert(@_);
        ref($id) eq 'ARRAY' ? push( @entries, @$id ) : push( @entries, $id );
    }
    return \@entries;
}

sub _insert_obj {
    my ( $obj, $fk_col, $fk_id ) = @_;
    my ( $class, $table ) = ( ref($obj), _get_table($obj) );
    my ( $id, %insert, %index, %children );
    my $error = $ERROR_NONE;

# Process object attributes
    while ( my ( $col, $data ) = each %$obj ) {
        if ( !$_types{$class}{$col} ) {
            $LOG->warn("$col=>$data is not a valid field in $class");
            delete $obj->{$col};
        }
# Store Arrays of child objects to insert later
        elsif ( $_types{$class}{$col} =~ m/(array)/ ) {
            $children{$col} = $data;
        }
# Insert child w/ 1 to 1 relationships and create a foreign key to it
        elsif ( $_types{$class}{$col} =~ m/ref:(.*)/ ) {
            if ( my $ft = $1->_get_table() ) {
               	$insert{$class->get_col_name($col)} = $data->insert();
            }
        }
# Add scalar attribute insert hash to be used @ INSERT time
        else {
            $insert{$col} = $dbhandle->quote($data);
        }
    }
# In case this is a child object, add the foreign key to parent
    $insert{$fk_col} = $fk_id if ( $fk_col && $fk_id );

# Generate and execute SQL INSERT statement
    my $sql = "INSERT INTO $table (" . join( ',', keys %insert ) . ") VALUES (" . join( ',', values(%insert) ) . ')';
    eval {
        $LOG->debug($sql);
        $dbhandle->do($sql);
    };
# Handle DB errors. If 1062 (collision) get the ID of pre-existing row
    if ($@) {
        if ( $dbhandle->err == 1062 ) {
            my $filter;
            while ( my ( $col, $key_type ) = each %{ $_keys{$class} } ) {
                if ( $key_type == $KEY_UNIQUE || $key_type == $KEY_UNIQUE_MULT )
                {
                    $filter->{$col} = $obj->{$col};
                }
            }

            my @rows = $class->select(
            	'-columns'=>['id'],
            	'-where'=>$filter,
            );
            if (scalar @rows) {
                $id = $rows[0]->{id};
            	$error = $ERROR_DUPLICATE_FOUND;
            }
            else {
                $error = $ERROR_DUPLICATE_UNRESOLVED;
                $LOG->fatal("Error: Can't resolve duplicate records\t" . $dbhandle->err . ": $@");
                Carp::croak("Error: Can't resolve duplicate records\n\t" . $dbhandle->err . ": $@");
            }
        }
        else {
            $error = $ERROR_INSERT_FAILED;
            $LOG->fatal("Error #".$dbhandle->err."while executing SQL:\n\t$sql\n$@");
            Carp::croak("Error #".$dbhandle->err."while executing SQL:\n\t$sql\n$@");
        }
    }
    else {
        $id = $dbhandle->{'mysql_insertid'};
    }
# Insert Children
    foreach ( keys %children ) {
        my $rv = insert($children{$_},$class->get_col_name($_), $id);
    }
    $LAST_ERROR = $error;
    return $id;
}

sub append_children {
	my ($class,%args) = @_;
	if (exists $args{'-parent_id'}) {
		my $pid = delete $args{'-parent_id'};
		if (my ($field,$children) = each %args) {
			if (exists $_types{$class}{$field}) {
				my ($child_class) = $_types{$class}{$field} =~ m/array:(.*)/;
				if (exists $_types{$child_class}) {
					my $result = $child_class->insert($children,$class->get_col_name($field),$pid);
					if (ref $result eq 'ARRAY') {
						return scalar(@$result);
					}
				}
			}
		}
	}
	else {
		$LOG->error("Can't append children without '-parent_id' argument");
	}
	return 0;
}

=head3 QUERY CONDITIONS

The following functions accept conditions using the '-where' argument. These
conditions filter results to the desired information. Currently any scalar field
is searchable (string, int, text, timestamp), while ref objects are searchable
only by their ids (for now).

The following query will list Regkey changes that occurred to the Windows
auto-start key .

  @runKeys = HoneyClient::DB::Regkey->select(
  	  -where => {
  	  	  key_name => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
  	  },
  );

In order to perform a partial match search, a tilda can be added to the front
of the column name. This is not applicable to ranges. The following query will
return any Registry change with the string 'Run' in the key name(path).

  @runKeys = HoneyClient::DB::Regkey->select(
  	  -where => {
  	  	  '~key_name' => 'Run',
  	  },
  );

B<NOTE:> In this case, the column name must be quoted, or used as a variable.

A query can search a range, for instance, the following will show all
Honeyclients in a given date range.

  @octoberClients = HoneyClient::DB::Client->select(
	  -where => {
	  	  start_time => ['2007-10-01 00::00::00','2007-10-31 23::59::59']
	  },
  );

The '-where' option accepts filters on multiple columns as well.


=item select

Creates and executes a SQL SELECT statement and returns an array of hash refs
containing result rows.

The following would select the name, age, address, and phone columns for all
records with the name 'bob', and an age in the range of 25-50 (inclusive).

  @my_objects = HoneyClient::DB::Process->select(
  	  -columns => qw(name,pid,parent_name,created_time),
  	  -where => {
  	  	  name => 'bob',
  	  	  age => [25,50],
  	  },
  );

B<Input>

The select() function can take as arguments a hash containing the following keys:

=item * B<'-columns'>

List of columns to be selected. By default, if no -columns argument is given,
all columns are selected. See L<get_fields>.

=item * B<'-where'>

This field can contain a set of conditions used to filter the results. Refer to
L<QUERY CONDITIONS> for more info.

=cut

sub select {
	my $trans = begin_transaction(); # Connect
	my (@results,$sql,$error);
    eval {
# Create SQL query
        $sql = _build_query(@_);
		#XXX: Change back to debug
        $LOG->debug($sql);

# Execute SQL query
		if ($sql) {
	        my $sth = $dbhandle->prepare($sql);
    	    $sth->execute();

# Retrieve results and exit
			while ( my $row = $sth->fetchrow_hashref() ) {
    	        push @results, $row;
        	}
		}
		else {
			$error = 1;
			$LOG->error("Error, invalid query parameters.");
		}
    };
    if ($@) {
        $error = 1;
		$LOG->error ("Error while executing SQL:\n\t$sql\n$@");
        @results = ();
    }
	end_transaction($trans,$error);
    wantarray ? return @results : return \@results;
}

sub _select_expr {
	my $class = shift;
	my @fields;
	foreach my $col_def (@_) {
		if (ref $col_def eq 'HASH') {
			while (my ($col,$as) = (each %$col_def)) {
				if (my $col_name = $class->get_col_name($col)) {
					push @fields, "$col_name AS '$as'";
				}
			}
		}
		else {
			my $col_name = $class->get_col_name($col_def);
			if ($col_name) {
				if ($col_name ne $col_def) {
					push @fields,"$col_name AS '$col_def'";
				}
				else {
					push @fields,$col_name;
				}
			}
		}
	}
	return @fields;
}

sub _build_query {
    my ($class, %args) = @_;
# Prepare select_expr with fields to retrieve
	my @fields;
	if (exists($args{'-columns'}) && scalar(@{$args{'-columns'}})) {
		@fields = @{$args{'-columns'}};
	}
	else {
		@fields = $class->get_fields();
	}
	return "" if (!scalar(@fields = $class->_select_expr(@fields)));
# Prepare SQL statement
    my $sql = "SELECT " . join( ',', @fields) . " FROM " . $class->_get_table();
# Set condition statements
    $sql .= $class->_where_condition($args{'-where'});
    return $sql;
}

# Generates a where condition (e.g. " WHERE id=5 AND name='foo'")
sub _where_condition {
	my ($class,$cond) = @_;
	my @conditions;
	if (!keys(%$cond)) {
		return '';
	}
	while ( my ( $col, $data ) = each %$cond ) {
		my $partial = 0;
		if ($col =~ /^\~(.*)/) {
			$col = $1;
			$partial = 1;
		}
		if ( !exists $_types{$class}{$col} && $col ne 'id') {
            next; #TODO: Handle non-existent field
        }
        my $cf = ($_check{$class}{$col} || \&check_nothing);
		if (my $ref = ref($data)) {
			eval {
				if (my ($type,$sub_class) = $_types{$class}{$col} =~ /(array|ref):(.*)/ ) {
					if ($ref eq 'HASH') {
						my ($left,$right) = ('id',$class->get_col_name($col));
						if ($type eq 'ref') {
							($left, $right) = ($right,$left);
						}
	                    my $sub_query = $sub_class->_build_query(
	                       -columns => [$right],
	                       -where => $data,
	                    );
						push @conditions, $left.' IN ('.$sub_query.')';
					}
				}
				elsif ($ref eq 'ARRAY' && &$cf($data->[0]) && &$cf($data->[1])) {
					push @conditions, ( $class->get_col_name($col) . ' BETWEEN ' .
						$dbhandle->quote($data->[0]) . ' AND '.
	                    $dbhandle->quote($data->[1])
					);
				}
			};
			#TODO: Handle Failure
		}
		else {
        	if (exists $_types{$class}{$col} && $_types{$class}{$col} =~ /ref:(.*)/ ) {
               if (check_int($data)) {
                   push @conditions,($class->get_col_name($col).'='.$dbhandle->quote($data));
               }
        	}
			#TODO: This is not right. Must fix Check functionality. Return a bool and pass by ref?
			elsif ($cf->($data)) {
				if ($partial) {
					my $wc_data = "%".$data."%";
					push @conditions, ( $col . ' LIKE ' . $dbhandle->quote($wc_data) )
				}
				else {
					push @conditions, ( $col . '=' . $dbhandle->quote($data) )
				}
			}
			else {
				next; #TODO: Die on failure
			}
        }
    }
    if (scalar @conditions) {
	    return ' WHERE '.join( ' AND ', @conditions );
	}
	return '';
}

=item update

Creates and executes a SQL SELECT statement and returns an array of hash refs
containing result rows.

The following would change the status of all jobs held by John Doe of HcTeam
to closed.

  @my_objects = HoneyClient::DB::Analyst::Job->update(
  	  -set => {
  	  	  status => $STATUS_CLOSED,
  	  }
  	  -where => {
  	  	  analyst => {
  	  	  	  name => 'John Doe',
  	  	  	  organization => 'HcTeam',
  	  	  },
  	  },
  );

B<NOTE:> In the above example, the uses a filter based on another table. This is
possible for both reference and array types. In both cases, a hash table
reference containing a single record can be used as an argument for the field.

B<Input>

The update() function can take as arguments a hash containing the following keys:

=item * B<'-set'>

The column name and value pairs to be set by the update. If no valid -set option
is provided, the update will fail.

=item * B<'-where'>

This field can contain a set of conditions used to filter the records to be
updated. Refer to L<QUERY CONDITIONS> for more info.

=cut

sub update {
    my ( $class, %args ) = @_;

	my (@set_expr,$error);
    # Prepare SQL statements
    while (my ($col,$data) = each %{$args{'-set'}}) {
		if (exists $_types{$class}{$col} || $col eq 'id') {
    		eval {
				my $foo = -1;
				$foo = $_check{$class}{$col}->($data) if(exists $_check{$class}{$col});
            };
    		if (!$@) {
                push @set_expr, ( $class->get_col_name($col) . '=' . $dbhandle->quote($data) )
    		}
			else {
				$error = "Update Warning. Invalid or missing -set argument."
			}
    	}
		else {
			$error = "Update Failed. Invalid or missing -set argument."
		}
    }
	my $rc = -1;
    if (scalar(@set_expr) && !$error) {
		my $trans = begin_transaction();
		eval {
    		$rc = $class->_update(join( ',',@set_expr ),$args{'-where'});
		};
		if($@ or $rc >= 0) {
			$error = "Update failed. Rolling Back"; 
		}
		end_transaction($trans,$error);
    }
	else {
		$LOG->warn($error);
	}
    return $rc;
}

sub _update {
	my ($class,$update,$conditions) = @_;
	my $rc = -1;
	my $sql = "UPDATE ". $class->_get_table()." SET " . $update . $class->_where_condition($conditions);
	# Debug Output
	$LOG->debug($sql);
    eval {
# Execute UPDATE and Parse mysql_info (e.g. Rows matched: 1  Changed: 1  Warnings: 0)
        $dbhandle->do($sql);
        my $info = $dbhandle->{'mysql_info'};
        if ($info =~ m/Changed:\s*(\d+)\s*Warnings:\s*(\d+)/) {
            if (0+$2) {
                $LOG->warn("Update reported ".$2." Warnings for SQL:\n\t".$sql);
            }
            $rc = 0+$1;
        }
    };
	if ($@) {
		$LOG->fatal("Update failure. SQL:\n\t".$sql."\n".$@);
		Carp::croak("Update failure. SQL:\n\t".$sql."\n".$@);
	}
    return $rc;
}


sub incrementColumn {
	my ($class,%args) = @_;
    return $class->_incOrDecColumn('+',%args);
}
sub decrementColumn {
	my ($class,%args) = @_;
    return $class->_incOrDecColumn('-',%args);
}
# Helper function, performs increment or decrement work.
sub _incOrDecColumn {
	my ($class,$op,%args) = @_;
	my $rc = -1;
	my $error;
	my ($col,$cond) = ($args{'-column'},$args{'-where'});
	my $amt = (exists $args{'-amount'} ? 0+$args{'-amount'} : 1);
	return $rc if ($op ne '+' && $op ne '-' && !(check_int($amt)));
	my $opName = ($op eq '+' ? 'increment' : 'decrement');
	my $trans = begin_transaction();

	# Ensure column exists AND the column is of type 'int'
    if ( $col && (exists $_types{$class}) && ($_types{$class}{$col} eq 'int')) {
		# Execute update and get number of columns changed.
		eval {
			$rc = $class->_update("$col=$col".$op.$amt,$cond);
		};
		if ($@) {
			$error = $class."->".$opName."Column for $col failed. Rolling Back.";
		}
    }
	else {
		$error = $class."->".$opName."Column failed. Invalid or missing '-column' argument: $col";
	}
	end_transaction($trans,$error);
    return $rc;
}

sub _get_table {
    my $class = shift;
    my ( $table, $ref );
    ( $ref = ref($class) ) ? ( $table = $ref ) : ( $table = $class );
    $table =~ s/HoneyClient::DB:://g;
    $table =~ s/::/_/g;
    $table;
}

sub get_col_name {
	my ($class,$field) = @_;
	if ($field eq 'id') {
		return $field;
	}
	if(!exists $_types{$class}{$field}) {
		return undef;
	}
	if (my ($type,$child_class) = $_types{$class}{$field} =~ m/(array|ref):(.*)/) {
		my $col_name = "_".$field."_fk";
		if ($type eq 'array') {
			return _get_table($class).$col_name;
		}
		return _get_table($child_class).$col_name;
	}
	return $field;
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
    my $class = ( ref($self) or $self );
    my @fields;
	my $type = shift; # $FIELDS_ALL,$FIELDS_SEARCH,$FIELDS_DISPLAY
	$type = $FIELDS_ALL if ($type == undef);

    # Begin Fields list w/ record id if all fields requested
    push @fields,'id' if ($type = $FIELDS_ALL);
    if ($type == $FIELDS_DISPLAY) {
	    return map($class->get_col_name($_), @{$display_rank{$class}});
    }
    else {
	    foreach ( keys %{ $_types{$class} } ) {
	        push(@fields,$class->get_col_name($_)) unless($_types{$class}{$_} =~ m/array:.*/);
	    }
	}
    return @fields;
}

sub _connect {
    my %conf = @_;
    my $dsn  = "DBI:" . $conf{driver}
      . ":database=" . $conf{dbname}
      . ";host=" . $conf{host}
      . ";port=" . $conf{port};
    my $dbh =
      DBI->connect_cached( $dsn, $conf{user}, $conf{pass},{ 'RaiseError' => 1, 'PrintError' => 0 } );

    if ( $dbh ne '' ) {
        $dbh->{'AutoCommit'} = 0;
        return $dbh;
    }
    else {
        $LOG->fatal("__PACKAGE__->_Connect Failed: $DBI::errstr");
        Carp::croak "__PACKAGE__->_Connect Failed: $DBI::errstr";
    }
}

sub begin_transaction {
	if ($TRANSACTION_PENDING) {
		return 0;
	}
    $dbhandle = HoneyClient::DB::_connect(%config);
	return ($TRANSACTION_PENDING = 1);
}

sub end_transaction {
	my ($owner,$error) = @_;
	if ($error) {
		if ($owner) {
			$dbhandle->rollback();
			$TRANSACTION_PENDING = 0;
		}
	}
	else {
		if ($owner) {
			$dbhandle->commit();
			$TRANSACTION_PENDING = 0;
		}
	}
	$dbhandle->disconnect() if ($owner && $dbhandle);
}

# Creates the table for the referenced class unless it exists
sub deploy_table {
    my $class = shift;
    my $table = $class->_get_table();

    # Check for existence of table in DB
    if ( table_exists($table) ) {
        $LOG->debug("${class}->deploy_table: Table $table exists!!");
        return 1;
    }
    $dbhandle = HoneyClient::DB::_connect(%config);
    my ( @mult_unique_key, @foreign_keys, %arrays );

    # Create SQL statement to create table
    my $sql = "CREATE TABLE $table (\n\tid INT UNSIGNED AUTO_INCREMENT PRIMARY KEY";

    # Process each column in the %_types table
    while ( my ( $col, $type ) = each %{ $_types{$class} } )
    {
        # Create a foreign key for reference types in new table
        if ( $type =~ m/ref:(.*)/ ) {
        	my $key_name = $class->get_col_name($col);
            $sql .= ",\n\t" . $key_name . " INT UNSIGNED";
            push @foreign_keys, [$1,$key_name];
        }

        # Create a foreign key to new table for array types in the child table
        elsif ( $type =~ m/array:(.*)/ ) {
            $arrays{$col} = $1;
            next;
        }

        # Add column in new table for scalar data types
        else {
            $sql .= ",\n\t$col " . _get_db_type($type);
        }

        # Required columns will be added as NOT NULL
        if ( exists $_required{$class} && $_required{$class}{$col} ) {
            $sql .= " NOT NULL";
        }

        # Initial Values for columns
        if ( exists $_init_val{$class} && $_init_val{$class}{$col} ) {
			if ($type !~ m/^(array|ref)/) {
	            $sql .= " DEFAULT " . $dbhandle->quote($_init_val{$class}{$col});
			}
        }

        # Add Index if necessary
        if ( exists $_keys{$class} && exists $_keys{$class}{$col} ) {
        	my $size_limit = '';
        	if ($_types{$class}{$col} eq 'text') {
        		$size_limit = '(1000)';
        	}
            if ( $_keys{$class}{$col} == $KEY_INDEX ) {
                $sql .= ",\tINDEX (".$col.$size_limit.")";
            }
            elsif ( $_keys{$class}{$col} == $KEY_UNIQUE ) {
                $sql .= ",\n\tUNIQUE  (".$col.$size_limit.")";
            }

            # Prevent collisions between records across several fields
            elsif ( $_keys{$class}{$col} == $KEY_UNIQUE_MULT ) {
                push @mult_unique_key, $class->get_col_name($col).$size_limit;
            }
        }
    }

    # Create FOREIGN KEY for each onsisting of several fields if necessary
    map {
        $sql .= ",\n\t" . $_->[0]->sql_foreign_key($_->[1])
    } @foreign_keys; # $_->[0] is class name, $_->[1] is key name

    # Create the UNIQUE Index consisting of several fields if necessary
    if ( scalar @mult_unique_key ) {
        $sql .= ",\n\tUNIQUE ${table}_unique (" . join( ',', @mult_unique_key ) . ')';
    }

    # Use InnoDB engine to utilize transactions
    $sql .= "\n) ENGINE=InnoDB";

    # Access DB and CREATE
    eval {
        $LOG->debug($sql);
        $dbhandle->do($sql);
        while ( my ( $col, $child_class ) = each %arrays ) {
            _create_array_fk( $class, $col, $child_class );
        }
    };
    if ($@) {
        $LOG->warn("Failed Creating Table using SQL:\n$sql\n: $@");
        $dbhandle->rollback();
        return 0;
    }
    $dbhandle->commit();
    $dbhandle->disconnect() if $dbhandle;
    return 1;
}

sub table_exists {
    my $table  = shift;
    my $exists = 0;
    $dbhandle = HoneyClient::DB::_connect(%config);
    my $sth = $dbhandle->prepare("SHOW TABLES");
    $sth->execute();
    while ( my $name = $sth->fetchrow_array() ) {
        if ( ( $name eq $table ) or ( lc($name) eq lc($table) ) ) {
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
    my ( $class, $attrib, $child_class ) = @_;
    my $ct = $child_class->_get_table();
    my $pt = $class->_get_table();

# Initialize SQL ALTER TABLE statement to add Foreign Key to Parent Table in Child Table
	my $key_name = $class->get_col_name($attrib);
    my $sql = "ALTER TABLE $ct ADD $key_name INT UNSIGNED,\n"."\tADD ".$class->sql_foreign_key($key_name);
    my $sql_cols = "";

    eval {

        # DEBUG Output
        $LOG->debug($sql);

        # Execute ADD FOREIGN KEY statement
        $dbhandle->do($sql);

        # Check to see if a (Multi-field) UNIQUE key exists for Child Table
        $sql = "SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE K WHERE TABLE_NAME="
          . "'$ct' AND CONSTRAINT_NAME='${ct}_unique' AND CONSTRAINT_SCHEMA='".$config{dbname}."' ORDER BY ORDINAL_POSITION";

        #DEBUG Output
        $LOG->debug($sql);

        # Prepare and Execute Query
        my ( $col, $sth ) = ( undef, $dbhandle->prepare($sql) );
        $sth->execute();

        # Process Query Results
        my $rv = $sth->bind_col( 1, \$col );
        while ( $sth->fetch() ) {
            $sql_cols .= "${col},";
        }

        # Modify Child (Multi-field) UNIQUE key if it previously existed
        if ($sql_cols) {
            $sql = "ALTER TABLE $ct ";
            $sql .= "DROP INDEX ${ct}_unique,\n\t";
            $sql .= "Add UNIQUE ${ct}_unique (" . $sql_cols . "$key_name)";

            #DEBUG Output
            $LOG->debug($sql);

            #Execute UNIQUE key statement
            $dbhandle->do($sql);
        }
    };
    if ($@) {
        $LOG->fatal($@);
        Carp::croak($@);
    }
}

sub sql_foreign_key {
    my $class = shift;
    my $key_name = shift;
    my $table = $class->_get_table();
    return "FOREIGN KEY (" . $key_name . ") REFERENCES " . $table . "(id) ON DELETE CASCADE";
}

sub db_exists {
    my %config = @_;
    eval {
        my $dbh = _connect(%config);
        $dbh->disconnect();
    };
    if ($@) {
        if ( $DBI::err == 1049 ) {
            $LOG->warn( "DB Error: No database exists with the name ".$config{dbname}
            	." does not exist. Try running '/bin/install_honeyclient_db.pl'."
            );
        }
        else {
            $LOG->warn("Unable to connect to database: " . $config{dbname} . "\t$@" );
        }
        return 0;
    }
    return 1;
}

sub _get_db_type {
    my $type = shift;
    return uc $type       if ( $type =~ m/^(int|text|timestamp)$/i );
    return "INT UNSIGNED" if ( $type =~ m/^uint$/i );
    return 'VARCHAR(255)' if ( $type =~ m/string/i );

    #TODO: Probably should reject this and throw syntax error
    return $type;
}

##################### Data Integrity Functions #####################

%defaults = (
    string    => { check_func => \&check_string, },
    int       => { check_func => \&check_int, },
    text      => { check_func => \&check_text, },
    timestamp => { check_func => \&check_timestamp, },
);

sub check_nothing {
    return shift;
}

sub check_string {
    my $string = shift;
    if ( length $string > 256 ) {
        $LOG->warn("String has exceeded limit ( of 255 characters): $string");
        $string = substr( $string, 0, 255 );
    }
    return $string;
}

sub check_int {
    my $int = shift;
    if (!Math::BigInt::is_int($int)) {
        $LOG->fatal("Value is not an integer: $int");
        Carp::croak "Value is not an integer: $int";
    }
    return $int;
}

sub check_text {
    my $text = shift;
    if ( length $text > 65536 ) {
        $LOG->warn("Text has exceeded limit ( of 65535 characters): ". substr( $text, 0, 64 ));
        $text = substr( $text, 0, 65535 );
    }
    return $text;
}

sub check_timestamp {
    my $time = shift;
    $time =~ s/ /T/;
    eval { DateTime::Format::ISO8601->parse_datetime($time); };
    if ($@) {
        $LOG->fatal("Invalid Timestamp Format: ${time}");
        Carp::croak "Invalid Timestamp Format: ${time}";
    }
    return $time;
}

1;

=head1 BUGS & ASSUMPTIONS

It is assumed that the <HoneyClient/><DB/> section of the
etc/honeyclient.xml configuration file is properly configured
and the host refered to in that section has MySQL v5.0 or
greater running.

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Tim Bunce for developing DBI

Jochen Wiedmann for developing DBD::mysql

=head1 AUTHORS

Matthew Briggs, E<lt>mbriggs@mitre.orgE<gt>

Darien Kindlund, E<lt>kindlund@mtre.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2007 The MITRE Corporation.  All rights reserved.

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
