setwd("~/projects/cellcycle/20180201_schela/20190918_DosageBalanceThroughReplicationCycle")
## input expression data in 6 S phase subgroup
mean <- read.table("20190918_sphase_6group_mean_expr.txt",header=T)
## input gene gene name file
id <- read.table("~/projects/cellcycle/20180201_schela/20190818_cx_not_expr_in_Sphase/id.txt",sep="\t",header=T)
head(id)
names(id) <- c("name","ensembl_gene_id","refseq_accession")
mean1 <- merge(id,mean,by.x="ensembl_gene_id",by.y="gene")
head(mean1)
## input cx file
cx <- read.table("~/projects/cellcycle/ALL/human_cx_subunit_info.txt",sep="\t")
head(cx)
names(cx) <- c("cx","name","id","chr","start","end")

mean_cx <- merge(cx,mean1,by="name")

head(mean_cx)
## calculate sd of RT of each cx
S1_expr_sd <- mean_cx[,c(2,3,10)] %>% group_by(cx) %>% summarise(sd=sd(log2(time1+0.1)))
head(S1_expr_sd)

##number cx gene 
gene_no <- data.frame(name=unique(cx$name),no=c(1:length(unique(cx$name))))
##add gene no. to cx
cx2 <- merge(cx,gene_no,by="name")

median <- as.data.frame(matrix(c(1:(1000*6)),ncol=6))
for(i in 1:1000){
## shuffle cx gene from cx coding genes
shuffle <- sample(unique(cx$name),size=length(unique(cx$name)))
## number shuffle cx gene
shuffle_no <- data.frame(name=shuffle,no=c(1:length(unique(cx$name))))
## pcik out shuffle cx gene expr
shuffle_expr <- mean1 %>% filter(name %in% shuffle)
## merge shuffle cx gene_no and expr
shuffle_expr_no <- merge(shuffle_expr,shuffle_no,by="name")
## shuffle gene assige to cx
shuffle_cx_rt <- merge(shuffle_expr_no,select(cx2,cx,no),by="no")
## shuffle cx rt SD
S1_expr_sd <- shuffle_cx_rt %>% group_by(cx) %>% summarise(sd=sd(log2(time1+0.1)))
S2_expr_sd <- shuffle_cx_rt %>% group_by(cx) %>% summarise(sd=sd(log2(time2+0.1)))
S3_expr_sd <- shuffle_cx_rt %>% group_by(cx) %>% summarise(sd=sd(log2(time3+0.1)))
S4_expr_sd <- shuffle_cx_rt %>% group_by(cx) %>% summarise(sd=sd(log2(time4+0.1)))
S5_expr_sd <- shuffle_cx_rt %>% group_by(cx) %>% summarise(sd=sd(log2(time5+0.1)))
S6_expr_sd <- shuffle_cx_rt %>% group_by(cx) %>% summarise(sd=sd(log2(time6+0.1)))

median[i,1] <- median(S1_expr_sd$sd,na.rm=T)
median[i,2] <- median(S2_expr_sd$sd,na.rm=T)
median[i,3] <- median(S3_expr_sd$sd,na.rm=T)
median[i,4] <- median(S4_expr_sd$sd,na.rm=T)
median[i,5] <- median(S5_expr_sd$sd,na.rm=T)
median[i,6] <- median(S6_expr_sd$sd,na.rm=T)
}
names(median) <- c("time1","time2","time3","time4","time5","time6")
median$time <- c(1:1000)
S1_expr_sd <- mean_cx %>% group_by(cx) %>% summarise(sd=sd(log2(time1+0.1)))
S2_expr_sd <- mean_cx %>% group_by(cx) %>% summarise(sd=sd(log2(time2+0.1)))
S3_expr_sd <- mean_cx %>% group_by(cx) %>% summarise(sd=sd(log2(time3+0.1)))
S4_expr_sd <- mean_cx %>% group_by(cx) %>% summarise(sd=sd(log2(time4+0.1)))
S5_expr_sd <- mean_cx %>% group_by(cx) %>% summarise(sd=sd(log2(time5+0.1)))
S6_expr_sd <- mean_cx %>% group_by(cx) %>% summarise(sd=sd(log2(time6+0.1)))
median[1001,] <- c(median(S1_expr_sd$sd,na.rm=T),median(S2_expr_sd$sd,na.rm=T),
                   median(S3_expr_sd$sd,na.rm=T),median(S4_expr_sd$sd,na.rm=T),
                   median(S5_expr_sd$sd,na.rm=T),median(S6_expr_sd$sd,na.rm=T),1001)

write.table(median,"median.txt")
library(reshape2)
median_convert <- melt(median, id.vars="time", variable.name="TimeinS", value.name="expr_sd")
head(median_convert)
median_convert$expr_sd <- as.numeric(median_convert$expr_sd)
median_convert$TimeinS_no <- rep(c(1:6),each=1001)
str(median_convert)
write.table(median_convert,"median_convert.txt")
median_convert$time <- as.numeric(median_convert$time)
p <- ggplot()+geom_line(data=subset(median_convert,time <  1001),aes(x=TimeinS_no,y=expr_sd,colour=as.factor(time)),alpha=0.5)+
  scale_colour_manual(values=c(rep("grey", time=1000))) +
  geom_line(data=subset(median_convert,time==1001),aes(x=TimeinS_no,y=expr_sd),colour="#DC143C")+
  mytheme_density1+theme(legend.position="none")+
  scale_x_continuous(breaks=c(1,2,3,4,5,6))+
  ylab("Medain of SD")
p  
library("grid")
pdf("20190918_cx_expr_sd.pdf",width=20,height=20,useDingbats = F)
print(p,vp=viewport(.2,.1,x=.5,y=.6))
dev.off()  
  
head(median)
str(median)

p1 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time1)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S1_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 1")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time1 <= median(S1_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)

p2 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time2)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S2_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 2")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time2<= median(S2_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)


p3 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time3)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S3_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 3")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time3 <= median(S3_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p3

p4 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time4)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S4_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 4")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time4 <= median(S4_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p4

p5 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time5)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S5_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 5")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time5 <= median(S5_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p5

p6 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time6)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S6_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 6")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time6 <= median(S6_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p6

library("grid")
pdf("20190919_cx_expr_sd_Sphase.pdf",width=20,height=20,useDingbats = F)
print(p1,vp=viewport(.1,.1,x=.2,y=.6))
print(p2,vp=viewport(.1,.1,x=.3,y=.6))
print(p3,vp=viewport(.1,.1,x=.4,y=.6))
print(p4,vp=viewport(.1,.1,x=.5,y=.6))
print(p5,vp=viewport(.1,.1,x=.6,y=.6))
print(p6,vp=viewport(.1,.1,x=.7,y=.6))
dev.off()


mytheme_density1 <-  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(axis.text.x = element_text(colour="black", size=8))+
  theme(axis.text.y = element_text(colour="black", size=8))+
  theme(axis.title=element_text(size=8))+
  #theme(plot.title=element_text(size=1.5, lineheight=.9))+
  theme(axis.ticks=element_line(colour="black",size=0.25),axis.ticks.length=unit(.2,"lines"))+
  theme(legend.title=element_text(size=8))+
  theme(legend.text=element_text(size=8))
