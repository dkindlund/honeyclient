package HoneyClient::Message;

use strict;
use warnings;
use vars qw(@ISA $AUTOLOAD $VERSION);

$VERSION = '1.0';

use Exporter;

require DynaLoader;
require AutoLoader;

@ISA = qw(DynaLoader Exporter);

bootstrap HoneyClient::Message $VERSION;

1;

__END__

=pod

=head1 NAME

HoneyClient::Message - Perl/XS interface to HoneyClient.Message

=head1 SYNOPSIS

=head2 Serializing messages

 #!/usr/bin/perl

 use strict;
 use warnings;
 use HoneyClient::Message;

 my $Message = HoneyClient::Message->new;
 # Set fields in $Message...
 my $packMessage = $Message->pack();

=head2 Unserializing messages

 #!/usr/bin/perl

 use strict;
 use warnings;
 use HoneyClient::Message;

 my $packMessage; # Read this from somewhere...
 my $Message = HoneyClient::Message->new;
 if ( $Message->unpack($packMessage) ) {
   print "OK"
 } else {
   print "NOT OK"
 }

=head1 DESCRIPTION

HoneyClient::Message defines the following classes:

=over 5

=item C<HoneyClient::Message::Client>

A wrapper around the HoneyClient.Message.Client message

=item C<HoneyClient::Message::File::Content>

A wrapper around the HoneyClient.Message.File.Content message

=item C<HoneyClient::Message::File>

A wrapper around the HoneyClient.Message.File message

=item C<HoneyClient::Message::Registry>

A wrapper around the HoneyClient.Message.Registry message

=item C<HoneyClient::Message::Process>

A wrapper around the HoneyClient.Message.Process message

=item C<HoneyClient::Message::Fingerprint>

A wrapper around the HoneyClient.Message.Fingerprint message

=item C<HoneyClient::Message::Url::Status>

A wrapper around the HoneyClient.Message.Url.Status enum

=item C<HoneyClient::Message::Url>

A wrapper around the HoneyClient.Message.Url message

=item C<HoneyClient::Message::Job>

A wrapper around the HoneyClient.Message.Job message

=item C<HoneyClient::Message::Firewall::Command::ActionType>

A wrapper around the HoneyClient.Message.Firewall.Command.ActionType enum

=item C<HoneyClient::Message::Firewall::Command::ResponseType>

A wrapper around the HoneyClient.Message.Firewall.Command.ResponseType enum

=item C<HoneyClient::Message::Firewall::Command>

A wrapper around the HoneyClient.Message.Firewall.Command message

=item C<HoneyClient::Message::Firewall>

A wrapper around the HoneyClient.Message.Firewall message

=item C<HoneyClient::Message>

A wrapper around the HoneyClient.Message message


=back

=head1 HoneyClient::Message::Client Constructor

=over 4

=item B<$Client = HoneyClient::Message::Client-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Client>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Client Methods

=over 4

=item B<$Client2-E<gt>copy_from($Client1)>

Copies the contents of C<Client1> into C<Client2>.
C<Client2> is another instance of the same message type.

=item B<$Client2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Client2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Client2-E<gt>merge_from($Client1)>

Merges the contents of C<Client1> into C<Client2>.
C<Client2> is another instance of the same message type.

=item B<$Client2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Client2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Client-E<gt>clear()>

Clears the contents of C<Client>.

=item B<$init = $Client-E<gt>is_initialized()>

Returns 1 if C<Client> has been initialized with data.

=item B<$errstr = $Client-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Client-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Client>.

=item B<$dstr = $Client-E<gt>debug_string()>

Returns a string representation of C<Client>.

=item B<$dstr = $Client-E<gt>short_debug_string()>

Returns a short string representation of C<Client>.

=item B<$ok = $Client-E<gt>unpack($string)>

Attempts to parse C<string> into C<Client>, returning 1 on success and 0 on failure.

=item B<$string = $Client-E<gt>pack()>

Serializes C<Client> into C<string>.

=item B<$length = $Client-E<gt>length()>

Returns the serialized length of C<Client>.

=item B<@fields = $Client-E<gt>fields()>

Returns the defined fields of C<Client>.

=item B<$hashref = $Client-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_vm_name = $Client-E<gt>has_vm_name()>

Returns 1 if the C<vm_name> element of C<Client> is set, 0 otherwise.

=item B<$Client-E<gt>clear_vm_name()>

Clears the C<vm_name> element(s) of C<Client>.

=item B<$vm_name = $Client-E<gt>vm_name()>

Returns C<vm_name> from C<Client>.  C<vm_name> will be a string.

=item B<$Client-E<gt>set_vm_name($value)>

Sets the value of C<vm_name> in C<Client> to C<value>.  C<value> must be a string.

=item B<$has_snapshot_name = $Client-E<gt>has_snapshot_name()>

