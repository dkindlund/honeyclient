package HoneyClient::Message::Firewall::Command;

use strict;
use warnings;
use vars qw(@ISA $AUTOLOAD $VERSION);

$VERSION = '1.0';

use Exporter;

require DynaLoader;
require AutoLoader;

@ISA = qw(DynaLoader Exporter);

bootstrap HoneyClient::Message::Firewall::Command $VERSION;

1;

__END__

=pod

=head1 NAME

HoneyClient::Message::Firewall::Command - Perl/XS interface to HoneyClient.Message.Firewall.Command

=head1 SYNOPSIS

=head2 Serializing messages

 #!/usr/bin/perl

 use strict;
 use warnings;
 use HoneyClient::Message::Firewall::Command;

 my $Command = HoneyClient::Message::Firewall::Command->new;
 # Set fields in $Command...
 my $packCommand = $Command->pack();

=head2 Unserializing messages

 #!/usr/bin/perl

 use strict;
 use warnings;
 use HoneyClient::Message::Firewall::Command;

 my $packCommand; # Read this from somewhere...
 my $Command = HoneyClient::Message::Firewall::Command->new;
 if ( $Command->unpack($packCommand) ) {
   print "OK"
 } else {
   print "NOT OK"
 }

=head1 DESCRIPTION

HoneyClient::Message::Firewall::Command defines the following classes:

=over 5

=item C<HoneyClient::Message::Firewall::Command::ActionType>

A wrapper around the HoneyClient.Message.Firewall.Command.ActionType enum

=item C<HoneyClient::Message::Firewall::Command::ResponseType>

A wrapper around the HoneyClient.Message.Firewall.Command.ResponseType enum

=item C<HoneyClient::Message::Firewall::Command>

A wrapper around the HoneyClient.Message.Firewall.Command message


=back

=head1 C<HoneyClient::Message::Firewall::Command::ActionType> values

=over 4

=item B<UNKNOWN>

This constant has a value of 1.

=item B<DENY_ALL>

This constant has a value of 2.

=item B<DENY_VM>

This constant has a value of 3.

=item B<ALLOW_VM>

This constant has a value of 4.

=item B<ALLOW_ALL>

This constant has a value of 5.


=back

=head1 C<HoneyClient::Message::Firewall::Command::ResponseType> values

=over 4

=item B<ERROR>

This constant has a value of 1.

=item B<OK>

This constant has a value of 2.


=back

=head1 HoneyClient::Message::Firewall::Command Constructor

=over 4

=item B<$Command = HoneyClient::Message::Firewall::Command-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Firewall::Command>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Firewall::Command Methods

=over 4

=item B<$Command2-E<gt>copy_from($Command1)>

Copies the contents of C<Command1> into C<Command2>.
C<Command2> is another instance of the same message type.

=item B<$Command2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Command2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Command2-E<gt>merge_from($Command1)>

Merges the contents of C<Command1> into C<Command2>.
C<Command2> is another instance of the same message type.

=item B<$Command2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Command2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Command-E<gt>clear()>

Clears the contents of C<Command>.

=item B<$init = $Command-E<gt>is_initialized()>

Returns 1 if C<Command> has been initialized with data.

=item B<$errstr = $Command-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Command-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Command>.

=item B<$dstr = $Command-E<gt>debug_string()>

Returns a string representation of C<Command>.

=item B<$dstr = $Command-E<gt>short_debug_string()>

Returns a short string representation of C<Command>.

=item B<$ok = $Command-E<gt>unpack($string)>

Attempts to parse C<string> into C<Command>, returning 1 on success and 0 on failure.

=item B<$string = $Command-E<gt>pack()>

Serializes C<Command> into C<string>.

=item B<$length = $Command-E<gt>length()>

Returns the serialized length of C<Command>.

=item B<@fields = $Command-E<gt>fields()>

Returns the defined fields of C<Command>.

=item B<$hashref = $Command-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_action = $Command-E<gt>has_action()>

Returns 1 if the C<action> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_action()>

Clears the C<action> element(s) of C<Command>.

=item B<$action = $Command-E<gt>action()>

Returns C<action> from C<Command>.  C<action> will be a value of HoneyClient::Message::Firewall::Command::ActionType.

