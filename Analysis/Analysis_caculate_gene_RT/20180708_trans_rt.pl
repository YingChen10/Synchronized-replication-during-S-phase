use strict;
use warnings;
my %s;my %e;my %rt;
my $in=shift;
open(IN,$in);
while(my $line=<IN>){
	chomp $line;
	my @line=split /\t/,$line;
	my $k="$line[0]\t$line[1]";
	$s{$k}=$line[1];
	$e{$k}=$line[2];
	$line[3]=~s/\s+//g;
	$rt{$k}=$line[3];
}
close IN;
my $m;my %note;my %n;my %info;my $key;
sub n{
##$m="$s{$_}:$e{$_}:$note{$_}";
if($n{$key}){$n{$key}=join ";",$n{$key},$m;}
else{$n{$key}=$m;}
}
my $in1=shift;
open (IN,$in1);
while(my $line=<IN>){
	chomp $line;
	my @line=split /\t/,$line;
	$key=$line[5];
	$info{$line[5]}=$line;
	foreach(sort keys %s){
		if ($s{$_} >= $line[1] && $e{$_} <= $line[2]){$note{$_}="in";$m="$s{$_}:$e{$_}:$rt{$_}:$note{$_}";&n;}
		elsif ($s{$_} <= $line[2] && $e{$_} >= $line[2]){$note{$_}="out";$m="$s{$_}:$e{$_}:$rt{$_}:$note{$_}";&n;}
		elsif ($s{$_} <= $line[1] && $e{$_} >= $line[1]){$note{$_}="out";$m="$s{$_}:$e{$_}:$rt{$_}:$note{$_}";&n;}
	}
}
close IN;
foreach(sort keys %info){
	if ($n{$_}){print "$info{$_}\t$n{$_}\n";}
}
