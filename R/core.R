# About me ---------------------------------------------------------------------
# Nitrous Acid Program in R (NAPR)
# Written by Bode Hoover (bodehoov@iu.edu)
# Currently only working for diurnal.
# Easily use diurnals package if needed (https://github.com/bhoover59/diurnals)
# Standardized form of calculating HONO sources and modeling [HONO]

# Clear Memory -----------------------------------------------------------------
rm(list = ls())

# Getting functions from other scripts------------------------------------------
# Eventually need to put on github and use NAPR:: before function names? or keep local
path <- getwd()
file <- paste(path, '/R/', 'get_functions', '.R', sep = "")
source(file)
get_functions() # load files to enable functions

# Dependencies -----------------------------------------------------------------
load_packages()

# Get input --------------------------------------------------------------------
df <- read.csv('C:\\Users\\bodehoov\\OneDrive - Indiana University\\NAPR\\Test Data\\DiurnalNAPR.csv')
# df <- read.csv('C:\\path to file\\file name.csv')
# df <- get_input_file() # Load csv file. INPUT IN PPB FOR SPECIES

# Check input ------------------------------------------------------------------
# check for required columns. They don't have to have valid data, but they must exist
check_input(df)

# Initial parameters -----------------------------------------------------------
# Includes constants and user options
initial <- get_initial()

# Converting units, convert to molec/cm3 from ppb
df <- convert_to_percc(df)

# Optional functions -----------------------------------------------------------
# Must have Rain column with 1 for rain and 0 for dry
# compare = 1 -> Rain days only, 2 = dry days only, otherwise keep all data
df <- get_rain_days(df = df, compare = 0)

# Meteorological information ---------------------------------------------------
df <- get_met(df = df, temp_units = 'C', temp_column = 'Temp', RH_units = 'perc')

# Photolysis and TUV Model -----------------------------------------------------
df <- TUV_hourly(df = df, date = 20220728, latitude = 45.568100, longitude = -84.682869, gAltitude = 0.2667, mAltitude = 0.26715)
df <- get_J_values(df = df, JNO2 = 0, Jcorr = 2)

# Run the model ----------------------------------------------------------------
df_kinetics <- get_kinetics(df = df, initial = initial) # get rate constants and uptake coefficients
df_model <- run_model(df_kinetics, initial) # calculate HONO and unknown source

# Plotting ---------------------------------------------------------------------
plot_HONO(df = df_model, xlab = 'Hour', ylab = '[HONO] (ppt)')
plot_HONO_grid(df = df_model, xlab = 'Hour', ylab = '[HONO] (ppt)')
# plot_species(df = df_model, species = 'NO2', xlab = 'Hour', ylab = 'Concentration (ppb)')
plot_rates(df = df_model) # plot all individual production and loss rates stacked

# Summary report ---------------------------------------------------------------
# report_summary(df_model)

# Percent contribution of each mechanism ---------------------------------------
df_model <- percent_contribution(df = df_model, view_percentages = 0)

# Plot correlations
plot_correlation(df_model)

# Output csv -------------------------------------------------------------------
output_csv(df_model, file_name = 'NAPR_output') # output csv to working directory


