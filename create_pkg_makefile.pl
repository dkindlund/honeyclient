#!/usr/bin/perl

# $Id$

# Remember to add $name to this, or else it will not work
use warnings;
use strict;

use File::Spec 0.82;
use lib File::Spec->catdir('lib');
use lib File::Spec->catdir('t','lib');
use File::Find;

my %requires;
my $package;
my $name = $ARGV[0];
open(FILE,'>Makefile.PL');

sub process{
	if( /\.pm$/ ){
		open TEMP, "<", $_;
		foreach (grep( /^use /, <TEMP> )){
			my @elements = split;
			my $name = $elements[1];
			unless( $name =~ /strict|warnings|\d\.\d+|$package/ ){
				$name =~ s/;//;
				my $version = 
					(/(\b[\d\.]+)\b/) && 
					(!defined($requires{$name}) ||
					 $requires{$name} == 0) ?    
					"$1":0;   
				$requires{$name} = $version;
			}
		}
	}
}

sub get_dependencies{
    $package = shift;
	find(\&process,'lib');
    foreach( sort keys %requires){
        printf FILE "requires\t'%s' => '%s';\n",$_,$requires{$_};
    }
}

my @name = split(/-/,$name);

print   FILE "# Load the Module::Install bundled in ./inc/\n";
printf  FILE "%s;\n\n","use inc::Module::Install";
print   FILE "# Define metadata\n";
printf  FILE "%s\t\t'%s';\n","name",join("-",@name);
print   FILE "license\t\t'gpl';\n";
print   FILE "perl_version\t'5.006';\n";
print   FILE "author\t\t'MITRE Honeyclient Project <honeyclient\@mitre.org>';\n";


my $file = 'lib/'.join("/",@name).'.pm';
if( -f $file ){
    printf  FILE "%s\t\t'%s';\n","all_from",'lib/'.join("/",@name).'.pm';
}else{
    print   FILE "version\t\t'0.01';\n";
}
print   FILE "clean_files\t't/';\n";
print   FILE "\n";
get_dependencies(join("::",@name));
print   FILE "\n";
print   FILE "no_index\t'directory' => 'etc';\n";
print   FILE "no_index\t'directory' => 'inc';\n";
print   FILE "no_index\t'directory' => 'thirdparty';\n";
print   FILE "\n";
print   FILE "auto_install;\n";
print   FILE "WriteAll;\n";

