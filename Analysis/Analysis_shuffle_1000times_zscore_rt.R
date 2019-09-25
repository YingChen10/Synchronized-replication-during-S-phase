setwd("~/projects/cellcycle/cx_rt/20180708_cell_lineage/20190919_rt_normalize")
## cx file
cx <-  read.table("/Dell/Dell6/cheny/projects/cellcycle/cx_rt/20180429_dif_cell_line_cx_sd/human_cx_subunit_info.txt",sep="\t")
names(cx) <- c("Complex","name","gene","chr","start","end")
library("dplyr")
unique(cx$Complex)
## rt normalized by z-transformating
rt <- read.table("20190919_rt_zscore_normalize.txt",head=T)
head(rt)

cx_rt <- merge(cx,rt,by="name")
head(cx_rt)

sample <- unique(cx_rt$cell)
## number cx gene
gene_no <- data.frame(name=unique(cx$name),no=c(1:length(unique(cx$name))))
cx_no <- merge(cx,gene_no,by="name")

## calculate cx rt sd
sd <- as.data.frame(cx_rt) %>% group_by(cell,Complex) %>% summarise(sd = sd(rt, na.rm=TRUE))
write.table(sd,"cx_sd_all_line_zscore_normalize.txt")
sd_median <- sd %>% group_by(cell) %>% summarise(median = median(sd,na.rm=T))  

##shuffle cx 
  shuffle_median <- data.frame(matrix(c(1:(19*1000)),nrow=1000))
for(i in 1:1000){
  ## shuffle complex coding genes 
  shuffle <- sample(unique(cx$name),size=length(unique(cx$name)))
  ## label shuffle cx gene
  shuffle_no <- data.frame(name=shuffle,no=c(1:length(unique(cx$name))))
  ## pseudo cx gene RT
  shuffle_rt <- rt %>% filter(name %in% shuffle)
  ## merge shuffle cx gene_no and RT
  shuffle_rt_no <- merge(shuffle_rt,shuffle_no,by="name")
  ## shuffle gene assige to cx
  shuffle_cx_rt <- merge(shuffle_rt_no,select(cx_no,Complex,no),by="no")
  ## shuffle cx rt SD
  shuffle_cx_sd <- as.data.frame(shuffle_cx_rt %>%
                                   group_by(cell,Complex) %>%
                                   summarise(sd = sd(rt, na.rm=TRUE)))
  ## calculate sd median
  shuffle_median[i,] <- as.data.frame(shuffle_cx_sd %>% group_by(cell) %>% summarise(medain = median(sd,na.rm=T)))$medain
}
names(shuffle_median) <-  as.data.frame(shuffle_cx_sd %>% group_by(cell) %>% summarise(medain = median(sd,na.rm=T)))$cell
shuffle_median$time <- c(1:1000)
shuffle_median[1001,] <- c(sd_median$median,"real")
#write.table(shuffle_median,"20190919_zscore_normalize_shuffle_sd.txt")
head(shuffle_median)
shuffle_median <- read.table("20190919_zscore_normalize_shuffle_sd.txt")
##output p value of Synchronized replicationafter z-transformated gene RT
PvalueSyncRep <- data.frame(cell=names(shuffle_median[,1:19]),p=c(1:19))
sample <- names(shuffle_median[,1:19])
for(i in 1:length(sample)){
  PvalueSyncRep$p[i] <- sum(as.numeric(shuffle_median[1:1000,i]) <= as.numeric(shuffle_median[1001,i]))/1000
}
write.table(PvalueSyncRep,"PvalueSyncRepz-transformation.txt")
PvalueSyncRep

## plot
sample <- unique(cx_rt$cell)
sample <- names(shuffle_median[,1:19])
rank <- 0
pdf("20190919_rt_zscore_normlize_shuffle1000times1.pdf",useDingbats = F)
  for(i in 1:length(sample)){
    if(rank%%9==0){
      grid.newpage()
      rank <- 0
    }
    rank <- rank +1
    print(
      ggplot()+geom_histogram(data=subset(shuffle_median,time!="real"),
                              aes(x=as.numeric(shuffle_median[1:1000,i])),fill="#0072B2",colour="black")+
        mytheme_violin+ggtitle(names(shuffle_median)[i])+xlab("Median of SD")+ylab("Count")+
        geom_vline(xintercept = as.numeric(shuffle_median[1001,i]))+
        annotate("text",x=-Inf,y=Inf,label=
                   sum(as.numeric(shuffle_median[1:1000,i]) <= as.numeric(shuffle_median[1001,i]))/1000,hjust=-.2,vjust=2,size=3),
      vp=viewport(.21,.2,x=(rank %% 3)*0.25+0.2,y=1-(rank %/% 3.1+1)*0.25)
    )
}
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

