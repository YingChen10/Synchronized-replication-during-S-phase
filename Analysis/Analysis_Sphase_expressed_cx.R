setwd("~/projects/cellcycle/20180201_schela")
## cell phase in cell cycle
pc <- read.table("PCs_phase.txt",header=T)
head(pc)
s <- subset(pc,PHASE=="S" & PC1 <= 5)
head(s)
cell <- read.table("Cell_phase.txt",header=T,sep="\t")
head(cell)
pc1 <- merge(pc,select(cell,Cell,Bc),by="Cell")
head(pc1)
#subset cells in S phase
s <- filter(pc1,PHASE=="S" & PC1 <= 5)
head(s)
# input UMI data
umi <- read.table("Umi.counts.allgenes.csv",header=T,sep=",")
names(umi[,1:6])

umi_convert <- as.data.frame(t(umi[,2:885]))
head(umi_convert[,1:6])
names(umi_convert) <- umi$X
umi_convert$Bc <- row.names(umi_convert)

s_umi <- merge(s,umi_convert,by="Bc")
head(s_umi[,1:6])
## count # of cell not detect the transcription of the gene
cellnum <- vector(length=33690)
for(i in 5:33695){
  cellnum[i-4] <- sum(s_umi[,i]==0)
}
## the # of cells with the gene expressed
num <- data.frame(gene=names(umi_convert[,5:33695]),num=cellnum)
head(num)

# # of gene with more than half of cell express
length(num$gene[num$num < 83])

## input cx file
cx <- read.table("~/projects/cellcycle/ALL/human_cx_subunit_info.txt",sep="\t")
head(cx)
names(cx) <- c("cx","name","id","chr","start","end")
id <- read.table("20190818_cx_not_expr_in_Sphase/id.txt",sep="\t",header=T)
head(id)
length(unique(cx$cx))
cx_id <- merge(cx,id,by.x="name",by.y="symbol")
head(cx_id)


cx_expr <- merge(cx_id,num,by.x="ensembl_gene_id",by.y="gene")
head(cx_expr)
## calaulate cx size
cx_size <- cx_id %>% group_by(cx) %>% summarise(size=length(name))
head(cx_size)
## # of subunits expressed in each cx
cx_expr_num <- filter(cx_expr,num < 83) %>% group_by(cx) %>% summarise(expr_size=length(name))
head(cx_expr_num)

cx_expr_size <- merge(cx_size,cx_expr_num,by="cx",all.x=T)
cx_expr_size$expr_size[is.na(cx_expr_size$expr_size)] <- 0

## input hela gene replication timing file
rt <- read.table("~/projects/cellcycle/cx_rt/20180708_cell_lineage/RT_HeLaS3_Cervical_Carcinoma_Int95117837/all_gene_mean_rt.txt")
head(rt)
names(rt) <- c("chr","start","end","sense","gene","name","rt")
## calculate sd of each cx
cx_rt <- merge(cx,rt,by="name")
cx_sd <- cx_rt %>% group_by(cx) %>% summarise(sd=sd(rt))

## merge cx_sd and cx_expression # of subunits
cx_sd_expr <- merge(cx_sd,cx_expr_size,by="cx")
head(cx_sd_expr)
cx_sd_expr$expr <- "no"
## cx with >2/3 subunits expressed are defined as expressed cx
cx_sd_expr$expr[cx_sd_expr$expr_size >= cx_sd_expr$size*(2/3)] <- "expr"
sum(cx_sd_expr$expr=="expr")
sum(cx_sd_expr$expr=="no")
#write.table(cx_sd_expr,"20190818_cx_not_expr_in_Sphase/20190820_cx_expr_sd.txt")
cx_sd_expr <- read.table("20190818_cx_not_expr_in_Sphase/20190820_cx_expr_sd.txt")
p <- ggplot()+geom_boxplot(data=cx_sd_expr,aes(x=expr,y=sd),notch = T)+theme_bw()+
  ylab("Standard deviation of replication timing within a protein complex")+
  xlab("Expressed in the S phase of HeLa cells?") +
  annotate("text", x=-Inf, y=Inf, label=signif(t.test(cx_sd_expr$sd[cx_sd_expr$expr=="expr"],
                                                      cx_sd_expr$sd[cx_sd_expr$expr=="no"])$p.value,digit=2),hjust=-.2, vjust=2)+
  annotate("text", x=-Inf, y=Inf, label=sum(cx_sd_expr$expr=="expr"),hjust=-.2, vjust=4)+
  annotate("text", x=-Inf, y=Inf, label=(sum(cx_sd_expr$expr=="no")+12),hjust=-.2, vjust=6)+mytheme_density1
p

p1 <- ggplot()+geom_boxplot(data=cx_sd_expr,aes(x=expr,y=sd))+theme_bw()+
  ylab("Standard deviation of replication timing within a protein complex")+
  xlab("Expressed in the S phase of HeLa cells?") +
  annotate("text", x=-Inf, y=Inf, label=signif(t.test(cx_sd_expr$sd[cx_sd_expr$expr=="expr"],
                                                      cx_sd_expr$sd[cx_sd_expr$expr=="no"])$p.value,digit=2),hjust=-.2, vjust=2)+
  annotate("text", x=-Inf, y=Inf, label=sum(cx_sd_expr$expr=="expr"),hjust=-.2, vjust=4)+
  annotate("text", x=-Inf, y=Inf, label=(sum(cx_sd_expr$expr=="no")+12),hjust=-.2, vjust=6)+mytheme_density1
p1
library("grid")
pdf("20190818_cx_not_expr_in_Sphase/20190819_expr_cx_Sphase.pdf",width=20,height=20,useDingbats = F)
print(p,vp=viewport(.1,.1,x=.3,y=.6))
print(p1,vp=viewport(.1,.1,x=.5,y=.6))
dev.off()

expr_median <- median(cx_sd_expr$sd[cx_sd_expr$expr=="expr"],na.rm = T)
noexpr_median <- median(cx_sd_expr$sd[cx_sd_expr$expr=="no"],na.rm = T)

mytheme_density1 <-  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(axis.text.x = element_text(colour="black", size=8))+
  theme(axis.text.y = element_text(colour="black", size=8))+
  theme(axis.title=element_text(size=8))+
  #theme(plot.title=element_text(size=1.5, lineheight=.9))+
  theme(axis.ticks=element_line(colour="black",size=0.25),axis.ticks.length=unit(.2,"lines"))+
  theme(legend.title=element_text(size=8))+
  theme(legend.text=element_text(size=8))