Returns 1 if the C<snapshot_name> element of C<Client> is set, 0 otherwise.

=item B<$Client-E<gt>clear_snapshot_name()>

Clears the C<snapshot_name> element(s) of C<Client>.

=item B<$snapshot_name = $Client-E<gt>snapshot_name()>

Returns C<snapshot_name> from C<Client>.  C<snapshot_name> will be a string.

=item B<$Client-E<gt>set_snapshot_name($value)>

Sets the value of C<snapshot_name> in C<Client> to C<value>.  C<value> must be a string.

=item B<$has_status = $Client-E<gt>has_status()>

Returns 1 if the C<status> element of C<Client> is set, 0 otherwise.

=item B<$Client-E<gt>clear_status()>

Clears the C<status> element(s) of C<Client>.

=item B<$status = $Client-E<gt>status()>

Returns C<status> from C<Client>.  C<status> will be a string.

=item B<$Client-E<gt>set_status($value)>

Sets the value of C<status> in C<Client> to C<value>.  C<value> must be a string.

=item B<$has_start_at = $Client-E<gt>has_start_at()>

Returns 1 if the C<start_at> element of C<Client> is set, 0 otherwise.

=item B<$Client-E<gt>clear_start_at()>

Clears the C<start_at> element(s) of C<Client>.

=item B<$start_at = $Client-E<gt>start_at()>

Returns C<start_at> from C<Client>.  C<start_at> will be a string.

=item B<$Client-E<gt>set_start_at($value)>

Sets the value of C<start_at> in C<Client> to C<value>.  C<value> must be a string.

=item B<$has_compromise_at = $Client-E<gt>has_compromise_at()>

Returns 1 if the C<compromise_at> element of C<Client> is set, 0 otherwise.

=item B<$Client-E<gt>clear_compromise_at()>

Clears the C<compromise_at> element(s) of C<Client>.

=item B<$compromise_at = $Client-E<gt>compromise_at()>

Returns C<compromise_at> from C<Client>.  C<compromise_at> will be a string.

=item B<$Client-E<gt>set_compromise_at($value)>

Sets the value of C<compromise_at> in C<Client> to C<value>.  C<value> must be a string.


=back

=head1 HoneyClient::Message::File::Content Constructor

=over 4

=item B<$Content = HoneyClient::Message::File::Content-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::File::Content>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::File::Content Methods

=over 4

=item B<$Content2-E<gt>copy_from($Content1)>

Copies the contents of C<Content1> into C<Content2>.
C<Content2> is another instance of the same message type.

=item B<$Content2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Content2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Content2-E<gt>merge_from($Content1)>

Merges the contents of C<Content1> into C<Content2>.
C<Content2> is another instance of the same message type.

=item B<$Content2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Content2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Content-E<gt>clear()>

Clears the contents of C<Content>.

=item B<$init = $Content-E<gt>is_initialized()>

Returns 1 if C<Content> has been initialized with data.

=item B<$errstr = $Content-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Content-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Content>.

=item B<$dstr = $Content-E<gt>debug_string()>

Returns a string representation of C<Content>.

=item B<$dstr = $Content-E<gt>short_debug_string()>

Returns a short string representation of C<Content>.

=item B<$ok = $Content-E<gt>unpack($string)>

Attempts to parse C<string> into C<Content>, returning 1 on success and 0 on failure.

=item B<$string = $Content-E<gt>pack()>

Serializes C<Content> into C<string>.

=item B<$length = $Content-E<gt>length()>

Returns the serialized length of C<Content>.

=item B<@fields = $Content-E<gt>fields()>

Returns the defined fields of C<Content>.

=item B<$hashref = $Content-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_size = $Content-E<gt>has_size()>

Returns 1 if the C<size> element of C<Content> is set, 0 otherwise.

=item B<$Content-E<gt>clear_size()>

Clears the C<size> element(s) of C<Content>.

=item B<$size = $Content-E<gt>size()>

Returns C<size> from C<Content>.  C<size> will be a 64-bit unsigned integer.

=item B<$Content-E<gt>set_size($value)>

Sets the value of C<size> in C<Content> to C<value>.  C<value> must be a 64-bit unsigned integer.

=item B<$has_md5 = $Content-E<gt>has_md5()>

Returns 1 if the C<md5> element of C<Content> is set, 0 otherwise.

=item B<$Content-E<gt>clear_md5()>

Clears the C<md5> element(s) of C<Content>.

=item B<$md5 = $Content-E<gt>md5()>

Returns C<md5> from C<Content>.  C<md5> will be a string.

=item B<$Content-E<gt>set_md5($value)>

Sets the value of C<md5> in C<Content> to C<value>.  C<value> must be a string.

=item B<$has_sha1 = $Content-E<gt>has_sha1()>

Returns 1 if the C<sha1> element of C<Content> is set, 0 otherwise.

