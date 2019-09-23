setwd("E:/qianlab/project/cellcycle/data/s_transcript/hela/data_from_chuxiao/data_process/20171202/20171204_replicate_early_late/")
# pc <- read.table("E:/qianlab/project/cellcycle/data/s_transcript/hela/data_from_chuxiao/data_process/PCs_phase.txt",header=T)
# no_g1 <- read.table("E:/qianlab/project/cellcycle/data/s_transcript/hela/data_from_chuxiao/data_process/20171202/outliner_g1.txt",header=T)
# pc <- pc[!(pc$Cell %in% no_g1$Cell),]
# s <- subset(pc,PHASE=="S" & PC1 <= 5)
# s <- s[order(-s$PC1),]
# s$time <- c(rep(1,each=46),rep(2:5,each=23),rep(6,each=29))
# g1 <- subset(pc,PHASE=="G1/S")
# g1$time <- c(rep(0,each=length(g1$Cell)))
# g2 <- subset(pc,PHASE=="G2")
# g2$time <- c(rep(7,each=length(g2$Cell)))
# 
# group <- rbind(g1,s,g2)
# #write.table(group,"20171204_HeLa_group_S_phase_6_phase.txt",row.names = F,quote=F,sep="\t")
# group <- read.table("20171204_HeLa_group_S_phase_6_phase.txt",header=T)
# rpm20 <- read.table("E:/qianlab/project/cellcycle/data/s_transcript/hela/data_from_chuxiao/Umi.RPM.meanRPM20.filter.txt",header=T)
# rpm <- as.data.frame(t(rpm20[,2:885]))
# names(rpm) <- rpm20$Gid
# rpm$Cell <- row.names(rpm)
# ##mark cells in 6 subgroup
# rpm1 <- merge(rpm,group,by="Cell")
# rpm <- rpm1
# 
# ####average expression level in each subgroup
# time <- levels(factor(rpm$time))
# mean <- data.frame(gene=names(rpm[,2:4962]),
#                    time0=c(1:4961),time1=c(1:4961),time2=c(1:4961),
#                    time3=c(1:4961),time4=c(1:4961),time5=c(1:4961),
#                    time6=c(1:4961),time7=c(1:4961))
# for (i in 2:(length(time)+1)){
#   mean[i] <- as.numeric(apply(subset(rpm,time==i-2)[,2:4962],2,mean))
# }
# 
# ##normalized by expression level in G1 phase
# mean_normalize <- mean 
# for(i in 2:(length(time)+1)){
#   mean_normalize[1:4961,i] <- log2(mean[1:4961,i]/mean[1:4961,2])
# }
# #write.table(mean_normalize,"20171204_hela_seperate_s_6group_vs_g1.txt",row.name=F,quote=F,sep="\t")

mean_normalize <- read.table("20171204_hela_seperate_s_6group_vs_g1.txt",header=T)
head(mean_normalize)
####define early and late replicating genes
rt <- read.table("E:/qianlab/project/cellcycle/data/hela_RT/hela_mean_rt.txt",header=F)
names(rt) <- c("chr","start","end","sense","Gene","RT")
rt <- rt[order(rt$RT),]

rt$rt_type <- "mid"
rt[1:2000,]$rt_type <- "latest_1000"
rt[15230:17230,]$rt_type <- "earliest_1000"
row.names(rt) <- rt$Gene
library("reshape")
rt <- rename(rt,c("Gene"="gene"))
head(rt)
## exclude S phase specific genes
merge <- merge(mean_normalize,rt,by="gene")
s_specific <- read.table("E:/qianlab/project/cellcycle/data/s_transcript/hela/data_from_chuxiao/data_process/UMI/20171111_PCA_again/gene_specific_cell_cycle_no_filter.txt",header=T)
id <- s_specific$gene[s_specific$cor > 0.3]
merge=merge[!merge$gene %in% id, ]
early <- subset(merge,rt_type=="earliest_1000")
ave_early <- apply(early[,2:(length(time)+1)],2,mean)
late <- subset(merge,rt_type=="latest_1000")
ave_late <- apply(late[,2:(length(time)+1)],2,mean)


ggplot()+geom_line(data=NULL,aes(x=c(0:7),y=ave_early))+ggtitle("2000")+mytheme_violin
ggplot()+geom_line(data=NULL,aes(x=c(0:7),y=ave_late))+ggtitle("2000")+mytheme_violin

p1 <- ggplot()+geom_point(data=NULL,aes(x=c(0:7),y=2^(ave_early-ave_late)*100))+mytheme_violin+
  scale_x_continuous(breaks=c(seq(0,7,by=1)))+ylab("% early vs late")+
  xlab("Phase")#+ggtitle("2000")
p1

p2 <- ggplot()+
  geom_point(data=NULL,aes(x=c(0:7),y=2^(ave_early-ave_late)*100))+
  geom_line(data=NULL,aes(x=c(0:7),y=2^(ave_early-ave_late)*100))+mytheme_violin+
  scale_x_continuous(breaks=c(seq(0,7,by=1)))+ylab("% early vs late")+
  xlab("Phase")#+ggtitle("2000")
p2

