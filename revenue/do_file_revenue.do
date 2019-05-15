
/***********************************************************************
Author: John Iselin
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file is designed to use the Actual Revenue by Account (FY 2003-FY2018).xlsx"
file provided by Kimberly Ruebens to the GSPP team.
**************************************************************************/


*** Set-Up
capture log close
clear matrix
clear all
set more off


cd "/Users/johniselin/Google Drive/IPA Fines and Fees Group Folder/Resources/Data/Revenue"

log using "revenue_setup_log", replace
 

import excel "Actual Revenue by Account (FY 2003-FY2018).xlsx", /// 
	sheet("Actuals Data") cellrange(A2:S364) firstrow

sum
de

** Convert fully to long format

gen id = _n

reshape long FY, i(id) j(fiscal_year)


** Clean 

rename Fund fund_number
rename Legacy legacy_number 
rename RevenueAccounts revenue_account_disc 
rename FY amount

gen fund_disc = ""
replace fund_disc = "General Fund" if fund_number == "A001"
replace fund_disc = "Convention Center Bond Fund" if fund_number == "B022" 
replace fund_disc = "Conduit Enterprise Fund" if fund_number == "B024" 
replace fund_disc = "Waste Water Utility Fund" if fund_number == "B070" 
replace fund_disc = "Water Utility Fund" if fund_number == "B071"  
replace fund_disc = "Stormwater Utility Fund" if fund_number == "B072"  
replace fund_disc = "Unknown" if fund_number == "B073" 
replace fund_disc = "Parking Enterprise Fund" if fund_number == "B075" 
replace fund_disc = "Parking Management Fund" if fund_number == "B076" 
replace fund_disc = "Unknown" if fund_number == "C001" 

gen amount_missing = 1 if amount == .
replace amount_missing = 0 if amount != .
replace amount = 0 if amount == .

gen fine_fee_tag = 0

** Fine or fee related legacy_numb
	
