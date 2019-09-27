PvalueSyncRep <- read.table("PvalueSyncRepz-transformation.txt")
PvalueSyncRep

## plot
sample <- unique(cx_rt$cell)
sample <- names(shuffle_median[,1:19])
rank <- 0
pdf("20190919_rt_zscore_normlize_shuffle1000times.pdf",useDingbats = F)
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
