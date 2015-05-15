
* ANALYSES
* 5/1/12

*** TABLE ENUMERATION:

** 1. Number eligible of different ages:
* 0
* 1-9
* =15
* =50
* Age missing
* Total

gen analysisage=allage
recode analysisage 0=0 1/9=1 10/14=4 15/49=2 50/max=3 
tab analysisage,m
label define analysisagelab 0 "0" 1 "1-9" 2 "15-49" 3 "50+" 4 "10-14"
label values analysisage analysisagelab
tab analysisage,m

** 2. Number eligible by sex:
tab sex,m

*** TABLE EXAMINATION:

** 1. Number examined of different ages:
* 0
* 1-9
* =15
* =50
* Age missing
* Total

tab trachage notexamined,m


** 2. Number eligible by sex:
tab sex notexamined, col m


** 3. Number examined:
* Overall:
tab notexamined if trachage==1, m
tab  notexamined if trachage==2,  m
tab  notexamined if trachage==3,  m


** 4. Reasons not examined:
* Overall:
tab  notexamined if trachage==1,m  
tab  notexamined if trachage==2,m
tab  notexamined if trachage==3,m

* By commune:
tab commune notexamined if trachage==1 & notexamined~=.
tab commune notexamined if (trachage==2 | trachage==3) & notexamined~=.
tab commune notexamined if  trachage==3 & notexamined~=.

* By village: 
tab comid notexamined if trachage==1 & notexamined~=.
tab comid notexamined if (trachage==2 | trachage==3) & notexamined~=.
tab comid notexamined if  trachage==3 & notexamined~=.


** 5. Number (%) 1-9 years with TF:
* Overall:
tab  anytf if trachage==1, m 

* a. By commune:
tab commune anytf if trachage==1, row 

**
recode anytf 9=. if anytf==9
** REMEMBER I HAVE DONE THIS!

tab commune anytf if trachage==1, row 

* b. By village:
tab comid anytf if trachage==1, row 


** 6. Number (%) >15 years with TT:
* Overall:
tab  anytt if trachage==2, m 
tab  anytt if trachage==3, m 

* a. By commune:
tab commune anytt if trachage==2 | trachage==3, row 

**
recode anytt 9=. if anytt==9
** REMEMBER I HAVE DONE THIS!

tab commune anytt if trachage==2 | trachage==3, row 

* b. By village:
tab comid anytt if trachage==2 | trachage==3, row 

** 7. Number (%) >50 years with VA:
* Overall:
tab  va if trachage==3, m

* a. By commune:
tab commune va if trachage==3, row 

* b. By village:
tab comid va if trachage==3, row 