replace fine_fee_tag = 1 if legacy_number == "A001-120" /* 	City/State Business */
replace fine_fee_tag = 1 if legacy_number == "A001-122" /* 	Alcoholic Beverage */
replace fine_fee_tag = 1 if legacy_number == "A001-123" /* 	Marriage */
replace fine_fee_tag = 1 if legacy_number == "A001-127" /* 	Cable TV Franchise Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-128" /* 	Fire Prevention - Fire Code */
replace fine_fee_tag = 1 if legacy_number == "A001-129" /*  Rental Property Registrations */
replace fine_fee_tag = 1 if legacy_number == "A001-130" /*  Multiple Family Dwelling Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-131" /* 	Miscellaneous Building Inspection Revenue */
replace fine_fee_tag = 1 if legacy_number == "A001-132" /* 	Building Construction Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-133" /* 	Electrical Installation Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-134" /* 	Mechanical Equipment Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-135" /* 	Plumbing Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-136" /* 	Elevator Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-137" /* 	Filing Fees - Building Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-138" /* 	Alarm System Registration Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-139" /* 	Public Assembly Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-140" /* 	Professional and Occupational Licenses */
replace fine_fee_tag = 1 if legacy_number == "A001-141" /* 	Vacant Structure Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-143" /* 	Amusement Device Licenses */
replace fine_fee_tag = 1 if legacy_number == "A001-145" /* 	Dog Licenses and Kennel Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-146" /* 	Special Police Appointment Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-149" /* 	Vacant Lot Registration Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-150" /* 	Trades Licenses */
replace fine_fee_tag = 1 if legacy_number == "A001-151" /* 	Food Dealer Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-152" /* 	Swimming Pool Licenses */
replace fine_fee_tag = 1 if legacy_number == "A001-154" /* 	Solid Waste Collection Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-163" /* 	Minor Privilege Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-164" /* 	Public Utility Pole Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-166" /* 	Telephone Conduit Franchise */
replace fine_fee_tag = 1 if legacy_number == "A001-169" /* 	Permits and Inspections - Private Paving */
replace fine_fee_tag = 1 if legacy_number == "A001-170" /* 	Development Agreement Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-171" /* 	Street Cut Permits */
replace fine_fee_tag = 1 if legacy_number == "A001-173" /* 	Special Events Permits */
replace fine_fee_tag = 2 if legacy_number == "A001-177" /* 	Court-Ordered Restitution and Misc Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-178" /* 	Civil Citations */
replace fine_fee_tag = 2 if legacy_number == "A001-179" /* 	Sheriff Revenue */
replace fine_fee_tag = 2 if legacy_number == "A001-180" /* 	Forfeitures Drug/Gambling Contraband */
replace fine_fee_tag = 2 if legacy_number == "A001-181" /* 	Minimum Wage Violations */
replace fine_fee_tag = 2 if legacy_number == "A001-182" /* 	Environmental Control Board Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-185" /* 	Bad Check Charge */
replace fine_fee_tag = 2 if legacy_number == "A001-186" /* 	District Court Housing Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-187" /* 	Liquor Board Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-188" /* 	Library Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-189" /* 	Stormwater and Sediment Control Penalties */
replace fine_fee_tag = 2 if legacy_number == "A001-190" /* 	Street Cut Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-191" /* 	Red Light Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-192" /* 	Right Turn on Red Fines */
replace fine_fee_tag = 2 if legacy_number == "A001-193" /* 	Speed Cameras */
replace fine_fee_tag = 2 if legacy_number == "A001-194" /* 	Commercial Truck Enforcement */
replace fine_fee_tag = 1 if legacy_number == "A001-617" /* 	Emergency Repairs - Contractors' Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-618" /* 	Transcriber Service Charges */
replace fine_fee_tag = 1 if legacy_number == "A001-620" /* 	RBDL Administration Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-621" /* 	Bill Drafting Service */
replace fine_fee_tag = 1 if legacy_number == "A001-623" /* 	Zoning Appeal Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-624" /* 	Rehab Loan Application Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-628" /* 	Civil Marriage Ceremonies */
replace fine_fee_tag = 1 if legacy_number == "A001-632" /* 	Lien Reports */
replace fine_fee_tag = 1 if legacy_number == "A001-633" /* 	Election Filing Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-634" /* 	Surveys Sales of Maps and Records */
replace fine_fee_tag = 1 if legacy_number == "A001-635" /* 	Telephone Commissions */
replace fine_fee_tag = 1 if legacy_number == "A001-636" /* 	3rd Party Disability Recoveries */
replace fine_fee_tag = 1 if legacy_number == "A001-637" /* 	Open Enrollment Expense Reimbursement */
replace fine_fee_tag = 1 if legacy_number == "A001-638" /* 	Semi - Annual Tax Payment Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-639" /* 	Tax Roll Service Charge */
replace fine_fee_tag = 1 if legacy_number == "A001-640" /* 	Audit Fees - Comptroller's Office */
replace fine_fee_tag = 1 if legacy_number == "A001-643" /* 	Reimbursable Billing Costs */
replace fine_fee_tag = 1 if legacy_number == "A001-648" /* 	Sub-division Plat Charges */
replace fine_fee_tag = 1 if legacy_number == "A001-649" /* 	Vending Machine Commissions */
replace fine_fee_tag = 1 if legacy_number == "A001-651" /* 	Reimbursement for Use of City Vehicles */
replace fine_fee_tag = 1 if legacy_number == "A001-654" /* 	Charges for Central City Services */
replace fine_fee_tag = 1 if legacy_number == "A001-656" /* 	Animal Shelter Sales and Charges */
replace fine_fee_tag = 1 if legacy_number == "A001-657" /* 	Liquor Board Advertising Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-659" /* 	Sale of Accident and Incident Reports */
replace fine_fee_tag = 1 if legacy_number == "A001-660" /* 	Stadium Security Service Charges */
replace fine_fee_tag = 1 if legacy_number == "A001-661" /* 	Port Fire Protection (MPA) */
replace fine_fee_tag = 1 if legacy_number == "A001-662" /* 	Sheriff - District Court Service */
replace fine_fee_tag = 1 if legacy_number == "A001-663" /* 	False Alarm Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-664" /* 	Fire Dept - Sales of Reports */
replace fine_fee_tag = 1 if legacy_number == "A001-665" /* 	Fire Ambulance Stadium Services */
replace fine_fee_tag = 1 if legacy_number == "A001-666" /* 	Child Support Enforcement */
replace fine_fee_tag = 1 if legacy_number == "A001-667" /* 	Fire Department Employment Application Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-668" /* 	Deputy Sheriff Enforcement */
replace fine_fee_tag = 1 if legacy_number == "A001-669" /* 	Federal Marshall Service */
replace fine_fee_tag = 1 if legacy_number == "A001-670" /* 	Police Sporting Events Fee */
replace fine_fee_tag = 1 if legacy_number == "A001-680" /* 	Miscellaneous Environmental Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-681" /* 	Air Quality Fees (1989, Ordinance #323) */
replace fine_fee_tag = 1 if legacy_number == "A001-754" /* 	Waxter Center Memberships */
replace fine_fee_tag = 1 if legacy_number == "A001-773" /* 	Video Rental and Other Charges */
replace fine_fee_tag = 1 if legacy_number == "A001-777" /* 	Swimming Pool Passes */
replace fine_fee_tag = 1 if legacy_number == "A001-778" /* 	General Recreation and Culture Charges */
replace fine_fee_tag = 1 if legacy_number == "A001-785" /* 	Impounding Cars - Storage */
replace fine_fee_tag = 1 if legacy_number == "A001-787" /* 	Impounding Cars - Towing */
replace fine_fee_tag = 1 if legacy_number == "A001-790" /* 	Stormwater and Sediment Control Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-795" /* 	Landfill Disposal Tipping Fees */
replace fine_fee_tag = 1 if legacy_number == "A001-797" /* 	Solid Waste Surcharge */
replace fine_fee_tag = 1 if legacy_number == "A001-800" /* 	Bulk Trash Collection */
replace fine_fee_tag = 1 if legacy_number == "A001-865" /* 	Vacat Struct & Boarding Fees */
replace fine_fee_tag = 2 if legacy_number == "B070-838" /* 	Non - Compliance Fines	 */
replace fine_fee_tag = 1 if legacy_number == "B072-790" /* 	Stormwater Management Fee */
replace fine_fee_tag = 1 if legacy_number == "B072-825" /* 	Stormwater Fee */
replace fine_fee_tag = 2 if legacy_number == "B075-182" /* 	Penalties on Parking Fines */
replace fine_fee_tag = 1 if legacy_number == "B076-760" /* 	Parking Garages */
replace fine_fee_tag = 1 if legacy_number == "B076-866" /* 	Booting Fee */
replace fine_fee_tag = 1 if legacy_number == "C001-170" /* 	Developer Agreement Fees */
replace fine_fee_tag = 1 if legacy_number == "C001-171" /* 	Street Cut Permit Fees */
replace fine_fee_tag = 2 if legacy_number == "C001-175" /* 	Stormwater and Sediment Control Penalty */
replace fine_fee_tag = 2 if legacy_number == "C001-176" /* 	Street Cut Fines */
replace fine_fee_tag = 2 if legacy_number == "C001-180" /* 	Red Light Fines */
replace fine_fee_tag = 2 if legacy_number == "C001-181" /* 	Right Turn On Red Fines */
replace fine_fee_tag = 1 if legacy_number == "C001-182" /* 	Speed Cameras */
replace fine_fee_tag = 2 if legacy_number == "C001-652" /* 	Impounding Cars */
replace fine_fee_tag = 1 if legacy_number == "C001-652" /* 	Stormwater and Sediment Control Fees */

	
sort fiscal_year fund_number	
by fiscal_year fund_number : egen rank = rank(-amount)
by fiscal_year fund_number: egen total = total(amount)
gen fund_share = amount / total * 100
drop total

