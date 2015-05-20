library(maps)
library(maptools)
library(mapdata)
library(spatstat)
library(foreign)
library(ggplot2)
library(rgeos)
library(adegenet)
library(plyr)
library(rgdal)
library(MASS)
library(ggmap)
library(classInt)
library(RColorBrewer)
library(gridExtra)
library(ecespa)

#########################
##
## DATA PREPARATION
##
########################

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
names(tfdat)

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
trial<-merge(tfdat,commune2,by.x="commune",by="commune")

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
comm<-data.frame(communityu2[1:2],communityu2[,108:112])
community3<-unique(comm)
head(community3)
#com_drop<-subset(community3,unique.tfdat...2.. != "DIOGUE" & unique.tfdat...2.. != "NIOMOUNE ZONE 2")
tf_casesCommunity1<-merge(tfdat,community3,by.x="comid",by="unique.tfdat...2..")
dim(tf_casesCommunity1)

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
names(commune4)
tt_cases1<-merge(ttdat,commune4,by.x="commune",by="commune")
names(tt_cases1)

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
tt_casesCommunity1<-merge(ttdat,community4,by.x="comid",by="Community")
dim(tt_casesCommunity1)


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
###########################################
##
## 1.4 SPATIAL DATA: communes and communities onto
##                 Casamance
###########################################

casamance <- readOGR(dsn = "C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Spatial data", "SEN_ADM2")
casamance2 <- subset(casamance,ADM2=="Diouloulou"|ADM2=="Sindian"|ADM2=="Tenghori"|ADM2=="Tendouck")

names(commune5)[4]<-"TF";names(commune5)[6]<-"TT";names(commune5)[7]<-"Blind";names(commune5)[8]<-"LowVision"

commune5$Commune_TF<-commune5$TF*100
commune5$Commune_TT<-commune5$TT*100
Tend<-sum(commune5$TF[commune5$ADM2=="Tendouck"])/5
Teng<-sum(commune5$TF[commune5$ADM2=="Tenghori"])/6
Sind<-sum(commune5$TF[commune5$ADM2=="Sindian"])/4
Diol<-sum(commune5$TF[commune5$ADM2=="Diouloulou"])/4

commune5$district_TF<-ifelse(commune5$ADM2=="Tendouck",Tend,ifelse(commune5$ADM2=="Tenghori",Teng,ifelse(commune5$ADM2=="Sindian",Sind,Diol)))
commune5$district_TF<-commune5$district_TF*100

Tend<-sum(commune5$TT[commune5$ADM2=="Tendouck"])/5
Teng<-sum(commune5$TT[commune5$ADM2=="Tenghori"])/6
Sind<-sum(commune5$TT[commune5$ADM2=="Sindian"])/4
Diol<-sum(commune5$TT[commune5$ADM2=="Diouloulou"])/4

commune5$district_TT<-ifelse(commune5$ADM2=="Tendouck",Tend,ifelse(commune5$ADM2=="Tenghori",Teng,ifelse(commune5$ADM2=="Sindian",Sind,Diol)))
commune5$district_TT<-commune5$district_TT*100

names(community5)[2]<-"TF";names(community5)[8]<-"TT";names(community5)[9]<-"Blind";names(community5)[10]<-"LowVision"

60-sum(ifelse(community5$TT == 0, 0, 1))
mean(community5$TT[community5$TT > 0])
mean(community5$TT)

commune5$single<-rep(1,19)

casamance.f <- fortify(casamance2, region = "ADM2")
commune.f <- merge(casamance.f, commune5, by.x = "id", by.y = "ADM2")

community.f <- merge(casamance.f, community5, by.x = "id", by.y = "Districts")


#SP<-as(commune5, "SpatialPoints")
#Commune<-as(casamance2,"ppp")
#CommuneDat<-slot(casamance2,"data")

###convert data into a owin format for spatstat
SP <- as(casamance2, "SpatialPolygons",)
W <- as(SP, "owin")

