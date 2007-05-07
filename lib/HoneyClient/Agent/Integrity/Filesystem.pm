################################################################################
# Created on:  April 12, 2007
# Package:     HoneyClient::Agent::Integrity::Filesystem
# File:        Filesystem.pm
# Description: Performs static checks of the Windows OS filesystem.
#
# CVS: $Id$
#
# @author xkovah, kindlund, stephenson
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
################################################################################

=pod

=head1 NAME

HoneyClient::Agent::Integrity::Filesystem - Perl extension to perform static
checks of the Windows OS filesystem.

=head1 VERSION

This documentation refers to HoneyClient::Agent::Integrity::Filesystem version 0.95.

=head1 SYNOPSIS

  use HoneyClient::Agent::Integrity::Filesystem;
  use Data::Dumper;

  # Create the filesystem object.  Upon creation, the object will
  # be initialized, by performing a baseline of the filesystem.
  my $filesystem = HoneyClient::Agent::Integrity::Filesystem->new();

  # ... Some time elapses ...

  # Check the filesystem, for any violations.
  my $changes = $filesystem->check();

  if (!defined($changes)) {
      print "No filesystem changes have occurred.\n";
  } else {
      print "Filesystem has changed:\n";
      print Dumper($changes);
  }

  # $changes refers to an array of hashtable references, where
  # each hashtable has the following format:
  #
  # $changes = [ {
  #     # Indicates if the filesystem entry was deleted,
  #     # added, or changed.
  #     'status' => 'deleted' | 'added' | 'changed',
  #
  #     # If the entry has been added/changed, then this 
  #     # hashtable contains the file/directory's new information.
  #     'new' => {
  #         'name'  => 'C:\WINDOWS\SYSTEM32...',
  #         'size'  => 1263, # in bytes
  #         'mtime' => 1178135092, # modification time, seconds since epoch
  #     },
  #
  #     # If the entry has been deleted/changed, then this
  #     # hashtable contains the file/directory's old information.
  #     'old' => {
  #         'name'  => 'C:\WINDOWS\SYSTEM32...',
  #         'size'  => 802, # in bytes
  #         'mtime' => 1178135028, # modification time, seconds since epoch
  #     },
  # }, ]

=head1 DESCRIPTION

This library allows the Integrity module to easily baseline and check
the Windows OS filesystem for any changes that may occur, while
instrumenting a target application.

=cut

package HoneyClient::Agent::Integrity::Filesystem;

use strict;
use warnings;
use Carp ();

# Include Global Configuration Processing Library
use HoneyClient::Util::Config qw(getVar);

# Include the File/Directory Search Library
use File::Find qw(find);

# Include the Diff algorithm for comparing files
use Algorithm::Diff;

# Include Cygwin Path Conversion Library.
use Filesys::CygwinPaths qw(:all);

# Use Storable Library
use Storable qw(nfreeze thaw dclone);
$Storable::Deparse = 1;
$Storable::Eval = 1;

# Use Dumper Library
use Data::Dumper;

# Use Basename Library
use File::Basename qw(dirname);

# Include Logging Library
use Log::Log4perl qw(:easy);

#######################################################################
# Module Initialization                                               #
#######################################################################

BEGIN {
    # Defines which functions can be called externally.
    require Exporter;
    our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS, $VERSION);

    # Set our package version.
    $VERSION = 0.95;

    @ISA = qw(Exporter);

    # Symbols to export on request
    @EXPORT = qw( );

    # Items to export into callers namespace by default. Note: do not export
    # names by default without a very good reason. Use EXPORT_OK instead.
    # Do not simply export all your public functions/methods/constants.

    # This allows declaration use HoneyClient::Agent::Integrity::Filesystem ':all';
    # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
    # will save memory.

    %EXPORT_TAGS = (
        'all' => [ qw( ) ],
    );

    # Symbols to autoexport (:DEFAULT tag)
    @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

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

