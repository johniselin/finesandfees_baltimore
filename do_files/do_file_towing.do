/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/

In this case, this do-file cleans the dataset "Baltimore DOT Towing"
From: https://data.baltimorecity.gov/Transportation/DOT-Towing/k78j-azhn
**************************************************************************/

clear

import delimited "raw_data/DOT_Towing.csv", bindquote(strict) 

sum
de

* Re-format address

rename towedfromlocation address
replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")



* Re-format dates

gen recieve_date = substr(receivingdatetime,1,10)
gen hold_release_date = substr(holdreleaseddatetime,1,10) 
gen release_date = substr(releasedatetime,1,10) 
gen tow_date = substr(toweddatetime,1,10)

foreach var of varlist ///
recieve_date hold_release_date release_date tow_date {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

drop receivingdatetime holdreleaseddatetime releasedatetime ///
	 holdreleasednotifydate removedfromyarddate vehiclemake ///
	 vehiclemodel vehiclecolor towcompany howtowed slingused dollyused ///
	 rollbackused pinpulled pinreplaced wheellift storagelocation ///
	 storagetelephone personalpropremoved personalpropleftinvehicle ///
	 trdatetime holddatetime toweddatetime stinger

	 
* Other cleaning	 
rename totalpaid total_paid_amt
rename towcharge tow_chg_amt
rename propertynumber prop_id
gen dataset = "towing"

order prop_id *_date *_amt

save "data_cleaned/dot_towing_cleaned.dta", replace
clear

*log close
