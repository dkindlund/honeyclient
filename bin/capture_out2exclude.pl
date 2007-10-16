#!/usr/bin/perl

open(BLA, "/tmp/realtime-changes.txt") or die "Can't open the file\n";

@dump = <BLA>;
close BLA;
%file_hash;
%reg_hash;
%proc_hash;


foreach $line (@dump){

    $line =~ s/"\r\n//g;
    $line =~ s/^\"(.*)/$1/;

    $line =~ s/\\/\\\\/g;
    $line =~ s/\./\\\./g;

    @toks = split("\",\"", $line, 8);
    if($toks[1] eq "file"){
        $file_hash{"+\t$toks[2]\t$toks[4]\t$toks[5]"} = 1;
        
    }
    elsif($toks[1] eq "registry"){
        $reg_hash{"+\t$toks[2]\t$toks[4]\t$toks[5]"} = 1;
    }
    elsif($toks[1] eq "process"){
        $toks[6] =~ s/\\\./\./g;
        @junk = split(/\\/, $toks[6]);
        $last = pop @junk;
        $proc_hash{"+\t$last\t.*\t$toks[6]"} = 1;
    }

}

open(FILE, ">file_ex.txt");
open(REG, ">reg_ex.txt");
open(PROC, ">proc_ex.txt");

print FILE "#### HONEYCLIENT AUTO EXCLUDE SCRIPT\r\n";
print PROC "#### HONEYCLIENT AUTO EXCLUDE SCRIPT\r\n";
print REG "#### HONEYCLIENT AUTO EXCLUDE SCRIPT\r\n";

foreach $key (keys %file_hash){
    print "$key\n";
    print FILE "$key\r\n";
}
foreach $key (keys %reg_hash){
    print "$key\n";
    print REG "$key\r\n";
}
foreach $key (keys %proc_hash){
    print "$key\n";
    print PROC "$key\r\n";
}
close FILE;
close REG;
close PROC;

