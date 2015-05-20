###################################
##
##  REFORMATING FOR SATSCAN

##
##  Load the data
library(foreign)
library(plyr)
library(rgdal)
library(MASS)

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

DATA_villages<-read.csv("C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Spatial data\\dataVillages.csv")
data_merged<-merge(data_points,DATA_villages,by.x="code",by.y="Village.code",all.x=TRUE)
head(data_merged)

#########
###
# 1.  Coordinates file
###
#########

##Communes

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

commune_coordinates<-data.frame(commune3temp[,1:3])
commune_coordinates[,1]<-gsub(" ","",commune_coordinates[,1])
write.csv(commune_coordinates,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Satscan files\\commune_coordinates.csv")


## Communities

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

community_coordinates<-data.frame(community3[,1],community3[,6:7])
names(community_coordinates)[1]<-"community"
head(community_coordinates)
community_coordinates[,1]<-gsub(" ", "", community_coordinates[,1], fixed = TRUE)
write.csv(community_coordinates,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Satscan files\\community_coordinates.csv")


#################
###
# 2. TF - cases file, controls file and covariates (general and risk factors)
###
#################

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
TF_temp<-data.frame(tfdat$comid,tfdat$anytf,tfdat$sex,tfdat$ethnotdiola,
                    tfdat$occupation,tfdat$monthlyincome,tfdat$moneyaside,tfdat$school,
                    tfdat$latrine,tfdat$sharedorprivate,tfdat$watersource,tfdat$fdir,
                    tfdat$ocdis,tfdat$nasdis,tfdat$anyrisk)
names(TF_temp)<-sub("tfdat.","",names(TF_temp))
head(TF_temp)
TF_temp$anytf<-as.numeric(TF_temp$anytf)
TF_temp$anytf<-ifelse(TF_temp$anytf==1,0,1)

##Case and Control files
TF_Cases<-subset(TF_temp,anytf==1)
TF_Controls<-subset(TF_temp,anytf==0)
dim(TF_Cases)
dim(TF_Controls)

TF_Cases[,1]<-gsub(" ","",TF_Cases[,1])
TF_Controls[,1]<-gsub(" ","",TF_Controls[,1])

write.csv(TF_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\TF_Cases_communities.csv")
write.csv(TF_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\TF_Controls_communities.csv")

## COMMUNES
## TF case file and covariates of interest
TF_temp<-data.frame(tfdat$commune,tfdat$anytf,tfdat$sex,tfdat$ethnicgroup,tfdat$ethnotdiola,
                    tfdat$occupation,tfdat$monthlyincome,tfdat$moneyaside,tfdat$school,
                    tfdat$latrine,tfdat$sharedorprivate,tfdat$watersource,tfdat$fdir,
                    tfdat$ocdis,tfdat$nasdis,tfdat$anyrisk)
names(TF_temp)<-sub("tfdat.","",names(TF_temp))
head(TF_temp)
TF_temp$anytf<-as.numeric(TF_temp$anytf)
TF_temp$anytf<-ifelse(TF_temp$anytf==1,0,1)

##Case and Control files
TF_Cases<-subset(TF_temp,anytf==1)
TF_Controls<-subset(TF_temp,anytf==0)
dim(TF_Cases)
dim(TF_Controls)

TF_Cases[,1]<-gsub(" ","",TF_Cases[,1])
TF_Controls[,1]<-gsub(" ","",TF_Controls[,1])

write.csv(TF_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\TF_Cases_communes.csv")
write.csv(TF_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\TF_Controls_communes.csv")

###########
###
# 3. TT Cases and Controls
###
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
TT_temp<-data.frame(ttdat$comid,ttdat$anytt,ttdat$sex,ttdat$ethnotdiola,
                    ttdat$occupation,ttdat$monthlyincome,ttdat$moneyaside,ttdat$school,
                    ttdat$latrine,ttdat$sharedorprivate,ttdat$watersource)
names(TT_temp)<-sub("ttdat.","",names(TT_temp))
head(TT_temp)
TT_temp$anytt<-as.numeric(TT_temp$anytt)
TT_temp$anytt<-ifelse(TT_temp$anytt==1,0,1)

##Case and Control files
TT_Cases<-subset(TT_temp,anytt==1)
TT_Controls<-subset(TT_temp,anytt==0)
dim(TT_Cases)
dim(TT_Controls)

TT_Cases[,1]<-gsub(" ","",TT_Cases[,1])
TT_Controls[,1]<-gsub(" ","",TT_Controls[,1])

write.csv(TT_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\TT_Cases_communities.csv")
write.csv(TT_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\TT_Controls_communities.csv")

## COMMUNES
## TF case file and covariates of interest
TT_temp<-data.frame(ttdat$commune,ttdat$anytt,ttdat$sex,ttdat$ethnicgroup,ttdat$ethnotdiola,
                    ttdat$occupation,ttdat$monthlyincome,ttdat$moneyaside,ttdat$school,
                    ttdat$latrine,ttdat$sharedorprivate,ttdat$watersource)
names(TT_temp)<-sub("ttdat.","",names(TT_temp))
head(TT_temp)
TT_temp$anytt<-as.numeric(TT_temp$anytt)
TT_temp$anytt<-ifelse(TT_temp$anytt==1,0,1)

##Case and Control files
TT_Cases<-subset(TT_temp,anytt==1)
TT_Controls<-subset(TT_temp,anytt==0)
dim(TT_Cases)
dim(TT_Controls)

TT_Cases[,1]<-gsub(" ","",TT_Cases[,1])
TT_Controls[,1]<-gsub(" ","",TT_Controls[,1])

write.csv(TT_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\TT_Cases_communes.csv")
write.csv(TT_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\TT_Controls_communes.csv")


#############
###
# 4. Blind cases and Low vision cases
###
#############

vadata<-subset(data_merged,trachage=="50+" )
vadat <- vadata[!(is.na(vadata$va)) ,]
dim(vadat)

names(vadat)
summary(vadat$ethnicgroup) ## make sure that there are 4 groups (Diola, Peulh, Mandingue and Other)
##  Use:  levels(vadat$ethnicgroup)[5]<-"Other"
summary(vadat$ethnotdiola)

summary(vadat$occupation) ## make sure there are 3 groups (agricultuer, other, sans activite)
##  Use:  levels(vadat$occupation)[3]<-"Other"

summary(vadat$monthlyincome) ## 80 NAs and continuous variable
summary(vadat$moneyaside) ## loss, break even or saving (83 NAs)

summary(vadat$school) ## 2 NAs and factor (yes, no)

summary(vadat$latrine) ## 2 NAs and factor (yes, no)
summary(vadat$sharedorprivate) ## 226 NAs and factor (yes, no)
summary(vadat$watersource) ## factor (6: )

## COMMUNITIES
## va case file and covariates of interest
VA_temp<-data.frame(vadat$comid,vadat$va,vadat$sex,vadat$ethnicgroup,vadat$ethnotdiola,
                    vadat$occupation,vadat$monthlyincome,vadat$moneyaside,vadat$school,
                    vadat$latrine,vadat$sharedorprivate,vadat$watersource)
names(VA_temp)<-sub("vadat.","",names(VA_temp))
head(VA_temp)
VA_temp$va<-as.numeric(VA_temp$va)
VA_temp$va<-ifelse(VA_temp$va==1,1,ifelse(VA_temp$va==2,2,0))

##Case and Control files
Blind_Cases<-subset(VA_temp,va==1)
lowvision_Cases<-subset(VA_temp,va==2)
Blind_Controls<-subset(VA_temp,va==0 | va==2)
lowvision_Controls<-subset(VA_temp,va==0 | va==1)
dim(Blind_Cases)
dim(Blind_Controls)

Blind_Cases[,1]<-gsub(" ","",Blind_Cases[,1])
Blind_Controls[,1]<-gsub(" ","",Blind_Controls[,1])

lowvision_Cases[,1]<-gsub(" ","",lowvision_Cases[,1])
lowvision_Controls[,1]<-gsub(" ","",lowvision_Controls[,1])

write.csv(Blind_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\Blind_Cases_communities.csv")
write.csv(Blind_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\Blind_Controls_communities.csv")

write.csv(lowvision_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\Low_vision_Cases_communities.csv")
write.csv(lowvision_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communities\\Low_vision_Controls_communities.csv")

## COMMUNES
## VA case file and covariates of interest
VA_temp<-data.frame(vadat$commune,vadat$va,vadat$sex,vadat$ethnicgroup,vadat$ethnotdiola,
                    vadat$occupation,vadat$monthlyincome,vadat$moneyaside,vadat$school,
                    vadat$latrine,vadat$sharedorprivate,vadat$watersource)
names(VA_temp)<-sub("vadat.","",names(VA_temp))
head(VA_temp)
VA_temp$va<-as.numeric(VA_temp$va)
VA_temp$va<-ifelse(VA_temp$va==1,1,ifelse(VA_temp$va==2,2,0))

##Case and Control files
Blind_Cases<-subset(VA_temp,va==1)
lowvision_Cases<-subset(VA_temp,va==2)
Blind_Controls<-subset(VA_temp,va==0 | va==2)
lowvision_Controls<-subset(VA_temp,va==0 | va==1)
dim(Blind_Cases)
dim(Blind_Controls)

Blind_Cases[,1]<-gsub(" ","",Blind_Cases[,1])
Blind_Controls[,1]<-gsub(" ","",Blind_Controls[,1])

lowvision_Cases[,1]<-gsub(" ","",lowvision_Cases[,1])
lowvision_Controls[,1]<-gsub(" ","",lowvision_Controls[,1])

write.csv(Blind_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\Blind_Cases_communes.csv")
write.csv(Blind_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\Blind_Controls_communes.csv")

write.csv(lowvision_Cases,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\Low_vision_Cases_communes.csv")
write.csv(lowvision_Controls,"C:\\Users\\Ellie\\Documents\\RStudioProjects\\Trachoma\\Files for Satscan\\Communes\\Low_vision_Controls_communes.csv")

