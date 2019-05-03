
/***********************************************************************
Authors: Angélica Marie Pagán, John Iselin, Lisa McCorkell, Rachel Wallace, and 
Sarah Edwards

Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/

This master do file calls a series of other do files which clean individual open
data files, then merges (where possible) by neighborhood, then produces a series
of tabulations and figures for analysis. 

Any questions can be directed to John Iselin at johniselin@berkeley.edu

**************************************************************************/


*** Set-Up
capture log close
clear matrix
clear all
set more off
local directory "/Users/johniselin/Google Drive/IPA Fines and Fees Group Folder/Resources/Data/open_data/"

cd "`directory'"
log using "logs/open_data_creation_log", replace 


* Run ECB Citation Code
do "do_files/do_file_ecb.do"

* Run Parking Citation Code
do "do_files/do_file_parking.do"

* Run DOT Towing Code
do "do_files/do_file_towing.do"

* Run Vacant Lot Code
do "do_files/do_file_vacant.do"

* Run Census Data Code
do "do_files/do_file_census.do"

* Run BPD Data code 
do "do_files/do_file_arrest.do"

* Run Property Tax Code
do "do_files/do_file_propertytaxes.do"

* Run Address Merge Code
do "do_files/do_file_address_merge.do"
 
log close 
 
 local directory "/Users/johniselin/Google Drive/IPA Fines and Fees Group Folder/Resources/Data/open_data/"

cd "`directory'" 
** Data analysis - ECB
log using "logs/ecb_results_log", replace 

use "data_cleaned/ecb_citations_cleaned_merge.dta", clear

gen year = year(viol_date)
bysort description year : gen freq = _N
gen common = 1 if freq > 1000
replace common = 0 if common == .
drop freq 

rename hearingstatus hearing_status
replace hearing_status = "NA" if hearing_status == "  "
replace hearing_status = "Hearing Scheduled" if hearing_status == "HR"
replace hearing_status = "Guilty" if hearing_status == "GU"
replace hearing_status = "Guilty Reduced" if hearing_status == "GR"
replace hearing_status = "Default, No Show" if hearing_status == "DF"
replace hearing_status = "Default, Behavior" if hearing_status == "DB"
replace hearing_status = "Dismissed" if hearing_status == "DI"
replace hearing_status = "Default, Abated" if hearing_status == "DA"

gen fine_abated_share = total_abated_amt / bal_amt

bysort year description: egen sum_fine = total(fine_amt)
bysort year description: egen sum_paid = total(total_paid_amt) 
gen total_paid_share = sum_paid/ sum_fine
drop sum_fine sum_paid

tab description if year == 2018, sort
table description if year == 2018, c(sum fine_amt mean fine_amt n fine_amt) 	///
format(%12.2fc)

table description if year == 2018, c(sum fine_amt sum total_paid_amt 			///
	max total_paid_share) format(%12.2fc)

tab neighborhoods_csa if year == 2018, sort plot
tab neighborhoods_csa if year == 2018, summarize(fine_amt)   

tab hearing_status if year == 2018

tab quint_black if year == 2018 & hearing_status == "NA"

table lien_code if year == 2018, c(n fine_amt sum fine_amt sum total_paid_amt) 	///
	format(%12.2fc)


