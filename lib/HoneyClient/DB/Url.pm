use strict;
package HoneyClient::DB::Url;
use base("HoneyClient::DB");

use Data::Validate::URI qw(is_uri);
use URI::URL;
use HoneyClient::DB;
use HoneyClient::Util::Config;
use Log::Log4perl qw(:easy);
our $LOG = get_logger();

our %fields = (
    string => {
        protocol => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        domain => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
        rel_path => {
            required => 1,
            key => $HoneyClient::DB::KEY_UNIQUE_MULT,
        },
    },
    int => {
        visits => {
            init_val => 1,
        },
    },
);

sub new {
    my ($class,$self) = @_;
    if (!ref $self) {
        # Assume a Url string has been passed
        if (is_uri($self)) {
            my $url = URI::URL->new($self);
            $self = {
                protocol => $url->scheme(),
                domain => $url->netloc(),
                rel_path => $url->path_query(),
            };
        }
		# The URL is undefined or of an incorrect format. Force to {} to prevent crash.
		else {
			$LOG->warn("Url: $self is improper and thus won't be created/inserted correctly");
			$self = {};
		}
    }
    $class->SUPER::new($self);
}

sub select_full_url {
	my $class = shift;
    push @_,('id','protocol','domain','rel_path');
    my @results = $class->SUPER::select(@_);
    foreach my $row (@results) {
        $row->{'url'} = delete $row->{'protocol'};
        $row->{'url'} .= '://';
        $row->{'url'} .= delete $row->{'domain'};
        $row->{'url'} .= delete $row ->{'rel_path'};
    }
    return @results;
}

sub insert {
	my $self = shift;
    my $url_id = $self->SUPER::insert();
    if ($HoneyClient::DB::LAST_ERROR == $HoneyClient::DB::DUPLICATE_FOUND) {
        HoneyClient::DB::Url->incrementColumn(
            '-column'   => 'visits',
            '-where' => {'id'=>$url_id},
        );
    }
    return $url_id;
}

1;
