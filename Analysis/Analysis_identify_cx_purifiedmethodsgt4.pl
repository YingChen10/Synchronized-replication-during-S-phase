use warnings;
use strict;
my $in=shift;
open(IN,$in);
while(my $line=<IN>){
	chomp $line;
	my @line=split/\t/,$line;
	next unless($line[2] eq "Human");
	my @l=split /;/,$line[7];
	my $count = ($line[7] =~ s/MI:/MI:/g);
	#print "$line[7]\n";
	if($count >= 4){print "$line\n";} 
}
