use HoneyClient::DB;
use HoneyClient::DB::Process;
use HoneyClient::DB::Note;
use strict;

=head1 NAME

HoneyClient::DB::Fingerprint - HoneyClient Compromise Fingerprint Object

=head1 DESCRIPTION

  HoneyClient::DB::Fingerprint describes a set of changes to be reported by a HoneyClient
  at the time of a compromise. This class describes the schema for a Fingerprint Set and 
  assists insertion into and queries from the HoneyClient database.

=head1 SYNOPSIS

  # Create a new Fingerprint
  my $fingerprint = new HoneyClient::DB::Fingerprint({
	  processes => \@process_array,
  });
  
  $fingerprint->insert();
  
  #XXX: This no longer works since no vmid
  # Search for Fingerprint containing a specific vmid
  my $fp_results = HoneyClient::DB::Fingerprint->select({
  	vmid => '1234567890ABCDEF1234567890',
  });

=head1 REQUIRES

Perl5.8.8, HoneyClient::DB, Digest::MD5, Carp

=cut


package HoneyClient::DB::Fingerprint;

use base("HoneyClient::DB");
use Digest::MD5;

BEGIN {

    our %fields = (
        string => {
            md5_hash => {
            	required => 1,
            	key => $HoneyClient::DB::KEY_UNIQUE_MULT,
            }
        },
        array => {
            processes => {
                objclass => 'HoneyClient::DB::Process',
            },
            notes => {
                objclass => 'HoneyClient::DB::Note',
            },
        },
    );
}
sub new {
	my ($class,$self) = @_;
	delete $self->{lasturl} if ( exists $self->{lasturl} );
	$self->{md5_hash} = _create_hashsum($self);
	use Data::Dumper;
	print Dumper($self)."\n";
	$class->SUPER::new($self);
}

# Create a string from the fingerprint attributes and HASH it. This value is used to prevent identical Fingerprints
sub _create_hashsum {
	my $self = shift;
    my @strings;
# Get a list of Process names to sort and associate with their hashes
    my %procs = map {$_->{name}=>$_} @{$self->{processes}};

# Sort Process List and process each item in it
    foreach my $proc_name (sort(keys %procs)) {
        my $proc = $procs{$proc_name};

# Fingerprint String segments begin with the Process and its Event Type
		my $proc_string = $proc_name;
		$proc_string .= 'created' if(exists $proc->{created_time} && $proc->{created_time});
		$proc_string .= 'terminated' if(exists $proc->{terminated_time} && $proc->{terminated_time});

# Append an identifier string from each file change to a list and sort the list
        my $file_string = "";
		$file_string = join ("",
            sort(
                map {
                    my $tmp_string = "";
# If file event was 'Delete' or if the File was deleted before being hashed, append name
                    if ($_->{'event_type'} eq 'Delete' || $_->{contents}->{md5} eq 'UNKNOWN' || $_->{contents}->{sha1} eq 'UNKNOWN') {
                        $tmp_string .= $_->{name};
                    }
                    if ($_->{'event_type'} ne 'Delete') {
                        $tmp_string .= $_->{contents}->{md5};
                        $tmp_string .= $_->{contents}->{sha1};
                    }
                    $tmp_string .= $_->{event_type};
                } @{$proc->{file_system}}
    	    )
	    ) if (exists $proc->{file_system});

# Append an identifier string from each Registry Key change to a list and sort the list
        my $regkey_string = "";
		$regkey_string = join ("",
            sort(
                map {
                    my $tmp_string = "";
                    if (exists $_->{key_name}) {
                        $tmp_string .= $_->{key_name};
                    }
                    if (exists $_->{event_type}) {
                        $tmp_string .= $_->{event_type};
                    }
                    if (exists $_->{value_name}) {
                        $tmp_string .= $_->{value_name};
                    }
                    $tmp_string;
                } @{$proc->{registry}}
            )
        ) if (exists $proc->{registry});
        push @strings,($file_string,$regkey_string);
	}
# Join Process, File, and Registry Key strings and create the Fingerprint Hash
    return Digest::MD5->new->add(join("",@strings))->hexdigest;
}

1;
