
/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/


Downloaded from: https://data.baltimorecity.gov/Public-Safety/BPD-Arrests/3i3v-ibrt

Note: Commas in the dollar amounts in theft cases of "charge_desc" mean that 
		in some cases the columns are offset, shoudl fix in a later version 
**************************************************************************/

clear

import delimited "raw_data/BPD_Arrests.csv", bindquote(strict) 

sum
de

* Re-format dates
rename arrestdate arrest_date
foreach var of varlist ///
arrest_date  {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

* Re-format location
* Note incidentlocation == arrestlocation

rename arrestlocation arrest_address
replace arrest_address = strlower(arrest_address)
replace arrest_address = subinstr(arrest_address, ".", "",.) 
replace arrest_address = strtrim(arrest_address)
replace arrest_address = regexr(arrest_address, "street", "st")
replace arrest_address = subinstr(arrest_address, "  ", " ",.)
replace arrest_address = regexr(arrest_address, "place", "pl")
replace arrest_address = regexr(arrest_address, "avenue", "ave")
replace arrest_address = regexr(arrest_address, "rd", "road")
rename arrest_address address

* Clean / rename other vars
drop location1 censuswardsprecincts zipcodes arresttime incidentlocation
drop latitude longitude post district  

rename arrest arrest_id
rename incidentoffense incident_offense
rename chargedescription charge_desc

order arrest_id arrest_date 

save "data_cleaned/bpd_arrests.dta", replace
clear




