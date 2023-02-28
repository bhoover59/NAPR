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
library(diurnals)

# Get input --------------------------------------------------------------------
# df <- read.csv('C:\\Users\\bodehoov\\Desktop\\Final MI 2022 Data\\DiurnalNAPR.csv')
df <- NAPR::get_input_file() # Load csv file

# Check input ------------------------------------------------------------------
# check for required columns
# They don't have to have valid data, but they must exist
check_input(df)

# Initial parameters -----------------------------------------------------------
# Includes deposition velocities and other constants
initial <- get_initial()

# Converting units, convert to molec/cm3 from ppb or ppt
df <- NAPR::convert_to_percc(df)

# Optional functions -----------------------------------------------------------
# change to TRUE if you want to compare rain vs dry days. Must have Rain column with 1 for rain and 0 for dry
# 1 = Rain days only, 2 = dry days only, otherwise keep all data
df <- NAPR::get_rain_days(df = df, compare = 0)
df <- NAPR::get_met(df = df, temp_units = 'C', temp_column = 'Temp')

# Run the model ----------------------------------------------------------------
df_kinetics <- NAPR::get_kinetics(df) # get rate constants
df_model <- NAPR::run_model(df_kinetics, initial) # calculate HONO and unknown source
df_model <- NAPR::convert_to_mixing_ratio(df_model) # convert output to ppb except OH

# Plotting ---------------------------------------------------------------------
plot_species(df = df_model, species = 'HONO_pss', xlab = 'Hour', ylab = 'HONO')
plot_species(df = df_model, species = 'OH', xlab = 'Hour', ylab = 'OH')
