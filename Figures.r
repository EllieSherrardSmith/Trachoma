###
#### Run the data prep script in Mapping1 then...
###


## Figure 2
par(mfrow=c(2,2));par(mar=c(0.001,0.005,0.001,0.005))

com_drop<-subset(community5,Community != "DIOGUE" & Community != "NIOMOUNE ZONE 2")

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$TF*100),main="Communities: TF",col=transp("blue",alpha=0.3),pty=20)
par(new=TRUE)
plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$TF*100),main="Communities: TF",pty=20)

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$TT*100),main="Communities: TT",col=transp("blue",alpha=0.3),pty=20)
par(new=TRUE)
plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$TT*100),main="Communities: TT",pty=20)

Map1 <- ggplot(commune.f, aes(long, lat, group = commune, fill = district_TF)) + geom_polygon() + 
  coord_equal() + labs(x = "Easting (m)", y = "Northing (m)", fill = "District Prevalence") + 
  ggtitle("Bignona Region") + scale_fill_gradient(low = "white", high = "grey30") + theme_bw() 

Map2 <- ggplot(commune.f, aes(long, lat, group = commune, fill = district_TT)) + geom_polygon() + 
  coord_equal() + labs(x = "Easting (m)", y = "Northing (m)", fill = "District Prevalence") + 
  ggtitle("Bignona Region") + scale_fill_gradient(low = "white", high = "grey30") + theme_bw() 


m1 <- Map1 + geom_point(data = commune5, aes(x = Easting, y = Northing, 
                                             size = Commune_TF, fill = TF)) 
m2 <- Map2 + geom_point(data = commune5, aes(x = Easting, y = Northing, 
                                             size = Commune_TT, fill = TT)) 
grid.arrange(m1,m2,ncol=2)


par(mfrow=c(1,1));par(mar=c(0.05,0.00005,0.0000,0.002))
plot(casamance,col="grey90")
par(new=TRUE)
Map1 <- ggplot(commune.f, aes(long, lat, group = commune, fill=single)) + geom_polygon() + 
  coord_equal() + guides(fill=FALSE) + labs(x = "Easting (m)", y = "Northing (m)", cex.size=2) +
  ggtitle("Bignona Region") + scale_fill_gradient(low = "white", high = "grey80") + theme_bw() +
  theme(axis.text=element_text(size=15),axis.title=element_text(size=18,face="bold"), plot.title = element_text(size=20))

Map1 + geom_text(aes(x=Easting, y=Northing, label=commune),size=10)


########Figure 3_Blind and Low vision
par(mfrow=c(2,2))
plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$Blind*100),main="Communes: Blind",col=transp("grey85",alpha=0.3),pty=20)
par(new=TRUE);plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$Blind*100),main="Communes: Blind",pty=20)

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$Blind*100),main="Communities: Blind",col=transp("grey30",alpha=0.3),pty=20)
par(new=TRUE);plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$Blind*100),main="Communities: Blind",pty=20)


com_drop<-subset(community5,Community != "DIOGUE" & Community != "NIOMOUNE ZONE 2")
plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$LowVision*100),main="Communes: Low vision",col=transp("grey85",alpha=0.3),pty=20)
par(new=TRUE);plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$LowVision*100),main="Communes: Low vision",pty=20)

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$LowVision*100),main="Communities: Low vision",col=transp("grey30",alpha=0.3),pty=20)
par(new=TRUE);plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$LowVision*100),main="Communities: Low vision",pty=20)

#######Figure 4?

par(mfrow=c(4,2))
par(mar=c(2,2,0.2,2))
plot(density(ppp(datcomm2$Easting,datcomm2$Northing,window=W,marks=datcomm2$counts), 0.05),main="Commune: TF")
plot(density(ppp(datCommunity2$Easting,datCommunity2$Northing,window=W,marks=datCommunity2$counts), 0.05),main="Communities: TF")

plot(density(ppp(datcomm3$Easting,datcomm3$Northing,window=W,marks=datcomm3$counts), 0.05),main="Commune: TT")
plot(density(ppp(datCommunity3$Easting,datCommunity3$Northing,window=W,marks=datCommunity3$counts), 0.05),main="Communities: TT")

plot(density(ppp(datcomm4$Easting,datcomm4$Northing,window=W,marks=datcomm4$counts), 0.05),main="Commune: Blind")
plot(density(ppp(datCommunity4$Easting,datCommunity4$Northing,window=W,marks=datCommunity4$counts), 0.05),main="Communities: Blind")

plot(density(ppp(datcomm5$Easting,datcomm5$Northing,window=W,marks=datcomm5$counts), 0.05),main="Commune: Low vision")
plot(density(ppp(datCommunity5$Easting,datCommunity5$Northing,window=W,marks=datCommunity5$counts), 0.05),main="Communities: Low vision")

#### Figure 5
satscanBern1<-readOGR(dsn = "C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\Results Commune Bernoulli", "Results Commune.gis")
commune5$satscanALL<-ifelse(commune5$commune=="SINDIAN",1,ifelse(commune5$commune=="SUELLE",1,ifelse(commune5$commune=="OULAMPANE",1,ifelse(commune5$commune=="ILES KARONE",1,0))))

satscanBern1community<-readOGR(dsn = "C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\Bernoulli_1", "Results Bernoulli.gis")
community5$satscanALL<-ifelse(community5$Community=="BOUYEME",1,ifelse(community5$Community=="SINDIAN ZONE 2",1,ifelse(community5$Community=="SINDIAN ZONE 4",1,ifelse(community5$Community=="MEDJEDJE ZONE 1",1,
                       ifelse(community5$Community=="GRAND KOULAYE",1,ifelse(community5$Community=="NIANKITE",1,ifelse(community5$Community=="COUROUCK",1,ifelse(community5$Community=="MARGOUNE",1,
                       ifelse(community5$Community=="SILINKINE ZONE 2",1,ifelse(community5$Community=="KAGNAROU ZONE 1",1,ifelse(community5$Community=="HITOU",2,0)))))))))))                                                                                                                            

com_drop<-subset(community5,Community != "DIOGUE" & Community != "NIOMOUNE ZONE 2")

par(mfrow=c(2,2));par(mar=c(0.001,0.005,0.001,0.005))


plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$TF*100),main="TF",col=transp("grey40",alpha=0.5),pty=20,border="grey80")
points(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$satscanALL)[com_drop$satscanALL==1],main="Communes: Blind",col="black",pch=20)
points(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$satscanALL)[commune5$satscanALL==1],main="Communes: Blind",col="black",pch=24)

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$TT*100),main="TT",col=transp("grey40",alpha=0.5),pty=20,border="grey80")
points(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$satscanALL)[com_drop$satscanALL==1],main="Communes: Blind",col="black",pch=20)
points(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$satscanALL)[commune5$satscanALL==1],main="Communes: Blind",col="black",pch=24)

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$Blind*100),main="Blind",col=transp("grey40",alpha=0.5),pty=20,border="grey80")
points(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$satscanALL)[com_drop$satscanALL==1],main="Communes: Blind",col="black",pch=20)
points(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$satscanALL)[commune5$satscanALL==1],main="Communes: Blind",col="black",pch=24)

plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$LowVision*100),main="Low vision",col=transp("grey40",alpha=0.5),pty=20,border="grey80")
points(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$satscanALL)[com_drop$satscanALL==1],main="Communes: Blind",col="black",pch=20)
points(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$satscanALL)[commune5$satscanALL==1],main="Communes: Blind",col="black",pch=24)
