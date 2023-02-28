# About me ----
# Nitrous Acid Program in R (NAPR)
# Currently only working for diurnal. Easily use diurnals package if needed
# Standardized form of calculating HONO sources and modeling [HONO]
# Later will make corresponding Nitrous Acid Program in Python (NAPPy)
# Later will make RShiny App for best UI
# df supplied must have all of the correct columns
# MAKE get_initial FUNCTION TO INPUT VELOCITIES, INPUT FILE, AND OTHERS

# Clear Memory ------------------------------------------------------------
rm(list = ls())
# Dependencies --------------------------------------------↓
library(ggplot2)

# Get input --------------------------------------------
# df <- read.csv('C:\\Users\\bodehoov\\Desktop\\Final MI 2022 Data\\DiurnalNAPR.csv')
df <- NAPR::get_input() # Load csv file

# Initial parameters ----
R <- 0.0820574 # L atm/ mol K
Mass_NO2 <- 46.0055 # g/mol
Mass_HONO <- 47.013 # g/mol
Mass_nitrate <- 62.0049 # g/mol
M <- 2.46e19

# HONO Deposition
v_HONO <- 2 / 100 # cm/s converted to m/s
H <- 200 # boundary layer height (m)
gamma_HONO_ground <- 7.3e-5
noon_JNO2 <- 1e-5

# NO2 Deposition
# https://pubs.acs.org/doi/full/10.1021/acs.est.8b06367, Liu 2019
v_NO2 <- 2 / 100 # cm/s converted to 2 m/s
# CHECK SONG 2022 SUPPLEMENT FOR EQUATIONS AND PARAMETERS

# Aerosols
gamma_NO2_aerosol <- 1.4e-4 # Liu 2019, Xue 2022a from Song 2022, Song 2022
S_aerosol <- 1e-4 # surface area of aerosols, m2/m3

# Ground surface
# Dark conversion/deposition
gamma_NO2_ground <-  8e-6  # Liu 2019
# Photo enhanced NO2 conversion

# HNO3 Deposition
v_HNO3 <- 2 / 100 # cm/s converted to 2 m/s
J_HNO3 <- 2 / 100 # cm/s converted to 2 m/s

# Converting units, convert to molec/cm3 from ppb or ppt
df <- NAPR::convert_to_percc(df)

# Run the model ----
df_kinetics <- NAPR::get_kinetics(df) # get rate constants
df_model <- NAPR::run_model(df_kinetics) # calculate HONO and unknown source
df_model <- NAPR::convert_to_mixing_ratio(df_model) # convert output to ppb except OH

# Plotting ----
plot_species(df = df_model, species = 'HONO_pss', xlab = 'Hour', ylab = 'HONO')