=item B<$Content-E<gt>clear_sha1()>

Clears the C<sha1> element(s) of C<Content>.

=item B<$sha1 = $Content-E<gt>sha1()>

Returns C<sha1> from C<Content>.  C<sha1> will be a string.

=item B<$Content-E<gt>set_sha1($value)>

Sets the value of C<sha1> in C<Content> to C<value>.  C<value> must be a string.

=item B<$has_mime_type = $Content-E<gt>has_mime_type()>

Returns 1 if the C<mime_type> element of C<Content> is set, 0 otherwise.

=item B<$Content-E<gt>clear_mime_type()>

Clears the C<mime_type> element(s) of C<Content>.

=item B<$mime_type = $Content-E<gt>mime_type()>

Returns C<mime_type> from C<Content>.  C<mime_type> will be a string.

=item B<$Content-E<gt>set_mime_type($value)>

Sets the value of C<mime_type> in C<Content> to C<value>.  C<value> must be a string.


=back

=head1 HoneyClient::Message::File Constructor

=over 4

=item B<$File = HoneyClient::Message::File-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::File>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::File Methods

=over 4

=item B<$File2-E<gt>copy_from($File1)>

Copies the contents of C<File1> into C<File2>.
C<File2> is another instance of the same message type.

=item B<$File2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<File2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$File2-E<gt>merge_from($File1)>

Merges the contents of C<File1> into C<File2>.
C<File2> is another instance of the same message type.

=item B<$File2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<File2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$File-E<gt>clear()>

Clears the contents of C<File>.

=item B<$init = $File-E<gt>is_initialized()>

Returns 1 if C<File> has been initialized with data.

=item B<$errstr = $File-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$File-E<gt>discard_unknown_fields()>

Discards unknown fields from C<File>.

=item B<$dstr = $File-E<gt>debug_string()>

Returns a string representation of C<File>.

=item B<$dstr = $File-E<gt>short_debug_string()>

Returns a short string representation of C<File>.

=item B<$ok = $File-E<gt>unpack($string)>

Attempts to parse C<string> into C<File>, returning 1 on success and 0 on failure.

=item B<$string = $File-E<gt>pack()>

Serializes C<File> into C<string>.

=item B<$length = $File-E<gt>length()>

Returns the serialized length of C<File>.

=item B<@fields = $File-E<gt>fields()>

Returns the defined fields of C<File>.

=item B<$hashref = $File-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_time_at = $File-E<gt>has_time_at()>

Returns 1 if the C<time_at> element of C<File> is set, 0 otherwise.

=item B<$File-E<gt>clear_time_at()>

Clears the C<time_at> element(s) of C<File>.

=item B<$time_at = $File-E<gt>time_at()>

Returns C<time_at> from C<File>.  C<time_at> will be a string.

=item B<$File-E<gt>set_time_at($value)>

Sets the value of C<time_at> in C<File> to C<value>.  C<value> must be a string.

=item B<$has_name = $File-E<gt>has_name()>

Returns 1 if the C<name> element of C<File> is set, 0 otherwise.

=item B<$File-E<gt>clear_name()>

Clears the C<name> element(s) of C<File>.

=item B<$name = $File-E<gt>name()>

Returns C<name> from C<File>.  C<name> will be a string.

=item B<$File-E<gt>set_name($value)>

Sets the value of C<name> in C<File> to C<value>.  C<value> must be a string.

=item B<$has_event = $File-E<gt>has_event()>

Returns 1 if the C<event> element of C<File> is set, 0 otherwise.

=item B<$File-E<gt>clear_event()>

Clears the C<event> element(s) of C<File>.

=item B<$event = $File-E<gt>event()>

Returns C<event> from C<File>.  C<event> will be a string.

=item B<$File-E<gt>set_event($value)>

Sets the value of C<event> in C<File> to C<value>.  C<value> must be a string.

=item B<$has_content = $File-E<gt>has_content()>

Returns 1 if the C<content> element of C<File> is set, 0 otherwise.

=item B<$File-E<gt>clear_content()>

Clears the C<content> element(s) of C<File>.

=item B<$content = $File-E<gt>content()>

Returns C<content> from C<File>.  C<content> will be an instance of HoneyClient::Message::File::Content.

=item B<$File-E<gt>set_content($value)>

Sets the value of C<content> in C<File> to C<value>.  C<value> must be an instance of HoneyClient::Message::File::Content.


=back

=head1 HoneyClient::Message::Registry Constructor

=over 4

=item B<$Registry = HoneyClient::Message::Registry-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Registry>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Registry Methods

=over 4

=item B<$Registry2-E<gt>copy_from($Registry1)>

Copies the contents of C<Registry1> into C<Registry2>.
C<Registry2> is another instance of the same message type.

