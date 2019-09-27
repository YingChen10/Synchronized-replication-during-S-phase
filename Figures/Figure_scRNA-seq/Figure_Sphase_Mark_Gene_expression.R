b <- read.table("20180620/cc_specific_gene/s_specifie_gene.txt",header=T,sep="\t")
b <- subset(b,PC2 > -2.5)
##前期
p1 <- ggplot(b,aes(-PC1,PC2,colour=ENSG00000105173))+geom_point(size=1)+
  mytheme_violin+
  #ggtitle("ENSG00000105173")+ 
  scale_colour_gradient(low="grey",high="red")#+
# theme(legend.position="none")
p1
##中期
p2 <- ggplot(b,aes(-PC1,PC2,colour=ENSG00000189060))+geom_point(size=1)+
  mytheme_violin+
  #ggtitle("ENSG00000189060")+ 
  scale_colour_gradient(low="grey",high="red")#+
#theme(legend.position="none")
p2
##后期
p3 <- ggplot(data=b,aes(-PC1,PC2,colour=ENSG00000115163))+geom_point(size=1)+
  mytheme_violin+
  #ggtitle("ENSG00000115163")+ 
  scale_colour_gradient(low="grey",high="red")#+
# theme(legend.position="none")
p3

library("grid")
pdf("20180620/cc_specific_gene/7.pdf",width=20,height=20)
print(p1,vp=viewport(.05,.05,x=.2,y=.7))
print(p2,vp=viewport(.05,.05,x=.25,y=.7))
print(p3,vp=viewport(.05,.05,x=.3,y=.7))
dev.off()