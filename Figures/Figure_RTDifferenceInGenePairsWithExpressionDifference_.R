cv_order <- read.table("gene_pair_expr_cv_among_6group_rtdif.txt",header=T)
cv_order$cv_rank <- as.character(cv_order$cv_rank)

cv_order$cv_rank1 <- 1
for(i in 1:100){
  cv_order$cv_rank1[c((length(cv_order$gene1)/100*(i-1)+1):(length(cv_order$gene1)/100*i))] <- i
}
cv_order$cv_rank1 <- as.character(cv_order$cv_rank1)
p1 <- ggplot(data=subset(cv_order,cv_rank1=="1" |cv_rank1=="100"),aes(x=cv_rank1,y=rt_dif))+
  geom_boxplot(notch=F,outlier.colour = "white")+theme_bw()+
  ylab("Difference in replication timing between genes within each pair")+
  xlab("CV of expression ratio of genes within each pair among 6 S-phase subgroups")+
  mytheme_density1
p1

p2 <- ggplot(data=subset(cv_order,cv_rank1=="1" |cv_rank1=="100"),aes(x=cv_rank1,y=rt_dif))+
  geom_boxplot(notch=T,outlier.size = 0.2)+theme_bw()+
  ylab("Difference in replication timing between genes within each pair")+
  xlab("CV of expression ratio of genes within each pair among 6 S-phase subgroups")+
  mytheme_density1
p2
wilcox.test(cv_order$rt_dif[cv_order$cv_rank1 == "1"],cv_order$rt_dif[cv_order$cv_rank1 == "100"])
# Wilcoxon rank sum test with continuity correction
# 
# data:  cv_order$rt_dif[cv_order$cv_rank1 == "1"] and cv_order$rt_dif[cv_order$cv_rank1 == "100"]
# W = 3.515e+09, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0
library("grid")
pdf("20190817_genepair_expr_ratio2.pdf",width=20,height=20,useDingbats = F)
print(p1,vp=viewport(.1,.1,x=.3,y=.6))
print(p2,vp=viewport(.1,.1,x=.5,y=.6))
dev.off()
