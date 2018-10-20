setwd("E:/qianlab/project/cellcycle/data/human/20180514_dif_line_cx_sd/20180708_expression_cluster/")
a <- read.table("20181020_expe_cx_sd_shuffle.txt",header=T)
library(grid)
sample <- unique(a$cell)
rank <- 0
pdf("20181020_cx_expr_sd_histogram.pdf",useDingbats = F)
for(i in 1:length(unique(a$cell))){
  if(rank%%16==0){
    grid.newpage()
    rank <- 0
  }
  rank <- rank +1
  print(
    ggplot(subset(a,cell==sample[i]),
           aes(x=shuffle_median))+geom_histogram(fill="#0072B2",colour="black",binwidth=0.01)+
      mytheme_violin+ggtitle(sample[i])+ylab("Count")+xlab("Median of standard deviation")+
      geom_vline(xintercept = a$sd_median[a$cell==sample[i]])+
      annotate("text",x=-Inf,y=Inf,label=
                 signif(
                   length(a$shuffle_median[a$cell==sample[i] & a$shuffle_median < a$sd_median[a$cell==sample[i]][1]])/1000,
                   digit=2),hjust=-.2,vjust=2,size=3),
    #vp=viewport(.21,.2,x=(rank %% 3)*0.25+0.2,y=1-(rank %/% 3.1+1)*0.25)
    vp=viewport(.2,.2,x=(rank %% 4)*0.2+0.13,y=1-(rank %/% 4.1+.7)*0.2)
  )
}
dev.off()