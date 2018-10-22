use strict;
use warnings;
my %sum;my %mean;
my $in=shift;
open(IN,$in);
while(my $line=<IN>){
	chomp $line;
	my @line=split /\t/,$line;
	my @a=split /;/,$line[6];
	for(my $i=0;$i<=$#a;$i++){
		my @b=split /:/,$a[$i];
		if(defined $sum{$line[5]}){$sum{$line[5]}=$sum{$line[5]}+$b[2];}
		else{$sum{$line[5]}=$b[2];}
	}
	$mean{$line[5]}=$sum{$line[5]}/($#a+1);
	print "$line[0]\t$line[1]\t$line[2]\t$line[3]\t$line[4]\t$line[5]\t$mean{$line[5]}\n";
}