sort fiscal_year fund_number fine_fee_tag 
by fiscal_year fund_number fine_fee_tag : egen type_rank = rank(-amount)

gen amount_mil = amount / 1000000	

label define finefee 0 "Neither" 1 "Fee" 2 "Fine"
label values fine_fee_tag finefee

save fy03_to_fy18_historic_rev.dta, replace
log close


log using "revenue_results_log", replace
	
** General Fund Summary Stats

table fiscal_year fund_number, 						///
	c(sum amount) format(%14.0fc) col row

* General fund revenue by year and fine / fee tag
table fiscal_year fine_fee_tag if fund_number == "A001", 						///
	c(sum amount) format(%14.0fc)
	
* General fund revenue share by year and fine / fee tag
table fiscal_year fine_fee_tag if fund_number == "A001", 						///
	c(sum fund_share) format(%14.0fc)

* General fund revenue type by fine / fee tag IF over 0.5% of gen fund revenue
table revenue_account_disc fine_fee_tag if fund_number == "A001" & 				///
										  fund_share > 0.5 &					///
										  fiscal_year == 2018, 					///
	c(sum fund_share) format(%14.2fc)
	
* Non-general fund revenue type by fine / fee tag IF over 0.5% of fund revenue
	
table revenue_account_disc fine_fee_tag if fund_number != "A001" & 				///
										  fund_share > 0.5 &					///
										  fiscal_year == 2018, 					///
	c(sum amount) format(%14.2fc)

	
* Top ten largest fines + top ten larges fees in 2018 

table revenue_account_disc fine_fee_tag if fine_fee_tag != 0 & 					///
										  fund_number == "A001" & 				///
										  type_rank < 11 &						///
										  fiscal_year == 2018, 					///
	c(sum amount) format(%14.2fc) 	
	
* Table showing the drop in speeding camera revenue in 2014 through 2017

table fiscal_year if revenue_account_disc == "Speed Cameras" & 					///
	fund_number == "A001", c(sum amount sum fund_share) format(%14.2fc) 

	
* Figure showing revenue by source for 2018
graph bar (sum) amount_mil if fund_number == "A001" & fiscal_year == 2018, 		///
	over(fine_fee_tag) blabel(bar, format(%14.0fc)) 							///
	ylabel(, format(%14.0fc)) 													///
	ytitle(Revenue in Millions)  												///												
	title("2018 General Fund Revenue") 
graph export "revenue_generalfund_bysource.pdf", replace


* Figure showing revenue by source for 2018
graph bar (sum) amount if fiscal_year > 2007 & 								///
	revenue_account_disc == "Environmental Control Board Fines" , 				///
	over(fiscal_year) 					///
	ylabel(, format(%14.0fc)) 													///
	ytitle(General Fund Revenue)  												///												
	title("Environmental Control Board Fines") 
graph export "ECB_revenue.pdf", replace

* Table showing library fine amounts over time. 

table fiscal_year if revenue_account_disc == "Library Fines", 					///
	c(sum amount sum fund_share) format(%14.2fc) 
	
graph export 2018_revenue_bar.pdf, replace

clear

log close






