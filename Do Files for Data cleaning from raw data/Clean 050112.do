      
* CLEAN CASAMANCE SURVEY DATA DO FILE

***
* CHILD.TXT: 
* ADDED DATE OF BIRTH FROM TBL ENUM FIRST
* ALSO ADDED SEX

***
* ENUM.TXT:
* ADDED DATE OF ENUM FROM TBL RISKS FIRST

***

** The following 11 don't have a record in examination data:
* 13-001-006-02, 13-001-006-03, 13-001-006-07, 13-001-006-08, 13-001-006-09
* 13-001-006-10, 13-001-006-12, 13-001-006-13, 13-001-006-14
* 13-001-066-04
* 13-001-066-14

* No ocular forms for these people in scans, so assume they weren't examined.
* Remove them in cleaning, as all data missing.

***

* To make "Working_play around file" the default directory:

cd "E:\BACK-UP LSHTM 190112\Casamance survey\STATA\Data\Work_playing around file"

log using clean3.log, replace

***

** Databases clean on 3rd Oct 2011

* Order of cleaning:
* 1. Risks - DONE
* 2. Enumeration - DONE
* 3. Exam - DONE
* 4. Merge Risks & Exam
***

*****************
/**********************************/
* 1. CLEAN HOUSEHOLD RISK FACTOR DATA *

insheet using "Risks.txt", clear

* Generate unique community and household ID 

* Community
tab communitycode
split communitycode, p(-) destring
gen comid= (communitycode1*1000)+communitycode2
order communitycode comid
label var comid "community id"
tab comid

* Village 15201 only has 9 households. They didn't examine hhold 185 for
* some reason, and didn't use any of the 3 reserves


* Name communities:
label define comidlab 1008 "NIANKITE" 1011 "CAPARAN" 1016 "SUELLE ZONE 2"  /// 
2014 "DIACOYE COMBOLY" 2032 "BRINDIAGO" 3002 "BOUYEME" 3012 "MEDJEDJE ZONE 1" 3016 "COUROUCK" /// 
3019 "KAGNAROU ZONE 1" 3201 "SINDIAN ZONE 2" 3401 "SINDIAN ZONE 4" 4001 "MANGUILINE BELFORT ZONE 1" ///
4003 "MEDINA PLATEAU ZONE 1" 4004 "BASSENE ZONE 5" 4006 "ANIMATION ZONE 5" 4008 "CHATEAU DEAU ZONE 4" ///
5006 "DIARONE" 5019 "KOUTENGHOR" 5028 "SOUTOU" 5031 "TENGHORY 1 ZONE 1" 5035 "TENGHORY 5 ZONE 2" ///
6008 "MANDOUARD 2" 6016 "TOGHO" 6023 "OUONCK ZONE 2" 7004 "COUBALANG ZONE2" 7005 "COUBANAO ZONE 4" ///
7009 "FINTHIOCK ZONE 2" 8001 "TABI" 8010 "NIAMONE ZONE 1" 9001 "THIONCK ESSYL 1 ZONE 1" 9004 "THIONCK ESSYL 4 ZONE 3" ///
10002 "ELANA" 10007 "TENDOUCK ZONE 2" 11001 "BALINGOR ZONE 2" 12001 "KARTIACK ZONE 2" 12003 "DIANKI ZONE 2" ///
13001 "DIEGOUNE ZONE 2" 13003 "KAGNOBON ZONE 1" 14005 "MONGONE" 14011 "KABILINE ZONE 3" 14016 "KACARE" ///
14022 "EBINKINE ZONE 2" 15003 "DIANNAH ZONE 3" 15004 "ABENE ZONE 4" 15201 "KAFOUNTINE ZONE 2" /// 
15601 "KAFOUNTINE ZONE 6" 16002 "NIOMOUNE ZONE 2" 16003 "DIOGUE" 16006 "HITOU" 17002 "BADIONCOTO" ///
17010 "DARS SALAM CHERIF ZONE 2" 17015 "DJIBARA" 17020 "KATABA 2" 17028 "MACOUDA" ///
17037 "SELETY ZONE 1" 18004 "BASSENE MANDOUARD" 18016 "DIANGO" 18025 "GRAND KOULAYE" 18039 "MARGOUNE" 18044 "SILINKINE ZONE 2"
	
label values comid comidlab
tab comid, m

list communitycode comid

gen commune=.
replace commune = 1 if comid==1008 | comid==1011 | comid==1016
replace commune = 2 if comid==2014 | comid==2032
replace commune = 3 if comid==3002 | comid==3012 | comid==3016 | comid==3019 | comid==3201 | comid==3401
replace commune = 4 if comid==4001 | comid==4003 | comid==4004 | comid==4006 | comid==4008
replace commune = 5 if comid==5006 | comid==5019 | comid==5028 
replace commune = 6 if comid==5031 | comid==5035
replace commune = 7 if comid==6008 | comid==6016 | comid==6023
replace commune = 8 if comid==7004 | comid==7005 | comid==7009
replace commune = 9 if comid==8001 | comid==8010 
replace commune = 10 if comid==9001 | comid==9004
replace commune = 11 if comid==10002 | comid==10007 
replace commune = 12 if comid==11001 
replace commune = 13 if comid==12001 | comid==12003
replace commune = 14 if comid==13001 | comid==13003
replace commune = 15 if comid==14005 | comid==14011 | comid==14016 | comid==14022
replace commune = 16 if comid==15003 | comid==15004 | comid==15201 | comid==15601
replace commune = 17 if comid==16002 | comid==16003 | comid==16006
replace commune = 18 if comid==17002 | comid==17010 | comid==17015 | comid==17020 | comid==17028 | comid==17037
replace commune = 19 if comid==18004 | comid==18016 | comid==18025 | comid==18039 | comid==18044 

tab commune,m

label define communelab 1 "SUELLE" 2 "DJIBIDIONE" 3 "SINDIAN" 4 "BIGNONA" 5 "TENGHORI" 6 "TENGHORI TRANSGAMBIENNE"  /// 
7 "OUONCK" 8 "COUBALAN" 9 "NIAMONE" 10 "THIONCK-ESSYL" 11 "MANGAGOULACK" 12 "BALINGHOR"  /// 
13 "KARTHIACKK" 14 "DIEGOUNE" 15 "DJINAKY" 16 "KAFOUNTINE" 17 "ILES KARONE" 18 "DIOULOULOU" 19 "OULAMPANE" 
label values commune communelab
tab commune,m

tab comid,m 



* Household

rename householdnumber hhno

* 'encode' creates a categorical variable assigning a # to each different entry
* need to get a unique hhno
gen hid=comid*100+hhno
sort hid
list comid hhno hid in 50/100

* HOUSEHOLD HEAD AGE:
* Calculate household head age: date of interview - date of birth
rename date qairedate
gen datestr="01/01/2010"
gen date=date(datestr, "dmy")
format date %d
list datestr date in f/10
drop datestr

desc dateofbirth
tab dateofbirth in f/10
split dateofbirth, p(/) 
desc dateofbirth

* Day:
gen hhdayob=real(dateofbirth1)
tab hhdayob in f/10
list comid hhno hid if hhdayob==. & age==.
* 10 in total are missing, 5 are confirmed missing
* For the others:
recode hhdayob .=1 if hid==400832
recode hhdayob .=21 if hid==400870
recode hhdayob .=15 if hid==1500344

tab age in f/10
recode age .=40 if hid==1401142
recode age .=60 if hid==1703754

list comid hhno hid if hhdayob==. & age==.
* These 5 are confirmed missing

* Year:
tab dateofbirth3, m
gen hhyrob=real(dateofbirth3)
tab hhyrob, m 

list comid hhno hid if hhyrob==. & age==.
recode  hhyrob .=1959 if hid==400832
recode  hhyrob .=1934 if hid==400870
recode  hhyrob .=1960 if hid==1500344

list comid hhno hid if hhyrob==2010
recode  hhyrob 2010=1970 if hid==1804466

list comid hhno hid if hhyrob==1998
recode  hhyrob 1998=1988 if hid==1803903

list comid hhno hid if hhyrob==1992
recode age .=65 if hid==1702823
recode hhdayob 10=. if hid==1702823
recode hhyrob 1992=. if hid==1702823

* Month:
tab dateofbirth2
encode dateofbirth2, gen(hhmthob)
label list hhmthob
tab hhmthob, m

list comid hhno hid if hhmthob==. & age==.
recode  hhmthob .=01 if hid==400832
recode  hhmthob .=08 if hid==400870
recode  hhmthob .=03 if hid==1500344

recode hhmthob 10=. if hid==1702823

list hhdayob hhyrob hhmthob age if hid==1702823

* Complete Date of birth:
gen hhdob=mdy(hhmthob, hhdayob, hhyrob)
format hhdob %d
list  hhdayob hhmthob hhyrob hhdob in f/10
drop dateofbirth*

* Recode interview date
tab qairedate in f/10
split qairedate, p(/) 
desc qairedate

gen qaireday=real(qairedate1)
tab qaireday
list comid hhno if qaireday==.
* No missing points

tab qairedate3, m
gen qaireyr=real(qairedate3)
tab qaireyr, m 
 
list hid qairedate1 qairedate2 qairedate3  if qaireyr==2020
recode qaireyr 2020=2010 if qaireyr==2020
 
list hid qairedate1 qairedate2 qairedate3  if qaireyr==2011
recode qaireyr 2011=2010 if qaireyr==2011


encode qairedate2, gen(qairemth)
label list qairemth

recode qairemth 1=101 2=102 3=103 4=104 5=105
recode qairemth 101=1 102=2 103=4 104=5 105=6 
label drop qairemth
tab qairemth, m

gen rfqairedate=mdy(qairemth, qaireday, qaireyr)
format rfqairedate %d
drop qairedate*

tab rfqairedate,m

list hid if qairemth==06

gen hhage=int((rfqairedate-hhdob)/365.25)
tab hhage, m

list hid if hhage==. & age==.
* 5 missing. Correct.

