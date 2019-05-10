# finesandfees_baltimore

## Introduction 

This repository holds the stata code used to analyze data from the City of Baltimore on data related to fines. It also holds various materials related to our analysis of fines and fees in Baltimore. 

## File Structure - Materials

This repository has the following folders containing non-data materials collected or constructed during our analysis. 

#### interview_materials

## File Structure - Data Analysis

The repository should have the following folders related to the data processs:

#### raw_data
This folder should hold all of the raw data used in the analysis in csv form. The version on this repository holds the crosswalk between nsa and csa neighborhood groups, but the rest of the data should be downloaded by the user. 

#### data_cleaned
Stata datasets created in this process will be stored in this folder. It is empty here due to space constraints.  

#### do_files
The individual do-files that master.do will call to clean the individual datasets are stored here. 

#### logs
All log files, whether they record the data cleaning process or the results, are stored here. 

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
