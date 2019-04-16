
/***********************************************************************
Author: Angélica Marie Pagán, John Iselin, Lisa McCorkell, Rachel Wallace, and 
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

cd "/Users/johniselin/finesandfees_baltimore"
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

* Run Property Tax Code
do "do_files/do_file_propertytaxes.do"

* Run BPD Arrests Code
do "do_files/do_file_arrest.do"

* Run Address Merge Code
do "do_files/do_file_address_merge.do"
 
log close 
 
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

tab description if year == 2018, sort

tab neighborhoods_csa if year == 2018, sort plot
tab neighborhoods_csa if year == 2018, summarize(fine_amt)   

** Count of citations and sum/mean fine amount by poverty share quintile for 2018
table quint_poverty if year == 2018, 											///
	c(n citation_id sum fine_amt mean fine_amt)  format(%12.0fc)

** Count of citations and sum/mean fine amount by black share quintile for 2018

table quint_black if year == 2018, 												///
	c(n citation_id sum fine_amt mean fine_amt)  format(%12.0fc)

** Count of citations and sum/mean voided amount by black share quintile for 2018

table quint_black if year == 2018 & total_voided_amt != 0, 												///
	c(n citation_id sum total_voided_amt mean total_voided_amt)  format(%12.0fc)

** Count of citations and sum/mean abated amount by black share quintile for 2018

table quint_black if year == 2018 & total_abated_amt != 0, 												///
	c(n citation_id sum total_abated_amt mean total_abated_amt)  format(%12.0fc)

** Count by black share quintile and common citation types for 2018	
tab description quint_black if year == 2018 & common == 1 

** Count by black share quintile and common citation types for 2018	
table description quint_black if year == 2018 & common == 1, c(n citation_id) format(%12.0fc)


** Hearing statistics

tab hearing_status if year == 2018

gen fine_abated_share = total_abated_amt / bal_amt

table hearing_status quint_black if year == 2018 & hearing_status != "NA"		///
	 , c(n fine_amt) format(%12.0fc)
	
table hearing_status quint_black if year == 2018 & hearing_status != "NA"		///
	, c(sum fine_amt) format(%12.0fc)
	
table hearing_status quint_black if year == 2018 & hearing_status != "NA"		///
	, c(mean fine_abated_share ) format(%12.2fc)	




clear

log close

** Data analysis - Parking

log using "logs/parking_results_log", replace 

clear
log close

** Data analysis - Towing
log using "logs/towing_results_log", replace 

clear
log close

** Data analysis - BPD
log using "logs/bpd_results_log", replace 

clear
log close

** Data analysis - BPD
log using "logs/vacant_results_log", replace 



clear
log close







