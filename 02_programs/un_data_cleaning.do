/*
  1. Transform the data so that for each indicator we can create a score documenting whether a value exists for the country in a year, whether the value is based on country data, country data adjusted, estimated, or modelled data according the UN Stats metadata. **This will only include tier 1 indicators**.    
  
  2. Combine the resulting data into a single file for use in the Statistical Performance Indicators dashboard and index

# UN Stats Database

Below is a paraphrased description from the UN stats webpage (https://unstats.un.org/sdgs/indicators/indicators-list/):

The global indicator framework for Sustainable Development Goals was developed by the Inter-Agency and Expert Group on SDG Indicators (IAEG-SDGs) and agreed upon at the 48th session of the United Nations Statistical Commission held in March 2017.

The global indicator framework includes 231 unique indicators. Please note that the total number of indicators listed in the global indicator framework of SDG indicators is 247. However, twelve indicators repeat under two or three different targets.

For each value of the indicator, the responsible international agency has been requested to indicate whether the national data were adjusted, estimated, modelled or are the result of global monitoring. The “nature” of the data in the SDG database is determined as follows:


  * Country data (C): Produced and disseminated by the country (including data adjusted by the country to meet international standards);    
  
  * Country data adjusted (CA): Produced and provided by the country, but adjusted by the international agency for international comparability to comply with internationally agreed standards, definitions and classifications;    
  
  * Estimated (E): Estimated based on national data, such as surveys or administrative records, or other sources but on the same variable being estimated, produced by the international agency when country data for some year(s) is not available, when multiple sources exist, or when there are data quality issues;    
  
  * Modeled (M): Modeled by the agency on the basis of other covariates when there is a complete lack of data on the variable being estimated;    
  
  * Global monitoring data (G): Produced on a regular basis by the designated agency for global monitoring, based on country data. There is no corresponding figure at the country level.

*/


clear

* Set the path the un_sdg_df.csv file
gl data_path "C:/Users/wb469649/OneDrive - WBG/Documents/Github/UN_Stats_SDG_Indicators_SPI/03_output_data/un_sdg_df.csv"

* set the time window
gl min_year=2015
gl max_year=2020

*load the data
import delimited using "$data_path" , encoding(UTF-8) 

* keep data inside window
keep if date<= $max_year & date >= $min_year

* 
destring ind_value, replace force
destring ind_quality, replace force



* collapse and check if there are any values with a quality indicator ()
collapse (max) ind_quality (mean) ind_value (first) ind_metadata, by(iso3c code goal)

replace ind_quality=0 if missing(ind_quality)

* now group by goal
collapse (mean) ind_quality, by(iso3c goal)