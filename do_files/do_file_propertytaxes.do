
/***********************************************************************
Author: Sarah Edwards
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/


**************************************************************************/


clear

import delimited "raw_data/Real_Property_Taxes", bindquote(strict) 

sum
de

replace propertyaddress = strtrim(propertyaddress)
replace propertyaddress = strlower(propertyaddress)
rename propertyaddress address

replace address = strlower(address)
replace address = subinstr(address, ".", "",.) 
replace address = strtrim(address)
replace address = regexr(address, "street", "st")
replace address = subinstr(address, "  ", " ",.)
replace address = regexr(address, "place", "pl")
replace address = regexr(address, "avenue", "ave")
replace address = regexr(address, "rd", "road")

drop lotsize lot block statetax

rename citytax city_tax_amt
rename amountdue amt_due_amt

keep address neighborhood policedistrict councildistrict location

rename neighborhood neighborhoods_city

save "data_cleaned/address_file.dta", replace

clear


