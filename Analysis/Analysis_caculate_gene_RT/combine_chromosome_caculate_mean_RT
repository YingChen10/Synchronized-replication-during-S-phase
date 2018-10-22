cat $1/chr/*trans_rt.txt > $1/all_gene_rt.txt
perl  ~/projects/cellcycle/bin/20180622_human_rt_ensembl/trans_mean_rt2.pl $1/all_gene_rt.txt > $1/all_gene_mean_rt.txt
cut -f5,6,7 ./$1/all_gene_mean_rt.txt > ./$1/1.txt
sed "s/ENSG0000/$1\tENSG0000/g" ./$1/1.txt > ./$1/$1_rt1.txt