=item B<$Registry2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Registry2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Registry2-E<gt>merge_from($Registry1)>

Merges the contents of C<Registry1> into C<Registry2>.
C<Registry2> is another instance of the same message type.

=item B<$Registry2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Registry2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Registry-E<gt>clear()>

Clears the contents of C<Registry>.

=item B<$init = $Registry-E<gt>is_initialized()>

Returns 1 if C<Registry> has been initialized with data.

=item B<$errstr = $Registry-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Registry-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Registry>.

=item B<$dstr = $Registry-E<gt>debug_string()>

Returns a string representation of C<Registry>.

=item B<$dstr = $Registry-E<gt>short_debug_string()>

Returns a short string representation of C<Registry>.

=item B<$ok = $Registry-E<gt>unpack($string)>

Attempts to parse C<string> into C<Registry>, returning 1 on success and 0 on failure.

=item B<$string = $Registry-E<gt>pack()>

Serializes C<Registry> into C<string>.

=item B<$length = $Registry-E<gt>length()>

Returns the serialized length of C<Registry>.

=item B<@fields = $Registry-E<gt>fields()>

Returns the defined fields of C<Registry>.

=item B<$hashref = $Registry-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_time_at = $Registry-E<gt>has_time_at()>

Returns 1 if the C<time_at> element of C<Registry> is set, 0 otherwise.

=item B<$Registry-E<gt>clear_time_at()>

Clears the C<time_at> element(s) of C<Registry>.

=item B<$time_at = $Registry-E<gt>time_at()>

Returns C<time_at> from C<Registry>.  C<time_at> will be a string.

=item B<$Registry-E<gt>set_time_at($value)>

Sets the value of C<time_at> in C<Registry> to C<value>.  C<value> must be a string.

=item B<$has_name = $Registry-E<gt>has_name()>

Returns 1 if the C<name> element of C<Registry> is set, 0 otherwise.

=item B<$Registry-E<gt>clear_name()>

Clears the C<name> element(s) of C<Registry>.

=item B<$name = $Registry-E<gt>name()>

Returns C<name> from C<Registry>.  C<name> will be a string.

=item B<$Registry-E<gt>set_name($value)>

Sets the value of C<name> in C<Registry> to C<value>.  C<value> must be a string.

=item B<$has_event = $Registry-E<gt>has_event()>

Returns 1 if the C<event> element of C<Registry> is set, 0 otherwise.

=item B<$Registry-E<gt>clear_event()>

Clears the C<event> element(s) of C<Registry>.

=item B<$event = $Registry-E<gt>event()>

Returns C<event> from C<Registry>.  C<event> will be a string.

=item B<$Registry-E<gt>set_event($value)>

Sets the value of C<event> in C<Registry> to C<value>.  C<value> must be a string.

=item B<$has_value = $Registry-E<gt>has_value()>

Returns 1 if the C<value> element of C<Registry> is set, 0 otherwise.

=item B<$Registry-E<gt>clear_value()>

Clears the C<value> element(s) of C<Registry>.

=item B<$value = $Registry-E<gt>value()>

Returns C<value> from C<Registry>.  C<value> will be a string.

=item B<$Registry-E<gt>set_value($value)>

Sets the value of C<value> in C<Registry> to C<value>.  C<value> must be a string.

=item B<$has_value_name = $Registry-E<gt>has_value_name()>

Returns 1 if the C<value_name> element of C<Registry> is set, 0 otherwise.

=item B<$Registry-E<gt>clear_value_name()>

Clears the C<value_name> element(s) of C<Registry>.

=item B<$value_name = $Registry-E<gt>value_name()>

Returns C<value_name> from C<Registry>.  C<value_name> will be a string.

=item B<$Registry-E<gt>set_value_name($value)>

Sets the value of C<value_name> in C<Registry> to C<value>.  C<value> must be a string.

=item B<$has_value_type = $Registry-E<gt>has_value_type()>

Returns 1 if the C<value_type> element of C<Registry> is set, 0 otherwise.

=item B<$Registry-E<gt>clear_value_type()>

Clears the C<value_type> element(s) of C<Registry>.

=item B<$value_type = $Registry-E<gt>value_type()>

Returns C<value_type> from C<Registry>.  C<value_type> will be a string.

=item B<$Registry-E<gt>set_value_type($value)>

Sets the value of C<value_type> in C<Registry> to C<value>.  C<value> must be a string.


=back

=head1 HoneyClient::Message::Process Constructor

=over 4

=item B<$Process = HoneyClient::Message::Process-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Process>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Process Methods

=over 4

=item B<$Process2-E<gt>copy_from($Process1)>

Copies the contents of C<Process1> into C<Process2>.
C<Process2> is another instance of the same message type.

=item B<$Process2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Process2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Process2-E<gt>merge_from($Process1)>

Merges the contents of C<Process1> into C<Process2>.
C<Process2> is another instance of the same message type.

