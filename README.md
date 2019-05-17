# finesandfees_baltimore

## Introduction 

This repository holds the stata code used to analyze data from the City of Baltimore on data related to fines. 

Cities and counties across the country have found that fines and fees criminalize poverty and reinforce racial and socioeconomic inequities in their communities. In this report, we outline findings from Baltimore City departments that interact with fines and fees, as well as community partners on the impact of fines and fees in Baltimore. We conclude that:
* Fines and fees in Baltimore have a disproportionate impact on Black communities.
* Fines and fees in Baltimore have a disproportionate impact on low-income communities.
* Fines and fees do not generate significant revenue for the city. 

Baltimore has the chance to emerge as a national leader in fines and fees reform. We recommend drawing from models in San Francisco and Chicago to establish a task force. This task force should work collaboratively to deepen the City’s understanding of the impact of fines and fees on Baltimore residents, lead reform efforts, and ensure effective implementation of these reforms.

## Data Discussion

We wanted to use available information from Baltimore’s open data system to measure the differential impact of fines and fees on specific communities - namely neighborhoods that are predominantly black or low-income. 
We focused our analysis on two datasets: Baltimore Police Department (BPD) arrest records and Environmental Control Board (ECB) citations. 

We chose these datasets because we saw evidence that these citations and police interactions have a real impact on people’s lives. and because we have the data necessary to measure this impact across demographics. With the BPD data we could directly observe the race of individuals who were arrested. With ECB citations, because they are linked to properties, we could observe the neighborhoods most heavily hit with citations, and therefore use Census Tract level demographics. 

In the BPD data, we can observe arrests we suspect of being related to fines and fees. This means someone who is arrested for having an outstanding warrant for (1)Failure to appear, (2) Failure to pay, OR (3) Driving on a suspended license. The original interaction could be over some unrelated matter, but the eventual arrest is for this warrant. These arrests made up about 16% of total arrests between 2014 and 2019.
 
The ECB is an independent agency that is charged with collecting fees that are issued by seven other city agencies. The majority of citations are issued by DHCD, making up 96.6% of the citations issued in 2018. We look at ECB citations because
(1) ECB citations are one of the larger sources of fine revenue, and (2) we are very confident in the neighborhood matching, so we can use the US census data.

When looking at these citations, neighborhoods with a higher share of black residents faced higher average fine amounts and a higher number of citations, meaning that overall, the neighborhood with the highest share of black residents owed almost four times as much as neighborhoods with the lowest share. 


## File Structure

The repository should have the following folders related to the data processs:

#### raw_data
This folder should hold all of the raw data used in the analysis in csv form. The version on this repository holds the crosswalk between nsa and csa neighborhood groups, but the rest of the data should be downloaded by the user. 

#### data_cleaned
Stata datasets created in this process will be stored in this folder. It is empty here due to space constraints.  

#### do_files
The individual do-files that master.do will call to clean the individual datasets are stored here. 

#### logs
All log files, whether they record the data cleaning process or the results, are stored here. 

#### revenue 
All log files and do files for our revenue analysis. Since we use internal Baltimore revenue data, we do not include the data files for our revenue analysis.

#### other
Contains the visualizations we used in our analysis. 

#### master.do
This do file is the only file you should have to run or modify, as it operates in this file-strucutre.
Make sure to change the filepath, and download the requisite datasets to the raw_data folder prior to running. 

## Data

Prior to running, download the following from Baltimore's Open Data system, Open Baltimore: https://data.baltimorecity.gov/

#### BPD Arrests
https://data.baltimorecity.gov/Public-Safety/BPD-Arrests/3i3v-ibrt

#### DOT Towing
https://data.baltimorecity.gov/Transportation/DOT-Towing/k78j-azhn

#### Environmental Citations
https://data.baltimorecity.gov/City-Services/Environmental-Citations/ywty-nmtg

#### Parking Citations
https://data.baltimorecity.gov/Transportation/Parking-Citations/n4ma-fj3m

#### Real Property Taxes
https://data.baltimorecity.gov/Financial/Real-Property-Taxes/27w9-urtv

#### Vacant Buildings
https://data.baltimorecity.gov/Housing-Development/Vacant-Buildings/qqcv-ihn5

#### Vital Signs 16 Census Demographics 
https://data.baltimorecity.gov/Neighborhoods/Vital-Signs-16-Census-Demographics/peh2-3qyi
