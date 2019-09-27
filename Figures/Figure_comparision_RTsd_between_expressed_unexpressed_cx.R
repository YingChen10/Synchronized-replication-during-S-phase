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