=item B<$Command-E<gt>set_action($value)>

Sets the value of C<action> in C<Command> to C<value>.  C<value> must be a value of HoneyClient::Message::Firewall::Command::ActionType.

=item B<$has_response = $Command-E<gt>has_response()>

Returns 1 if the C<response> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_response()>

Clears the C<response> element(s) of C<Command>.

=item B<$response = $Command-E<gt>response()>

Returns C<response> from C<Command>.  C<response> will be a value of HoneyClient::Message::Firewall::Command::ResponseType.

=item B<$Command-E<gt>set_response($value)>

Sets the value of C<response> in C<Command> to C<value>.  C<value> must be a value of HoneyClient::Message::Firewall::Command::ResponseType.

=item B<$has_err_message = $Command-E<gt>has_err_message()>

Returns 1 if the C<err_message> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_err_message()>

Clears the C<err_message> element(s) of C<Command>.

=item B<$err_message = $Command-E<gt>err_message()>

Returns C<err_message> from C<Command>.  C<err_message> will be a string.

=item B<$Command-E<gt>set_err_message($value)>

Sets the value of C<err_message> in C<Command> to C<value>.  C<value> must be a string.

=item B<$has_chain_name = $Command-E<gt>has_chain_name()>

Returns 1 if the C<chain_name> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_chain_name()>

Clears the C<chain_name> element(s) of C<Command>.

=item B<$chain_name = $Command-E<gt>chain_name()>

Returns C<chain_name> from C<Command>.  C<chain_name> will be a string.

=item B<$Command-E<gt>set_chain_name($value)>

Sets the value of C<chain_name> in C<Command> to C<value>.  C<value> must be a string.

=item B<$has_mac_address = $Command-E<gt>has_mac_address()>

Returns 1 if the C<mac_address> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_mac_address()>

Clears the C<mac_address> element(s) of C<Command>.

=item B<$mac_address = $Command-E<gt>mac_address()>

Returns C<mac_address> from C<Command>.  C<mac_address> will be a string.

=item B<$Command-E<gt>set_mac_address($value)>

Sets the value of C<mac_address> in C<Command> to C<value>.  C<value> must be a string.

=item B<$has_ip_address = $Command-E<gt>has_ip_address()>

Returns 1 if the C<ip_address> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_ip_address()>

Clears the C<ip_address> element(s) of C<Command>.

=item B<$ip_address = $Command-E<gt>ip_address()>

Returns C<ip_address> from C<Command>.  C<ip_address> will be a string.

=item B<$Command-E<gt>set_ip_address($value)>

Sets the value of C<ip_address> in C<Command> to C<value>.  C<value> must be a string.

=item B<$has_protocol = $Command-E<gt>has_protocol()>

Returns 1 if the C<protocol> element of C<Command> is set, 0 otherwise.

=item B<$Command-E<gt>clear_protocol()>

Clears the C<protocol> element(s) of C<Command>.

=item B<$protocol = $Command-E<gt>protocol()>

Returns C<protocol> from C<Command>.  C<protocol> will be a string.

=item B<$Command-E<gt>set_protocol($value)>

Sets the value of C<protocol> in C<Command> to C<value>.  C<value> must be a string.

=item B<$port_size = $Command-E<gt>port_size()>

Returns the number of C<port> elements present in C<Command>.

=item B<$Command-E<gt>clear_port()>

Clears the C<port> element(s) of C<Command>.

=item B<@port_list = $Command-E<gt>port()>

Returns all values of C<port> in an array.  Each element of C<port_list> will be a 32-bit unsigned integer.

=item B<$port_elem = $Command-E<gt>port($index)>

Returns C<port> element C<index> from C<Command>.  C<port> will be a 32-bit unsigned integer, unless C<index> is out of range, in which case it will be undef.

=item B<$Command-E<gt>add_port($value)>

Adds C<value> to the list of C<port> in C<Command>.  C<value> must be a 32-bit unsigned integer.


=back

=head1 AUTHOR

Generated from HoneyClient.Message.Firewall.Command by the protoc compiler.

=head1 SEE ALSO

http://code.google.com/p/protobuf

=cut

