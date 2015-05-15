library(maps)
library(maptools)
library(mapdata)
library(spatstat)
library(foreign)
library(ggplot2)
library(rgeos)
library(adegenet)
library(plyr)

#map("worldHires","Senegal", col="grey95",fill=TRUE)

##load data with lon and lat coordinates
data_points <- read.dta("C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Data\\20150514 Individual level Clean data with RFs for Ellie.dta") ##ensure xy are first 2 columns
data_points$Districts <- ifelse(data_points[,2]=="NIANKITE","SINDIAN",ifelse(data_points[,2]=="BOUYEME","SINDIAN",
    ifelse(data_points[,2]=="BRINDIAGO","SINDIAN",ifelse(data_points[,2]=="CAPARAN","SINDIAN",ifelse(data_points[,2]=="SUELLE ZONE 2","SINDIAN",
    ifelse(data_points[,2]=="SINDIAN ZONE 4","SINDIAN",ifelse(data_points[,2]=="SINDIAN ZONE 2","SINDIAN",ifelse(data_points[,2]=="BASSENE MANDOUARD","SINDIAN",
    ifelse(data_points[,2]=="DIACOYE COMBOLY","SINDIAN",ifelse(data_points[,2]=="GRAND KOULAYE","SINDIAN",ifelse(data_points[,2]=="SILINKINE ZONE 2","SINDIAN",
    ifelse(data_points[,2]=="MEDJEDJE ZONE 1","SINDIAN",ifelse(data_points[,2]=="KAGNAROU ZONE 5","SINDIAN",ifelse(data_points[,2]=="COUROUCK","SINDIAN",
    ifelse(data_points[,2]=="MARGOUNE","SINDIAN",ifelse(data_points[,2]=="BOUYEME","SINDIAN",ifelse(data_points[,2]=="DIANGO","SINDIAN","other")))))))))))))))))
data_points$Districts <- ifelse(data_points$Districts=="SINDIAN","SINDIAN",ifelse(data_points[,2]=="SINDIAN","SINDIAN",ifelse(data_points[,2]=="DIANKI ZONE 2","TENDOUCK",ifelse(data_points[,2]=="KARTIACK ZONE 2","TENDOUCK",
    ifelse(data_points[,2]=="KAGNOBON ZONE 1","TENDOUCK",ifelse(data_points[,2]=="DIEGOUNE ZONE 2","TENDOUCK",ifelse(data_points[,2]=="THIONCK ESSYL 4 ZONE 3","TENDOUCK",
    ifelse(data_points[,2]=="THIONCK ESSYL 1 ZONE 1","TENDOUCK",ifelse(data_points[,2]=="BALINGOR ZONE 2","TENDOUCK",ifelse(data_points[,2]=="TENDOUCK ZONE 2","TENDOUCK",
    ifelse(data_points[,2]=="ELANA","TENDOUCK","other")))))))))))
data_points$Districts <- ifelse(data_points$Districts=="SINDIAN","SINDIAN",ifelse(data_points$Districts=="TENDOUCK","TENDOUCK",ifelse(data_points[,2]=="SINDIAN","SINDIAN",ifelse(data_points[,2]=="TENDOUCK","TENDOUCK",
    ifelse(data_points[,2]=="MACOUDA","DIOULOULOU",ifelse(data_points[,2]=="SELETY ZONE 1","DIOULOULOU",ifelse(data_points[,2]=="DARS SALAM CHERIF ZONE 2","DIOULOULOU",
    ifelse(data_points[,2]=="ABENE ZONE 4","DIOULOULOU",ifelse(data_points[,2]=="DIANNAH ZONE 3","DIOULOULOU",ifelse(data_points[,2]=="DJIBARA","DIOULOULOU",
    ifelse(data_points[,2]=="BADIONCOTO","DIOULOULOU",ifelse(data_points[,2]=="KATABA 2","DIOULOULOU",ifelse(data_points[,2]=="KAFOUNTINE ZONE 2","DIOULOULOU",
    ifelse(data_points[,2]=="KAFOUNTINE ZONE 6","DIOULOULOU",ifelse(data_points[,2]=="KABILINE ZONE 3","DIOULOULOU",ifelse(data_points[,2]=="KACARE","DIOULOULOU",
    ifelse(data_points[,2]=="EBINKINE ZONE 2","DIOULOULOU",ifelse(data_points[,2]=="MONGONE","DIOULOULOU",ifelse(data_points[,2]=="HITOU","DIOULOULOU",
    ifelse(data_points[,2]=="NIOMOUNE ZONE 2","DIOULOULOU","TENGHORI"))))))))))))))))))))
