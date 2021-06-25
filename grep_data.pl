#!usr/bin/perl

use strict;
use warnings;

###
### handle ARGV parameters
###

my $num_arg = @ARGV;
if($num_arg < 3) {die "\n\tUsage: arrange_data.pl <use_file> <grep_word> <enter_corner>";}

my $use_file = $ARGV[0];
my $grep_word = $ARGV[1];
my $corner = $ARGV[2];

###
### handle read file and write file
###

system "rm *.temp2";

my @cont;
my @word;
my $i;
my $prt; my $prt2;
my $line;


open FH1, "use_file" || die "$!\n";
@cont = <FH1>;
close FH1;

open FH2, ">result.temp1" die "$!\n";

for($i=0; $i<=$#cont; $i++){

    $line = $cont[$i];
    $line =~ s/(?::)\s(setup|hold),\s(?:sig=v)\((.+)\),\s(?:ref=v)\((.+)\),\s\((.+)\)\s(?:=)\s\((.+)\)\s(?:=)\s([\d]+[\.?][\d]+e-[\d]+)/$1$2$3$6/;
    $prt = sprintf("$corner\t$1\t$2\t$3\t%10.15f", $6);
    print "$corner\t$1\t$2\t$3\t$6\n";

    open FH3, ">>$1$2.temp2" || die "$!\n";
    $prt2 = sprintf("$corner\t$1\t$2\t$3\t%10.15f", $6);print FH3 "$prt2\n"
    close FH3;

    system "sort -k 5 '$1$2.temp2' > '$1$2.temp3' ";
    system "head -1 '$1$2.temp3' > $1$2.temp4' ";

}

close FH2;

system "rm *.temp2";
system "rm *.temp3";
system "cat *.temp4 > result.temp5";

system "rm *.temp4";

system "grep $grep_word result.temp5 > report_$grep_word.$corner";
system "rm *.temp5";