=item B<$Process2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Process2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Process-E<gt>clear()>

Clears the contents of C<Process>.

=item B<$init = $Process-E<gt>is_initialized()>

Returns 1 if C<Process> has been initialized with data.

=item B<$errstr = $Process-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Process-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Process>.

=item B<$dstr = $Process-E<gt>debug_string()>

Returns a string representation of C<Process>.

=item B<$dstr = $Process-E<gt>short_debug_string()>

Returns a short string representation of C<Process>.

=item B<$ok = $Process-E<gt>unpack($string)>

Attempts to parse C<string> into C<Process>, returning 1 on success and 0 on failure.

=item B<$string = $Process-E<gt>pack()>

Serializes C<Process> into C<string>.

=item B<$length = $Process-E<gt>length()>

Returns the serialized length of C<Process>.

=item B<@fields = $Process-E<gt>fields()>

Returns the defined fields of C<Process>.

=item B<$hashref = $Process-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_name = $Process-E<gt>has_name()>

Returns 1 if the C<name> element of C<Process> is set, 0 otherwise.

=item B<$Process-E<gt>clear_name()>

Clears the C<name> element(s) of C<Process>.

=item B<$name = $Process-E<gt>name()>

Returns C<name> from C<Process>.  C<name> will be a string.

=item B<$Process-E<gt>set_name($value)>

Sets the value of C<name> in C<Process> to C<value>.  C<value> must be a string.

=item B<$has_pid = $Process-E<gt>has_pid()>

Returns 1 if the C<pid> element of C<Process> is set, 0 otherwise.

=item B<$Process-E<gt>clear_pid()>

Clears the C<pid> element(s) of C<Process>.

=item B<$pid = $Process-E<gt>pid()>

Returns C<pid> from C<Process>.  C<pid> will be a 64-bit unsigned integer.

=item B<$Process-E<gt>set_pid($value)>

Sets the value of C<pid> in C<Process> to C<value>.  C<value> must be a 64-bit unsigned integer.

=item B<$file_size = $Process-E<gt>file_size()>

Returns the number of C<file> elements present in C<Process>.

=item B<$Process-E<gt>clear_file()>

Clears the C<file> element(s) of C<Process>.

=item B<@file_list = $Process-E<gt>file()>

Returns all values of C<file> in an array.  Each element of C<file_list> will be an instance of HoneyClient::Message::File.

=item B<$file_elem = $Process-E<gt>file($index)>

Returns C<file> element C<index> from C<Process>.  C<file> will be an instance of HoneyClient::Message::File, unless C<index> is out of range, in which case it will be undef.

=item B<$Process-E<gt>add_file($value)>

Adds C<value> to the list of C<file> in C<Process>.  C<value> must be an instance of HoneyClient::Message::File.

=item B<$registry_size = $Process-E<gt>registry_size()>

Returns the number of C<registry> elements present in C<Process>.

=item B<$Process-E<gt>clear_registry()>

Clears the C<registry> element(s) of C<Process>.

=item B<@registry_list = $Process-E<gt>registry()>

Returns all values of C<registry> in an array.  Each element of C<registry_list> will be an instance of HoneyClient::Message::Registry.

=item B<$registry_elem = $Process-E<gt>registry($index)>

Returns C<registry> element C<index> from C<Process>.  C<registry> will be an instance of HoneyClient::Message::Registry, unless C<index> is out of range, in which case it will be undef.

=item B<$Process-E<gt>add_registry($value)>

Adds C<value> to the list of C<registry> in C<Process>.  C<value> must be an instance of HoneyClient::Message::Registry.


=back

=head1 HoneyClient::Message::Fingerprint Constructor

=over 4

=item B<$Fingerprint = HoneyClient::Message::Fingerprint-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Fingerprint>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Fingerprint Methods

=over 4

=item B<$Fingerprint2-E<gt>copy_from($Fingerprint1)>

Copies the contents of C<Fingerprint1> into C<Fingerprint2>.
C<Fingerprint2> is another instance of the same message type.

=item B<$Fingerprint2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Fingerprint2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Fingerprint2-E<gt>merge_from($Fingerprint1)>

Merges the contents of C<Fingerprint1> into C<Fingerprint2>.
C<Fingerprint2> is another instance of the same message type.

=item B<$Fingerprint2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Fingerprint2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Fingerprint-E<gt>clear()>

Clears the contents of C<Fingerprint>.

=item B<$init = $Fingerprint-E<gt>is_initialized()>

Returns 1 if C<Fingerprint> has been initialized with data.

=item B<$errstr = $Fingerprint-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Fingerprint-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Fingerprint>.

=item B<$dstr = $Fingerprint-E<gt>debug_string()>

Returns a string representation of C<Fingerprint>.

=item B<$dstr = $Fingerprint-E<gt>short_debug_string()>

