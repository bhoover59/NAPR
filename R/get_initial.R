get_initial <- function(){
  # Initialize data frame ------------------------------------------------------
  initial <- data.frame(matrix(NA, nrow = 1, ncol = 1))
  # Constants ------------------------------------------------------------------
  initial$R <- 8.314 # J / mol K
  initial$Mass_NO2 <- 46.0055 # g/mol
  initial$Mass_HONO <- 47.013 # g/mol
  initial$Mass_nitrate <- 62.0049 # g/mol
  initial$M <- 2.46e19 # concentration of intermediate air molecules

  # Deposition and Conversion --------------------------------------------------
  initial$gamma_NO2_aerosol <- 1e-5 # Liu 2019, Xue 2022a from Song 2022, Song 2022
  # Over 100 m2/m3 excluded by Janson 2016 for being too high for pine forest
  # Ranges from 0.01 to over 100 depending on location and local meteorological conditions
  initial$gamma_NO2_ground <- 1e-6
  # 8e-6  # Liu 2019
  initial$S_aerosol <- 1e-4 # surface area of aerosols clean, m2/m3 (https://cires1.colorado.edu/jimenez-group/Press/2015.05.22-Atmospheric.Chemistry.Cheat.Sheet.pdf)
  # initial$S_aerosol <- 2e-3 if urban
  # Boundary layer height located in get_kinetics.R

  # Photoenhanced version in get_kinetics.R
  # Only use these if no RH or pH measurements. Otherwise adjust the weighting of RH and pH
  initial$gamma_HONO_ground <- 8.7e-5
  initial$gamma_HONO_aerosol <- 7.3e-5
  initial$beta <- 0.00724 # light scaling factor

  initial$HONO <- 20 # ppt HONO initialization

  # Boundary layer height initialization
  initial$BLH_night <- 200 # m, night time boundary layer height, Daytime = 3 * Night
  # Boundary layer rain = 0.5 * BLH dry Che 2021 (https://acp.copernicus.org/articles/21/5253/2021/acp-21-5253-2021.pdf), Li 2011; Zuo 2004

  # HNO3 Deposition
  initial$v_HNO3 <- 2 / 100 # cm/s converted to 2 m/s
  initial$J_HNO3 <- 1e-4

  # Vehicle emissions ----------------------------------------------------------
  initial$HONO_NOx <- 1e-3 # ratio to estimate influence of anthropogenic emissions

  # Soil Emissions ------------------------------------------------------
  # ECM: no soil emissions
  # AM: soil emissions
  # you can edit production_mechanisms.R to change how soil emissions are handled
  # Right now it is just turn on or off default
  initial$soil_type <- 0 # 'AM' to turn on
  initial$F_soil_HONO <- 5 # ng/m2 s flux emission of HONO estimate

  # Dilution
  initial$kdil <- 1/86400 # s- lifetime of species in box 1/day

  # Estimate OH
  initial$estimate_OH <- 0 # 1 to estimate OH using NOx and O3, 0 to use measurements

  # Delete first column used to initialize
  initial <- initial[,-1]

  return(initial)
}
