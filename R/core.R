# About me ---------------------------------------------------------------------
# Nitrous Acid Program in R (NAPR)
# Currently only working for diurnal.
# Easily use diurnals package if needed (https://github.com/bhoover59/diurnals)
# Standardized form of calculating HONO sources and modeling [HONO]
# Later will make corresponding Nitrous Acid Program in Python (NAPPy)
# Later will make RShiny App for best UI

# Clear Memory -----------------------------------------------------------------
rm(list = ls())

# Dependencies -----------------------------------------------------------------
library(ggplot2)
# Check https://github.com/bhoover59/diurnals for more information about diurnals package
library(diurnals) # allows diurnal averaging and time averaging
library(psych) # correct describe function to return data frame
# library(magrittr) # allows %>% operator
library(dplyr) # remove duplicated columns
library(plotly) # allows interactive ggplot

# Getting functions from other scripts------------------------------------------
# Eventually need to put on github and use NAPR:: before function names
# path <- paste(getwd(), '/R/') # use this generic method when publishing package

source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\check_input.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\convert_to_mixing_ratio.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\convert_to_percc.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\core.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\get_initial.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\get_input_file.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\get_kinetics.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\get_met.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\get_rain_days.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\loss_mechanisms.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\plot_species.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\production_mechanisms.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\report_summary.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\run_model.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\plot_rates.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\convert_to_numeric.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\plot_stacked_rates.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\output_csv.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\plot_all_stacked_rates.R')
source('C:\\Users\\bodehoov\\Documents\\NAPR\\R\\TUV_core.R')


# Get input --------------------------------------------------------------------
# df <- read.csv('C:\\Users\\bodehoov\\Desktop\\Final MI 2022 Data\\DiurnalNAPR.csv')
df <- get_input_file() # Load csv file. INPUT IN PPB FOR SPECIES

# Check input ------------------------------------------------------------------
# check for required columns
# They don't have to have valid data, but they must exist
check_input(df)

# Initial parameters -----------------------------------------------------------
# Includes deposition velocities and other constants
initial <- get_initial()

# Converting units, convert to molec/cm3 from ppb or ppt
df <- convert_to_percc(df)

# Optional functions -----------------------------------------------------------
# change to TRUE if you want to compare rain vs dry days. Must have Rain column with 1 for rain and 0 for dry
# 1 = Rain days only, 2 = dry days only, otherwise keep all data
df <- get_rain_days(df = df, compare = 0)
# Meteorological information ---------------------------------------------------
# RH input must be % right now. Might update to have optional conversion
# Pressure must be in atm. Might update to have optional conversion
df <- get_met(df = df, temp_units = 'C', temp_column = 'Temp')
df <- get_J_values(df = df, JNO2 = 1, Jcorr = 1)
# if JNO2 = 1, you have JNO2 measurements. 2 means you want to use TUV JNO2
# Jcorr = 1 means you want to calculate Jcorr by JNO2 measured/JNO2 TUV
# Jcorr = 0 means you want to input your own column of Jcorr values
# Jcorr = 2 means you don't want to scale by Jcorr, use ideal conditions

# Run the model ----------------------------------------------------------------
df_kinetics <- get_kinetics(df, initial) # get rate constants
df_model <- run_model(df_kinetics, initial) # calculate HONO and unknown source
df_model <- convert_to_mixing_ratio(df_model) # convert output to ppb except OH and rates
# df_model <- convert_to_numeric(df_model) # convert all columns to numeric other than time

# Plotting ---------------------------------------------------------------------
plot_species(df = df_model, species = 'HONO_pss', xlab = 'Hour', ylab = 'HONO')
plot_species(df = df_model, species = 'OH', xlab = 'Hour', ylab = 'OH')
plot_rates(df = df_model) # plot HONO production and loss rates
plot_stacked_rates(df = df_model)
plot_all_stacked_rates(df = df_model)

# Summary report ---------------------------------------------------------------
# Print summary statistics for subset of data frame
# Currently subsets for HONO_pss and unknown but can easily be edited
report_summary(df_model)

# Output csv -------------------------------------------------------------------
output_csv(df_model, file_name = 'test name') # output csv to working directory