###########################################################
##
## 2. SPATIAL ANALYSIS
##
##
############################################
###Fitting inhomogeneous Poisson models
##Create TF_temp in Formatting for Satscan
placeCommune<-prevtfCommune<-propMale<-propDiola<-propoccupAgri<-propoccupSans<-propSchool<-propLatrine<-propShare<-propDirtyAny<-numeric(19)
for(i in 1:19){
  placeCommune <- subset(TF_temp,commune==unique(TF_temp[,2])[i])
  prevtfCommune[i] <-  sum(placeCommune$anytf)/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propMale[i] <-  sum(ifelse(placeCommune$sex=="male",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propDiola[i] <-  sum(ifelse(placeCommune$ethnotdiola=="Diola",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propoccupAgri[i] <- sum(ifelse(placeCommune$occupation=="Agriculteur",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propoccupSans[i] <- sum(ifelse(placeCommune$occupation=="Sans activite",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propSchool[i] <- sum(ifelse(placeCommune$school=="Yes",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propLatrine[i] <- sum(ifelse(placeCommune$latrine=="Yes",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propShare[i] <- sum(ifelse(placeCommune$sharedorprivate=="Shared",1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
  propDirtyAny[i] <- sum(ifelse(placeCommune$anyrisk==1,1,0))/sum(ifelse(TF_temp[,2]==unique(TF_temp[,2])[i],1,0))
}
datCommune<-data.frame(unique(TF_temp[,2]),propMale,propDiola,propoccupAgri)
names(datCommune)[1]<-"commune"
#datCommune$satscan<-satscanALL<-ifelse(datCommune$commune=="SINDIAN",1,ifelse(datCommune$commune=="SUELLE",1,ifelse(datCommune$commune=="OULAMPANE",1,0)))

Communedata<-merge(commune5,datCommune,by.x="commune",by.y="commune")
Communedata1<-data.frame(Communedata[,1:4],Communedata[,14:16])
xy <- Communedata1[,c(2,3)]

spdf <- SpatialPointsDataFrame(coords = xy, data = Communedata1[,3:6],
                               proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
class(spdf)

dfComm1 <- as(spdf, "ppp")
dfComm1data <- slot(spdf, "data")

###################
##
##
## Just look at the cases
##
######################
##if covariates are factors then use the chi2 tests
trial2<-subset(trial,anytf=="Yes")
tf_cases<-ppp(trial2$Easting.y,trial2$Northing.y,window=W)

tf_casesCommunity2<-subset(tf_casesCommunity1,anytf=="Yes")
tf_casesCommunity<-ppp(tf_casesCommunity2$Easting.y,tf_casesCommunity2$Northing.y,window=W)

tt_cases2<-subset(tt_cases1,anytt=="TT either/both eyes")
tt_casesCommune<-ppp(tt_cases2$Easting.y,tt_cases2$Northing.y,window=W)

tt_casesCommunity2<-subset(tt_casesCommunity1,anytt=="TT either/both eyes")
tt_casesCommunity<-ppp(tt_casesCommunity2$Easting.x,tt_casesCommunity2$Northing.x,window=W)

fitcommune <- ppm(tf_cases, ~1) ## Fit a homogeneous Poisson model
fitcommunity <- ppm(tf_casesCommunity, ~1) ## Fit a homogeneous Poisson model
fitcommuneTT <- ppm(tt_casesCommune, ~1) ## Fit a homogeneous Poisson model
fitcommunityTT <- ppm(tt_casesCommunity, ~1) ## Fit a homogeneous Poisson model

M <- quadrat.test(fitcommune, nx = 2, ny = 2)
M2<- quadrat.test(fitcommunity, nx = 2, ny = 2)
M3 <- quadrat.test(fitcommuneTT, nx = 2, ny = 2)
M4<- quadrat.test(fitcommunityTT, nx = 2, ny = 2)



fit <- ppm(tf_cases, ~polynom(x, y, 2)) ## Fit an inhomogeneous Poisson model with log-quadratic intensity in catesian coordinates
fit2 <- ppm(tf_casesCommunity, ~polynom(x, y, 2)) ## Fit an inhomogeneous Poisson model with log-quadratic intensity in catesian coordinates
fit3 <- ppm(tt_casesCommune, ~polynom(x, y, 2)) ## Fit an inhomogeneous Poisson model with log-quadratic intensity in catesian coordinates
fit4 <- ppm(tt_casesCommunity, ~polynom(x, y, 2)) ## Fit an inhomogeneous Poisson model with log-quadratic intensity in catesian coordinates

#fit <- ppm(dfComm1, ~TF, covariates = list(slope = propMale))##inhom Poiss model with loglinear fn of popn density intensity
par(mfrow=c(2,2))
plot(tf_cases, pch = ".")
plot(M, add = TRUE, cex = 1.5, col = "red")
plot(tf_casesCommunity, pch = ".")
plot(M2, add = TRUE, cex = 1.5, col = "red")
plot(tt_casesCommune, pch = ".")
plot(M3, add = TRUE, cex = 1.5, col = "red")
plot(tt_casesCommunity, pch = ".")
plot(M4, add = TRUE, cex = 1.5, col = "red")

par(mar=c(2,2,2,2))
plot(predict(fit),main="Commune: Predicted TF cases")
plot(predict(fit2),main="Community: Predicted TF cases")
plot(predict(fit3),main="Commune: Predicted TF cases")
plot(predict(fit4),main="Community: Predicted TF cases")

Gc <- Kest(tf_casesCommunity)
Gc  ##same for all  
par(pty = "s")
plot(Kest(tf_cases))
plot(Kest(tf_casesCommunity))
plot(Kest(tt_casesCommune))
plot(Kest(tt_casesCommunity))


#pairdist(tf_cases) ##returns a matrix of pairwise distances (so within a village could look for clustsers)
plot(tf_cases %mark% (nndist(tf_cases)/2), markscale = 1, main = "Stienen diagram: TF Communes")##considers distance to nearest neighbours
plot(tf_casesCommunity %mark% (nndist(tf_casesCommunity)/2), markscale = 1, main = "Stienen diagram: TF Communities")##considers distance to nearest neighbours

plot(tt_casesCommune %mark% (nndist(tt_casesCommune)/2), markscale = 1, main = "Stienen diagram: TT Communes")##considers distance to nearest neighbours
plot(tt_casesCommunity %mark% (nndist(tt_casesCommunity)/2), markscale = 1, main = "Stienen diagram: TT Communities")##considers distance to nearest neighbours

E1 <- envelope(tf_cases, Kest, nsim = 19, correction="best")
par(mfrow=c(2,2));par(mar=c(2,2,2,2))
plot(E1, main = "Communes: TF")#,sqrt(./pi)-r~r,lty=c(1,2,3,3),col=c(1,2,3,3),ylab="L(t)")

E2 <- envelope(tf_casesCommunity, Kest, nsim = 19, correction="best")
par(mar=c(2,2,2,2))
plot(E2, main = "Communities: TF")#,sqrt(./pi)-r~r,lty=c(1,2,3,3),col=c(1,2,3,3),ylab="L(t)")

E3 <- envelope(tt_casesCommune, Kest, nsim = 19, correction="best")
par(mar=c(2,2,2,2))
plot(E3, main = "Communes: TT")#,sqrt(./pi)-r~r,lty=c(1,2,3,3),col=c(1,2,3,3),ylab="L(t)")

E4 <- envelope(tt_casesCommunity, Kest, nsim = 19, correction="best")
par(mar=c(2,2,2,2))
plot(E4, main = "Communities: TT")#,sqrt(./pi)-r~r,lty=c(1,2,3,3),col=c(1,2,3,3),ylab="L(t)")

#E2 <- envelope(tf_cases, Lest, nsim = 38, rank = 1, global = TRUE)
#plot(E2, main = "global envelopes of L(r)")

#E1a <- envelope(fit2, Kest, nsim = 19, global = TRUE, correction = "border")
#plot(E1a, main = "TF Commune data")#,sqrt(./pi)-r~r,lty=c(1,2,3,3),col=c(1,2,3,3),ylab="L(t)")
#E1B <- envelope(fit, Kest, nsim = 19, global = TRUE, correction = "border")
#plot(E1B, main = "TF Community data")#,sqrt(./pi)-r~r,lty=c(1,2,3,3),col=c(1,2,3,3),ylab="L(t)")


###########################################################
##
## 3. RISK FACTOR ANALYSIS
##
##
############################################
#####################################
##
##  Modelling in lme4
##
##
#######################
library(lme4)
library(DAAG)
library(pbkrtest)
library(RLRsim)


######
#######
########
#########
##########
tfdata<-subset(data_merged,trachage=="1-9")
tfdat<-subset(tfdata, anytf=="No"|anytf=="Yes")
dim(tfdat)

names(tfdat)
summary(tfdat$ethnicgroup) ## make sure that there are 4 groups (Diola, Peulh, Mandingue and Other)
##  Use:  levels(tfdat$ethnicgroup)[5]<-"Other"
summary(tfdat$ethnotdiola)

summary(tfdat$occupation) ## make sure there are 3 groups (agricultuer, other, sans activite)
##  Use:  levels(tfdat$occupation)[2]<-"Other"

summary(tfdat$monthlyincome) ## 80 NAs and continuous variable
summary(tfdat$moneyaside) ## loss, break even or saving (83 NAs)

summary(tfdat$school) ## 2 NAs and factor (yes, no)

summary(tfdat$latrine) ## 2 NAs and factor (yes, no)
summary(tfdat$sharedorprivate) ## 226 NAs and factor (yes, no)
summary(tfdat$watersource) ## factor (6: )

summary(tfdat$fdir) ##no yes ) 1 NA
summary(tfdat$ocdis) ##no yes ) 1 NA
summary(tfdat$nasdis) ##no yes ) 1 NA
##  summary(tfdat$flies) ##no yes ) 1 NA only 5 yeses so dont include
tfdat$anyrisk<-factor(tfdat$unclean) 
summary(tfdat$anyrisk) ##1 NA

## COMMUNITIES
## TF case file and covariates of interest
TF_temp<-data.frame(tfdat$comid,tfdat$commune,tfdat$anytf,tfdat$sex,tfdat$ethnotdiola,
                    tfdat$occupation,tfdat$monthlyincome,tfdat$moneyaside,tfdat$school,
                    tfdat$latrine,tfdat$sharedorprivate,tfdat$watersource,tfdat$fdir,
                    tfdat$ocdis,tfdat$nasdis,tfdat$anyrisk)
names(TF_temp)<-sub("tfdat.","",names(TF_temp))
head(TF_temp)
TF_temp$anytf<-as.numeric(TF_temp$anytf)
TF_temp$anytf<-ifelse(TF_temp$anytf==1,0,1)
##########
#########
########
#######
######
data2<-TF_temp
head(TF_temp)
row.has.na <- apply(data2, 1, function(x){any(is.na(x))})
final.filtered <- data2[!row.has.na,]
dim(final.filtered);dim(TF_temp)

#
###
#### tf
###
#
##COMMUNES AS A RANDOM EFFECT (NESTED WITHIN POPULATION)
mod1a<-glmer(anytf~school+sex+ethnotdiola+sharedorprivate+occupation+anyrisk+(1|commune),data=final.filtered,family="binomial")
summary(mod1a);logLik(mod1);drop1(mod1)##using drop1 and dropping if AIC mod1-2 is bigger than 2 AIC units

mod1<-glmer(anytf~sex+ethnotdiola+occupation+(1|commune),data=final.filtered,family="binomial")
summary(mod1)
lme4=plogis(coef(mod1)$commune[,1])
sum(simulate(mod1))/nrow(simulate(mod1))
sum(final.filtered$anytf)/length(final.filtered$anytf)
as.data.frame(VarCorr(mod1))
plot(mod1,type=c("p","smooth"))
plot(mod1,sqrt(abs(resid(.)))~fitted(.), type=c("p","smooth"))
qqmath(mod1,id=0.05)

iqrvec <- sapply(simulate(mod1,1000),IQR)
obsval <- IQR(final.filtered$anytf)
post.pred.p <- mean(obsval>=c(obsval,iqrvec))

mod1b<-glmer(anytf~ethnotdiola+sex+(1|commune),data=final.filtered,family="binomial")

anova(mod1,mod1b)

mod1.mcmc <- mcmcsamp(mod1 , n=1000)
z <- VarCorr(mod1.mcmc, type="varcov")
colnames(z) <- c("commune", "Residual")

##COMMUNITIES AS A RANDOM EFFECT (NESTED WITHIN POPULATION)
mod2a<-glmer(anytf~school+sex+ethnotdiola+sharedorprivate+occupation+anyrisk+(1|comid),data=final.filtered,family="binomial")
summary(mod2a);logLik(mod2a);drop1(mod2a)##using drop1 and dropping if AIC mod1-2 is bigger than 2 AIC units

mod2<-glmer(anytf~sex+ethnotdiola+occupation+(1|comid),data=final.filtered,family="binomial")
drop1(mod2);summary(mod2)
lme4=plogis(coef(mod1)$commune[,1])
sum(simulate(mod2))/nrow(simulate(mod2))
sum(final.filtered$anytf)/length(final.filtered$anytf)
as.data.frame(VarCorr(mod2))
plot(mod2,type=c("p","smooth"))
plot(mod2,sqrt(abs(resid(.)))~fitted(.), type=c("p","smooth"))
qqmath(mod2,id=0.05)

iqrvec <- sapply(simulate(mod2,1000),IQR)
obsval <- IQR(final.filtered$anytf)
post.pred.p <- mean(obsval>=c(obsval,iqrvec))

mod1b<-glmer(anytf~ethnotdiola+occupation+(1|comid),data=final.filtered,family="binomial")

anova(mod1,mod1b)

mod1.mcmc <- mcmcsamp(mod1 , n=1000)
z <- VarCorr(mod1.mcmc, type="varcov")
colnames(z) <- c("commune", "Residual")

#
###
#### tt
###
#
#######
########
#########
##########
###########
ttdata<-subset(data_merged,trachage=="15-49" | trachage=="50+" )
ttdat<-subset(ttdata, anytt=="No TT"|anytt=="TT either/both eyes")
dim(ttdat)

names(ttdat)
summary(ttdat$ethnicgroup) ## make sure that there are 4 groups (Diola, Peulh, Mandingue and Other)
##  Use:  levels(ttdat$ethnicgroup)[5]<-"Other"
summary(ttdat$ethnotdiola)

summary(ttdat$occupation) ## make sure there are 3 groups (agricultuer, other, sans activite)
##  Use:  levels(ttdat$occupation)[2]<-"Other"

summary(ttdat$monthlyincome) ## 80 NAs and continuous variable
summary(ttdat$moneyaside) ## loss, break even or saving (83 NAs)

summary(ttdat$school) ## 2 NAs and factor (yes, no)

summary(ttdat$latrine) ## 2 NAs and factor (yes, no)
summary(ttdat$sharedorprivate) ## 226 NAs and factor (yes, no)
summary(ttdat$watersource) ## factor (6: )

## COMMUNITIES
## tt case file and covariates of interest
TT_temp<-data.frame(ttdat$comid,ttdat$commune,ttdat$anytt,ttdat$sex,ttdat$ethnotdiola,
                    ttdat$occupation,ttdat$monthlyincome,ttdat$moneyaside,ttdat$school,
                    ttdat$latrine,ttdat$sharedorprivate,ttdat$watersource)
names(TT_temp)<-sub("ttdat.","",names(TT_temp))
head(TT_temp)
TT_temp$anytt<-as.numeric(TT_temp$anytt)
TT_temp$anytt<-ifelse(TT_temp$anytt==1,0,1)

##Case and Control files
TT_Cases<-subset(TT_temp,anytt==1)
TT_Controls<-subset(TT_temp,anytt==0)
##############
#############
############
###########
##########

data2<-TT_temp
head(TT_temp)
row.has.na <- apply(data2, 1, function(x){any(is.na(x))})
final.filtered2 <- data2[!row.has.na,]
dim(final.filtered2);dim(TT_temp)

##COMMUNES AS A RANDOM EFFECT (NESTED WITHIN POPULATION)
mod3a<-glmer(anytt~sex+ethnotdiola+school+sharedorprivate+(1|commune),data=final.filtered2,family="binomial")
summary(mod3a);logLik(mod3a);drop1(mod3a)##using drop1 and dropping if AIC mod1-2 is bigger than 2 AIC units

mod3<-glmer(anytt~sex+(1|commune),data=final.filtered2,family="binomial")
drop1(mod3);summary(mod3)
lme4=plogis(coef(mod3)$commune[,1])
sum(simulate(mod3))/nrow(simulate(mod3))
sum(final.filtered2$anytt)/length(final.filtered2$anytt)
as.data.frame(VarCorr(mod3))
plot(mod3,type=c("p","smooth"))
plot(mod3,sqrt(abs(resid(.)))~fitted(.), type=c("p","smooth"))
qqmath(mod3,id=0.05)

iqrvec <- sapply(simulate(mod3,1000),IQR)
obsval <- IQR(final.filtered2$anytt)
post.pred.p <- mean(obsval>=c(obsval,iqrvec))

mod3b<-glmer(anytt~(1|commune),data=final.filtered2,family="binomial")

anova(mod3,mod3b)

mod3.mcmc <- mcmcsamp(mod3 , n=1000)
z <- VarCorr(mod3.mcmc, type="varcov")
colnames(z) <- c("commune", "Residual")

##COMMUNITIES AS A RANDOM EFFECT (NESTED WITHIN POPULATION)
mod4a<-glmer(anytt~sex+ethnotdiola+school+sharedorprivate+(1|comid),data=final.filtered2,family="binomial")
summary(mod4a);logLik(mod4a);drop1(mod4a)##using drop1 and dropping if AIC mod1-2 is bigger than 2 AIC units

mod4<-glmer(anytt~sex+(1|comid),data=final.filtered2,family="binomial")
drop1(mod4);summary(mod4)
lme4=plogis(coef(mod4)$comid[,1])
sum(simulate(mod4))/nrow(simulate(mod4))
sum(final.filtered2$anytt)/length(final.filtered2$anytt)
as.data.frame(VarCorr(mod4))
plot(mod4,type=c("p","smooth"))
plot(mod4,sqrt(abs(resid(.)))~fitted(.), type=c("p","smooth"))
qqmath(mod4,id=0.05)

iqrvec <- sapply(simulate(mod3,1000),IQR)
obsval <- IQR(final.filtered2$anytt)
post.pred.p <- mean(obsval>=c(obsval,iqrvec))

mod3b<-glmer(anytt~(1|commune),data=final.filtered2,family="binomial")

anova(mod3,mod3b)