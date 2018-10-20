library(tidyverse)

setwd("E:/qianlab/project/cellcycle/data/human/20180514_dif_line_cx_sd/20180708_expression_cluster/")
all <- read.table("all_expr.txt",header=T)
## average RPKM among replicates of each cell type
cell <- names(all)[2:length(all[1,])]
cell1 <- sub("_R\\d+","",cell)
sample <- unique(cell1)
length(sample)
b <- all[,1:length(sample)]
names(b) <- sample
for(i in 1:length(sample)){
  b[,i] <- all %>%
    select(contains(sample[i])) %>%
    apply(1,mean)
}
b$ID <- all$X.Sample_title

## convert probe id to gene id
id <- read.table("GPL10558-50081_no_header.txt",header=T,sep="\t",quote="", comment.char='')
all <- merge(select(id,ID,Symbol),b,by="ID")
write.table(all,"total_cell_gene_expr.txt")

## subset differentiation cell and ESC cell
sub_all <- select(all,contains("ID"),contains("Symbol"),contains("Liver"),contains("Panc"),contains("ESC"))

library(reshape2)
convert <- melt(sub_all, id.vars=c("ID","Symbol"), variable.name="cell", value.name="RPKM")
## average RPKM of each gene
mean <- convert %>% group_by(cell,Symbol) %>%summarise(mean=mean(RPKM))
## complex infomation file
complex <- read.table("E:/common_data/human_cx_subunit_info.txt",sep="\t")
names(complex) <- c("COM","Symbol","id","chr","s","e")
## caculate sd(log2(RPKM)) of each complex for each cell type 
cx <- merge(complex[,1:2],mean,by="Symbol")
cx$mean <- log2(cx$mean)
sd <- cx %>% group_by(cell,COM) %>% summarise(sd=sd(mean))
sd_median <- sd %>% group_by(cell) %>% summarise(sd_median=median(sd,na.rm=TRUE))

cx_gene_no <- data.frame(Symbol=unique(complex$Symbol),no=c(1:length(unique(complex$Symbol))))
cx_no <- merge(complex,cx_gene_no,by="Symbol")
## shuffle among complex coding genes 1000 times
shuffle_median <- data.frame(matrix(c(1:9000), ncol = 9))
names(shuffle_median) <- c("Time",as.character(sd_median$cell))
for (i in 1:1000){
  random <- sample(unique(complex$Symbol),size=length(unique(complex$Symbol)),replace=F)
  random_cx_no <- data.frame(Ran_symbol=random,no=c(1:length(random)))
  complex_random <- merge(cx_no,random_cx_no,by="no") 
  complex_random$Symbol <- complex_random$Ran_symbol
  cx <- merge(complex_random[,2:3],mean,by="Symbol")
  cx$mean <- log2(cx$mean)
  sd <- cx %>% group_by(cell,COM) %>% summarise(sd=sd(mean))
  shuffle_median[i,-1] <- as.data.frame(sd %>% 
                                        group_by(cell) %>%
                                        summarise(sd_median=median(sd,na.rm=TRUE)))[,2]
}
shuffle_convert <- melt(shuffle_median, id.vars="Time", variable.name="cell", value.name="shuffle_median")
a <- merge(sd_median,shuffle_convert,by="cell")
write.table(a,"20181020_expe_cx_sd_shuffle.txt")

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

