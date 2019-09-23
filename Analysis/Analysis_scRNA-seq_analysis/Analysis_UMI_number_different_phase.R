setwd("E:/qianlab/project/cellcycle/data/s_transcript/hela/data_from_chuxiao/data_process/")
umi <- read.table("20171202/20171202_HeLa_umi_phase.txt",header=T)
umi$sum <- apply(umi[,4:33697],1,sum)

library(dplyr)
umi1 <- umi %>% group_by(PHASE) %>%
   summarise(umi_num = mean(sum),na.rm=TRUE)

sd <- umi %>% group_by(PHASE) %>%
   summarise(sd = sd(sum),na.rm=TRUE)

cell_num <- umi %>%  group_by(PHASE) %>% summarise(cell_num = length(Bc))

b <- data.frame(Phase=umi1$PHASE,umi=umi1$umi_num/100000,se=sd$sd/sqrt(cell_num$cell_num)/100000)
b

write.table(b,"20180620/cell_phase_umi.txt",row.names=F,quote=F,sep="\t")

b <- read.table("20180620/cell_phase_umi.txt",header=T)
cb_palette <- c("#E69F00", "#56B4E9", "#009E73", "#BF3EFF", "#FF1493","#CC79A7")

p1 <- ggplot(b, aes(x=Phase, y=umi,colour=Phase)) +
  geom_point(size=1.3) +
  geom_errorbar(aes(ymin=umi-se, ymax=umi+se), width=.1)+mytheme_violin+
  scale_color_manual(values=cb_palette)+
  scale_x_discrete(limits=c("M/G1","G1/S","S","G2","G2/M"))+
  ylab("# of mRNA captured\nper cell (x10^5)")+
  xlab("Phase")+ theme(legend.position="none")
p1

library("grid")
pdf("20180620/20180620_umi_num_error_bar2.pdf",width=20,height=20,useDingbats = F)
print(p1,vp=viewport(.11,.05,x=.2,y=.7))
dev.off()
 