* Need to check that people don't have age AND dob:
* hhage = calculated from RF Qaire & HH DOB
* age = age entered in database
list hid rfqairedate hhdob age hhage if hhage~=. & age~=. 
* Age is data entry mistake
recode  age 1=. if hid==1804444 


* Combine age and hhage into one "headage" variable:
desc age
desc hhage
* hhage is numeric: float
* Age is numeric: byte 

gen headage=age
replace headage=hhage if age==.
tab headage,m
* 5 missing. Correct!

list hid hhdob headage if hid==1600370
recode headage 29=. if hid==1600370
tab headage,m
* 6 missing. Correct!


* Sex: 1=male; 2=female
rename sex hhsex
tab hhsex,m

label define sexlab 1 "Male" 2 "Female"
label values hhsex sexlab
tab hhsex,m


* Ethnic group
tab ethnicgroup,m
label define ethlab 1 "Diola" 2 "Peulh" 3 "Mandingue" 4 "Manjaque"  5 "Mancagne" 6 "Bambara" 7 "Balante" 8 "Pepelle" 9 "Other" 10 "Bainounk" 11 "Karoninke" 12 "Serer" 13 "Wolof" 14 "Toucouleur" 
label values ethnicgroup ethlab
tab ethnicgroup,m

tab othergp if ethnicgroup==9,m

encode othergp, gen(othethgp)
label list othethgp

recode othethgp 1=101 2=102 3=103 4=104 5=105 6=106 7=107 8=108 9=109 10=110 11=111 12=112 13=113 14=114 15=115 16=116

recode ethnicgroup 9=10 if othethgp==102 | othethgp==103
recode ethnicgroup 9=6 if othethgp==106 
recode ethnicgroup 9=13 if othethgp==109 | othethgp==116
recode ethnicgroup 9=12 if othethgp==113
recode ethnicgroup 9=14 if othethgp==115

tab ethnicgroup,m
tab othergp if ethnicgroup==9,m
list hid if othethgp==101
recode othethgp 101=112


* Grouping all eth gps together so can analyse against Diola
gen ethnotdiola=1 if ethnicgroup==1
recode ethnotdiola .=2 
tab ethnotdiola,m

label define notdiolalab 1 "Diola" 2 "Not Diola"
label values ethnotdiola notdiolalab
tab ethnotdiola,m

* Grouping eth gps that aren't dominant/sig together
gen ethsig=1 if ethnicgroup==1 
recode ethsig .=2 if ethnicgroup==2
recode ethsig .=3 if ethnicgroup==3
recode ethsig .=4 if ethnicgroup==9
recode ethsig .=4 if ethnicgroup==4
recode ethsig .=4 if ethnicgroup==6
recode ethsig .=4 if ethnicgroup==7 
recode ethsig .=4 if ethnicgroup==10
recode ethsig .=4 if ethnicgroup==12
recode ethsig .=4 if ethnicgroup==13
recode ethsig .=4 if ethnicgroup==14

tab ethsig,m
label define ethsiglab 1 "Diola" 2 "Peulh" 3 "Mandingue" 4 "Others"
label values ethsig ethsiglab
tab ethsig,m

* Occupation
tab occupation,m
label define occulab 1 "Agriculteur" 2 "Eleveur" 3 "Pecheur" 4 "Other" 5 "Commercant" 6 "Fonctionnaire" 7 "Enseignant" 8 "Informel" 9 "Sans activite" 
label values occupation occulab
tab occupation,m

list hid if occu==.
recode occupation .=1 if hid==700413 

tab otheroccupation if occupation==4

* Grouping occupation:
gen groupedoccu=1 if occupation==1
recode groupedoccu .=2 if occupation==5
recode groupedoccu .=3 if occupation==7
recode groupedoccu .=4 if occupation==9
recode groupedoccu .=5 

tab groupedoccu,m
label define gpocculab 1 "Agriculteur" 2 "Commercant" 3 "Enseignant" 4 "Sans Activite" 5 "Other"  
label values groupedoccu gpocculab
tab groupedoccu,m

* RECODING TEXT VARIABLES AND GROUPING THEM
* FIND IN ANALYSIS1.DO

* Monthly income & daily expense
tab monthly,m
tab daily,m

* Savings:
* Assume 30 days per month (Average)

gen savings = monthly/(daily*30)
tab savings,m

list monthly daily savings in f/10
list  hid monthly daily if savings==.

gen moneyaside=1 if savings<1
recode moneyaside .=2 if savings==1
recode moneyaside .=3 if savings>1

tab moneyaside,m
list  hid monthly daily moneyaside if savings==.

recode moneyaside 3=. if savings==.
tab moneyaside,m
label define moneylab 1 "Loss" 2 "Break even" 3 "Saving"
label values moneyaside moneylab
tab moneyaside,m

* School
tab school,m

list hid if school==.
* Confirmed missing

label define schlab 1 "Yes" 2 "No"
label values school schlab
tab school,m