Returns a short string representation of C<Fingerprint>.

=item B<$ok = $Fingerprint-E<gt>unpack($string)>

Attempts to parse C<string> into C<Fingerprint>, returning 1 on success and 0 on failure.

=item B<$string = $Fingerprint-E<gt>pack()>

Serializes C<Fingerprint> into C<string>.

=item B<$length = $Fingerprint-E<gt>length()>

Returns the serialized length of C<Fingerprint>.

=item B<@fields = $Fingerprint-E<gt>fields()>

Returns the defined fields of C<Fingerprint>.

=item B<$hashref = $Fingerprint-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$process_size = $Fingerprint-E<gt>process_size()>

Returns the number of C<process> elements present in C<Fingerprint>.

=item B<$Fingerprint-E<gt>clear_process()>

Clears the C<process> element(s) of C<Fingerprint>.

=item B<@process_list = $Fingerprint-E<gt>process()>

Returns all values of C<process> in an array.  Each element of C<process_list> will be an instance of HoneyClient::Message::Process.

=item B<$process_elem = $Fingerprint-E<gt>process($index)>

Returns C<process> element C<index> from C<Fingerprint>.  C<process> will be an instance of HoneyClient::Message::Process, unless C<index> is out of range, in which case it will be undef.

=item B<$Fingerprint-E<gt>add_process($value)>

Adds C<value> to the list of C<process> in C<Fingerprint>.  C<value> must be an instance of HoneyClient::Message::Process.


=back

=head1 C<HoneyClient::Message::Url::Status> values

=over 4

=item B<NOT_VISITED>

This constant has a value of 1.

=item B<VISITED>

This constant has a value of 2.

=item B<IGNORED>

This constant has a value of 3.

=item B<TIMED_OUT>

This constant has a value of 4.

=item B<ERROR>

This constant has a value of 5.

=item B<SUSPICIOUS>

This constant has a value of 6.


=back

=head1 HoneyClient::Message::Url Constructor

=over 4

=item B<$Url = HoneyClient::Message::Url-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Url>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Url Methods

=over 4

=item B<$Url2-E<gt>copy_from($Url1)>

Copies the contents of C<Url1> into C<Url2>.
C<Url2> is another instance of the same message type.

=item B<$Url2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Url2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Url2-E<gt>merge_from($Url1)>

Merges the contents of C<Url1> into C<Url2>.
C<Url2> is another instance of the same message type.

=item B<$Url2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Url2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Url-E<gt>clear()>

Clears the contents of C<Url>.

=item B<$init = $Url-E<gt>is_initialized()>

Returns 1 if C<Url> has been initialized with data.

=item B<$errstr = $Url-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Url-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Url>.

=item B<$dstr = $Url-E<gt>debug_string()>

Returns a string representation of C<Url>.

=item B<$dstr = $Url-E<gt>short_debug_string()>

Returns a short string representation of C<Url>.

=item B<$ok = $Url-E<gt>unpack($string)>

Attempts to parse C<string> into C<Url>, returning 1 on success and 0 on failure.

=item B<$string = $Url-E<gt>pack()>

Serializes C<Url> into C<string>.

=item B<$length = $Url-E<gt>length()>

Returns the serialized length of C<Url>.

=item B<@fields = $Url-E<gt>fields()>

Returns the defined fields of C<Url>.

=item B<$hashref = $Url-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_name = $Url-E<gt>has_name()>

Returns 1 if the C<name> element of C<Url> is set, 0 otherwise.

=item B<$Url-E<gt>clear_name()>

Clears the C<name> element(s) of C<Url>.

=item B<$name = $Url-E<gt>name()>

Returns C<name> from C<Url>.  C<name> will be a string.

=item B<$Url-E<gt>set_name($value)>

Sets the value of C<name> in C<Url> to C<value>.  C<value> must be a string.

=item B<$has_status = $Url-E<gt>has_status()>

Returns 1 if the C<status> element of C<Url> is set, 0 otherwise.

=item B<$Url-E<gt>clear_status()>

Clears the C<status> element(s) of C<Url>.

=item B<$status = $Url-E<gt>status()>

Returns C<status> from C<Url>.  C<status> will be a value of HoneyClient::Message::Url::Status.

=item B<$Url-E<gt>set_status($value)>

Sets the value of C<status> in C<Url> to C<value>.  C<value> must be a value of HoneyClient::Message::Url::Status.

=item B<$has_client = $Url-E<gt>has_client()>

Returns 1 if the C<client> element of C<Url> is set, 0 otherwise.

=item B<$Url-E<gt>clear_client()>

Clears the C<client> element(s) of C<Url>.

=item B<$client = $Url-E<gt>client()>

Returns C<client> from C<Url>.  C<client> will be an instance of HoneyClient::Message::Client.

