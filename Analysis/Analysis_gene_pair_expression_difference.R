setwd("~/projects/cellcycle/20180201_schela/20190816_gene_pair_expr_ratio")
## input all possible gene pairs of all rpm > 20 
com <- read.table("gene_pair_combination_unique1.txt")
head(com)

## calculate expression ratio of genes within each pair in 6 S-phase subgroup
ratio <- 2^(com[,2:9]-com[,12:19])
head(ratio)
ratio$gene1 <- com$V1
ratio$gene2 <- com$V11

## calculate cv of expression ration of each gene pair among 6 S-phase subgroup
sd <- apply(ratio[,2:7],1,sd)
mean <- apply(ratio[,2:7],1,mean)

cv <- data.frame(gene1=com$V1,gene2=com$V11,sd=sd,mean=mean,gene1_rt=com$V10,gene2_rt=com$V20)
cv$cv <- cv$sd/cv$mean
write.table(cv,"gene_pair_expr_cv_among_6group.txt",quote=F,sep="\t",row.names=F)

cv <-read.table("gene_pair_expr_cv_among_6group.txt",header=T)
head(cv)
cv$rt_dif <- abs(cv$gene1_rt-cv$gene2_rt)

## mark cv with cutoff median of CV of all gene pairs
cv$category <- "largeCV"
cv$category[cv$cv < median(cv$cv)] <- "smallCV"

#cv$category[cv$cv < 0.17)] <- "smallCV"

levels(cv$category)


ggplot()+geom_boxplot(data=cv,aes(x=category,y=rt_dif))

t.test(cv$rt_dif[cv$category=="largeCV"],cv$rt_dif[cv$category=="smallCV"])

## seperate all gene pairs into 10 group
cv_order <- cv[with(cv, order(cv)), ]

cv_order$cv_rank <- 1
for(i in 1:10){
  cv_order$cv_rank[c((length(cv_order$gene1)/10*(i-1)+1):(length(cv_order$gene1)/10*i))] <- i
}

cv_order$cv_rank <- as.character(cv_order$cv_rank)
write.table(cv_order,"gene_pair_expr_cv_among_6group_rtdif.txt",quote=F,sep="\t",row.names=F)

unique(cv_order$cv_rank)

levels(cv_order$cv_rank)

ggplot(data=subset(cv_order,cv_rank=="1" |cv_rank=="10"),aes(x=cv_rank,y=rt_dif))+
  geom_boxplot(outlier.colour = "white",notch=T)+theme_bw()

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





