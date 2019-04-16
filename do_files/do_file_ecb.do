
/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/

In particular, this do file downloads the dataset "Environmental Citations" 
From: https://data.baltimorecity.gov/City-Services/ECB-Citations/ywty-nmtg  
**************************************************************************/

/*
*** Set-Up
capture log close
clear matrix
clear all
set more off


cd "/Users/johniselin/Google Drive/IPA Fines and Fees Group Folder/Resources/Data/open_data/"

log using "open_data_ecb_log", replace

*/

import delimited "raw_data/Environmental_Citations.csv", bindquote(strict) 

sum
de

* Re-format dates


gen viol_date = substr(violationdate,1,10)
gen viol_time = substr(violationdate, 12, 10) 
gen due_date = substr(duedate,1,10) 
gen lastpaid_date = substr(lastpaiddate,1,10) 
gen hearing_date = substr(hearingdate,1,10) 
gen hearreq_date = substr(hearingrequestreceiveddate,1,10) 


foreach var of varlist ///
viol_date due_date lastpaid_date hearing_date hearreq_date {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}


* Clean / rename other vars
gen dataset = "ecd_citations"
drop block lot officerpresencerequested heartime location viol_time 			///
	violationdate duedate lastpaiddate hearingdate hearingrequestreceiveddate


rename citationno citation_id
rename liencode lien_code
rename fineamount fine_amt
rename balance bal_amt
rename lastpaidamount lastpaid_amt
rename totalpaid total_paid_amt
rename totalabated total_abated_amt
rename totalvoided total_voided_amt
rename citationstatus citation_stat
rename officerid officer_id

order citation_id *_date *_amt 

save "data_cleaned/ecb_citations_cleaned.dta", replace
clear

*log close


