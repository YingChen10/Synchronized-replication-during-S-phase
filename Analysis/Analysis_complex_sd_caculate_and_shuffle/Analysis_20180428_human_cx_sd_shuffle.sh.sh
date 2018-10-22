cp ../$1/*rt1.txt ./1.txt
Rscript Analysis_20180428_human_cx_sd_shuffle.R
mv random_median.txt ./times_1000/$1\_random_sd_median_1000times.txt
