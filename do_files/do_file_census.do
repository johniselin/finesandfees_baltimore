
/***********************************************************************
Author: Sarah Edwards
Date: Spring 2019

Goldman School of Public Policy 
Masters in Public Policy Program
Introduction to Policy Analysis 
Fines and Fees in Baltimore

This do-file downloads, cleans, and uses data from Baltimore's Open data system.
https://data.baltimorecity.gov/

In this case, this do-file cleans the dataset "Vital_Signs_16_Census_Demographics"


**************************************************************************/

clear

import delimited "raw_data/Vital_Signs_16_Census_Demographics.csv", bindquote(strict) 

sum
de


rename csa2010 neighborhoods_csa
rename tpop10 total_pop_2010
rename male10 male_pop_2010
rename female10 female_pop2010
rename paa16 perc_black_16
rename pwhite16 perc_white_16
rename pasi16 perc_asian_16
rename p2more16 perc_twoplus_16
rename ppac16 perc_pacificislander_16
rename phisp16 perc_hispanic_16
rename racdiv16	racial_diversity_index
rename hhs16 total_households
rename femhhs16 female_head_16
rename fam16 families_with_children_16
rename mhhi16 median_household_inc
rename hh25inc16 perc_households_under_25k
rename hh40inc16 perc_households_25to40k
rename hh60inc16 perc_households_40to60k
rename hh75inc16 perc_households_60to75k
rename hhm7516 perc_households_over75k
rename hhpov16 perc_households_below_pov
rename hhchpov16 perc_childern_below_pov

drop racial_diversity_index perc_childern_below_pov median_household_inc		///
		male_pop_2010 female_pop2010 families_with_children_16 ïobjectid

gen young_16 = age5_16 + age18_16 + age24_16
gen working_16 = age64_16
gen old_16 = age65_16

gen perc_households_25to60k = perc_households_25to40k + perc_households_40to60k
replace perc_households_over75k = perc_households_60to75k + perc_households_over75k

drop age5_16 age18_16 age24_16 age64_16 age65_16 perc_households_25to40k		///
	perc_households_40to60k perc_households_60to75k shape__area shape__length 

xtile quint_female_head = female_head_16 [fw = total_pop_2010], n(5)
table quint_female_head, c(max female_head_16 min female_head_16)

xtile quint_workingage = working_16 [fw = total_pop_2010], n(5)
table quint_workingage, c(max working_16 min working_16)

xtile quint_black = perc_black_16 [fw = total_pop_2010], n(5)
table quint_black, c(max perc_black_16 min perc_black_16)
label define pct_black 1 "1.7% to 29.8%" 2 "31.2% to 63.1%" 3 "63.1% to 84.6%" 	///
	4 "84.9% to 93.5%" 5 "93.8% to 96.6%"
label values quint_black pct_black
label variable quint_black "Quintiles by Black Share of Residents"


xtile quint_poverty = perc_households_below_pov [fw = total_pop_2010], n(5)
table quint_poverty, c(max perc_households_below_pov min perc_households_below_pov)
label define pct_poverty 1 "0.8% to 8.1%" 2 "10.0% to 15.1%" 3 "15.4% to 19.9%" ///
	4 "20.3% to 26.3%" 5 "29.2% to 47.7%"
label values quint_poverty pct_poverty
label variable quint_poverty "Quintiles by Share of Residents in Poverty"


label data

save "data_cleaned/census_data_cleaned.dta", replace
clear 



