
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

replace buildingaddress = strtrim(buildingaddress)
replace buildingaddress = strlower(buildingaddress)

rename noticedate notice_date
drop censusneighborhoods neighborhood 

foreach var of varlist ///
notice_date {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

gen dataset = "vacant_lots"

save "data_cleaned/vacant_lots_cleaned.dta", replace
clear 

*log close