# Make sure the module loads properly, with the exportable
# functions shared.
BEGIN { use_ok('HoneyClient::Util::Config', qw(getVar setVar))
        or diag("Can't load HoneyClient::Util::Config package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Util::Config');
can_ok('HoneyClient::Util::Config', 'getVar');
can_ok('HoneyClient::Util::Config', 'setVar');
use HoneyClient::Util::Config qw(getVar setVar);

# Suppress all logging messages, since we need clean output for unit testing.
Log::Log4perl->init({
    "log4perl.rootLogger"                               => "DEBUG, Buffer",
    "log4perl.appender.Buffer"                          => "Log::Log4perl::Appender::TestBuffer",
    "log4perl.appender.Buffer.min_level"                => "fatal",
    "log4perl.appender.Buffer.layout"                   => "Log::Log4perl::Layout::PatternLayout",
    "log4perl.appender.Buffer.layout.ConversionPattern" => "%d{yyyy-MM-dd HH:mm:ss} %5p [%M] (%F:%L) - %m%n",
});

# Make sure Data::Dumper loads
BEGIN { use_ok('Data::Dumper')
        or diag("Can't load Data::Dumper package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Data::Dumper');
use Data::Dumper;

# Make sure Storable loads
BEGIN { use_ok('Storable', qw(nfreeze thaw dclone))
        or diag("Can't load Storable package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Storable');
can_ok('Storable', 'nfreeze');
can_ok('Storable', 'thaw');
can_ok('Storable', 'dclone');
use Storable qw(nfreeze thaw dclone);

# Make sure File::Find loads.
BEGIN { use_ok('File::Find', qw(find)) or diag("Can't load File::Find package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Find');
can_ok('File::Find', 'find');
use File::Find;

# Make sure Filesys::CygwinPaths loads
BEGIN { use_ok('Filesys::CygwinPaths')
        or diag("Can't load Filesys::CygwinPaths package. Check to make sure the package library is correctly listed within the path."); }
require_ok('Filesys::CygwinPaths');
use Filesys::CygwinPaths qw(:all);

# Make sure Algorithm::Diff loads.
BEGIN { use_ok('Algorithm::Diff') or diag("Can't load Algorithm::Diff package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('Algorithm::Diff');
use Algorithm::Diff;

# Make sure File::Basename loads.
BEGIN { use_ok('File::Basename', qw(dirname)) or diag("Can't load File::Basename package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('File::Basename');
can_ok('File::Basename', 'dirname');
use File::Basename qw(dirname);

# Make sure HoneyClient::Agent::Integrity::Filesystem loads.
BEGIN { use_ok('HoneyClient::Agent::Integrity::Filesystem') or diag("Can't load HoneyClient::Agent::Integrity::Filesystem package.  Check to make sure the package library is correctly listed within the path."); }
require_ok('HoneyClient::Agent::Integrity::Filesystem');
use HoneyClient::Agent::Integrity::Filesystem;

=end testing

=cut

#######################################################################
# Global Configuration Variables                                      #
#######################################################################

# The global logging object.
our $LOG = get_logger();

# Temporary global array reference, used to hold the file analysis information,
# for the baseline and check operations.
my $file_analysis = [ ];

# The global delimeter used for storing file analysis information inside
# a single string.
our $DELIMETER = ":";

# Make Dumper format more terse.
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

=pod

=head1 DEFAULT PARAMETER LIST

When a Filesystem B<$object> is instantiated using the B<new()> function,
the following parameters are supplied default values.  Each value
can be overridden by specifying the new (key => value) pair into the
B<new()> function, as arguments.

=head2 bypass_baseline

=over 4

When set to 1, the object will forgo any type of initial baselining
process, upon initialization.  Otherwise, baselining will occur
as normal, upon initialization.

=back

=head2 baseline_analysis 

=over 4

An array of hashtables used to hold the file analysis information,
for the baseline filesystem operation.

=back

=head2 monitored_directories 

=over 4

The base list of drives, directories, and/or files to monitor.

=back

=head2 ignored_entries 

=over 4

The list of regular expressions that match drives, directories,
and/or files to exclude from analysis.

=back

=cut

my %PARAMS = (
    # When set to 1, the object will forgo any type of initial baselining
    # process, upon initialization.  Otherwise, baselining will occur
    # as normal, upon initialization.
    bypass_baseline => 0,

    # An array of hashtables used to hold the file analysis information,
    # for the baseline filesystem operation.
    baseline_analysis => [ ],

    # The base list of drives/directories/files to monitor.
    monitored_directories => getVar(name => 'directories_to_check')->{name},

    # The list of drives/directories/files to ignore.
    ignored_entries => getVar(name => 'exclude_list')->{regex},
);

#######################################################################
# Private Methods Implemented                                         #
#######################################################################

# A helper function, designed to baseline the filesystem.
#
# Input: self
# Output: none
sub _baseline {
    # Extract arguments.
    my ($self) = @_;

    # Convert monitored directories to a Cygwin-style format.
    my @search_dirs;
    foreach (@{$self->{monitored_directories}}) {
        push (@search_dirs, posixpath($_));
    }

    # Save converted results back into our object.
    $self->{monitored_directories} = \@search_dirs;
    
    # Convert ignored entires to a Cygwin-style format.
    my @ignored_entries;
    foreach (@{$self->{ignored_entries}}) {
        push (@ignored_entries, posixpath($_));
    }

    # Save converted results back into our object.
    $self->{ignored_entries} = \@ignored_entries;

    # Analyze filesystem.
    $self->_analyze();

    # Save analyzed results to object's baseline array.
    $self->{baseline_analysis} = $file_analysis;
}

# A helper function, designed to analyze the filesystem
# and create entries of filesystem objects.
#
# Input: self
# Output: none
sub _analyze {
    # Extract arguments.
    my ($self) = @_;

    # Clear previous analysis array.
    $file_analysis = [ ];

    # Search the filesystem.
    # Trap and ignore all warnings from the find operation.
    {
        no warnings;
	    find(\&_processFile, @{$self->{monitored_directories}});
    };
}

# A helper callback function, designed to populate the @file_analysis
# global array with hashtable entries about filesystem objects.
#
# Input: none
# Output: none
sub _processFile {
    # Get file stats.
	my @attr = stat($File::Find::name);

    # Create a new entry.
    my $entry = {
        name  => $File::Find::name,
        size  => $attr[7],
        mtime => $attr[9],
    };

    # Push entry onto analysis array.
	push (@{$file_analysis}, $entry);
}

# A helper callback function, designed to stringify each filesystem
# entry object.  Used by Algorithm::Diff operations.
#
# Input: filesystem entry
# Output: unique string
sub _toString {
    # Extract arguments.
    my ($entry) = @_;

    # Check to make sure that each entry is defined.
    my $name  = defined($entry->{name})  ? $entry->{name}  : "";
    my $size  = defined($entry->{size})  ? $entry->{size}  : "";
    my $mtime = defined($entry->{mtime}) ? $entry->{mtime} : "";

    my $string = $name  . $DELIMETER .
                 $size  . $DELIMETER .
                 $mtime . $DELIMETER;

    return $string;
}

# A helper function, designed to take the output of an Algorithm::Diff object
# and return a list of changes found in the filesystem.
#
# Input: Algorithm::Diff object
# Output: Array reference of hashtables
sub _diff {

    # Extract arguments.
   	my ($self, $diff) = @_;

    # List of changes found.
	my $ret = [ ];

    # Temporary variables.
    my $index;
    my $old_entry;
    my $new_entry;

	while ($diff->Next()) {
        # Ignore all matches.
	    next if $diff->Same();

        # Check if entries were deleted.
	    if(!$diff->Items(2)) {
	        for ($diff->Items(1)) {
                # Make Dumper format more terse.
                $Data::Dumper::Terse = 1;
                $Data::Dumper::Indent = 0;
                $LOG->debug("File Deleted - " . Dumper($_));

                push (@{$ret}, {
                    'status' => 'deleted',
                    'old' => $_,
                });
	        }
        # Check if entries were added.
	    } elsif(!$diff->Items(1)) {
	        for ($diff->Items(2)) {
                # Make Dumper format more terse.
                $Data::Dumper::Terse = 1;
                $Data::Dumper::Indent = 0;
                $LOG->debug("File Added - " . Dumper($_));

                push (@{$ret}, {
                    'status' => 'added',
                    'new' => $_,
                });
	        }
        # Check if entries are different.
	    } else {
	        # This is the complicated case where there may be a single change or
	        # multiple changes which are contiguous
	        my $size_of_1 = scalar($diff->Items(1));
	        my $size_of_2 = scalar($diff->Items(2));

	        # There are multiples, but the same number from each scan
	        if ($size_of_1 == $size_of_2) {

	            $index = 0;
	            for ($diff->Items(1)) {
                    $old_entry = $_;
                    $new_entry = ($diff->Items(2))[$index];

                    # If the entry names are the same, then we know the contents
                    # of the entry have changed.
                    if ($old_entry->{name} eq $new_entry->{name}) {

                        # Make Dumper format more terse.
                        $Data::Dumper::Terse = 1;
                        $Data::Dumper::Indent = 0;
                        $LOG->debug("File Changed - Old - " . Dumper($old_entry) .
                                                " - New - " . Dumper($new_entry));

                        push (@{$ret}, {
                            'status' => 'changed',
                            'old' => $old_entry,
                            'new' => $new_entry,
                        });
                    # Otherwise, the old entry got deleted and the new entry got
                    # added.
                    } else {
                        # Make Dumper format more terse.
                        $Data::Dumper::Terse = 1;
                        $Data::Dumper::Indent = 0;
                        $LOG->debug("File Deleted - " . Dumper($old_entry));
                        $LOG->debug("File Added - "   . Dumper($new_entry));

                        push (@{$ret}, {
                            'status' => 'deleted',
                            'old' => $old_entry,
                        });
                        push (@{$ret}, {
                            'status' => 'added',
                            'new' => $new_entry,
                        });
                    }

	                $index++;
	            }
	        # There are more contiguous entries in the baseline.
	        } elsif ($size_of_1 > $size_of_2) {
	            $index = 0;
	            for ($diff->Items(1)) {
                    $old_entry = $_;
                    $new_entry = ($diff->Items(2))[$index];

                    # If the entry names are the same, then we know the contents
                    # of the entry have changed.
                    if (defined($new_entry) && ($old_entry->{name} eq $new_entry->{name})) {
                        # Make Dumper format more terse.
                        $Data::Dumper::Terse = 1;
                        $Data::Dumper::Indent = 0;
                        $LOG->debug("File Changed - Old - " . Dumper($old_entry) .
                                                " - New - " . Dumper($new_entry));

                        push (@{$ret}, {
                            'status' => 'changed',
                            'old' => $old_entry,
                            'new' => $new_entry,
                        });
                        $index++;
                    # Otherwise, the old entry got deleted and the new entry got
                    # added (possibly).
                    } else {
                        # Make Dumper format more terse.
                        $Data::Dumper::Terse = 1;
                        $Data::Dumper::Indent = 0;
                        $LOG->debug("File Deleted - " . Dumper($old_entry));

                        push (@{$ret}, {
                            'status' => 'deleted',
                            'old' => $old_entry,
                        });
                        # Mark the new entry as added, if and only if it's defined
                        # and NOT the final new entry in this chunk.
                        if (defined($new_entry) && ($index < ($size_of_2 - 1))) {
                            # Make Dumper format more terse.
                            $Data::Dumper::Terse = 1;
                            $Data::Dumper::Indent = 0;
                            $LOG->debug("File Added - "   . Dumper($new_entry));
                            push (@{$ret}, {
                                'status' => 'added',
                                'new' => $new_entry,
                            });
	                        $index++;
                        }
                    }
	            }
                # If we still have a final new entry to process, and we're finished
                # with all old entries, then we know the new entry was a filesystem
                # addition.
                if ($index < $size_of_2) {
                    # Make Dumper format more terse.
                    $Data::Dumper::Terse = 1;
                    $Data::Dumper::Indent = 0;
                    $LOG->debug("File Added - "   . Dumper($new_entry));
                    push (@{$ret}, {
                        'status' => 'added',
                        'new' => $new_entry,
                    });
                }
	        # There are more contiguous entries in the second scan.
	        } else {
	            $index = 0;
	            for ($diff->Items(2)) {
                    $old_entry = ($diff->Items(1))[$index];
                    $new_entry = $_;

                    # If the entry names are the same, then we know the contents
                    # of the entry have changed.
                    if (defined($old_entry) && ($old_entry->{name} eq $new_entry->{name})) {
                        # Make Dumper format more terse.
                        $Data::Dumper::Terse = 1;
                        $Data::Dumper::Indent = 0;
                        $LOG->debug("File Changed - Old - " . Dumper($old_entry) .
                                                " - New - " . Dumper($new_entry));
                        push (@{$ret}, {
                            'status' => 'changed',
                            'old' => $old_entry,
                            'new' => $new_entry,
                        });
                        $index++;
                    # Otherwise, the old entry got (possibly) deleted and the new entry got
                    # added.
                    } else {
                        # Make Dumper format more terse.
                        $Data::Dumper::Terse = 1;
                        $Data::Dumper::Indent = 0;
                        $LOG->debug("File Added - "   . Dumper($new_entry));
                        push (@{$ret}, {
                            'status' => 'added',
                            'new' => $new_entry,
                        });
                        # Mark the old entry as deleted, if and only if it's defined
                        # and NOT the final old entry in this chunk.
                        if (defined($old_entry) && ($index < ($size_of_1 - 1))) {
                            # Make Dumper format more terse.
                            $Data::Dumper::Terse = 1;
                            $Data::Dumper::Indent = 0;
                            $LOG->debug("File Deleted - "   . Dumper($old_entry));
                            push (@{$ret}, {
                                'status' => 'deleted',
                                'old' => $old_entry,
                            });
	                        $index++;
                        }
                    }
	            }
                # If we still have a final old entry to process, and we're finished
                # with all the new entries, then we know the old entry was a filesystem
                # deletion.
                if ($index < $size_of_1) {
                    # Make Dumper format more terse.
                    $Data::Dumper::Terse = 1;
                    $Data::Dumper::Indent = 0;
                    $LOG->debug("File Deleted - "   . Dumper($old_entry));
                    push (@{$ret}, {
                        'status' => 'deleted',
                        'old' => $old_entry,
                    });
                }
	        }
	    }
	}
	return $ret;
}

# A helper function, designed to filter out changes that should be
# ignored and correlate matching add/delete entries as changes,
# instead of separate add/delete entries.
#
# Input: Array reference of hashtables 
# Output: Array reference of hashtables (filtered) 
sub _filter {
	my ($self, $changes) = @_;
	my $ret = [];

    my $entries_by_name = { };
	foreach (@{$changes}) {
        # Extract the file name from each entry.
        my $name = undef;
        if (($_->{status} eq 'added') or ($_->{status} eq 'changed')) {
            $name = $_->{'new'}->{name};
        } else {
            $name = $_->{'old'}->{name};
        }
        
        # Check to make sure a name exists, skip if not found.
        if (!defined($name)) {
            next;
        }

        # Set an exclude flag.
		my $exclude_flag = 0;
        foreach (@{$self->{ignored_entries}}) {
   			if ($name =~ /^$_$/i) {
   				$exclude_flag = 1;
                last; # We only need to set the flag once.
			}
        }
        
        # Skip if excluded.
        if ($exclude_flag) {
            $LOG->info("Excluding '" . win32path($name) . "' from integrity checks.");
            next;
        }

        # Check to see if an entry with the same name has already
        # been pushed onto our return array.
        if (exists($entries_by_name->{$name}) &&
            defined($entries_by_name->{$name})) {

            $LOG->debug("Correlating multiple filesystem changes for '" . $name . "'.");

            my $prev_entry = $entries_by_name->{$name};
            my $curr_entry = $_;

            # Sanity check.
            if ((($prev_entry->{status} eq 'changed') ||
                 ($curr_entry->{status} eq 'changed')) ||
                (($prev_entry->{status} eq 'added') &&
                 ($curr_entry->{status} eq 'added')) ||
                (($prev_entry->{status} eq 'deleted') &&
                 ($curr_entry->{status} eq 'deleted'))) {
                $LOG->error("Duplicate filesystem change entries were found. " .
                            "Previous Entry - " . Dumper($prev_entry) . " - ".
                            "Current Entry - " . Dumper($curr_entry));
                push (@{$ret}, $_);
                next;
            }

            # If the previous entry was added and the current
            # was deleted.
            if (($prev_entry->{status} eq 'added') &&
                ($curr_entry->{status} eq 'deleted')) {
                $prev_entry->{status} = 'changed';
                $prev_entry->{old} = $curr_entry->{old};

            # Otherwise, if the previous entry was deleted and the
            # current was added.
            } else {
                $prev_entry->{status} = 'changed';
                $prev_entry->{'new'} = $curr_entry->{'new'};
            }

        } else {
            # The entry is completely new, so record it.
            $entries_by_name->{$name} = $_;

            # And push it onto our return array.
            push (@{$ret}, $_);
        }
    }
	return $ret;
}

#######################################################################
# Public Methods Implemented                                          #
#######################################################################

=pod

=head1 METHODS IMPLEMENTED

The following functions have been implemented by any Filesystem object.

=head2 HoneyClient::Agent::Integrity::Filesystem->new($param => $value, ...)

=over 4

Creates a new Filesystem object, which contains a hashtable
containing any of the supplied "param => value" arguments.  Upon
creation, the Filesystem object performs a baseline of the Windows
filesystem.

I<Inputs>:
 B<$param> is an optional parameter variable.
 B<$value> is $param's corresponding value.

Note: If any $param(s) are supplied, then an equal number of
corresponding $value(s) B<must> also be specified.

I<Output>: The instantiated Filesystem B<$object>, fully initialized.

=back

=begin testing

diag("These tests will create temporary files in /tmp.  Be sure to cleanup this directory, if any of these tests fail.");

# Create a generic Filesystem object, with test state data.
my $filesystem = HoneyClient::Agent::Integrity::Filesystem->new(test => 1, bypass_baseline => 1);
is($filesystem->{test}, 1, "new(test => 1, bypass_baseline => 1)") or diag("The new() call failed.");
isa_ok($filesystem, 'HoneyClient::Agent::Integrity::Filesystem', "new(test => 1, bypass_baseline => 1)") or diag("The new() call failed.");

diag("Performing baseline check of the filesystem; this may take some time...");

# Perform baseline.
$filesystem = HoneyClient::Agent::Integrity::Filesystem->new();
isa_ok($filesystem, 'HoneyClient::Agent::Integrity::Filesystem', "new()") or diag("The new() call failed.");

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
    $self = { };
    my %params = %{dclone(\%PARAMS)};
    @{$self}{keys %params} = values %params;

    # Now, overwrite any default parameters that were redefined
    # in the supplied arguments.
    @{$self}{keys %args} = values %args;

    # Now, assign our object the appropriate namespace.
    bless $self, $class;

    # Perform baselining, if not bypassed.
    if (!$self->{'bypass_baseline'}) {
        $LOG->info("Baselining filesystem.");
        $self->_baseline();
    }

    # Finally, return the blessed object.
    return $self;
}

################################################################################

=pod

=head2 $object->check()

=over 4

Checks the filesystem for various changes, based upon
the filesystem baseline, when the new() method was invoked.

I<Output>:
 B<$changes>, which is an array of hashtable references, where each
hashtable has the following format:

  $changes = [ {
      # Indicates if the filesystem entry was deleted,
      # added, or changed.
      'status' => 'deleted' | 'added' | 'changed',

      # If the entry has been added/changed, then this 
      # hashtable contains the file/directory's new information.
      'new' => {
          'name'  => 'C:\WINDOWS\SYSTEM32...',
          'size'  => 1263, # in bytes
          'mtime' => 1178135092, # modification time, seconds since epoch
      },

      # If the entry has been deleted/changed, then this
      # hashtable contains the file/directory's old information.
      'old' => {
          'name'  => 'C:\WINDOWS\SYSTEM32...',
          'size'  => 802, # in bytes
          'mtime' => 1178135028, # modification time, seconds since epoch
      },
  }, ]

I<Notes>:

=back

=begin testing

### Get the test directory to monitor.
my $monitor_dir = $ENV{PWD} . "/" . getVar(name      => "monitor_dir",
                                           namespace => "HoneyClient::Agent::Integrity::Filesystem::Test");

### Seed the directory with test data.
my $delete_file = $monitor_dir . "/" . "to_delete.txt";
my $change_file = $monitor_dir . "/" . "to_change.txt";
my $add_file    = $monitor_dir . "/" . "to_add.txt";

my $delete_string  = "Test string for the file to be deleted.";
my $add_string     = "Test string for the added file.";
my $change_string1 = "Original test string for the file to be changed.";
my $change_string2 = "Final test string for the changed file.";

my @file_attr;

open(DELETE_FILE, ">", $delete_file) or BAIL_OUT("Unable to create test file '" . $delete_file . "'.");
print DELETE_FILE $delete_string;
close DELETE_FILE;

@file_attr = stat($delete_file);
my $delete_file_size  = $file_attr[7];
my $delete_file_mtime = $file_attr[9];

open(CHANGE_FILE, ">", $change_file) or BAIL_OUT("Unable to create test file '" . $change_file . "'.");
print CHANGE_FILE $change_string1;
close CHANGE_FILE;

@file_attr = stat($change_file);
my $change_file_size1  = $file_attr[7];
my $change_file_mtime1 = $file_attr[9];

# Make sure the $add_file isn't present.
unlink($add_file);

### Perform baseline.
my $filesystem = HoneyClient::Agent::Integrity::Filesystem->new(monitored_directories => [ $monitor_dir ],
                                                                ignored_entries       => [ $monitor_dir ]);

### Change data in our test directory on the filesystem.
# Delete the target test file.
if (!unlink($delete_file)) {
    fail("Unable to delete test file '" . $delete_file . "'.");
}

# Add the target test file.
open(ADD_FILE, ">", $add_file) or BAIL_OUT("Unable to create test file '" . $add_file . "'.");
print ADD_FILE $add_string;
close ADD_FILE;

@file_attr = stat($add_file);
my $add_file_size  = $file_attr[7];
my $add_file_mtime = $file_attr[9];

# Change the target test file.
open(CHANGE_FILE, ">", $change_file) or BAIL_OUT("Unable to create test file '" . $change_file . "'.");
print CHANGE_FILE $change_string2;
close CHANGE_FILE;

@file_attr = stat($change_file);
my $change_file_size2  = $file_attr[7];
my $change_file_mtime2 = $file_attr[9];

### Perform check.
my $foundChanges = $filesystem->check();

# Uncomment these lines, if you want to see more
# detailed information about the changes found.
#$Data::Dumper::Terse = 0;
#$Data::Dumper::Indent = 1;
#diag(Dumper($foundChanges));

### Verify changes.
my $expectedChanges = [
  {
    'status' => 'changed',
    'new' => {
        'name'  => $change_file,
        'size'  => $change_file_size2,
        'mtime' => $change_file_mtime2,
    },
    'old' => {
        'name'  => $change_file,
        'size'  => $change_file_size1,
        'mtime' => $change_file_mtime1,
    },
  },
  {
    'status' => 'added',
    'new' => {
        'name'  => $add_file,
        'size'  => $add_file_size,
        'mtime' => $add_file_mtime,
    },
  },
  {
    'status' => 'deleted',
    'old' => {
        'name'  => $delete_file,
        'size'  => $delete_file_size,
        'mtime' => $delete_file_mtime,
    },
  },
];

is_deeply($foundChanges, $expectedChanges, "check(monitored_directories => [ $monitor_dir ], ignored_entries => [ $monitor_dir ])") or diag("The check() call failed.");

### Clean up test data.
close DELETE_FILE;
unlink($delete_file);

close CHANGE_FILE;
unlink($change_file);

close ADD_FILE;
unlink($add_file);

=end testing

=cut

sub check {

    # Extract arguments.
    my ($self, %args) = @_;

    # Log resolved arguments.
    # Make Dumper format more terse.
    $Data::Dumper::Terse = 1;
    $Data::Dumper::Indent = 0;
    $LOG->debug(Dumper(\%args));

    # Analyze the filesystem.
    $LOG->info("Analyzing filesystem.");
    $self->_analyze();

    # Compare analysis with baseline.
    $LOG->info("Checking for filesystem changes.");
    my $changes = $self->_diff(Algorithm::Diff->new($self->{baseline_analysis},
                                                    $file_analysis,
                                                    { keyGen => \&_toString }));
    # Return filtered results.
    $changes = $self->_filter($changes);
    if (scalar(@{$changes})) {
        $LOG->warn("Filesystem changes found.");
    } else {
        $LOG->info("No filesystem changes found.");
    }
    return $changes;
}

1;

=pod

=head1 BUGS & ASSUMPTIONS

This library performs B<STATIC> checks of the Windows filesystem.
If malware modifies the filesystem between the time the $object->new()
and $object->check() methods are called, then this library may B<FAIL>
to detect those changes if:

=over 4

=item *

Malware writes itself to one of the regions of the filesystem that is
excluded.  See the <HoneyClient/><Agent/><Integrity/><exclude_list/>
element, in the etc/honeyclient.xml file.

=item *

Malware writes itself to a monitored region of the filesystem but
reverses all its activity (including self-deletion).

=back

=head1 SEE ALSO

L<http://www.honeyclient.org/trac>

=head1 REPORTING BUGS

L<http://www.honeyclient.org/trac/newticket>

=head1 ACKNOWLEDGEMENTS

Mark-Jason Dominus E<lt>mjd-perl-diff@plover.comE<gt>,
Ned Konz E<lt>perl@bike-nomad.comE<gt>, and Tye McQueen,
for using their Algorithm::Diff code.

=head1 AUTHORS

Xeno Kovah, E<lt>xkovah@mitre.orgE<gt>

Darien Kindlund, E<lt>kindlund@mitre.orgE<gt>

Brad Stephenson, E<lt>stephenson@mitre.orgE<gt>

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

