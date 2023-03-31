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
  initial$gamma_NO2_aerosol <- 1.4e-4 # Liu 2019, Xue 2022a from Song 2022, Song 2022
  # Over 100 m2/m3 excluded by Janson 2016 for being too high for pine forest
  # Ranges from 0.01 to over 100 depending on location and local meteorological conditions
  initial$gamma_NO2_ground <-  8e-6  # Liu 2019
  initial$S_aerosol <- 1e-4 # surface area of aerosols, m2/m3

  # Boundary layer height located in get_kinetics.R

  # Photoenhanced version in get_kinetics.R
  # These should eventually be RH and pH dependent on soils
  initial$gamma_HONO_ground <- 7.3e-4 # Emily value: 8.7e-5
  initial$gamma_HONO_aerosol <- 7.3e-5 # where did I get this?
  initial$beta <- 0.00724 # light scaling factor

  initial$HONO <- 20 # percc HONO initialization

  # Boundary layer height initialization
  initial$BLH_night <- 200 # m, night time boundary layer height, Daytime = 3 * Night

  # HNO3 Deposition
  initial$v_HNO3 <- 2 / 100 # cm/s converted to 2 m/s
  initial$J_HNO3 <- 1e-4 # cm/s converted to 2 m/s

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

  # Delete first column used to initialize
  initial <- initial[,-1]

  return(initial)
}
