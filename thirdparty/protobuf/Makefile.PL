use ExtUtils::MakeMaker;

$CC = 'g++';

# Generate the C++, XS, and Perl files that we need.

my $protoxs = "protoxs --cpp_out=. --out=. message.proto";

print "Generating C++ and Perl/XS sources...\n";
print "$protoxs\n";

`$protoxs`;

# Now write the Makefile.

WriteMakefile(
	      'NAME'	      => 'HoneyClient::Message',
	      'VERSION_FROM'  => 'Message.pm',
	      'OPTIMIZE'      => '-O2 -Wall',
              'CC'            => $CC,
              'LD'            => '$(CC)',
              'CCFLAGS'       => '-fno-strict-aliasing',
	      'OBJECT'        => 'message.pb.o Message.o',
	      'TYPEMAPS'      => ['Message.typemap'],
              'INC'           =>  " -I/usr/local/include",
	      'LIBS'          => [" -L/usr/local/lib -lprotobuf"],
              'XSOPT'         => '-C++',
	      clean           => { FILES => "Message.* message.pb.* lib" }
	     );