=item B<$Url-E<gt>set_client($value)>

Sets the value of C<client> in C<Url> to C<value>.  C<value> must be an instance of HoneyClient::Message::Client.

=item B<$has_fingerprint = $Url-E<gt>has_fingerprint()>

Returns 1 if the C<fingerprint> element of C<Url> is set, 0 otherwise.

=item B<$Url-E<gt>clear_fingerprint()>

Clears the C<fingerprint> element(s) of C<Url>.

=item B<$fingerprint = $Url-E<gt>fingerprint()>

Returns C<fingerprint> from C<Url>.  C<fingerprint> will be an instance of HoneyClient::Message::Fingerprint.

=item B<$Url-E<gt>set_fingerprint($value)>

Sets the value of C<fingerprint> in C<Url> to C<value>.  C<value> must be an instance of HoneyClient::Message::Fingerprint.


=back

=head1 HoneyClient::Message::Job Constructor

=over 4

=item B<$Job = HoneyClient::Message::Job-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Job>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Job Methods

=over 4

=item B<$Job2-E<gt>copy_from($Job1)>

Copies the contents of C<Job1> into C<Job2>.
C<Job2> is another instance of the same message type.

=item B<$Job2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Job2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Job2-E<gt>merge_from($Job1)>

Merges the contents of C<Job1> into C<Job2>.
C<Job2> is another instance of the same message type.

=item B<$Job2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Job2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Job-E<gt>clear()>

Clears the contents of C<Job>.

=item B<$init = $Job-E<gt>is_initialized()>

Returns 1 if C<Job> has been initialized with data.

=item B<$errstr = $Job-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Job-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Job>.

=item B<$dstr = $Job-E<gt>debug_string()>

Returns a string representation of C<Job>.

=item B<$dstr = $Job-E<gt>short_debug_string()>

Returns a short string representation of C<Job>.

=item B<$ok = $Job-E<gt>unpack($string)>

Attempts to parse C<string> into C<Job>, returning 1 on success and 0 on failure.

=item B<$string = $Job-E<gt>pack()>

Serializes C<Job> into C<string>.

=item B<$length = $Job-E<gt>length()>

Returns the serialized length of C<Job>.

=item B<@fields = $Job-E<gt>fields()>

Returns the defined fields of C<Job>.

=item B<$hashref = $Job-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.

=item B<$has_uuid = $Job-E<gt>has_uuid()>

Returns 1 if the C<uuid> element of C<Job> is set, 0 otherwise.

=item B<$Job-E<gt>clear_uuid()>

Clears the C<uuid> element(s) of C<Job>.

=item B<$uuid = $Job-E<gt>uuid()>

Returns C<uuid> from C<Job>.  C<uuid> will be a string.

=item B<$Job-E<gt>set_uuid($value)>

Sets the value of C<uuid> in C<Job> to C<value>.  C<value> must be a string.

=item B<$has_created_at = $Job-E<gt>has_created_at()>

Returns 1 if the C<created_at> element of C<Job> is set, 0 otherwise.

=item B<$Job-E<gt>clear_created_at()>

Clears the C<created_at> element(s) of C<Job>.

=item B<$created_at = $Job-E<gt>created_at()>

Returns C<created_at> from C<Job>.  C<created_at> will be a string.

=item B<$Job-E<gt>set_created_at($value)>

Sets the value of C<created_at> in C<Job> to C<value>.  C<value> must be a string.

=item B<$has_completed_at = $Job-E<gt>has_completed_at()>

Returns 1 if the C<completed_at> element of C<Job> is set, 0 otherwise.

=item B<$Job-E<gt>clear_completed_at()>

Clears the C<completed_at> element(s) of C<Job>.

=item B<$completed_at = $Job-E<gt>completed_at()>

Returns C<completed_at> from C<Job>.  C<completed_at> will be a string.

=item B<$Job-E<gt>set_completed_at($value)>

Sets the value of C<completed_at> in C<Job> to C<value>.  C<value> must be a string.

=item B<$has_total_num_urls = $Job-E<gt>has_total_num_urls()>

Returns 1 if the C<total_num_urls> element of C<Job> is set, 0 otherwise.

=item B<$Job-E<gt>clear_total_num_urls()>

Clears the C<total_num_urls> element(s) of C<Job>.

=item B<$total_num_urls = $Job-E<gt>total_num_urls()>

Returns C<total_num_urls> from C<Job>.  C<total_num_urls> will be a 64-bit unsigned integer.

=item B<$Job-E<gt>set_total_num_urls($value)>

Sets the value of C<total_num_urls> in C<Job> to C<value>.  C<value> must be a 64-bit unsigned integer.

=item B<$url_size = $Job-E<gt>url_size()>

Returns the number of C<url> elements present in C<Job>.

=item B<$Job-E<gt>clear_url()>

Clears the C<url> element(s) of C<Job>.