#####individual genes
early1 <- early[,2:9]
for(i in 1:length(early[,1])){
  early1[i,] <- 2^(early[i,2:9]-ave_late)*100
}

early1$gene <- early$gene
a <- melt(early1,id.vars="gene")
write.table(a,"20190409_each_early_RT_geneVSlate_mean.txt")
p3 <- ggplot()+geom_boxplot(data=a,aes(x=variable,y=value),outlier.size = 0.2)+
  mytheme_violin+ylim(45,200)+ylab("% early vs late")

p4 <- ggplot()+geom_boxplot(data=a,aes(x=variable,y=value),notch=T,outlier.size = 0.2)+
  mytheme_violin+ylim(45,200)+ylab("% early vs late")
p4
ggplot()+geom_histogram(data=subset(a,variable=="time4"),aes(x=value),binwidth=5)+
  mytheme_violin+xlab("% early vs late")+ylab("# of genes")

ggplot()+geom_density(data=subset(a,variable=="time4"),aes(x=value),binwidth=5)+
  mytheme_violin+xlab("% early vs late")+ylab("# of genes")


median(subset(a,variable=="time4")$value)
mean(subset(a,variable=="time0")$value)
mean(subset(a,variable=="time1")$value)
mean(subset(a,variable=="time2")$value)
mean(subset(a,variable=="time3")$value)
mean(subset(a,variable=="time4")$value)
mean(subset(a,variable=="time5")$value)
mean(subset(a,variable=="time6")$value)
mean(subset(a,variable=="time7")$value)


library("grid")
pdf("20171212_S_6group_23_each_2000.pdf",width=20,height=20,useDingbats = F)
print(p1,vp=viewport(.13,.1,x=.2,y=.7))
print(p2,vp=viewport(.13,.1,x=.4,y=.7))
print(p3,vp=viewport(.13,.1,x=.2,y=.6))
print(p4,vp=viewport(.13,.1,x=.4,y=.6))
dev.off()



combination <- expand.grid(x = early$gene, y = late$gene)
ratio <- data.frame(matrix(c(1:(length(combination$x)*10)),ncol =10))
ratio[,1:2] <- combination[,1:2]

for(i in 1:length(combination$x)){
  ratio[i,3:10] <- 2^(as.numeric(subset(early,gene==combination[i,1])[,2:9])-as.numeric(subset(late,gene==combination[i,2])[,2:9]))
}
head(ratio[,1:5])
names(ratio) <- c("earlyRT","LateRT","time0","time1","time2","time3","time4","time5","time6","time7")
write.table(ratio,"20190409_gene_paire/observe_gene_paire_ratio.txt") 
p <- ggplot()+geom_histogram(data=ratio,aes(x=time4*100),binwidth=8,fill="#4876FF",colour="black",alpha=0.8)+
  mytheme_violin+xlab("% early vs late")+ylab("# of genes")
#xlim(0,260)#+geom_vline(xintercept = median(ratio$time4)*100)
p
ggplot()+geom_histogram(data=ratio,aes(x=log2(time4)),fill="#4876FF",colour="black",binwidth=0.05,alpha=0.8)+
  mytheme_violin+xlab("% early vs late")+ylab("# of genes")

library("grid")
pdf("20190409_gene_paire/20190409_genepaire.pdf",width=20,height=20,useDingbats = F)
print(p,vp=viewport(.12,.1,x=.2,y=.7))
dev.off()

## expression ration of pseudo early- and late-replicating genes
random <- read.table("random_gene/random_EL_replicate_gene_id.txt",header=T)
random$rt_type <- "latest_1000"
random[2001:4000,]$rt_type <- "earliest_1000"
#row.names(rt) <- rt$Gene
library("reshape")
random <- rename(random,c("random_id"="gene"))
head(random)
## exclude s phase specific genes
merge <- merge(mean_normalize,random,by="gene")
early <- subset(merge,rt_type=="earliest_1000")
late <- subset(merge,rt_type=="latest_1000")

combination <- expand.grid(x = early$gene, y = late$gene)
ratio_random <- data.frame(matrix(c(1:(length(combination$x)*10)),ncol =10))
ratio_random[,1:2] <- combination[,1:2]
for(i in 1:length(combination$x)){
  ratio_random[i,3:10] <- 2^(as.numeric(subset(early,gene==combination[i,1])[,2:9])-as.numeric(subset(late,gene==combination[i,2])[,2:9]))
}
head(ratio_random[,1:5])
names(ratio_random) <- c("earlyRT","LateRT","time0","time1","time2","time3","time4","time5","time6","time7")
write.table(ratio_random,"20190409_gene_paire/random_gene_paire_ratio.txt") 

ggplot()+geom_histogram(data=ratio_random,aes(x=time4*100),binwidth=5,fill="#4876FF",colour="black")+
  mytheme_violin+xlab("% early vs late")+ylab("# of genes")
median(ratio_random$time4)


ggplot()+geom_density(data=ratio,aes(x=time4*100),binwidth=5,fill="#4876FF",colour="black",alpha=0.5)+
  mytheme_violin+xlab("% early vs late")+ylab("# of genes")+
  geom_density(data=ratio_random,aes(x=time4*100),binwidth=5,fill="#EEB422",colour="black",alpha=0.5)+
  xlim(0,200)
