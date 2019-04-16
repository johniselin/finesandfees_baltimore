
/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/

Crime Data from Baltimore Police Dept. 
Downloaded from: https://data.baltimorecity.gov/Public-Safety/BPD-Part-1-Victim-Based-Crime-Data/wsfq-mvij

**************************************************************************/

clear

import delimited "BPD_Part_1_Victim_Based_Crime_Data.csv", bindquote(strict) 

sum
de

* Re-format dates

foreach var of varlist ///
crimedate{
	gen test = date(`var' , "MDY")
	drop `var'
	gen `var' = test
	format `var'  %td
	drop test
}

rename crimedate crime_date

* Clean / rename other vars

drop totalincidents crimecasenumber location1 crimetime post 

save bpd_crime_cleaned.dta, replace
clear

log close


