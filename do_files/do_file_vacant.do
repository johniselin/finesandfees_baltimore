
/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/

In this case, this do-file cleans the dataset "Vacant_Buildings"
From: https://data.baltimorecity.gov/Housing-Development/Vacant-Buildings/qqcv-ihn5

**************************************************************************/

clear

import delimited "raw_data/Vacant_Buildings.csv" , varnames(1) 

sum
de

* Clean Address Var

rename buildingaddress address  
replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")


* Clean Date Var

rename noticedate notice_date

foreach var of varlist ///
notice_date {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

* Other Cleaning

gen dataset = "vacant_lots"
drop censusneighborhoods  

save "data_cleaned/vacant_lots_cleaned.dta", replace
clear 

*log close


