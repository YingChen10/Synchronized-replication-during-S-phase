setwd("~/projects/cellcycle/cx_rt/20180708_cell_lineage")
# input RT file   
rt <- read.table("Data_all_line_rt_wide.txt")
# conver width to length
a2 <- melt(rt, id.vars="name", variable.name="cell", value.name="rt")
head(a2)
# plot density curve
p1 <- ggplot()+geom_line(data=a2,
                         aes(x=rt,colour=cell),stat = "density")+mytheme_violin+#mytheme_density1+
  scale_colour_manual(values=c(rep("#CC6666",6), rep("#1E90FF",6),rep("#CC6666",7)))#
p1
# input cel type
cell_type <- read.table("Data_cell_type.txt")
cell_type
cell_type$sy <- c(rep("sy",time=3),rep("nosy",time=6),rep("sy",time=10))
cell_type$sy[cell_type$cell %in% "Liver"] <- "nosy"
a2 <- merge(a2,cell_type,by="cell")
p2 <- ggplot()+geom_line(data=subset(a2,cell !="HCT116_Epithelial_cells_from_colon_carcinoma"),
                            aes(x=rt,colour=cell),stat = "density")+mytheme_violin+#mytheme_density1+
  scale_colour_manual(values=c(rep("#CC6666",6), rep("#1E90FF",6),rep("#CC6666",6)))#mytheme_violin
p2

library("grid")
pdf("20190919_rt_normalize/20180730_hela_density.pdf",width=20,height=20)
print(p1,vp=viewport(.124,.1,x=.2,y=.7))
print(p2,vp=viewport(.12,.1,x=.5,y=.7))
dev.off()

head(a2)
sample <- unique(a2$cell)
library(tidyverse)

# normalized by z-transformating
z <- a1
for(i in 2:20){
  z[,i] = (a1[,i]-mean(a1[,i],na.rm=T))/sd(a1[,i],na.rm=T)
}
z2 <- melt(z, id.vars="name", variable.name="cell", value.name="rt")
head(z2)
#write.table(z2,"20190919_rt_normalize/20190919_rt_zscore_normalize.txt")
p1 <- ggplot()+geom_density(data=z2,aes(x=rt,colour=cell,stat = "identity"))+mytheme_density
p1
p2 <- ggplot()+geom_density(data=subset(z2,cell !="HCT116_Epithelial_cells_from_colon_carcinoma"),
                            aes(x=rt,colour=cell,stat = "identity"))+mytheme_density
p2



