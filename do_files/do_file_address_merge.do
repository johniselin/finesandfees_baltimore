/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file takes cleaned data from prior do-files, and (when possible) maps 
addresses to neighborhoods, and then neighborhoods to city CSA neighborhoods, 
about which we have Census demographics. 

We do not have enough information to merge data on towing, parking, 

Towing -> 29.57 percent of our data can be merged
Parking -> 11.48 percent of our data can be merged 

**************************************************************************/

* Create neighborhood dta file
clear
import delimited "raw_data/csa-to-nsa-2010.csv", varnames(1) 
rename ïcsa2010 neighborhoods_csa
rename nsa2010 neighborhoods_nsa

save "data_cleaned/neighborhood_crosswalk.dta", replace

clear



*ECB Citations - Has city neighborhood data already included

use "data_cleaned/ecb_citations_cleaned.dta", clear
rename neighborhood neighborhoods_nsa
save "data_cleaned/ecb_citations_cleaned_merge.dta", replace

clear

* For Vacant Lots And Arrests 


foreach dataset in vacant_lots_cleaned bpd_arrests {
	use "data_cleaned/`dataset'.dta", clear
	
	merge m:m address using "data_cleaned/address_file.dta"

	tab _merge
	drop if _merge == 2
	tab _merge
	rename _merge address_match
	replace address_match = 1 if address_match == 3
	replace address_match = 0 if address_match == 1
	
	rename neighborhoods_city neighborhoods_nsa

	save "data_cleaned/`dataset'_merge.dta", replace
	clear
	

}


* For vacant_lots and ecb_citations use neighborhood designation
* from address match derived from property tax data to matched neighbor-
* hood (small) to neighborhood (large) to merge with census data. 

foreach dataset in 																///
	vacant_lots_cleaned_merge ecb_citations_cleaned_merge bpd_arrests_merge {
	use "data_cleaned/`dataset'.dta", clear
	drop if neighborhoods_nsa == ""
	
	merge m:1 neighborhoods_nsa using "data_cleaned/neighborhood_crosswalk.dta"
	tab _merge
	keep if _merge == 3
	drop _merge
	
	merge m:1 neighborhoods_csa using "data_cleaned/census_data_cleaned.dta"
	drop _merge

	save "data_cleaned/`dataset'.dta", replace
	clear
	

}


