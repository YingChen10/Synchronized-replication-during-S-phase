median <- read.table(median,"median.txt") 

head(median)
str(median)

p1 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time1)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S1_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 1")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time1 <= median(S1_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)

p2 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time2)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S2_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 2")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time2<= median(S2_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)


p3 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time3)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S3_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 3")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time3 <= median(S3_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p3

p4 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time4)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S4_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 4")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time4 <= median(S4_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p4

p5 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time5)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S5_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 5")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time5 <= median(S5_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p5

p6 <- ggplot()+geom_histogram(data=median,aes(x=as.numeric(time6)),fill="#1874CD",colour="black")+
  geom_vline(xintercept = median(S6_expr_sd$sd,na.rm=T))+mytheme_density1+
  xlab("Medain of SD in S-phase subgroup 6")+
  annotate("text", x=-Inf, y=Inf, label=sum(as.numeric(median$time6 <= median(S6_expr_sd$sd,na.rm=T)))/1000,hjust=-.2, vjust=4)
p6

library("grid")
pdf("20190919_cx_expr_sd_Sphase.pdf",width=20,height=20,useDingbats = F)
print(p1,vp=viewport(.1,.1,x=.2,y=.6))
print(p2,vp=viewport(.1,.1,x=.3,y=.6))
print(p3,vp=viewport(.1,.1,x=.4,y=.6))
print(p4,vp=viewport(.1,.1,x=.5,y=.6))
print(p5,vp=viewport(.1,.1,x=.6,y=.6))
print(p6,vp=viewport(.1,.1,x=.7,y=.6))
dev.off()


mytheme_density1 <-  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(axis.text.x = element_text(colour="black", size=8))+
  theme(axis.text.y = element_text(colour="black", size=8))+
  theme(axis.title=element_text(size=8))+
  #theme(plot.title=element_text(size=1.5, lineheight=.9))+
  theme(axis.ticks=element_line(colour="black",size=0.25),axis.ticks.length=unit(.2,"lines"))+
  theme(legend.title=element_text(size=8))+
  theme(legend.text=element_text(size=8))