data_points$Districts<-factor(data_points$Districts)
summary(data_points$Districts)

DATA_villages<-read.csv("C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Spatial data\\dataVillages.csv")
data_merged<-merge(data_points,DATA_villages,by.x="code",by.y="Village.code",all.x=TRUE)

################################
##
##  DESCRIPTIVE STATISTICS
##
## 1. Create a master data frame with the 
## prevalence of TF, TT and VA for all
##  communes and communities
##################################

##############################
##
## 1.1 TF Cases: Children
##
####################################
tfdata<-subset(data_merged,trachage=="1-9")
tfdat<-subset(tfdata, anytf=="No"|anytf=="Yes")
dim(tfdat)

prevtf<- sum(ifelse(tfdat$anytf == "Yes", 1, 0))/nrow(tfdat) ##the overall prevalence for Casamance

### Calculate the prevalence in each Commune and plot it on a map
placeCommune<-prevtfCommune<-numeric(19)
for(i in 1:19){
  placeCommune <- subset(tfdat,commune==unique(tfdat[,34])[i])
  prevtfCommune[i]<-  sum(ifelse(placeCommune$anytf  == "Yes",1,0))/sum(ifelse(tfdat[,34]==unique(tfdat[,34])[i],1,0))
}
commune<-data.frame(prevtfCommune,unique(tfdat[,34]))
datacommune2<-data.frame(data_merged[,107],data_merged[,109:111])
colnames(datacommune2)[1]<-"ADM2"
commune1<-merge(commune,datacommune2,by.x="unique.tfdat...34..",by.y="Commune",all.x=TRUE)

  north <- tapply(commune1$Northing,commune1[,1],mean)
  east  <- tapply(commune1$Easting,commune1[,1],mean)
north<-data.frame(key=names(north), value=north);colnames(north)[1]<-"commune";colnames(north)[2]<-"Northing"
east<-data.frame(key=names(east), value=east);colnames(east)<-c("commune","Easting")
commune2<-merge(north,east,by="commune")
commune3temp<-merge(commune2,commune,by.x="commune",by.y="unique.tfdat...34..")

ADM2<-NA
for (i in 1:19){
  ADM2[i]<-(data_merged$Districts[data_merged$Commune==unique(data_merged$Commune)[i]])[1]
}

a<-data.frame(unique(data_merged$Commune),ADM2)
a[,2]<-ifelse(a[,2]==2,"Sindian",ifelse(a[,2]==1,"Diouloulou",ifelse(a[,2]==3,"Tendouck","Tenghori")))
commune3<-merge(commune3temp,a,by.x="commune",by.y="unique.data_merged.Commune.")

##Now repeat this for the communities
placeCommunity<-prevtfCommunity<-numeric(60)
for(i in 1:60){
  placeCommunity <- subset(tfdat,comid==unique(tfdat[,2])[i])
  prevtfCommunity[i]<-  sum(ifelse(placeCommunity$anytf  == "Yes",1,0))/sum(ifelse(tfdat[,2]==unique(tfdat[,2])[i],1,0))
}

community<-data.frame(prevtfCommunity,unique(tfdat[,2]))
communityu2<-merge(community,data_merged,by.x="unique.tfdat...2..",by.y="comid",all=FALSE)
names(communityu2)
comm<-data.frame(communityu2[1:2],communityu2[108:111])
community3<-unique(comm)
head(community3)
#com_drop<-subset(community3,unique.tfdat...2.. != "DIOGUE" & unique.tfdat...2.. != "NIOMOUNE ZONE 2")



##############################
##
## 1.2 TT Cases: 15-49 year olds
##
####################################
ttdata<-subset(data_merged,trachage=="15-49" | trachage=="50+" )
ttdat<-subset(ttdata, anytt=="No TT"|anytt=="TT either/both eyes")
dim(ttdat)

prevtt<- sum(ifelse(ttdat$anytt == "TT either/both eyes", 1, 0))/nrow(ttdat) ##the overall prevalence for Casamance

### Calculate the prevalence in each Commune and plot it on a map
placeCommune<-prevttCommune<-numeric(19)
for(i in 1:19){
  placeCommune <- subset(ttdat,commune==unique(ttdat[,34])[i])
  prevttCommune[i]<-  sum(ifelse(placeCommune$anytt  == "TT either/both eyes",1,0))/sum(ifelse(ttdat[,34]==unique(ttdat[,34])[i],1,0))
}
communeTT<-data.frame(prevttCommune,unique(ttdat[,34]))
commune4<-merge(commune3,communeTT,by.x="commune",by.y="unique.ttdat...34..")
head(commune4)