tab schooltype,m
* 271 missing (1 missing, 270 didn't go to school)
label define schtypelab 1 "Primary"  2 "Secondary" 3 "University"
label values schooltype schtypelab

tab schooltype if school==1,m
tab schooltype if school==2,m
list hid schooltype if school==2 & schooltype~=.

recode schooltype 2=. if hid==101181 
recode schooltype 2=. if hid==320113  
* no more children who reached a class level without going to school

tab schooltype if school==1,m

* Latrine
tab latrine,m
list hid  if latrine==. 
* Both confirmed missing

label define latlab 1 "Yes" 2 "No"
label values latrine latlab
tab latrine,m

tab shared,m
* 100 missing (98 don't have latrine, 2 missing)
tab shared if latrine==1,m
* 0 missing
tab shared if latrine==2,m
* 98 missing

label define sharedlab 1 "Private" 2 "Shared"
label values shared sharedlab
tab shared if latrine==1,m

* Water source
tab watersource, m
list hid if watersource==.
* Confirmed missing

label define watlab 1 "Inside well" 2 "Inside tap" 3 "Uncovered outside well" 4 "Outside coevered well with pump" 5 "Outside tap" 6 "Other" 
label values watersource watlab
tab watersource, m

tab othersource if watersource==6,m
* Citerne = tank

* Time to water source
tab time,m
list hid if time==.
* 4 confirmed missing
recode time .=3 if hid==1600204

label define timelab 1 "Less than time for rice" 2 "Same as time for rice" 3 "More than time for rice" 
label values time timelab
tab time,m

sort hid

save risks, replace

*****************
/**********************************/
* 2. CLEAN ENUMERATION DATA TO GET UNIQUE IDs and number of people per hhold

clear
set mem 120m

insheet using tblenumeration.txt, clear

drop dosemg
drop dateoftreatment
drop takenornottaken
drop reasonnottaken

drop name
drop surname
drop alias

* split up the string variable variable at the '-' sign
* use destring option to create numeric variables
tab code,m
split code, p(-) destring
gen comid= (code1*1000)+code2
order code comid
label var comid "community id"
tab comid,m
* 5 missing

drop if comid==.

drop code1
drop code2

* Name communities:
label define comidlab 1008 "NIANKITE" 1011 "CAPARAN" 1016 "SUELLE ZONE 2"  /// 
2014 "DIACOYE COMBOLY" 2032 "BRINDIAGO" 3002 "BOUYEME" 3012 "MEDJEDJE ZONE 1" 3016 "COUROUCK" /// 
3019 "KAGNAROU ZONE 1" 3201 "SINDIAN ZONE 2" 3401 "SINDIAN ZONE 4" 4001 "MANGUILINE BELFORT ZONE 1" ///
4003 "MEDINA PLATEAU ZONE 1" 4004 "BASSENE ZONE 5" 4006 "ANIMATION ZONE 5" 4008 "CHATEAU DEAU ZONE 4" ///
5006 "DIARONE" 5019 "KOUTENGHOR" 5028 "SOUTOU" 5031 "TENGHORY 1 ZONE 1" 5035 "TENGHORY 5 ZONE 2" ///
6008 "MANDOUARD 2" 6016 "TOGHO" 6023 "OUONCK ZONE 2" 7004 "COUBALANG ZONE2" 7005 "COUBANAO ZONE 4" ///
7009 "FINTHIOCK ZONE 2" 8001 "TABI" 8010 "NIAMONE ZONE 1" 9001 "THIONCK ESSYL 1 ZONE 1" 9004 "THIONCK ESSYL 4 ZONE 3" ///
10002 "ELANA" 10007 "TENDOUCK ZONE 2" 11001 "BALINGOR ZONE 2" 12001 "KARTIACK ZONE 2" 12003 "DIANKI ZONE 2" ///
13001 "DIEGOUNE ZONE 2" 13003 "KAGNOBON ZONE 1" 14005 "MONGONE" 14011 "KABILINE ZONE 3" 14016 "KACARE" ///
14022 "EBINKINE ZONE 2" 15003 "DIANNAH ZONE 3" 15004 "ABENE ZONE 4" 15201 "KAFOUNTINE ZONE 2" /// 
15601 "KAFOUNTINE ZONE 6" 16002 "NIOMOUNE ZONE 2" 16003 "DIOGUE" 16006 "HITOU" 17002 "BADIONCOTO" ///
17010 "DARS SALAM CHERIF ZONE 2" 17015 "DJIBARA" 17020 "KATABA 2" 17028 "MACOUDA" ///
17037 "SELETY ZONE 1" 18004 "BASSENE MANDOUARD" 18016 "DIANGO" 18025 "GRAND KOULAYE" 18039 "MARGOUNE" 18044 "SILINKINE ZONE 2"
	
label values comid comidlab
tab comid, m

gen commune=.
replace commune = 1 if comid==1008 | comid==1011 | comid==1016
replace commune = 2 if comid==2014 | comid==2032
replace commune = 3 if comid==3002 | comid==3012 | comid==3016 | comid==3019 | comid==3201 | comid==3401
replace commune = 4 if comid==4001 | comid==4003 | comid==4004 | comid==4006 | comid==4008
replace commune = 5 if comid==5006 | comid==5019 | comid==5028 
replace commune = 6 if comid==5031 | comid==5035
replace commune = 7 if comid==6008 | comid==6016 | comid==6023
replace commune = 8 if comid==7004 | comid==7005 | comid==7009
replace commune = 9 if comid==8001 | comid==8010 
replace commune = 10 if comid==9001 | comid==9004
replace commune = 11 if comid==10002 | comid==10007 
replace commune = 12 if comid==11001 
replace commune = 13 if comid==12001 | comid==12003
replace commune = 14 if comid==13001 | comid==13003
replace commune = 15 if comid==14005 | comid==14011 | comid==14016 | comid==14022
replace commune = 16 if comid==15003 | comid==15004 | comid==15201 | comid==15601
replace commune = 17 if comid==16002 | comid==16003 | comid==16006
replace commune = 18 if comid==17002 | comid==17010 | comid==17015 | comid==17020 | comid==17028 | comid==17037
replace commune = 19 if comid==18004 | comid==18016 | comid==18025 | comid==18039 | comid==18044 

tab commune,m

label define communelab 1 "SUELLE" 2 "DJIBIDIONE" 3 "SINDIAN" 4 "BIGNONA" 5 "TENGHORI" 6 "TENGHORI TRANSGAMBIENNE"  /// 
7 "OUONCK" 8 "COUBALAN" 9 "NIAMONE" 10 "THIONCK-ESSYL" 11 "MANGAGOULACK" 12 "BALINGHOR"  /// 
13 "KARTHIACKK" 14 "DIEGOUNE" 15 "DJINAKY" 16 "KAFOUNTINE" 17 "ILES KARONE" 18 "DIOULOULOU" 19 "OULAMPANE" 
label values commune communelab
tab commune,m

tab comid,m 

* 'encode' creates a categorical variable assigning a # to each different entry

* need to get a unique hhno
gen hid=comid*100+householdnum
list comid householdnum hid in f/20

list idnumber in f/20
split idnumber, p(-)
egen uniqueid=concat(idnumber1 idnumber2 idnumber3 idnumber4)
destring uniqueid, replace
format uniqueid %13.0g
duplicates report uniqueid
duplicates list uniqueid
drop if uniqueid==.
drop idnumber*
list uniqueid in f/10


* Date of birth:

tab dateofbirth in f/10
split dateofbirth, p(/) 
desc dateofbirth

gen dayob=real(dateofbirth1)

list dateofbirth age uniqueid if dayob==. & age==.
count if dayob==. & age==.
* Confirmed all 48 are missing

tab dateofbirth3, m
desc dateofbirth3
* string variable
gen yrob=real(dateofbirth3)
* 1792 missing
tab yrob, m 

list yrob dateofbirth3 in f/10

list uniqueid if yrob==2010
 
 replace yrob=2009 if uniqueid==101602002

 list age yrob if uniqueid==1701008307
 list age in f/50 
 
 replace age=0 if uniqueid==1701008307
 replace dayob=. if uniqueid==1701008307
 replace yrob=. if uniqueid==1701008307
 
encode dateofbirth2, gen(mthob)
label list mthob
tab mthob, m
desc mthob

recode mthob 01=. if uniqueid==1701008307

gen dob=mdy(mthob, dayob, yrob)
format dob %d
drop dateofbirth*

tab dob in f/10

* Generate age variable:
rename date enumdate
list enumdate in f/10

gen datestr="01/01/2010"
gen refdate=date(datestr, "dmy")
format refdate %d
list datestr refdate in f/10
drop datestr

* clean this variable
split enumdate, p(/)
desc enumdate* 
gen dayenum=real(enumdate1)
tab dayenum,m

encode enumdate2, gen(mthenum)
tab mthenum , m
label list mthenum

recode mthenum 1=101 2=102 3=103 4=104 
recode mthenum 101=1 102=2 103=4 104=5
label drop mthenum

tab enumdate3, m
gen yrenum=real(enumdate3)
tab yrenum,m 

list uniqueid if yrenum==2011
recode yrenum 2011=2010
list uniqueid if yrenum==2020
recode yrenum 2020=2010


gen dateenum=mdy(mthenum, dayenum, yrenum)
format dateenum %d
drop enumdate*
tab dateenum,m

* Generate age for all people enumerated (whole village):
gen enumage=int((dateenum-dob)/365.25)
tab enumage, m
* 1793 missing (Should have a date of birth)

* Need to check that people don't have age AND dob:
count if enumage==. & age==.
* 48 people without ages 

* ID of those missing data:
list uniqueid age enumage if enumage==. & age==. 

* Check whether people have BOTH age and DOB:
count if enumage~=. & age~=. 
* None

* Need to separate out 10 year-olds with exact DOB
* and 10 year-olds that are 01/01/00

tab dob if enumage==10
* 41 children whose DOB is 01/01/00

tab enumage if dayob==01 & mthob==01 & yrob==2000
replace enumage = 9 if dayob==01 & mthob==01 & yrob==2000
* 41 changes made!!
tab enumage, m
* 1793 missing

list dob dateenum if enumage==10
* Fine. Those born in 1999 were examined after bday
* (i.e. those who are 10 YO, are definitely 10 YO)

* Combine age and enumage into one "age" variable:
desc age
desc enumage
* Enumage is numeric: float
* Age is numeric: byte 

gen allage=age
replace allage=enumage if age==.
tab allage,m
* 48 missing with no age

* Sex:
tab sex,m 
label define sexlab 1 "male" 2 "female"
label values sex sexlab
tab sex,m

sort uniqueid

save tblenum, replace

*****************

* 3. CLEAN CHILD DATA for risk factor analysis

insheet using "Child.txt", clear
describe

rename communitycode code
rename householdnumber hhno
rename enumerationnumber enno

split idnumber, p(-)
egen uniqueid=concat(idnumber1 idnumber2 idnumber3 idnumber4)
destring uniqueid, replace
format uniqueid %13.0g
duplicates report uniqueid
duplicates list uniqueid
drop if uniqueid==.
drop idnumber*

* split up the string variable variable at the '-' sign
* use destring option to create numeric variables

split code, p(-) destring
gen comid= (code1*1000)+code2
order code comid
label var comid "community id"

gen commune=.
replace commune = 1 if comid==1008 | comid==1011 | comid==1016
replace commune = 2 if comid==2014 | comid==2032
replace commune = 3 if comid==3002 | comid==3012 | comid==3016 | comid==3019 | comid==3201 | comid==3401
replace commune = 4 if comid==4001 | comid==4003 | comid==4004 | comid==4006 | comid==4008
replace commune = 5 if comid==5006 | comid==5019 | comid==5028 
replace commune = 6 if comid==5031 | comid==5035
replace commune = 7 if comid==6008 | comid==6016 | comid==6023
replace commune = 8 if comid==7004 | comid==7005 | comid==7009
replace commune = 9 if comid==8001 | comid==8010 
replace commune = 10 if comid==9001 | comid==9004
replace commune = 11 if comid==10002 | comid==10007 
replace commune = 12 if comid==11001 
replace commune = 13 if comid==12001 | comid==12003
replace commune = 14 if comid==13001 | comid==13003
replace commune = 15 if comid==14005 | comid==14011 | comid==14016 | comid==14022
replace commune = 16 if comid==15003 | comid==15004 | comid==15201 | comid==15601
replace commune = 17 if comid==16002 | comid==16003 | comid==16006
replace commune = 18 if comid==17002 | comid==17010 | comid==17015 | comid==17020 | comid==17028 | comid==17037
replace commune = 19 if comid==18004 | comid==18016 | comid==18025 | comid==18039 | comid==18044 

tab commune,m
label values commune communelab
tab commune,m

tab comid,m 


* 'encode' creates a categorical variable assigning a # to each different entry

* need to get a unique hhno
gen hid=comid*100+hhno

* Create age variable

desc age
* = byte (numeric)

* Age:
tab age,m
* 3895 missing
* 1744 have age


* Date of birth:
split dateofbirth, p(/) 
desc dateofbirth

tab dateofbirth1,m
gen dayob=real(dateofbirth1)
tab comid if dayob==.
* 1781 missing. 

tab dateofbirth3, m
* gen yrob1=real(dateofbirth3)+2000 if dateofbirth3==00 | dateofbirth3==01 | dateofbirth3==02 | dateofbirth3==03 | dateofbirth3==04 | dateofbirth3==05 | dateofbirth3==06
gen yrob=real(dateofbirth3)
tab yrob, m 
* 1792 missing. 

encode dateofbirth2, gen(mthob)
label list mthob
label drop mthob
tab mthob, m
* 1792 missing. 

gen dob=mdy(mthob, dayob, yrob)
format dob %d
drop dateofbirth*
list dob in f/10


* Calculate age: date of exam - date of birth
rename date examdate

*check format of date of interview variable
desc examdate
tab examdate,m

* clean this variable
split examdate, p(/)
desc examdate* 
gen dayexam=real(examdate1)
tab dayexam,m

encode examdate2, gen(mthexam)
tab mthexam , m
label list mthexam

recode mthexam 1=101 2=102 3=103 4=104 5=105 
recode mthexam 101=1 102=2 103=4 104=5 105=6 
label drop mthexam

tab examdate3, m
gen yrexam=real(examdate3)
tab yrexam,m 

gen dateexam=mdy(mthexam, dayexam, yrexam)
format dateexam %d
drop examdate*
tab dateexam,m

* 11 missing
list uniqueid if dateexam==.
* these are the 11 entries where no ocular forms found

drop if dateexam==.

* Generate age for all people enumerated (whole village):
gen enumage=int((dateexam-dob)/365.25)
tab enumage, m
* 1781 missing (Should have a date of birth)

* Need to check that people don't have age AND dob:
count if enumage==. & age==.
* 48 people without ages 

* ID of those missing data:
list comid hhno enno age enumage if enumage==. & age==. 

* these 48 people are missing age/DOB
drop if enumage==. & age==. 

* Check whether people have BOTH age and DOB:
count if enumage~=. & age~=. 
* None

* Need to separate out 10 year-olds with exact DOB
* and 10 year-olds that are 01/01/00

tab dob if enumage==10
* 41 children whose DOB is 01/01/00

tab enumage if dayob==01 & mthob==01 & yrob==2000
replace enumage = 9 if dayob==01 & mthob==01 & yrob==2000
* 41 changes made!!
tab enumage, m
* 1733 missing

list dob dateexam if enumage==10
* Fine. Those born in 1999 were examined after bday
* (i.e. those who are 10 YO, are definitely 10 YO)

* Combine age and enumage into one "age" variable:
desc age
desc enumage
* Enumage is numeric: float
* Age is numeric: byte 

gen allage=age
replace allage=enumage if age==.
tab allage,m

gen agegp=allage
recode agegp 0=0 1/9=1 10/14=2 15/19=3 20/29=4 30/39=5 40/49=6 50/59=7 60/max=8 
tab agegp,m
label define agegplab 0 "0" 1 "1-9" 2 "10-14" 3 "15-19" 4 "20-29" 5 "30-39" 6 "40-49" 7 "50-59" 8 "60+" 
label values agegp agegplab
tab agegp,m

gen chagegp=0 if allage==0
recode chagegp .=1 if allage==1 | allage==2
recode chagegp .=2 if allage==3 | allage==4 | allage==5
recode chagegp .=3 if allage==6 | allage==7 | allage==8 | allage==9 
tab chagegp ,m
recode chagegp 0=100 1=101 2=102 3=103
recode chagegp 100=3 101=2 102=1 103=0
label define agecat2lab 0 "6-9 years" 1 "3-5 years" 2 "1-2 years" 3 "0 years"
label values chagegp agecat2lab
tab chagegp ,m

gen trachage=agegp
recode trachage 2=104 3=102 4=102 5=102 6=102 7=103 8=103
recode trachage 102=2 103=3 104=4
tab trachage,m 
label define trachagelab 0 "0" 1 "1-9" 2 "15-49" 3 "50+" 4 "10-14"
label values trachage trachagelab 
tab trachage,m

* generate child = age
* recode to indicate adult or child
* USE THIS VARIABLE LATER when calculating number of children & adults/hhold

gen child=allage
recode child min/9=1 10/max=0
label define childlab 1 "Child" 0 "Adult"
label values child childlab
tab child,m

* Look at sex distribution
tab sex,m 
label values sex sexlab
tab sex,m

capture drop yesno
label define yesno 0 "No" 1 "Yes" 4 "no invert / NA"

label define complete 1 "Complete" 2 "Incomplete" 3 "Refused" 4 "Absent"

* These variables are string variables
* Recode risk variables to become numerical 0=no and 1=yes
tab isfacedirty, m
desc isfacedirty
encode isface, gen(fdir)
label list fdir
recode fdir 1=0 2=1
label values fdir yesno
tab isface fdir,m
drop isface
label var fdir "is face dirty"

tab ocu, m
desc ocu
encode ocu, gen(ocdis)
label list ocdis
label list yesno
recode ocdis 1=0 2=1
label values ocdis yesno
tab ocular ocdis,m
drop ocular

tab nasal, m
desc nasal
encode nasal, gen(nasdis)
label list nasdis
label list yesno
recode nasdis 1=0 2=1
label values nasdis yesno
tab nasal nasdis,m
drop nasal

tab fliesonface, m
encode fliesonface, gen(flies)
label list flies
label list yesno
recode flies 1=0 2=1
label values flies yesno
tab fliesonface flies,m
drop fliesonface

*** Combining the "unclean face" variables:
gen unclean=0 if fdir==0 & nasdis==0 & ocdis==0 & flies==0
recode unclean .=1 if fdir==1 | nasdis==1 | ocdis==1 | flies==1
tab unclean,m

*recode and label clinical signs into yesno variables
tab rtf, m
label values rtf yesno
label var rtf "rt eye tf"
tab rtf, m

tab rti, m
label values rti yesno
label var rti "rt eye ti"
tab rti, m

tab rts, m
label values rts yesno
label var rts "rt eye ts"
tab rts, m

tab rtt, m
label values rtt yesno
label var rtt "rt eye tt"
tab rtt, m

tab rco, m
label values rco yesno
label var rco "rt eye co"

tab ltf, m
label values ltf yesno
label var ltf "lft eye tf"

tab lti, m
label values lti yesno
label var lti "lft eye ti"

tab lts, m
label values lts yesno
label var lts "lft eye ts"

tab ltt, m
label values ltt yesno
label var ltt "lft eye tt"

tab lco, m
label values lco yesno
label var lco "lft eye co"

* Name communities:
label values comid comidlab
tab comid, m

* DATA CLEANING * 
* These mistakes were found later on, but changing them now means
* don't have to recoded EVERYTHING in subsequent commands


*  |   uniqueid   trachage |
 * |-----------------------|
 * |  100804205          0 | Couldn't evert eyelids (TF, TI, TS)
 list rtf rti rts rtt rco if uniqueid==100804205
 list ltf lti lts ltt lco if uniqueid==100804205
 * OK now
 
 * |  203203702        50+ | Coded 0 for all trachoma, no VA
 list rtf rti rts rtt rco if uniqueid==203203702
 list ltf lti lts ltt lco if uniqueid==203203702
 recode ltf 4=0 if uniqueid==203203702
 recode lti 4=0 if uniqueid==203203702
 recode lts 4=0 if uniqueid==203203702
 recode ltt 4=0 if uniqueid==203203702
 recode lco 4=0 if uniqueid==203203702
 
  * |  320100534        50+ |VA incl. RE: All 0. LE: Change to unable to evert
 list rtf rti rts rtt rco if uniqueid==320100534
 list ltf lti lts ltt lco if uniqueid==320100534
* Sorted out below

 * |  400100111      10-14 | RE: All 0. LE TF, TI, TS unable to evert
 list rtf rti rts rtt rco if uniqueid==400100111
 list ltf lti lts ltt lco if uniqueid==400100111
* Sorted out below

 * |  400107707          0 | Unable to evert both eyes
 list rtf rti rts rtt rco if uniqueid==400107707
 list ltf lti lts ltt lco if uniqueid==400107707
* OK now

 * |  400603203      15-49 |RE: Can't evert eyelid. LE=All 0
 list rtf rti rts rtt rco if uniqueid==400603203
 list ltf lti lts ltt lco if uniqueid==400603203
* Sorted out below
 
 * |  502804706          0 |Couldn't evert either eyelid
 list rtf rti rts rtt rco if uniqueid==502804706
 list ltf lti lts ltt lco if uniqueid==502804706
* OK now
 
 * |  502804707        50+ |Couldn't evert either eyelid. Has VA
 list rtf rti rts rtt rco if uniqueid==502804707
 list ltf lti lts ltt lco if uniqueid==502804707
* OK now
 
 * |  502804802      15-49 |Code 0 for all trachoma both eyes
list rtf rti rts rtt rco if uniqueid==502804802
list ltf lti lts ltt lco if uniqueid==502804802
recode rtf .=0 if uniqueid==502804802
recode rti .=0 if uniqueid==502804802
recode rts .=0 if uniqueid==502804802
recode rtt .=0 if uniqueid==502804802
recode rco 1=0 if uniqueid==502804802

 * |  600800407          0 |Couldn't evert either eyelid. 
list rtf rti rts rtt rco if uniqueid==600800407
list ltf lti lts ltt lco if uniqueid==600800407
* OK now

 * |  600802301        50+ |VA missing. Couldn't evert RE. Left all 0 except CO=1
list rtf rti rts rtt rco if uniqueid==600802301
list ltf lti lts ltt lco if uniqueid==600802301
* Sorted out below
  
* |  602300916          0 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==602300916
list ltf lti lts ltt lco if uniqueid==602300916
* OK now

 * |  602300919      15-49 |LE could't evert, TT+CO=1. RE = All 0
list rtf rti rts rtt rco if uniqueid==602300919
list ltf lti lts ltt lco if uniqueid==602300919
* Sorted out below
 
 * |  700401309        1-9 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700401309
list ltf lti lts ltt lco if uniqueid==700401309
 * OK now

 * |  700401402      15-49 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700401402
list ltf lti lts ltt lco if uniqueid==700401402
 * OK now

 * |  700401710        1-9 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700401710
list ltf lti lts ltt lco if uniqueid==700401710
 * OK now
 
 * |  700504418          0 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700504418
list ltf lti lts ltt lco if uniqueid==700504418
 * OK now
 
 * |  700509607          0 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700509607
list ltf lti lts ltt lco if uniqueid==700509607
 * OK now

 * |  700903904        50+ |Has VA. Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700903904
list ltf lti lts ltt lco if uniqueid==700903904
 * OK now
 
 * |  700903905        1-9 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700903905
list ltf lti lts ltt lco if uniqueid==700903905
 * OK now
 
 * |  700903906        1-9 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==700903906
list ltf lti lts ltt lco if uniqueid==700903906
 * OK now
 
 * |  800109508        1-9 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==800109508
list ltf lti lts ltt lco if uniqueid==800109508
 * OK now
 
 * |  800109715        1-9 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==800109715
list ltf lti lts ltt lco if uniqueid==800109715
 * OK now
 
 * | 1400501002        50+ |RE=All 0. LE=CO (other=0). Has VA
list rtf rti rts rtt rco if uniqueid==1400501002
list ltf lti lts ltt lco if uniqueid==1400501002
recode ltf .=0 if uniqueid==1400501002
recode lti .=0 if uniqueid==1400501002
recode lts .=0 if uniqueid==1400501002
recode ltt .=0 if uniqueid==1400501002

 * | 1702003109        50+ |Has VA. Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==1702003109
list ltf lti lts ltt lco if uniqueid==1702003109
 * OK now
 
 * | 1800400305      15-49 |RE: Couldn't evert. LE=All 0. Has VA.
list rtf rti rts rtt rco if uniqueid==1800400305
list ltf lti lts ltt lco if uniqueid==1800400305
* Sorted out below

 * | 1802501016      10-14 |Couldn't evert either eyelid.
list rtf rti rts rtt rco if uniqueid==1802501016
list ltf lti lts ltt lco if uniqueid==1802501016
 * OK now

 * | 1803900201        50+ |Couldn't evert either eyelid. Has VA.
list rtf rti rts rtt rco if uniqueid==1803900201
list ltf lti lts ltt lco if uniqueid==1803900201
 * OK now

 *  | 1804400618        1-9 |Couldn't evert LE. RE=All 0.
list rtf rti rts rtt rco if uniqueid==1804400618
list ltf lti lts ltt lco if uniqueid==1804400618
* Sorted out below


* CLINICAL SIGNS CODING
* TO HAVE 1. RTF ONLY, 2. LTF ONLY AND 3.TF BOTH EYES 
* AND 4. NO TF EITHER EYE
* WITH DENOMINATOR TOTAL PEOPLE WITH/WITHOUT ANY TF

gen tf=1 if rtf==1 & ltf==1
recode tf .=2 if rtf==1 & ltf~=1
recode tf .=3 if ltf==1 & rtf~=1
recode tf .=4 if ltf==0 & rtf==0
recode tf .=9 if ltf==4 & rtf==4
tab tf,m

gen ti=1 if rti==1 & lti==1
recode ti .=2 if rti==1 & lti~=1
recode ti .=3 if lti==1 & rti~=1
recode ti .=4 if lti==0 & rti==0
recode ti .=9 if ltf==4 & rtf==4

gen ts=1 if rts==1 & lts==1
recode ts .=2 if rts==1 & lts~=1
recode ts .=3 if lts==1 & rts~=1
recode ts .=4 if lts==0 & rts==0
recode ts .=9 if ltf==4 & rtf==4

gen tt=1 if rtt==1 & ltt==1
recode tt .=2 if rtt==1 & ltt~=1
recode tt .=3 if ltt==1 & rtt~=1
recode tt .=4 if ltt==0 & rtt==0
recode tt .=9 if ltf==4 & rtf==4

gen co=1 if rco==1 & lco==1
recode co .=2 if rco==1 & lco~=1
recode co .=3 if lco==1 & rco~=1
recode co .=4 if lco==0 & rco==0
recode co .=9 if ltf==4 & rtf==4

label define tflab 1 "TF both eyes" 2 "TF RT only" 3 "TF LT only" 4 "TF neither eye" 9 "Couldn't evert eyelid"
label list tflab

label define tilab 1 "TI both eyes" 2 "TI RT only" 3 "TI LT only" 4 "TI neither eye" 9 "Couldn't evert eyelid"
label list tilab

label define tslab 1 "TS both eyes" 2 "TS RT only" 3 "TS LT only" 4 "TS neither eye" 9 "Couldn't evert eyelid"
label list tslab

label define ttlab 1 "TT both eyes" 2 "TT RT only" 3 "TT LT only" 4 "TT neither eye" 9 "Couldn't evert eyelid"
label list ttlab

label define colab 1 "CO both eyes" 2 "CO RT only" 3 "CO LT only" 4 "CO neither eye" 9 "Couldn't evert eyelid"
label list colab

label values tf tflab 
label values ti tilab 
label values ts tslab 
label values tt ttlab 
label values co colab 

tab tf,m
tab ti,m
tab ts,m
tab tt,m
tab co,m

list uniqueid tf ti ts tt co if tf==9 & tt==9

* CREATE VARIABLE OF CLINICAL SIGN IN EITHER AND/OR BOTH EYES
gen anytf=1 if tf==1 | tf==2 | tf==3
recode anytf .=0 if tf==4
recode anytf .=9 if tf==9

gen anyti=1 if ti==1 | ti==2 | ti==3
recode anyti .=0 if ti==4
recode anyti .=9 if ti==9

gen anyts=1 if ts==1 | ts==2 | ts==3
recode anyts .=0 if ts==4
recode anyts .=9 if ts==9

gen anytt=1 if tt==1 | tt==2 | tt==3
recode anytt .=0 if tt==4
recode anytt .=9 if tt==9

gen anyco=1 if co==1 | co==2 | co==3
recode anyco .=0 if co==4
recode anyco .=9 if co==9

gen activedis=1 if tf==1 | tf==2 | tf==3 | ti==1 | ti==2 | ti==3
recode activedis .=0 if tf==4 & ti==4
recode activedis .=9 if tf==9 & ti==9

label define anytflab 1 "TF either/both eyes" 0 "No TF" 9 "Couldn't evert eyelid"
label values anytf anytflab 

label define anytilab 1 "TI either/both eyes" 0 "No TI" 9 "Couldn't evert eyelid"
label values anyti anytilab 

label define anytslab 1 "TS either/both eyes" 0 "No TS" 9 "Couldn't evert eyelid"
label values anyts anytslab 

label define anyttlab 1 "TT either/both eyes" 0 "No TT" 9 "Couldn't evert eyelid"
label values anytt anyttlab

label define anycolab 1 "CO either/both eyes" 0 "No CO" 9 "Couldn't evert eyelid"
label values anyco anycolab

label define activedislab 1 "Active disease" 0 "No active disease" 9 "Couldn't evert eyelid"
label values activedis activedislab 

tab anytf,m
tab anyti,m
tab anyts,m
tab anytt,m
tab anyco,m
tab activedis,m
tab activedis anytf,m

gen unilat=.
recode unilat .=1 if tf==2 | tf==3 | ti==2 | ti==3
recode unilat .=0
tab unilat,m 
label define unilab 0 "No or bilateral AT" 1 "Unilateral"
label value unilat unilab
tab unilat,m 

tab activedis unilat,m row

* Cross-tab to check exam status 
tab notexamined activedis, m
* 555 "absent"
* 12 "refused"
* 8 "Other"

label define notexamlab 1 "Absent" 2 "Refused" 3 "Other reason"
label values notexamined notexamlab
tab notexamined activedis, m
tab notexamined activedis
* Good: No person with active disease and said to not be examined


tab notexamined anytt, m

tab trachage,m
* Labelling is: 0 "0" 1 "1-9" 2 "15-49" 3 "50+" 4 "10-14"

* Prevalence of TF in 1-9 year-olds:
label define tf2lab 0 "No" 1 "Yes" 9 "Couldn't evert eyelid"
label values anytf tf2lab

tab comid anytf if trachage==1, row

* This will help identify data entry mistakes:
tab commune anytf if trachage==1 & notexamined==., row m
* 1 in commune Oulampane
list uniqueid if trachage==1 & notexamined==. & anytf==.
* 1804400618

list uniqueid trachage if anytf==. & notexamined==., noobs
* The only one in 1-9 year age group = 1804400618  
* = Silinkine
list rtf rti rts rtt rco if uniqueid==1804400618
list ltf lti lts ltt lco if uniqueid==1804400618

list tf  if uniqueid==1804400618
list anytf  if uniqueid==1804400618
* Change to "Can't evert eyelid" so that doesn't appear as missing
* but don't know what clinical sign was in one eye

recode tf .=9 if uniqueid==1804400618 
recode ti .=9 if uniqueid==1804400618 
recode ts .=9 if uniqueid==1804400618 
recode tt .=9 if uniqueid==1804400618 
recode co .=9 if uniqueid==1804400618 

recode anytf .=9 if uniqueid==1804400618
recode anyti .=9 if uniqueid==1804400618 
recode anyts .=9 if uniqueid==1804400618 
recode anytt .=9 if uniqueid==1804400618 
recode anyco .=9 if uniqueid==1804400618 

recode activedis .=9 if uniqueid==1804400618 

***** REST OF CLEANING DONE ABOVE! (just before clinical sign coding) *****

* Other people where change to "Can't evert eyelid" so that doesn't appear as missing
* but don't know what clinical sign was in one eye
*
recode tf .=9 if uniqueid==320100534 
recode ti .=9 if uniqueid==320100534 
recode ts .=9 if uniqueid==320100534 
recode tt .=9 if uniqueid==320100534 
recode co .=9 if uniqueid==320100534 

recode anytf .=9 if uniqueid==320100534
recode anyti .=9 if uniqueid==320100534 
recode anyts .=9 if uniqueid==320100534 
recode anytt .=9 if uniqueid==320100534 
recode anyco .=9 if uniqueid==320100534 

recode activedis .=9 if uniqueid==320100534 

*
recode tf .=9 if uniqueid==400100111 
recode ti .=9 if uniqueid==400100111 
recode ts .=9 if uniqueid==400100111 
recode tt .=9 if uniqueid==400100111 
recode co .=9 if uniqueid==400100111 

recode anytf .=9 if uniqueid==400100111
recode anyti .=9 if uniqueid==400100111 
recode anyts .=9 if uniqueid==400100111 
recode anytt .=9 if uniqueid==400100111 
recode anyco .=9 if uniqueid==400100111 

recode activedis .=9 if uniqueid==400100111 

*
recode tf .=9 if uniqueid==400603203 
recode ti .=9 if uniqueid==400603203 
recode ts .=9 if uniqueid==400603203 
recode tt .=9 if uniqueid==400603203 
recode co .=9 if uniqueid==400603203 

recode anytf .=9 if uniqueid==400603203
recode anyti .=9 if uniqueid==400603203 
recode anyts .=9 if uniqueid==400603203 
recode anytt .=9 if uniqueid==400603203 
recode anyco .=9 if uniqueid==400603203 

recode activedis .=9 if uniqueid==400603203 

*
recode tf .=9 if uniqueid==600802301 
recode ti .=9 if uniqueid==600802301 
recode ts .=9 if uniqueid==600802301 
recode tt .=9 if uniqueid==600802301 
recode co .=9 if uniqueid==600802301 

recode anytf .=9 if uniqueid==600802301
recode anyti .=9 if uniqueid==600802301 
recode anyts .=9 if uniqueid==600802301 
recode anytt .=9 if uniqueid==600802301 
recode anyco .=9 if uniqueid==600802301 

recode activedis .=9 if uniqueid==600802301 

*
recode tf .=9 if uniqueid==602300919 
recode ti .=9 if uniqueid==602300919 
recode ts .=9 if uniqueid==602300919 
recode tt .=9 if uniqueid==602300919 
recode co .=9 if uniqueid==602300919 

recode anytf .=9 if uniqueid==602300919
recode anyti .=9 if uniqueid==602300919 
recode anyts .=9 if uniqueid==602300919 
recode anytt .=9 if uniqueid==602300919 
recode anyco .=9 if uniqueid==602300919 

recode activedis .=9 if uniqueid==602300919

*
recode tf .=9 if uniqueid==1800400305 
recode ti .=9 if uniqueid==1800400305 
recode ts .=9 if uniqueid==1800400305 
recode tt .=9 if uniqueid==1800400305 
recode co .=9 if uniqueid==1800400305 

recode anytf .=9 if uniqueid==1800400305
recode anyti .=9 if uniqueid==1800400305 
recode anyts .=9 if uniqueid==1800400305 
recode anytt .=9 if uniqueid==1800400305 
recode anyco .=9 if uniqueid==1800400305 

recode activedis .=9 if uniqueid==1800400305

*
recode tf .=9 if uniqueid==1804400618 
recode ti .=9 if uniqueid==1804400618 
recode ts .=9 if uniqueid==1804400618 
recode tt .=9 if uniqueid==1804400618 
recode co .=9 if uniqueid==1804400618 

recode anytf .=9 if uniqueid==1804400618
recode anyti .=9 if uniqueid==1804400618 
recode anyts .=9 if uniqueid==1804400618 
recode anytt .=9 if uniqueid==1804400618 
recode anyco .=9 if uniqueid==1804400618 

recode activedis .=9 if uniqueid==1804400618

* Check data cleaning:
list uniqueid trachage if anytf==. & notexamined==., noobs
* Good. None left.

***
tab comid anytt if trachage==2 | trachage==3, row

* Checking for missing data:
tab commune anytt if (trachage==2 | trachage==3) & notexamined==., row m
*  0 problems!

list uniqueid trachage if anytt==. & notexamined==., noobs
*  0 problems!


** CODING FOR VISUAL ACUITY

tab  snellenrighttop if trachage==3,m 
tab snellenrightbottom if trachage==3,m 

desc snellenrightbottom
* string  - need to make numerical
* 06016 004 01 has 9F - NOW REMOVED
* Now byte - numerical

desc snellenrighttop
* byte - numerical

tab snellenrighttop snellenrightbottom if trachage==3,m 

** FROM THIS TABLE:
* work out frequency of different combinations
* turn these combinations into a code that means something (logmar?)

tab snellenlefttop snellenleftbottom if trachage==3,m 

**Cleaning:

* RIGHT EYE:
list uniqueid if snellenrighttop==0 & snellenrightbottom==6
recode snellenrighttop 0=6 if uniqueid==1802502212 

list uniqueid if snellenrighttop==1 & snellenrightbottom==6
recode snellenrightbottom 6=60 if uniqueid==400408103 
recode snellenrightbottom 6=60 if uniqueid==1600203505 

list uniqueid if snellenrighttop==2 & snellenrightbottom==6
recode snellenrightbottom 6=60 if uniqueid==400106509  

list uniqueid if snellenrighttop==2 & snellenrightbottom==10
recode snellenrightbottom 10=36 if uniqueid==400100103   
recode snellenrighttop 2=6 if uniqueid==400100103   

list uniqueid if snellenrighttop==3 & snellenrightbottom==6
recode snellenrightbottom 6=60 if uniqueid==601600709
recode snellenrightbottom 6=60 if uniqueid==1702800306 

list uniqueid if snellenrighttop==4 & snellenrightbottom==6
recode snellenrightbottom 6=18 if uniqueid==400102801   
recode snellenrighttop 4=6 if uniqueid==400102801 

recode snellenrightbottom 6=18 if uniqueid==601600704   
recode snellenrighttop 4=6 if uniqueid==601600704 

recode snellenrightbottom 6=18 if uniqueid==601600705   
recode snellenrighttop 4=6 if uniqueid==601600705 

recode snellenrightbottom 6=18 if uniqueid==800102505   
recode snellenrighttop 4=6 if uniqueid==800102505 

recode snellenrightbottom 6=18 if uniqueid==800104901   
recode snellenrighttop 4=6 if uniqueid==800104901 

recode snellenrightbottom 6=18 if uniqueid==800104906   
recode snellenrighttop 4=6 if uniqueid==800104906 

recode snellenrightbottom 6=18 if uniqueid==1802502213   
recode snellenrighttop 4=6 if uniqueid==1802502213 

recode snellenrightbottom 6=18 if uniqueid==1803903001   
recode snellenrighttop 4=6 if uniqueid==1803903001 

list uniqueid if snellenrighttop==5 & snellenrightbottom==6
recode snellenrightbottom 6=60 if uniqueid==400101401  
recode snellenrighttop 5=6 if uniqueid==400101401 

recode snellenrightbottom 6=60 if uniqueid==400102802 
recode snellenrighttop 5=6 if uniqueid==400102802

recode snellenrightbottom 6=60 if uniqueid==400109001  
recode snellenrighttop 5=6 if uniqueid==400109001

list uniqueid if snellenrighttop==6 & snellenrightbottom==1
recode snellenrightbottom 1=12 if uniqueid==1600202304  

list uniqueid if snellenrighttop==6 & snellenrightbottom==8
recode snellenrightbottom 8=18 if uniqueid==1500402501  
recode snellenrightbottom 8=18 if uniqueid==1560111317  

list uniqueid if snellenrighttop==9 & snellenrightbottom==6
recode snellenrighttop 9=6 if uniqueid==602302313
recode snellenrightbottom 6=9 if uniqueid==602302313

recode snellenrighttop 9=6 if uniqueid==602302501
recode snellenrightbottom 6=9 if uniqueid==602302501

recode snellenrighttop 9=6 if uniqueid==800108601
recode snellenrightbottom 6=9 if uniqueid==800108601

recode snellenrighttop 9=6 if uniqueid==800108605
recode snellenrightbottom 6=9 if uniqueid==800108605

recode snellenrighttop 9=6 if uniqueid==900102201
recode snellenrightbottom 6=9 if uniqueid==900102201

recode snellenrighttop 9=6 if uniqueid==1000208701
recode snellenrightbottom 6=9 if uniqueid==1000208701

recode snellenrighttop 9=6 if uniqueid==1000208704
recode snellenrightbottom 6=9 if uniqueid==1000208704

recode snellenrighttop 9=6 if uniqueid==1400500508
recode snellenrightbottom 6=9 if uniqueid==1400500508

recode snellenrighttop 9=6 if uniqueid==1401102701 
recode snellenrightbottom 6=9 if uniqueid==1401102701 

recode snellenrighttop 9=6 if uniqueid==1500404601
recode snellenrightbottom 6=9 if uniqueid==1500404601

recode snellenrighttop 9=6 if uniqueid==1520112201
recode snellenrightbottom 6=9 if uniqueid==1520112201

list uniqueid if snellenrighttop==9 & snellenrightbottom==60
recode snellenrighttop 9=6 if uniqueid==602302201
recode snellenrightbottom 60=9 if uniqueid==602302201

list uniqueid if snellenrighttop==10 & snellenrightbottom==10
recode snellenrighttop 10=6 if uniqueid==400100101
recode snellenrightbottom 10=6 if uniqueid==400100101

list uniqueid if snellenrighttop==12 & snellenrightbottom==6
recode snellenrighttop 12=6 if uniqueid==1802505307 
recode snellenrightbottom 6=12 if uniqueid==1802505307 

list uniqueid if snellenrighttop==18 & snellenrightbottom==6
recode snellenrighttop 18=6 if uniqueid==500600201
recode snellenrightbottom 6=18 if uniqueid==500600201

recode snellenrighttop 18=6 if uniqueid==1700201902
recode snellenrightbottom 6=18 if uniqueid==1700201902

recode snellenrighttop 18=6 if uniqueid==1701001703
recode snellenrightbottom 6=18 if uniqueid==1701001703

recode snellenrighttop 18=6 if uniqueid==1802504302
recode snellenrightbottom 6=18 if uniqueid==1802504302

list uniqueid if snellenrighttop==18 & snellenrightbottom==60
recode snellenrighttop 18=6 if uniqueid==1300304002 
recode snellenrightbottom 60=18 if uniqueid==1300304002 

list uniqueid if snellenrighttop==24 & snellenrightbottom==6
recode snellenrighttop 24=6 if uniqueid==1402203128
recode snellenrightbottom 6=24 if uniqueid==1402203128

recode snellenrighttop 24=6 if uniqueid==1703700806
recode snellenrightbottom 6=24 if uniqueid==1703700806

* LEFT EYE:
list uniqueid if snellenlefttop==0 & snellenleftbottom==6
recode snellenlefttop 0=6 if uniqueid==400408103
recode snellenlefttop 0=6 if uniqueid==1802502212

list uniqueid if snellenlefttop==1 & snellenleftbottom==6
recode snellenleftbottom 6=60 if uniqueid==1600203505 

list uniqueid if snellenlefttop==3 & snellenleftbottom==6
recode snellenleftbottom 6=60 if uniqueid==400106509
recode snellenleftbottom 6=60 if uniqueid==601600704 
recode snellenleftbottom 6=60 if uniqueid==601600709 
recode snellenleftbottom 6=60 if uniqueid==1702800306 

list uniqueid if snellenlefttop==4 & snellenleftbottom==6
recode snellenlefttop 4=6 if uniqueid==400101401
recode snellenleftbottom 6=18 if uniqueid==400101401

recode snellenlefttop 4=6 if uniqueid==1803903001
recode snellenleftbottom 6=18 if uniqueid==1803903001

list uniqueid if snellenlefttop==5 & snellenleftbottom==6
recode snellenlefttop 5=6 if uniqueid==400102801
recode snellenleftbottom 6=12 if uniqueid==400102801

recode snellenlefttop 5=6 if uniqueid==400106501
recode snellenleftbottom 6=12 if uniqueid==400106501

recode snellenlefttop 5=6 if uniqueid==400109001 
recode snellenleftbottom 6=12 if uniqueid==400109001 

recode snellenlefttop 5=6 if uniqueid==601600705
recode snellenleftbottom 6=12 if uniqueid==601600705

recode snellenlefttop 5=6 if uniqueid==800102505
recode snellenleftbottom 6=12 if uniqueid==800102505

recode snellenlefttop 5=6 if uniqueid==800104901
recode snellenleftbottom 6=12 if uniqueid==800104901

recode snellenlefttop 5=6 if uniqueid==800104906
recode snellenleftbottom 6=12 if uniqueid==800104906

recode snellenlefttop 5=6 if uniqueid==1520106608
recode snellenleftbottom 6=12 if uniqueid==1520106608

recode snellenlefttop 5=6 if uniqueid==1802502213
recode snellenleftbottom 6=12 if uniqueid==1802502213

list uniqueid if snellenlefttop==6 & snellenleftbottom==1
recode snellenleftbottom 1=60 if uniqueid==1600202304 

list uniqueid if snellenlefttop==6 & snellenleftbottom==5
recode snellenleftbottom 5=12 if uniqueid==400103101

list uniqueid if snellenlefttop==9 & snellenleftbottom==6
recode snellenlefttop 9=6 if uniqueid==503108202 
recode snellenleftbottom 6=9 if uniqueid==503108202 

recode snellenlefttop 9=6 if uniqueid==602302313 
recode snellenleftbottom 6=9 if uniqueid==602302313 

recode snellenlefttop 9=6 if uniqueid==602302501
recode snellenleftbottom 6=9 if uniqueid==602302501

recode snellenlefttop 9=6 if uniqueid==1300103701
recode snellenleftbottom 6=9 if uniqueid==1300103701

recode snellenlefttop 9=6 if uniqueid==1500404620
recode snellenleftbottom 6=9 if uniqueid==1500404620

recode snellenlefttop 9=6 if uniqueid==1520106607
recode snellenleftbottom 6=9 if uniqueid==1520106607

recode snellenlefttop 9=6 if uniqueid==1520112205
recode snellenleftbottom 6=9 if uniqueid==1520112205


list uniqueid if snellenlefttop==10 & snellenleftbottom==10
recode snellenlefttop 10=6 if uniqueid==400100101
recode snellenleftbottom 10=6 if uniqueid==400100101

recode snellenlefttop 10=6 if uniqueid==400100103
recode snellenleftbottom 10=6 if uniqueid==400100103

list uniqueid if snellenlefttop==12 & snellenleftbottom==6
recode snellenlefttop 12=6 if uniqueid==800108601
recode snellenleftbottom 6=12 if uniqueid==800108601

recode snellenlefttop 12=6 if uniqueid==1000208704 
recode snellenleftbottom 6=12 if uniqueid==1000208704 

recode snellenlefttop 12=6 if uniqueid==1400500508
recode snellenleftbottom 6=12 if uniqueid==1400500508

recode snellenlefttop 12=6 if uniqueid==1700201902
recode snellenleftbottom 6=12 if uniqueid==1700201902

recode snellenlefttop 12=6 if uniqueid==1802504302
recode snellenleftbottom 6=12 if uniqueid==1802504302

recode snellenlefttop 12=6 if uniqueid==1802505307
recode snellenleftbottom 6=12 if uniqueid==1802505307


list uniqueid if snellenlefttop==12 & snellenleftbottom==60
recode snellenlefttop 12=6 if uniqueid==1300304002 
recode snellenleftbottom 60=12 if uniqueid==1300304002 

list uniqueid if snellenlefttop==18 & snellenleftbottom==6
recode snellenlefttop 18=6 if uniqueid==500600201 
recode snellenleftbottom 6=18 if uniqueid==500600201 

list uniqueid if snellenlefttop==36 & snellenleftbottom==6
recode snellenlefttop 36=6 if uniqueid==1402203128 
recode snellenleftbottom 6=36 if uniqueid==1402203128

recode snellenlefttop 36=6 if uniqueid==1701001703 
recode snellenleftbottom 6=36 if uniqueid==1701001703

recode snellenlefttop 36=6 if uniqueid==1703700806 
recode snellenleftbottom 6=36 if uniqueid==1703700806

*****
* These recodings come from missing data identified below:

* |  301201408        50+ |Just says "24" for both. Assume it means 6/24
recode snellenlefttop .=6 if uniqueid==301201408 
recode snellenleftbottom .=24 if uniqueid==301201408

recode snellenrighttop .=6 if uniqueid==301201408 
recode snellenrightbottom .=24 if uniqueid==301201408

 * | 1400500501        50+ |LE only, 24/6
list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1400500501
recode snellenlefttop .=6 if uniqueid==1400500501 
recode snellenleftbottom .=24 if uniqueid==1400500501

 * | 1500301820        50+ |36/6 for both eyes
list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1500301820
recode snellenlefttop .=6 if uniqueid==1500301820 
recode snellenleftbottom .=36 if uniqueid==1500301820

recode snellenrighttop .=6 if uniqueid==1500301820 
recode snellenrightbottom .=36 if uniqueid==1500301820

 * | 1500304902        50+ |6/6 for both eyes
 list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1500304902
recode snellenlefttop .=6 if uniqueid==1500304902 
recode snellenleftbottom .=6 if uniqueid==1500304902

recode snellenrighttop .=6 if uniqueid==1500304902 
recode snellenrightbottom .=6 if uniqueid==1500304902

 * | 1500306601        50+ |6/6 for both eyes
list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1500306601

recode snellenlefttop .=6 if uniqueid==1500306601 
recode snellenleftbottom .=6 if uniqueid==1500306601

recode snellenrighttop .=6 if uniqueid==1500306601 
recode snellenrightbottom .=6 if uniqueid==1500306601

*  | 1600301607        50+ |RE: CLD 4m, LE: PL+
list snellenleftcode if uniqueid==1600301607
list snellenrightcode if uniqueid==1600301607

replace snellenrightcode = "CLD4M" if uniqueid==1600301607
replace snellenleftcode = "PL+" if uniqueid==1600301607

*  | 1703700802        50+ |6/6 in both eyes
list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1703700802

recode snellenlefttop .=6 if uniqueid==1703700802 
recode snellenleftbottom .=6 if uniqueid==1703700802

recode snellenrighttop .=6 if uniqueid==1703700802 
recode snellenrightbottom .=6 if uniqueid==1703700802

*  | 1804404405        50+ |6/6 in both eyes
list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1804404405

recode snellenlefttop .=6 if uniqueid==1804404405 
recode snellenleftbottom .=6 if uniqueid==1804404405

recode snellenrighttop .=6 if uniqueid==1804404405 
recode snellenrightbottom .=6 if uniqueid==1804404405

*  | 1804404408        50+ |RE: 6/60, LE: 6/01
list snellenrighttop snellenrightbottom snellenlefttop snellenleftbottom if uniqueid==1804404408

recode snellenlefttop .=6 if uniqueid==1804404408 
recode snellenleftbottom .=60 if uniqueid==1804404408

recode snellenrighttop .=6 if uniqueid==1804404408 
recode snellenrightbottom .=60 if uniqueid==1804404408

** END OF CLEANING FROM ERRORS DETECTED BELOW **

*****
tab trachage,m
* 778 ids >50 years

* CODING:
tab snellenlefttop snellenleftbottom if trachage==3,m 
* 7 + 4 + 504 = 515

tab snellenrighttop snellenrightbottom if trachage==3,m 
* 6 + 2 + 6 + 506 = 520

** LEFT EYE:
gen valeft=.

* Low vision:
recode valeft .=2 if snellenlefttop==3 & snellenleftbottom==60
recode valeft .=2 if snellenlefttop==6 & snellenleftbottom==24
recode valeft .=2 if snellenlefttop==6 & snellenleftbottom==36
recode valeft .=2 if snellenlefttop==6 & snellenleftbottom==60

* Normal:
recode valeft .=3 if snellenlefttop==6 & snellenleftbottom==18
recode valeft .=3 if snellenlefttop==6 & snellenleftbottom==12
recode valeft .=3 if snellenlefttop==6 & snellenleftbottom==9
recode valeft .=3 if snellenlefttop==6 & snellenleftbottom==6

tab valeft,m

* Blind:
tab snellenleftcode,m 
* 5580 - 5523 = 57

encode snellenleftcode, gen (snellenleftcode2)
label list snellenleftcode2

recode valeft .=1 if snellenleftcode2==1 | snellenleftcode2==2 | snellenleftcode2==3 | snellenleftcode2==4 | snellenleftcode2==5 | snellenleftcode2==6 | snellenleftcode2==7 | snellenleftcode2==8 | snellenleftcode2==9 | snellenleftcode2==10 | snellenleftcode2==11 | snellenleftcode2==12 | snellenleftcode2==13 | snellenleftcode2==14 | snellenleftcode2==15 | snellenleftcode2==16 | snellenleftcode2==17 | snellenleftcode2==18 | snellenleftcode2==19
* Only 45 changes made, not 57... Lost 12 somehow and don't know why

recode valeft .=1 if snellenlefttop==1 & snellenleftbottom==60

tab valeft if trachage==3,m

* 218 missing. 
* 515 + 57 = 572
* 778 - 572 = 206 (some discrepancy (by 12) but not sure why)

** RIGHT EYE:
gen varight=.

* Low vision:
recode varight .=2 if snellenrighttop==3 & snellenrightbottom==60
recode varight .=2 if snellenrighttop==6 & snellenrightbottom==24
recode varight .=2 if snellenrighttop==6 & snellenrightbottom==36
recode varight .=2 if snellenrighttop==6 & snellenrightbottom==60

* Normal:
recode varight .=3 if snellenrighttop==6 & snellenrightbottom==18
recode varight .=3 if snellenrighttop==6 & snellenrightbottom==12
recode varight .=3 if snellenrighttop==6 & snellenrightbottom==9
recode varight .=3 if snellenrighttop==6 & snellenrightbottom==6

tab varight,m

* Blind:
tab snellenrightcode,m 
* 5580 - 5529 = 51

encode snellenrightcode, gen (snellenrightcode2)
label list snellenrightcode2

recode varight .=1 if snellenrightcode2==1 | snellenrightcode2==2 |snellenrightcode2==3 | snellenrightcode2==4 | snellenrightcode2==5 | snellenrightcode2==6 | snellenrightcode2==7 | snellenrightcode2==8 | snellenrightcode2==9 | snellenrightcode2==10 | snellenrightcode2==11 | snellenrightcode2==12 | snellenrightcode2==13 | snellenrightcode2==14 | snellenrightcode2==15 | snellenrightcode2==16 | snellenrightcode2==17 | snellenrightcode2==18 | snellenrightcode2==19
* 44 changes made (instead of 51): 7 missing somehow
recode varight .=1 if snellenrighttop==1 & snellenrightbottom==60
recode varight .=1 if snellenrighttop==2 & snellenrightbottom==60

tab varight if trachage==3,m
* 217 missing. 
* 520 + 51 = 571
* 778 - 571 = 207 (some discrepancy (by 10) but not sure why)

label define valab 1 "Blind" 2 "Low vision" 3 "Normal"
label values varight valab
label values valeft valab
tab varight if trachage==3,m
tab valeft if trachage==3,m

**** CODING COMBINING RIGHT & LEFT EYES:

* Visual acuity is based on better eye

*** Combinations:

** Normal (3) (6/6 to 6/18)= 
gen va=3 if varight==3 | valeft==3
tab va if trachage==3,m
* 390 are normal

** Low vision (2) (<6/18 to 3/60)= 
recode va .=2 if varight==2 | valeft==2
tab va if trachage==3,m
* 390 normal, 144 low vision

** Blind (1) (<3/60 to PL)= 
recode va .=1 if varight==1 | valeft==1
tab va if trachage==3,m
* 390 normal, 144 low vision, 28 blind
* 216 missing

label values va valab
tab va if trachage==3,m

* Checking for missing data:
tab commune va if trachage==3 & notexamined==., row m

list uniqueid trachage if va==. & notexamined==. & trachage==3, noobs


* For the below list, any that need changing have moved upwards
 *|   uniqueid   trachage |
 * |-----------------------|
 * |  100804206        50+ |Confirmed missing
 * |  100804512        50+ |Confirmed missing
 * |  100805307        50+ |Confirmed missing
 * |  101104901        50+ |Confirmed missing
 * |  101106001        50+ |Confirmed missing
 * |-----------------------|
 * |  101106008        50+ |Confirmed missing
 * |  101600608        50+ |Confirmed missing
 * |  201400302        50+ |Confirmed missing
 * |  201401801        50+ |Confirmed missing
 * |  300206102        50+ |Confirmed missing
 * |-----------------------|
 
 * |  301201408        50+ |Just says "24" for both. Assume it means 6/24
 * Sorted out above
 
 * |  301201701        50+ |Confirmed missing
 * |  301203904        50+ |Confirmed missing
 * |  301600201        50+ |Confirmed missing
 * |  301600202        50+ |Confirmed missing
 * |-----------------------|
 * |  301605810        50+ |Confirmed missing
 * |  301606002        50+ |Confirmed missing
 * |  301901407        50+ |Confirmed missing
 * |  301903304        50+ |Confirmed missing
 * |  301903305        50+ |Confirmed missing
 * |-----------------------|
 * |  320101302        50+ |Confirmed missing
 * |  320103401        50+ |Confirmed missing
 * |  400100102        50+ |Whole ocular form missing
 * |  400109301        50+ |Confirmed missing
 * |  400303301        50+ |Confirmed missing
 * |-----------------------|
 * |  400303801        50+ |Confirmed missing
 * |  400305401        50+ |Confirmed missing
 * |  400305402        50+ |Confirmed missing
 * |  400401001        50+ |Confirmed missing
 * |  400406802        50+ |Confirmed missing
 * |-----------------------|
 * |  400406805        50+ |Confirmed missing
 * |  400406811        50+ |Confirmed missing
 * |  400406812        50+ |Confirmed missing
 * |  400408101        50+ |Confirmed missing
 * |  400408102        50+ |Confirmed missing
 * |-----------------------|
 * |  400606401        50+ |Confirmed missing
 * |  400803201        50+ |Confirmed missing
 * |  400803225        50+ |Confirmed missing
 * |  500604901        50+ |Confirmed missing
 * |  500608615        50+ |Confirmed missing
 * |-----------------------|
 * |  501900302        50+ |Confirmed missing
 * |  501906007        50+ |Confirmed missing
  *|  501906010        50+ |Confirmed missing
 * |  502804801        50+ |Confirmed missing
 * |  503500801        50+ |Confirmed missing
 * |-----------------------|
 * |  503502201        50+ |Confirmed missing
 * |  600800101        50+ |Confirmed missing
 * |  600800904        50+ |Confirmed missing
 * |  600801605        50+ |Confirmed missing
 * |  600802301        50+ |Confirmed missing
 * |-----------------------|
*  |  600802302        50+ |Confirmed missing
 * |  601602201        50+ |Confirmed missing
*  |  700400301        50+ |Confirmed missing
*  |  700400901        50+ |Confirmed missing
 * |  700401408        50+ |Confirmed missing
 * |-----------------------|
 * |  700509602        50+ |Confirmed missing
 * |  800100202        50+ |Confirmed missing
 * |  800104002        50+ |Confirmed missing
 * |  900100402        50+ |Confirmed missing
 * |  900101001        50+ |Confirmed missing
*  |-----------------------|
 * |  900101501        50+ |Confirmed missing
 * |  900101502        50+ |Confirmed missing
 * |  900102101        50+ |Confirmed missing
 * |  900102102        50+ |Confirmed missing
 * |  900102701        50+ |Confirmed missing
 * |-----------------------|
 * |  900103802        50+ |Confirmed missing
 * |  900403404        50+ |Confirmed missing
 * |  900405503        50+ |Confirmed missing
 * | 1000200301        50+ |Confirmed missing
 * | 1000201301        50+ |Confirmed missing
 * |-----------------------|
 * | 1000201701        50+ |Unable to measure VA
 * | 1000201702        50+ |Confirmed missing
 * | 1000202502        50+ |Confirmed missing
 * | 1000205502        50+ |Confirmed missing
 * | 1000209701        50+ |Unable to measure VA (dark)
 * |-----------------------|
*  | 1000706707        50+ |Confirmed missing
 * | 1200103709        50+ |Scan unclear
 * | 1300305501        50+ |Confirmed missing
 * | 1300313501        50+ |Confirmed missing
 * | 1300313505        50+ |Confirmed missing
  *|-----------------------|
  
 * | 1400500501        50+ |LE only, 24/6
 * Sorted out above
 
 * | 1400500502        50+ |Confirmed missing
 * | 1400505901        50+ |Confirmed missing
 * | 1401103301        50+ |Confirmed missing
 * | 1401601501        50+ |Confirmed missing
 * |-----------------------|
 * | 1401601801        50+ |Confirmed missing
 * | 1401601802        50+ |Confirmed missing
 * | 1401601901        50+ |Confirmed missing
 * | 1402203201        50+ |Confirmed missing
 
 * | 1500301820        50+ |36/6 for both eyes
* Dealt with above
 * | 1500304902        50+ |6/6 for both eyes
* Dealt with above
 * | 1500306601        50+ |6/6 for both eyes
* Dealt with above
 
 * | 1520105110        50+ |Confirmed missing
 * | 1520105115        50+ |Confirmed missing
 * | 1560105207        50+ |Confirmed missing
*  |-----------------------|
*  | 1600202211        50+ |Confirmed missing
*  | 1600202301        50+ |Confirmed missing

*  | 1600301607        50+ |RE: CLD 4m, LE: PL+
* Dealt with above

*  | 1600602902        50+ |Confirmed missing
*  | 1700203804        50+ |Confirmed missing
*  |-----------------------|
*  | 1701002101        50+ |Confirmed missing
*  | 1701002202        50+ |Confirmed missing
*  | 1701500402        50+ |Confirmed missing
*  | 1701500501        50+ |Confirmed missing
*  | 1701501002        50+ |Confirmed missing
*  |-----------------------|
*  | 1702002102        50+ |Confirmed missing

*  | 1703700802        50+ |6/6 in both eyes
* Dealt with above

*  | 1703705101        50+ |Confirmed missing
*  | 1800400803        50+ |Confirmed missing
*  | 1800400901        50+ |Confirmed missing
*  |-----------------------|
*  | 1801602503        50+ |Confirmed missing
*  | 1801602510        50+ |Confirmed missing
*  | 1801603003        50+ |Confirmed missing
 * | 1801603710        50+ |Confirmed missing
*  | 1802501403        50+ |Confirmed missing
*  |-----------------------|
*  | 1802502201        50+ |Confirmed missing
*  | 1802504301        50+ |Confirmed missing
*  | 1803900302        50+ |Confirmed missing
*  | 1803900502        50+ |Confirmed missing
*  | 1803900517        50+ |Confirmed missing
*  |-----------------------|
*  | 1803903101        50+ |Confirmed missing
*  | 1803903106        50+ |Confirmed missing

*  | 1804404405        50+ |6/6 in both eyes
*  | 1804404408        50+ |RE: 6/60, LE: 6/01
* Dealt with above

 * | 1804406607        50+ |Confirmed missing
* Dealt with above

*****

tab comid va if trachage==3, row

tab trachage varight if comid==17015,m 

sort hid

save child, replace

*****************
/**********************************/
***** MERGE RISKS DATABASE INTO CHILD DATABASE

* This section of 4 lines often needs to be repeated independently for it to work

use child, clear
sort hid
merge hid using Risks

save child, replace