foreach quint in quint_poverty quint_black quint_female_head {

di "Count of citations and sum/mean fine amount for 2018"

table `quint' if year == 2018, c(n citation_id sum fine_amt mean fine_amt) format(%12.0fc)

di "Count of citations and sum/mean voided amount for 2018"

table `quint' if year == 2018 & total_voided_amt != 0, 												///
	c(n citation_id sum total_voided_amt mean total_voided_amt) format(%12.0fc)

di "Count of citations and sum/mean abated amount for 2018"

table `quint' if year == 2018 & total_abated_amt != 0, 												///
	c(n citation_id sum total_abated_amt mean total_abated_amt) format(%12.0fc)

di "Count common citation types for 2018"
	
table description `quint' if year == 2018 & common == 1, c(n citation_id) format(%12.0fc)

di "Count by hearing status and `quint' common citation types for 2018"

table hearing_status `quint'  if year == 2018 & hearing_status != "NA"		///
	 , c(n fine_amt) format(%12.0fc)
	 
di "Sum of fines by hearing status and `quint' common citation types for 2018"
	
table hearing_status `quint'  if year == 2018 & hearing_status != "NA"		///
	, c(sum fine_amt) format(%12.0fc)
	
di "Mean of fines by hearing status and `quint' common citation types for 2018"

table hearing_status `quint'  if year == 2018 & hearing_status != "NA"		///
	, c(mean fine_abated_share ) format(%12.2fc)	

di "Collection Share by lien presence"

table `quint'  lien_code if year == 2018 , c(mean fine_abated_share) format(%12.2fc)
	
}

* Figure showing 2018 ECB Citation count by Share-Black Quintile
graph hbar (count) fine_amt if year == 2018, 									///
	over(quint_black) blabel(bar, format(%12.0fc)) 								///
	ylabel(, format(%12.0fc)) 													///
	ytitle(Count of ECB Citations)  											///												
	title("2018 ECB Citations by Share-Black Quintile") 
graph export "ecb_blackquint_count.pdf", replace

* Figure showing 2018 ECB Citation total by Share-Black Quintile
graph hbar (sum) fine_amt (sum) total_paid_amt if year == 2018, 						///
	over(quint_black) blabel(bar, format(%12.0fc)) 								///
	ylabel(, format(%12.0fc)) 													///
	ytitle(Sum)  																///		
	legend(lab(1 "ECB Fine Amount") lab(2 "ECB Amount Paid")) 											///												
	title("2018 ECB Citations by Share-Black Quintile") 
graph export "ecb_blackquint_sum.pdf", replace

* Figure showing 2018 ECB Citation mean by Share-Black Quintile
graph hbar (mean) fine_amt (mean) total_paid_amt if year == 2018, 				///
	over(quint_black) blabel(bar, format(%12.0fc)) 								///
	ylabel(, format(%12.0fc)) 													///
	ytitle(Mean)  																///		
	legend(lab(1 "ECB Fine Amount") lab(2 "ECB Amount Paid")) 					///
	title("2018 ECB Citations by Share-Black Quintile") 
graph export "ecb_blackquint_mean.pdf", replace

clear

log close

** Data analysis - Parking

log using "logs/parking_results_log", replace 

use "data_cleaned/parking_citations_cleaned.dta"

sum open_fine_amt
tab description

tab viol_fine_amt
tab open_fine_amt

*trying to understand how much more people are having to pay if they do not pay 
*their first fine/how much it escalates
tab viol_fine_amt if bal_amt>=502
tab viol_fine_amt if bal_amt>= viol_fine_amt

