setwd("/Dell/Dell6/cheny/projects/cellcycle/cx_rt/20180708_cell_lineage/sd")
## cx file
cx <-  read.table("/Dell/Dell6/cheny/projects/cellcycle/cx_rt/20180429_dif_cell_line_cx_sd/human_cx_subunit_info.txt",sep="\t")
names(cx) <- c("Complex","name","gene","chr","start","end")

## rt file
rt <- read.table("1.txt")
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
##label cx gene 
gene_no <- data.frame(name=levels(as.factor(cx$name)),no=c(1:length(levels(as.factor(cx$name)))))
##add gene no. to cx
cx2 <- merge(cx,gene_no,by="name")
for (i in 1:1000){
## random cx gene from genome
random <- sample(levels(as.factor(rt$name)),size=length(levels(as.factor(cx$name))))
## number random cx gene
random_no <- data.frame(name=random,no=c(1:length(levels(as.factor(cx$name)))))
## pcik out random cx gene RT
random_rt <- rt %>% filter(name %in% random)
## merge random cx gene_no and RT
random_rt_no <- merge(random_rt,random_no,by="name")
## random gene assige to cx
random_cx_rt <- merge(random_rt_no,select(cx2,name,Complex,no),by="no")
## random cx rt SD
random_cx_sd <- as.data.frame(random_cx_rt %>%
  group_by(Complex) %>%
  summarise(sd = sd(rt, na.rm=TRUE)))
sd$random[i] <- median(random_cx_sd$sd,na.rm=T)
sd$random_mean[i] <- mean(random_cx_sd$sd,na.rm=T)
}
for(i in 1:1000){
## shuffle complex coding genes 
shuffle <- sample(levels(as.factor(cx$name)),size=length(levels(as.factor(cx$name))))
## label shuffle cx gene
shuffle_no <- data.frame(name=shuffle,no=c(1:length(levels(as.factor(cx$name)))))
## shuffle cx gene RT
shuffle_rt <- rt %>% filter(name %in% shuffle)
## merge shuffle cx gene_no and RT
shuffle_rt_no <- merge(shuffle_rt,shuffle_no,by="name")
## shuffle gene assige to cx
shuffle_cx_rt <- merge(shuffle_rt_no,select(cx2,name,Complex,no),by="no")
## shuffle cx rt SD
shuffle_cx_sd <- as.data.frame(shuffle_cx_rt %>%
  group_by(Complex) %>%
  summarise(sd = sd(rt, na.rm=TRUE)))
sd$shuffle[i] <- median(shuffle_cx_sd$sd,na.rm=T)
sd$shuffle_mean[i] <- mean(shuffle_cx_sd$sd,na.rm=T)
}
write.table(sd,"random_median.txt",quote=F,sep="\t",row.names=F)
