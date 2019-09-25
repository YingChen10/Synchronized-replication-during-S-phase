setwd("/Dell/Dell6/cheny/projects/cellcycle/20180201_schela/20190821_validate_cx/dip_database/")
## cx file
cx <-  read.table("/Dell/Dell6/cheny/projects/cellcycle/20180201_schela/20190821_validate_cx/dip_database/cx_purificationgt4_final.txt",sep="\t",header=T)

unique(cx$Complex)
#cx <- subset(cx,Complex!="TFTC_complex_(TATA-binding_protein-free_TAF-II-containing_complex)"|Complex != "CDK8_subcomplex_(CCNC,_CDK8,_MED12,_MED13)")
head(cx)
names(cx) <- c("Complex","UniProtID","EntrezID","name")
cx_size <- as.data.frame(cx %>% 
                           group_by(Complex) %>%
                           summarise(size = length(name)))## rt file
#rt <- read.table("mean_rt_cx_mark_long_isoform.txt")
rt <- read.table("/Dell/Dell6/cheny/projects/cellcycle/cx_rt/20180708_cell_lineage/RT_HeLaS3_Cervical_Carcinoma_Int95117837/RT_HeLaS3_Cervical_Carcinoma_Int95117837_rt1.txt")
head(rt)

library("dplyr")
## gene name file
names(rt) <- c("cell","gene_id","name","rt")
cell <- unique(rt$cell)
## cx gene rt
cx_rt <- merge(select(cx,Complex,name),rt,by="name")
## calculate sd of each cx
cx_sd <- as.data.frame(cx_rt %>% 
                         group_by(Complex) %>%
                         summarise(sd = sd(rt, na.rm=TRUE)))
cx_median <- median(cx_sd$sd,na.rm=T)
cx_mean  <- mean(cx_sd$sd,na.rm=T) 

sd <- data.frame(cell=rep(cell,time=1000),time=c(1:1000),sd=rep(cx_median,time=1000),random=c(1,1000),shuffle=c(1,1000),
                 sd_mean=rep(cx_mean,time=1000),random_mean=c(1,1000),shuffle_mean=c(1,1000))
##number cx gene 
gene_no <- data.frame(name=unique(cx$name),no=c(1:length(unique(cx$name))))
##add gene no. to cx
cx2 <- merge(cx,gene_no,by="name")

for(i in 1:1000){
  ## shuffle cx gene from cx coding genes
  shuffle <- sample(unique(cx$name),size=length(unique(cx$name)))
  ## number shuffle cx gene
  shuffle_no <- data.frame(name=shuffle,no=c(1:length(unique(cx$name))))
  ## pcik out shuffle cx gene RT
  shuffle_rt <- rt %>% filter(name %in% shuffle)
  ## merge shuffle cx gene_no and RT
  shuffle_rt_no <- merge(shuffle_rt,shuffle_no,by="name")
  ## shuffle gene assige to cx
  shuffle_cx_rt <- merge(shuffle_rt_no,select(cx2,Complex,no),by="no")
  ## shuffle cx rt SD
  shuffle_cx_sd <- as.data.frame(shuffle_cx_rt %>%
                                   group_by(Complex) %>%
                                   summarise(sd = sd(rt, na.rm=TRUE)))
  sd$shuffle[i] <- median(shuffle_cx_sd$sd,na.rm=T)
  sd$shuffle_mean[i] <- mean(shuffle_cx_sd$sd,na.rm=T)
}
# write.table(sd,"random_median_methodgt4.txt",quote=F,sep="\t",row.names=F)
# 
# sd <- read.table("random_median_methodgt4.txt",header=T)
sum(sd$shuffle < sd$sd[1])/1000

p <- ggplot()+geom_histogram(data=sd,aes(x=shuffle),fill="#0072B2",colour="black",binwidth=0.01)+
  geom_vline(xintercept = sd$sd[1],colour="red")+mytheme_violin+
  annotate("text",x=-Inf,y=Inf,label=sum(sd$shuffle < sd$sd[1])/1000,hjust=-.2,vjust=2,size=2,colour="red")+
  xlab("Standard deviation of replication timing")
p
sum(sd$shuffle_mean < sd$sd_mean[1])/1000
p <- ggplot()+geom_histogram(data=sd,aes(x=shuffle_mean),fill="#0072B2",colour="black",binwidth=0.02)+
  geom_vline(xintercept = sd$sd_mean[1],colour="red")+mytheme_violin+
  annotate("text",x=-Inf,y=Inf,label=length(sd$shuffle_mean[sd$shuffle_mean < sd$sd_mean[1]])/1000,hjust=-.2,vjust=2,size=2,colour="red")+
  xlab("Standard deviation of replication timing")
p

library("grid")
pdf("20190821_validate_cx_methodgt4.pdf",width=20,height=20,useDingbats = F)
print(p,vp=viewport(.1,.1,x=.3,y=.6))
dev.off()

library(ggplot2)
mytheme_violin <-  theme_bw()+theme(legend.position="none")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.border = element_rect(colour="black", fill=NA, size=.6))+
  theme(plot.title=element_text(size=8))+
  # theme(axis.text.x = element_text(angle=30, hjust=1, vjust=1))+
  theme(axis.text.x = element_text(colour="black", size=8))+
  theme(axis.text.y = element_text(colour="black", size=8))+
  theme(axis.title=element_text(size=8))+
  #theme(plot.title=element_text(size=rel(1.5), lineheight=.9))+
  theme(axis.ticks=element_line(colour="black",size=0.5))+
  theme(legend.title=element_text(size=8))+
  theme(legend.text=element_text(size=8))
head(sd)

