
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

foreach var of varlist ///
arrestdate  {
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

* Clean / rename other vars
drop location1 neighborhood censusneighborhoods censuswardsprecincts zipcodes 	///
		arresttime 


rename arrestdate arrest_date
rename arrestlocation arrest_location
rename incidentlocation incident_location
rename arrest arrest_id
rename incidentoffense incident_offense
rename chargedescription charge_desc

replace arrest_location = strlower(arrest_location)
replace incident_location = strlower(incident_location)
replace arrest_location = strtrim(arrest_location)
replace incident_location = strtrim(incident_location)

order arrest_id arrest_date 

save "data_cleaned/bpd_arrests_cleaned.dta", replace
clear




