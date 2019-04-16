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

**************************************************************************/

** Merging with property tax data for addresses

* Vacant Lots

use "data_cleaned/vacant_lots_cleaned.dta"
rename buildingaddress address 

replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")

merge m:m address using "data_cleaned/address_file.dta"

tab _merge
drop if _merge == 2
tab _merge
drop _merge 

save "data_cleaned/vacant_lots_cleaned_merge.dta", replace

clear

* Towing

use "data_cleaned/dot_towing_cleaned.dta", clear
rename towedfromlocation address

replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")

merge m:m address using "data_cleaned/address_file.dta"

tab _merge

*We have a low match rate therefore we are not going to attempt to look at
*neighborhood level statistics for towing data. See report for discussion for
*future research.

drop _merge
drop address dataset

save "data_cleaned/dot_towing_cleaned.dta", replace
clear

* Parking Citations

use "data_cleaned/parking_citations_cleaned.dta", clear

replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")

merge m:m address using "data_cleaned/address_file.dta"

tab _merge

*We have a low match rate (11.48%) therefore we are not going to attempt to look at
*neighborhood level statistics for towing data. See report for discussion for
*future research.

drop _merge
drop address neighborhood policedistrict councildistrict location dataset

save "data_cleaned/parking_citations_cleaned.dta", replace
clear

* Arrests

use "data_cleaned/bpd_arrests_cleaned.dta", clear
rename arrest_location address

replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")

*drop if missing(address)
*We dropped any observation that did not have a location associated with it.

merge m:m address using "data_cleaned/address_file.dta"
tab _merge
*We have a low match rate (6.17%) therefore we are not going to attempt to look at
*neighborhood level statistics for towing data. See report for discussion for
*future research.

drop _merge
drop latitude longitude post district address incident_location

save "data_cleaned/bpd_arrests_cleaned.dta", replace

clear


*ECB Citations - Has city neighborhood data already included

use "data_cleaned/ecb_citations_cleaned.dta", clear
rename neighborhood neighborhoods_city
save "data_cleaned/ecb_citations_cleaned_merge.dta", replace

clear

*99.79% match rate*



** NOTE: Not enough data on: dot_towing_cleaned, parking_citations_cleaned, bpd_arrests

* Create neighborhood dta file
clear
import delimited "raw_data/neighborhood_crosswalk.csv", varnames(1) 

save "data_cleaned/neighborhood_crosswalk.dta", replace

clear

* For vacant_lots and ecb_citations use neighborhood designation
* from address match derived from property tax data to matched neighbor-
* hood (small) to neighborhood (large) to merge with census data. 

foreach dataset in vacant_lots_cleaned_merge ecb_citations_cleaned_merge {
	use "data_cleaned/`dataset'.dta", clear
	drop if neighborhoods_city == ""
	
	merge m:1 neighborhoods_city using "data_cleaned/neighborhood_crosswalk.dta"
	tab _merge
	keep if _merge == 3
	drop _merge
	
	merge m:1 neighborhoods_csa using "data_cleaned/census_data_cleaned.dta"
	drop _merge

	save "data_cleaned/`dataset'.dta", replace
	clear
	

}