##Now repeat this for the communities
placeCommunity<-prevttCommunity<-numeric(60)
for(i in 1:60){
  placeCommunity <- subset(ttdat,comid==unique(ttdat[,2])[i])
  prevttCommunity[i]<-  sum(ifelse(placeCommunity$anytt  == "TT either/both eyes",1,0))/sum(ifelse(ttdat[,2]==unique(ttdat[,2])[i],1,0))
}

communityTT<-data.frame(prevttCommunity,unique(ttdat[,2]))
community4<-merge(community3,communityTT,by.x="unique.tfdat...2..",by.y="unique.ttdat...2..")
colnames(community4)[1]<-"Community"
head(community4)


##############################
##
## 1.3 VA Cases: 15-49 year olds
##
####################################
vadata<-subset(data_merged,trachage=="50+" )
vadat <- vadata[!(is.na(vadata$va)) ,]
dim(vadat)

prevva<- sum(ifelse(vadat$va == "Normal", 0, 1))/nrow(vadat) ##the overall prevalence for Casamance

### Calculate the prevalence in each Commune and plot it on a map
placeCommune<-prevBlindCommune<-prevLowVisCommune<-numeric(19)
for(i in 1:19){
  placeCommune <- subset(vadat,commune==unique(vadat[,34])[i])
  prevBlindCommune[i]<-  sum(ifelse(placeCommune$va  == "Blind",1,0))/sum(ifelse(vadat[,34]==unique(vadat[,34])[i],1,0))
  prevLowVisCommune[i]<-  sum(ifelse(placeCommune$va  == "Low vision",1,0))/sum(ifelse(vadat[,34]==unique(vadat[,34])[i],1,0))
}
communeVA<-data.frame(prevBlindCommune,prevLowVisCommune,unique(vadat[,34]))
commune5<-merge(commune4,communeVA,by.x="commune",by.y="unique.vadat...34..")
head(commune5)


##Now repeat this for the communities
placeCommunity<-prevBlindCommunity<-prevLowVisCommunity<-numeric(59)
for(i in 1:59){
  placeCommunity <- subset(vadat,comid==unique(vadat[,2])[i])
  prevBlindCommunity[i]<-  sum(ifelse(placeCommunity$va  == "Blind",1,0))/sum(ifelse(vadat[,2]==unique(vadat[,2])[i],1,0))
  prevLowVisCommunity[i]<-  sum(ifelse(placeCommunity$va  == "Low vision",1,0))/sum(ifelse(vadat[,2]==unique(vadat[,2])[i],1,0))
}

communityVA<-data.frame(prevBlindCommunity,prevLowVisCommunity,unique(vadat[,2]))
community5<-merge(community4,communityVA,by.x="Community",by.y="unique.vadat...2..")
colnames(community4)[1]<-"Community"
head(community5)
levels(community5$Districts)<-ifelse(community5$Districts=="DIOULOULOU","Diouloulou",ifelse(community5$Districts=="TENDOUCK","Tendouck",
                              ifelse(community5$Districts=="SINDIAN","Sindian","Tenghori")))

com_drop<-subset(community5,Community != "DIOGUE" & Community != "NIOMOUNE ZONE 2")

###########################################
##
## 2. Plot the prevalence for TF TT and VA
## for the communes and communities onto
##                 Casamance
###########################################

#data_shape <- readShapePoly("C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Spatial data\\SEN_ADM2.shp") ##the overall region of Senegal of interest
#data_shape2 <- subset(data_shape,ADM2=="Diouloulou"|ADM2=="Sindian"|ADM2=="Tenghori"|ADM2=="Tendouck")
library(rgdal)
casamance <- readOGR(dsn = "C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Spatial data", "SEN_ADM2")
casamance2 <- subset(casamance,ADM2=="Diouloulou"|ADM2=="Sindian"|ADM2=="Tenghori"|ADM2=="Tendouck")
plot(casamance2)

casamance.f <- fortify(casamance2, region = "ADM2")
commune.f <- merge(casamance.f, commune5, by.x = "id", by.y = "ADM2")

#par(mfrow=c(2,1));par(mar=c(0.1,0.1,0.1,0.1))
#plot(ppp(commune3$Easting,commune3$Northing,window=W,marks=commune3$prevtfCommune*100),main="Casamance: Communes",border="grey65")
#plot(ppp(com_drop$Easting,com_drop$Northing,window=W,marks=com_drop$prevtfCommunity*100),main="Casamance: Communities",border="grey65",pch=20,col=transp("aquamarine1",alpha=0.2))

