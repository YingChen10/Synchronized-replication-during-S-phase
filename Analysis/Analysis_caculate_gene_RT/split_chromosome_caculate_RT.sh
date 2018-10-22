 mkdir $1
 mkdir $1/chr
 awk -F "\t" '$1~/chrY$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chrY_RT.txt
 awk -F "\t" '$1~/chr1$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr1_RT.txt
 awk -F "\t" '$1~/chr2$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr2_RT.txt
 awk -F "\t" '$1~/chr3$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr3_RT.txt
 awk -F "\t" '$1~/chr4$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr4_RT.txt
 awk -F "\t" '$1~/chr5$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr5_RT.txt
 awk -F "\t" '$1~/chr6$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr6_RT.txt
 awk -F "\t" '$1~/chr7$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr7_RT.txt
 awk -F "\t" '$1~/chr8$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr8_RT.txt
 awk -F "\t" '$1~/chr9$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr9_RT.txt
 awk -F "\t" '$1~/chr10$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr10_RT.txt
 awk -F "\t" '$1~/chr11$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr11_RT.txt
 awk -F "\t" '$1~/chr12$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr12_RT.txt
 awk -F "\t" '$1~/chr13$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr13_RT.txt
 awk -F "\t" '$1~/chr14$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr14_RT.txt
 awk -F "\t" '$1~/chr15$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr15_RT.txt
 awk -F "\t" '$1~/chr16$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr16_RT.txt
 awk -F "\t" '$1~/chr17$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr17_RT.txt
 awk -F "\t" '$1~/chr18$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr18_RT.txt
 awk -F "\t" '$1~/chr19$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr19_RT.txt
 awk -F "\t" '$1~/chr20$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr20_RT.txt
 awk -F "\t" '$1~/chr21$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr21_RT.txt
 awk -F "\t" '$1~/chr22$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chr22_RT.txt
 awk -F "\t" '$1~/chrX$/' ./$1_hg38.bedgraph > ./$1/chr/RT_RCH_chrX_RT.txt

perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chrY_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chrY.txt > ./$1/chr/chrY_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chrX_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chrX.txt > ./$1/chr/chrX_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr1_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr1.txt > ./$1/chr/chr1_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr2_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr2.txt > ./$1/chr/chr2_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr3_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr3.txt > ./$1/chr/chr3_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr4_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr4.txt > ./$1/chr/chr4_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr5_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr5.txt > ./$1/chr/chr5_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr6_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr6.txt > ./$1/chr/chr6_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr7_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr7.txt > ./$1/chr/chr7_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr8_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr8.txt > ./$1/chr/chr8_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr9_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr9.txt > ./$1/chr/chr9_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr10_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr10.txt > ./$1/chr/chr10_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr11_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr11.txt > ./$1/chr/chr11_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr12_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr12.txt > ./$1/chr/chr12_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr13_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr13.txt > ./$1/chr/chr13_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr14_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr14.txt > ./$1/chr/chr14_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr15_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr15.txt > ./$1/chr/chr15_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr16_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr16.txt > ./$1/chr/chr16_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr17_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr17.txt > ./$1/chr/chr17_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr18_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr18.txt > ./$1/chr/chr18_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr19_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr19.txt > ./$1/chr/chr19_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr20_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr20.txt > ./$1/chr/chr20_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr21_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr21.txt > ./$1/chr/chr21_trans_rt.txt&
perl ~/projects/cellcycle/bin/20180708_trans_rt.pl ./$1/chr/RT_RCH_chr22_RT.txt ~/projects/cellcycle/20180426_cx_rt/chr/chr22.txt > ./$1/chr/chr22_trans_rt.txt&