generate penalty_cats=recode(open_penalty_amt,0, 10, 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
tab description if penalty_cats>=200

tab bal_amt if description=="Residential Parking Permit Only"
tab open_penalty_amt if description=="Residential Parking Permit Only"
tab penalty_cats if description=="Residential Parking Permit Only"

gen year = year(viol_date)
tab state if year == 2018, sort

table state if year == 2018 & (state == "MD" | state == "VA" | state == "PA" | 	///
			state == "NJ" | state == "NY" | state == "NC" |	state == "FL" | 	///
			state == "DE" | state == "TX" | state == "DC"), 					///
		c(n bal_amt sum bal_amt mean bal_amt) format(%12.0fc)	

table state if year == 2018 & (state == "MD" | state == "VA" | state == "PA" | 	///
			state == "NJ" | state == "NY" | state == "NC" |	state == "FL" | 	///
			state == "DE" | state == "TX" | state == "DC"), 					///
		c(n open_fine_amt sum open_fine_amt mean open_fine_amt) format(%12.0fc)	


clear
log close

** Data analysis - Towing
log using "logs/towing_results_log", replace 
use "data_cleaned/dot_towing_cleaned.dta", clear

generate paid_cats=recode(total_paid_amt,50,150,200,250,300,350,400, 500, 600, 700, 800, 900, 1000)

tab paid_cats

gen difference_paid=0
replace difference_paid= total_paid_amt-tow_chg_amt
generate difference_paid_cats=recode(difference_paid,-150,-100,-50,50,150,200,250,300,350,400,500,600,700,800, 900, 1000)
tab difference_paid_cats

tab releasetype paid_cats

gen days_held=0
replace days_held= release_date-recieve_date

generate days_held_cats=recode(days_held, 1, 14, 28, 42, 56, 100, 200, 300, 400, 500, 600)

tab days_held_cats

clear
log close
** Data analysis - BPD
log using "logs/bpd_results_log", replace 

use "data_cleaned/bpd_arrests_merge.dta", clear

sort charge_desc

gen year = year(arrest_date)
tab year race

gen ff_from_chargedesc=0
replace ff_from_chargedesc=1 if charge_desc=="DRI ON SUSP LIC"
replace ff_from_chargedesc=1 if charge_desc=="DRIV ON SUS LIC"
replace ff_from_chargedesc=1 if charge_desc=="DRIV ON SUSP LIC & PRIV"
replace ff_from_chargedesc=1 if charge_desc=="DRIV. ON SUSP. LIC."
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON A SUSPENDED LICENSE"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUS"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUS LIC"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUS LICENSE"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUS. LIC."
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSP"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSP LIC"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSP LIC."
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSP LICENSE"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSP. LIC"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSP. LIC."
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPEND LICENSE"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENDED"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENDED LIC"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENDED LIC."
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENDED LIC. & PR"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENDED LICENCE"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENDED LICENSE A"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENED"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING ON SUSPENED LICENCE"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING SUSPENDED"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING WHILE LIC SUSPENDED"
replace ff_from_chargedesc=1 if charge_desc=="DRIVING WHILE SUSPENDED"
replace ff_from_chargedesc=1 if charge_desc=="DRIVINGONSUSPENDEDLIC"
replace ff_from_chargedesc=1 if charge_desc=="FAILURE TO APPEAR" 
replace ff_from_chargedesc=1 if charge_desc=="FAILURE TO APPEAR OR PAY FINE"
replace ff_from_chargedesc=1 if charge_desc=="FAILURE TO APPEAR OR PAY FINE"
replace ff_from_chargedesc=1 if charge_desc=="FAILURE TO PAY"
replace ff_from_chargedesc=1 if charge_desc=="FTA"
replace ff_from_chargedesc=1 if charge_desc=="SUSPENDED LICENCE"
replace ff_from_chargedesc=1 if charge_desc=="SUSPENDEDLIC"

gen crim_homeless=0
replace crim_homeles=1 if charge_desc=="LOITERING"
replace crim_homeles=1 if charge_desc=="OPEN CONTAINER"
*I know this is iffy because I imagine there's a broader range of 
*people being charged but there's also a larger group of homeless individuals
*within it and it was on  SF's list. 
replace crim_homeles=1 if charge_desc=="DRINKING IN PUBLIC"
replace crim_homeles=1 if charge_desc=="PANHANDLING"
replace crim_homeles=1 if charge_desc=="PARK RULE VIOLATION"
replace crim_homeles=1 if charge_desc=="PARK VIOLATION"
replace crim_homeles=1 if charge_desc=="PUBLIC DEFECATION"
replace crim_homeles=1 if charge_desc=="PUBLIC URINATION"
replace crim_homeles=1 if charge_desc=="ROGUE & VAGABOND"
replace crim_homeles=1 if charge_desc=="ROGUE AND VAGABOND"
replace crim_homeles=1 if charge_desc=="SELLING W/O LICENSE"
replace crim_homeles=1 if charge_desc=="SELLING W/OUT A LICENSE"
replace crim_homeles=1 if charge_desc=="SELLING WITHOUT LICENSE"
replace crim_homeles=1 if charge_desc=="TRESPASSING"
replace crim_homeles=1 if charge_desc=="TRESPASS: PRIVATE PROPERTY"
replace crim_homeles=1 if charge_desc=="TRESPASS-POSTED PROPERTY"
replace crim_homeles=1 if charge_desc=="TRESPASS PUB AGNCY DUR HRS"
replace crim_homeles=1 if charge_desc=="TRESPASS POSTED PROPERTY"
replace crim_homeles=1 if charge_desc=="TRESPASS"
replace crim_homeles=1 if charge_desc=="TRESPASSING/DISORDELY"
replace crim_homeles=1 if charge_desc=="TRESSPASING"
replace crim_homeles=1 if charge_desc=="TRESSPASS"
replace crim_homeles=1 if charge_desc=="TRESSPASSING"
replace crim_homeles=1 if charge_desc=="URINATING IN PUBLIC"

replace charge_desc="Driving Suspended License" if charge_desc=="DRI ON SUSP LIC"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIV ON SUS LIC"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIV ON SUSP LIC & PRIV"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIV. ON SUSP. LIC."
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON A SUSPENDED LICENSE"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUS"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUS LIC"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUS LICENSE"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUS. LIC."
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSP"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSP LIC"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSP LIC."
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSP LICENSE"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSP. LIC"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSP. LIC."
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPEND LICENSE"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENDED"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENDED LIC"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENDED LIC."
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENDED LIC. & PR"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENDED LICENCE"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENDED LICENSE A"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENED"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING ON SUSPENED LICENCE"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING SUSPENDED"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING WHILE LIC SUSPENDED"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVING WHILE SUSPENDED"
replace charge_desc="Driving Suspended License" if charge_desc=="DRIVINGONSUSPENDEDLIC"
replace charge_desc="Driving Suspended License" if charge_desc=="SUSPENDED LICENCE"
replace charge_desc="Driving Suspended License" if charge_desc=="SUSPENDEDLIC"

tab ff_from_chargedesc year
tab crim_homeless year

tab charge_desc if ff_from_chargedesc==1
tab charge_desc race if ff_from_chargedesc==1
table charge_desc race sex if ff_from_chargedesc==1

tab charge_desc if crim_homeless==1
tab charge_desc race if crim_homeless==1
table charge_desc race sex if crim_homeless==1

tab incident_offense race
*I think that the charge descriptions are more valuable but we can dive 
*deeper into this if helpful

tab race quint_poverty
* because only 81,891 of the 138,000 values had geolocated data, the quantiles
* are only reflective of the data able to be matched to neighborhoods

tab ff_from_chargedesc quint_poverty
tab crim_homeless quint_poverty
table charge_desc quint_poverty if ff_from_chargedesc==1
table charge_desc quint_poverty if crim_homeless==1

*Question: MOTOR VEH/UNLAWFUL TAKING?
clear
log close

** Data analysis - Vacant Lots
log using "logs/vacant_results_log", replace 

use "data_cleaned/vacant_lots_cleaned_merge.dta"

gen year = year(notice_date)

tab year

tab neighborhoods_csa , sort
tab quint_poverty  , sort
tab quint_black , sort
tab quint_workingage , sort
tab quint_female_head , sort

collapse (count) zipcodes (mean) perc_black_16 perc_households_below_pov, by(neighborhoods_csa)

rename zipcodes count
label variable count "Count of vacant homes"
label variable perc_black_16 "Black share of population"
label variable perc_households_below_pov  "Share of population in poverty"

twoway scatter count perc_black_16
graph export "vacant_by_black_scatter.pdf", replace
twoway scatter count perc_households_below_pov
graph export "vacant_by_poverty_scatter.pdf", replace

clear
log close







