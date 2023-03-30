# About me ---------------------------------------------------------------------
# Nitrous Acid Program in R (NAPR)
# Currently only working for diurnal.
# Easily use diurnals package if needed (https://github.com/bhoover59/diurnals)
# Standardized form of calculating HONO sources and modeling [HONO]
# Later will make corresponding Nitrous Acid Program in Python (NAPPy)
# Later will make RShiny App for best UI

# Clear Memory -----------------------------------------------------------------
rm(list = ls())

# Getting functions from other scripts------------------------------------------
# Eventually need to put on github and use NAPR:: before function names?
path <- getwd()
file <- paste(path, '/R/', 'get_functions', '.R', sep = "")
source(file)
get_functions() # load files to enable functions

# Dependencies -----------------------------------------------------------------
# Install and load necessary packages
load_packages()

# Get input --------------------------------------------------------------------
# df <- read.csv('C:\\Users\\bodehoov\\Desktop\\Final MI 2022 Data\\DiurnalNAPR.csv')
# df <- read.csv('C:\\path to file\\file name.csv')
df <- get_input_file() # Load csv file. INPUT IN PPB FOR SPECIES

# Check input ------------------------------------------------------------------
# check for required columns
# They don't have to have valid data, but they must exist
check_input(df)

# Initial parameters -----------------------------------------------------------
# Includes deposition velocities and other constants
initial <- get_initial()

# Converting units, convert to molec/cm3 from ppb
df <- convert_to_percc(df)

# Optional functions -----------------------------------------------------------
# Must have Rain column with 1 for rain and 0 for dry
# compare = 1 -> Rain days only, 2 = dry days only, otherwise keep all data
df <- get_rain_days(df = df, compare = 0)

# Meteorological information ---------------------------------------------------
# RH input must be % right now. Might update to have optional conversion
# Pressure must be in atm. Might update to have optional conversion
df <- get_met(df = df, temp_units = 'C', temp_column = 'Temp')

# Photolysis and TUV Model ------------------------------------------------------
# TUV model takes a couple of minutes to run
# NCAR TUV differs substantially from MCM & F0AM
df <- TUV_hourly(df = df, date = 20220728, latitude = 45.568100, longitude = -84.682869, gAltitude = 0.2667, mAltitude = 0.26715)
# FIX JHONO SO IT WORKS CONSISTENTLY
# Sometimes TUV output is weird, especially on fringes so you may need to edit some values especially if 0 --> infinity
df <- get_J_values(df = df, JNO2 = 2, Jcorr = 1)
# JNO2 = 1, use JNO2 measurements
# JNO2 = 2 use TUV modeled JNO2
# Jcorr = 1 calculate Jcorr by JNO2 measured/JNO2 TUV
# Jcorr = 0 input your own column of Jcorr values
# Jcorr = 2 input JHONO values
# Jcorr = else use ideal conditions (don't want to scale by Jcorr), not recommended
# Calculates JHONO based on JNO2 and Jcorr

# Run the model ----------------------------------------------------------------
df_kinetics <- get_kinetics(df, initial) # get rate constants and boundary layer height
df_model <- run_model(df_kinetics, initial) # calculate HONO and unknown source
df_model <- convert_to_mixing_ratio(df_model) # convert output to ppb except OH and rates
# df_model <- convert_to_numeric(df_model) # convert all columns to numeric

# Plotting ---------------------------------------------------------------------
plot_HONO(df = df_model, xlab = 'Hour', ylab = '[HONO] (ppt)')
plot_species(df = df_model, species = 'JHONO', xlab = 'Hour', ylab = 'J Photolysis (s-)')
plot_rates(df = df_model) # plot HONO production and loss rates
plot_stacked_rates(df = df_model) # plot stacked loss rates with total production line
plot_all_stacked_rates(df = df_model) # plot all individual production and loss rates stacked
plot_all_stacked_rates_test(df = df_model) # plot all individual production and loss rates stacked

# Summary report ---------------------------------------------------------------
# Print summary statistics for subset of data frame
# Currently subsets for HONO_pss and unknown but can easily be edited
report_summary(df_model)

# Output csv -------------------------------------------------------------------
output_csv(df_model, file_name = 'NAPR output') # output csv to working directory
