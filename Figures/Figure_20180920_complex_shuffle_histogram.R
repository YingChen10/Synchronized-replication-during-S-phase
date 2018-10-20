setwd("E:/qianlab/project/cellcycle/data/human/20180514_dif_line_cx_sd/1000_times/")
sd <- read.table("all_random_sd_median_1000times1.txt")
names(sd) <- c("cell","time","sd_median","random_median","shuffle_median",
               "sd_mean","random_mean","shuffle_mean")
sd <- subset(sd,cell !="RT_BG01_ESC_Int49279242")
sd <- subset(sd,cell !="RT_CyT49_Liver_D16_Int81158282")
sd <- subset(sd,cell !="RT_CyT49_Panc_D12_Int56654336")
sd$cell <- gsub("RT_", "",sd$cell)
sd$cell <- gsub("_Int\\w+", "",sd$cell)
sd$cell <- gsub("_Ext\\w+", "",sd$cell)

# sd_convert <- dcast(select(sd,shuffle_median,sd_median), time+ ~ cell, value.var="rt")
# a1 <- select(rt_convert,contains("name"),contains("ESC"),contains("Liver"),contains("Panc"),contains("HeLa"),
#              contains("SK-N-SH"),contains("HepG2"),contains("MCF"))


library("grid")
sample <- levels(as.factor(sd$cell))
rank <- 0
pdf("20180920_cx_sd_32_line_1000_times_shuffle_median_histogram.pdf",useDingbats = F)
for(i in 1:length(sample)){
  if(rank%%16==0){
    grid.newpage()
    rank <- 0
  }
  rank <- rank +1
  print(
    ggplot(subset(sd,cell==sample[i]),
           aes(x=shuffle_median))+geom_histogram(fill="#0072B2",colour="black",binwidth=0.01)+
      mytheme_violin+ggtitle(sample[i])+ylab("Count")+xlab("Median of standard deviation")+
      geom_vline(xintercept = sd$sd_median[sd$cell==sample[i]])+
      annotate("text",x=-Inf,y=Inf,label=
                 signif(
                   length(sd$shuffle_median[sd$cell==sample[i] & sd$shuffle_median < sd$sd_median[sd$cell==sample[i]][1]])/1000,
                   digit=2),hjust=-.2,vjust=2,size=3),
    #vp=viewport(.21,.2,x=(rank %% 3)*0.25+0.2,y=1-(rank %/% 3.1+1)*0.25)
    vp=viewport(.2,.2,x=(rank %% 4)*0.2+0.13,y=1-(rank %/% 4.1+.7)*0.2)
  )
}
dev.off()

