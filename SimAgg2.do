//Post Factum Clarity 
//Aggregate Events

//Edited file: June 2020
//Rotem Dvir, TAMU Polsci

**	Program set-up	*************************************************************
clear all
set linesize 80

//Set Working Directory
capture cd "C:\Users\admin\Dropbox\TAMU\Extra_Projects\Git_edits\Post_factum"

//Import Dataset
use "/Users/admin/Dropbox/TAMU/Extra_Projects/Git_edits/Post_factum/SPEED Agg v2.dta", clear

**	Data Insertion and Computing Aggregate results	*********************************

**	Enter fixed variables
**	Since analysis focus on Relevance, other aspects of computation are set
**	Also, I set the threathold(Th) to a convinient 0.95

gen Iv = 1
gen Rb = 1
gen Red = 0
gen Th = 0.95

**	Relevant events: Violent and Non-violent
**	Violent events are coded with higher degree of relevance
**	Dynamic relevance (full description and logic in paper): 
**	Violent => more than 8 events per months are coded higher
**	Non-Violent => I account for two levels (3 and 6 events per months)

gen Rel_V = 0.6
replace Rel_V = 0.8 if violent_count> 8

gen Rel_NV=0.2
replace Rel_NV = 0.4 if non_violent_count>3
replace Rel_NV= 0.5 if non_violent_count>6

**	Compute IU: Information Utility
**	Value is based on Model computation: relevance x reliability x (1-reduandency)

**	Violent Data
**	When there are no event in a month, the value is reset to 0
gen Iu_V = Rel_V*Rb*(1-Red)
replace Iu_V=0 if violent_count==0

**	Non-Violent Data
**	When there are no event in a month, the value is reset to 0
gen Iu_NV = Rel_NV*Rb*(1-Red)
replace Iu_NV=0 if non_violent_count==0

**	All Data
**	When there are no event in a month, the value is reset to 0
gen Iu = (Rel_V+Rel_NV)*Rb*(1-Red)
replace Iu=0 if month_agg==0

**	Compute CCP: adding the Iu for each observation (month)  
**	When there are no event in a month, the value is adjusted to fit the situation
**	Final value is running ccp (violent) computed with the hyperbolic tangent
**	function (see paper)

**	Violent Data
gen run_Viu = sum(Iu_V)
replace run_Viu= run_Viu*0.92 if violent_count==0
gen run_Vccp = tanh(run_Viu)

**	Non-Violent Data
gen run_NViu = sum(Iu_NV)
replace run_NViu= run_NViu*0.92 if non_violent_count==0
gen run_NVccp = tanh(run_NViu)

**	All Data
gen run_Iu = sum(Iu)
replace run_Iu= run_Iu*0.92 if month_agg==0
gen run_ccp = tanh(run_Iu)

**	Graph: 3 types CCP 
twoway (line  run_Vccp month_id, lpattern(shortdash)) (line run_NVccp run_ccp month_id, lpattern(dash)), xlabel(1(1)12) ymlabel(0(0.1)1) yline(0.95, lwidth(thick)) ///
xtitle(1987 Months) ytitle(CCP Changes) legend(label(1 "Violent Events") label(2 "Non-Violent Events") label(3 "All Events")) ///
title(1987- CCP changes for Violent and Nonviolent events) text(0.98 2 "Threshold", place(c)) graphregion(color(white))
graph export threemodels.png
graph export 3models.png

**	Events aggregate graph
**	Total number of events in dataset
twoway bar month_agg month_id, lcolor(black) fcolor(maroon) xlabel(1(1)12) xtitle(1987 Months) ytitle(Total Events)	///
title(1987: Total Events - Monthly) text(29 5 "Predicted Change-CCP Model", place(c)) 	///
text(40 11 "Actual Change", place(w)) graphregion(color(white))
graph export month_agg.png

**	Types correlation
pwcorr violent_count non_violent_count
