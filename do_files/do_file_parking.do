
/***********************************************************************
Author: Sarah Edwards
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/


In particular, this do file downloads the dataset "Parking_Citations" 
From: https://data.baltimorecity.gov/Transportation/Parking-Citations/n4ma-fj3m

**************************************************************************/

clear

import delimited "raw_data/Parking_Citations.csv", bindquote(strict) 

sum
de

* Re-format dates


gen viol_date = substr(violdate,1,10) 
rename noticedate notice_date
foreach var of varlist ///
viol_date notice_date {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

* Clean Dataset

drop violdate importdate penaltydate 

rename violcode viol_code
rename violfine viol_fine_amt
rename balance bal_amt
rename openfine open_fine_amt
rename openpenalty	open_penalty_amt
rename citation citation_id

gen dataset = "parking_citations"

save "data_cleaned/parking_citations_cleaned.dta", replace
clear