#proj4string(casamance2) <- CRS("+init=epsg:4326")


Map <- ggplot(commune.f, aes(long, lat, group = commune, fill = prevtfCommune)) + geom_polygon() + 
  coord_equal() + labs(x = "Easting (m)", y = "Northing (m)", fill = "Prevalence TF") + 
  ggtitle("Casamance")

Map
Map + scale_fill_gradient(low = "white", high = "black")

summary(casamance2@data)
head(commune5)  # the variables to join
casamance2@data <- join(casamance2@data, commune5)

###convert data into a owin format for spatstat
SP <- as(casamance2, "SpatialPolygons",)
W <- as(SP, "owin")

plot(W)
plot(ppp(data_merged$Easting,data_merged$Northing,window=W),col="grey95",main="Casamance",border="grey65")

par(mfrow=c(1,2));par(mar=c(0.001,0.5,0.0001,0.5))

plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$prevttCommune*100),main="Casamance: Communes",col=transp("blue",alpha=0.3),pty=20)
legend("bottomright",c("TF in 1-9yrs","TT in 15+ yrs"),pch=1,col=c("black","blue"))
par(new=TRUE)
plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$prevtfCommune*100),main="Casamance: Communes",pty=20)

#plot(ppp(commune5$Easting,commune5$Northing,window=W,marks=commune5$prevtfCommune*100),main="Casamance: Communes",pty=20)
par(mar=c(0.5,0.5,2,2))
plot(density(ppp(commune4$Easting,commune4$Northing,window=W,marks=commune4$prevttCommune*100), 0.05),main="Casamance: TT")























####################################
##
## 1.2 We want to consider only positive cases
##
############################################
tfdat2<-subset(tfdata, anytf=="Yes")
dim(tfdat2)
TF<-data.frame(tfdat2[,])
communes<-summary(tfdat2$commune)
communes<-data.frame(key=names(communes), value=communes);colnames(communes)[1]<-"communes";colnames(communes)[2]<-"counts"
datcomm<-merge(communes,commune2,by.x="communes",by.y="commune")
datcomm2<-subset(datcomm,counts > 0)

communities<-summary(tfdat2$comid)
communities<-data.frame(key=names(communities), value=communities);colnames(communities)[1]<-"communities";colnames(communities)[2]<-"counts"
datCommunity<-merge(communities,community3,by.x="communities",by.y="unique.tfdat...2..")
datCommunity2<-subset(datCommunity,counts > 0)


CommuneData2<-ppp(datcomm2$Easting,datcomm2$Northing,window=W)
CommunityData2<-ppp(datCommunity2$Easting,datCommunity2$Northing,window=W)

plot(density(ppp(datcomm2$Easting,datcomm2$Northing,window=W,marks=datcomm2$prevtfCommune*100), 0.05),main="Casamance: TF")

##if covariates are factors then use the chi2 tests
fit <- ppm(CommunityData2, ~1) ## Fit a homogeneous Poisson model
M <- quadrat.test(fit, nx = 2, ny = 2)
plot(CommunityData2, pch = ".")
plot(M, add = TRUE, cex = 1.5, col = "red")


 
fit <- ppm(CommuneData2, ~polynom(x, y, 2)) ## Fit an inhomogeneous Poisson model with log-quadratic intensity in catesian coordinates
fit <- ppm(bei, ~popndens, covariates = list(slope = popndens) ##inhom Poiss model with loglinear fn of popn density intensity

plot(predict(fit))
    
Gc <- Kest(data1)
Gc    
par(pty = "s")
plot(Kest(CommunityData2))


pairdist(CommunityData2) ##returns a matrix of pairwise distances (so within a village could look for clustsers)
plot(CommunityData2 %mark% (nndist(CommunityData2)/2), markscale = 1, main = "Stienen diagram")##considers distance to nearest neighbours

E <- envelope(CommunityData2, Kest, nsim = 39, rank = 1)
plot(E, main = "pointwise envelopes")
E <- envelope(CommunityData2, Lest, nsim = 19, rank = 1, global = TRUE)
plot(E, main = "global envelopes of L(r)")


##Are TF infections associated with certain risk factors?
data(data1)
Z <- data1.extra$riskfactor_dirtyface




#plot(density(data, 10))
#contour(density(data, 10), axes = FALSE)

##Multitype point patterns

plot(split(CommuneData)) ##