=item B<@url_list = $Job-E<gt>url()>

Returns all values of C<url> in an array.  Each element of C<url_list> will be an instance of HoneyClient::Message::Url.

=item B<$url_elem = $Job-E<gt>url($index)>

Returns C<url> element C<index> from C<Job>.  C<url> will be an instance of HoneyClient::Message::Url, unless C<index> is out of range, in which case it will be undef.

=item B<$Job-E<gt>add_url($value)>

Adds C<value> to the list of C<url> in C<Job>.  C<value> must be an instance of HoneyClient::Message::Url.


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

=head1 HoneyClient::Message::Firewall Constructor

=over 4

=item B<$Firewall = HoneyClient::Message::Firewall-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message::Firewall>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message::Firewall Methods

=over 4

=item B<$Firewall2-E<gt>copy_from($Firewall1)>

Copies the contents of C<Firewall1> into C<Firewall2>.
C<Firewall2> is another instance of the same message type.

=item B<$Firewall2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Firewall2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Firewall2-E<gt>merge_from($Firewall1)>

Merges the contents of C<Firewall1> into C<Firewall2>.
C<Firewall2> is another instance of the same message type.

=item B<$Firewall2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Firewall2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Firewall-E<gt>clear()>

Clears the contents of C<Firewall>.

=item B<$init = $Firewall-E<gt>is_initialized()>

Returns 1 if C<Firewall> has been initialized with data.

=item B<$errstr = $Firewall-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Firewall-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Firewall>.

=item B<$dstr = $Firewall-E<gt>debug_string()>

Returns a string representation of C<Firewall>.

=item B<$dstr = $Firewall-E<gt>short_debug_string()>

Returns a short string representation of C<Firewall>.

=item B<$ok = $Firewall-E<gt>unpack($string)>

Attempts to parse C<string> into C<Firewall>, returning 1 on success and 0 on failure.

=item B<$string = $Firewall-E<gt>pack()>

Serializes C<Firewall> into C<string>.

=item B<$length = $Firewall-E<gt>length()>

Returns the serialized length of C<Firewall>.

=item B<@fields = $Firewall-E<gt>fields()>

Returns the defined fields of C<Firewall>.

=item B<$hashref = $Firewall-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.


=back

=head1 HoneyClient::Message Constructor

=over 4

=item B<$Message = HoneyClient::Message-E<gt>new( [$arg] )>

Constructs an instance of C<HoneyClient::Message>.  If a hashref argument
is supplied, it is copied into the message instance as if
the copy_from() method were called immediately after
construction.  Otherwise, if a scalar argument is supplied,
it is interpreted as a serialized instance of the message
type, and the scalar is parsed to populate the message
fields.  Otherwise, if no argument is supplied, an empty
message instance is constructed.

=back

=head1 HoneyClient::Message Methods

=over 4

=item B<$Message2-E<gt>copy_from($Message1)>

Copies the contents of C<Message1> into C<Message2>.
C<Message2> is another instance of the same message type.

=item B<$Message2-E<gt>copy_from($hashref)>

Copies the contents of C<hashref> into C<Message2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Message2-E<gt>merge_from($Message1)>

Merges the contents of C<Message1> into C<Message2>.
C<Message2> is another instance of the same message type.

=item B<$Message2-E<gt>merge_from($hashref)>

Merges the contents of C<hashref> into C<Message2>.
C<hashref> is a Data::Dumper-style representation of an
instance of the message type.

=item B<$Message-E<gt>clear()>

Clears the contents of C<Message>.

=item B<$init = $Message-E<gt>is_initialized()>

Returns 1 if C<Message> has been initialized with data.

=item B<$errstr = $Message-E<gt>error_string()>

Returns a comma-delimited string of initialization errors.

=item B<$Message-E<gt>discard_unknown_fields()>

Discards unknown fields from C<Message>.

=item B<$dstr = $Message-E<gt>debug_string()>

Returns a string representation of C<Message>.

=item B<$dstr = $Message-E<gt>short_debug_string()>

Returns a short string representation of C<Message>.

=item B<$ok = $Message-E<gt>unpack($string)>

Attempts to parse C<string> into C<Message>, returning 1 on success and 0 on failure.

=item B<$string = $Message-E<gt>pack()>

Serializes C<Message> into C<string>.

=item B<$length = $Message-E<gt>length()>

Returns the serialized length of C<Message>.

=item B<@fields = $Message-E<gt>fields()>

Returns the defined fields of C<Message>.

=item B<$hashref = $Message-E<gt>to_hashref()>

Exports the message to a hashref suitable for use in the
C<copy_from> or C<merge_from> methods.


=back

=head1 AUTHOR

Generated from HoneyClient.Message by the protoc compiler.

=head1 SEE ALSO

http://code.google.com/p/protobuf

=cut

