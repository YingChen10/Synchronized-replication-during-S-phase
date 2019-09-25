setwd("~/projects/cellcycle/cx_rt/20180708_cell_lineage/20190919_signif_sd_change")
# input all cell lines' cx sd 
cx_sd <- read.table("~/projects/cellcycle/cx_rt/20180708_cell_lineage/20190919_rt_normalize/cx_sd_all_line_zscore_normalize.txt")
head(cx_sd)
# mark cell type (slow or faste)
cell_type <-  data.frame(cell=unique(cx_sd$cell),
                         type1=c(rep("fast",time=3),rep("slow",time=6),
                         rep("fast",time=3),rep("slow",time=2),rep("fast",time=5)),
                         type=c(rep("ESC",time=3),rep("Diff",time=6),
                                rep("ESC",time=3),rep("Diff",time=2),rep("Cancer",time=5)))
cell_type
write.table(cell_type,"cell_type.txt")
# merge cx sd and cell type
all <- merge(cx_sd,cell_type,by="cell")
head(all)
all <- subset(all,cell != "H9_Mesothelial")
all <- subset(all,cell != "H9_Smooth_Muscle")
all <- subset(all,cell != "HCT116_Epithelial_cells_from_colon_carcinoma")
unique(all$cell)
# compare cx sd between slow- and fast- growing cells
#all <- na.omit(all)
com <- unique(all$Complex)
## creat a data frame to store the result of wilcox.test
compare <- data.frame(matrix(c(1:(length(unique(all$Complex))*6)),ncol=6))
names(compare) <- c("cx","EDpvalue","DCpvalue","esc_mean","diff_mean","cancer_mean")
compare$cx <- com
for (i in 1:length(com)){
  if(sum(is.na(all$sd[all$Complex==com[i] & all$type=="ESC"])) < 6 & 
     sum(is.na(all$sd[all$Complex==com[i] & all$type=="Diff"])) < 6 & 
     sum(is.na(all$sd[all$Complex==com[i] & all$type=="Cancer"])) < 4)
  {compare$EDpvalue[i] <- wilcox.test(all$sd[all$Complex==com[i] & all$type=="ESC"],
                                   all$sd[all$Complex==com[i] & all$type=="Diff"])$p.value
  compare$DCpvalue[i] <- wilcox.test(all$sd[all$Complex==com[i] & all$type=="Cancer"],
                                   all$sd[all$Complex==com[i] & all$type=="Diff"])$p.value
  compare$esc_mean[i] <- mean(all$sd[all$Complex==com[i] & all$type=="ESC"])
  compare$diff_mean[i] <- mean(all$sd[all$Complex==com[i] & all$type=="Diff"])
  compare$cancer_mean[i] <- mean(all$sd[all$Complex==com[i] & all$type=="Cancer"])
  }
}
write.table(compare,"cx_sd_compare_among_cell_no_MeSM.txt")
## # of cx sd in diff > sd in esc
length(compare$cx[compare$EDpvalue < 0.05 & compare$diff_mean > compare$esc_mean])
#276
## # of cx sd in diff > sd in cancer
length(compare$cx[compare$DCpvalue < 0.05 & compare$diff_mean > compare$cancer_mean])
#171
## # of cx sd in diff > sd in cancer and sd in diff > sd in esc
length(compare$cx[compare$DCpvalue < 0.05 & compare$diff_mean > compare$cancer_mean &
                    compare$EDpvalue < 0.05 & compare$diff_mean > compare$esc_mean])

#109