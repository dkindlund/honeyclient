use ExtUtils::MakeMaker;

$CC = 'g++';

# Generate the C++, XS, and Perl files that we need.

my $protoxs = "protoxs --cpp_out=. --out=. firewall_command.proto";

print "Generating C++ and Perl/XS sources...\n";
print "$protoxs\n";

`$protoxs`;

# Now write the Makefile.

WriteMakefile(
	      'NAME'	      => 'HoneyClient::Message::Firewall::Command',
	      'VERSION_FROM'  => 'Command.pm',
	      'OPTIMIZE'      => '-O2 -Wall',
              'CC'            => $CC,
              'LD'            => '$(CC)',
              'CCFLAGS'       => '-fno-strict-aliasing',
	      'OBJECT'        => 'firewall_command.pb.o Command.o',
	      'TYPEMAPS'      => ['Command.typemap'],
              'INC'           =>  " -I/usr/local/include",
	      'LIBS'          => [" -L/usr/local/lib -lprotobuf"],
              'XSOPT'         => '-C++',
	      clean           => { FILES => "Command.* firewall_command.pb.* lib" }
	     );
