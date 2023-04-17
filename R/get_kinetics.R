get_kinetics <- function(df, initial) {
  # Reaction rates -------------------------------------------------------------
  # Low pressure limit
  df$k_OH_NO_LPL <- (7.0e-31 * (df$TempK / 300) ^ -2.6) * initial$M
  # High pressure limit
  df$k_OH_NO_HPL <- (3.6e-11 * (df$TempK / 300) ^ -0.1)
  df$k_OH_NO <- (df$k_OH_NO_LPL / (1 + df$k_OH_NO_LPL / df$k_OH_NO_HPL)) * 0.6 ^ (1.0 / (1 + (log10(df$k_OH_NO_LPL / df$k_OH_NO_HPL)) ^ 2))

  df$k_HONO_OH <- 2.5e-12 * exp(260 / df$TempK)

  # Dilution factor ------------------------------------------------------------
  # df$kdil <- -df$kdil * 3600 * 2.46e10

  # NO2 uptake efficiencies ----------------------------------------------------
  # This is only valid for diurnal
  max_JNO2 <- max(df$JNO2) # assume maximum JNO2 is at noon
  df$gamma_NO2_ground <- initial$gamma_NO2_ground * df$JNO2 / max_JNO2
  df$gamma_NO2_aerosol <- 1.4e-4 * df$JNO2 / max_JNO2 # JNO2/JNO2 @ noon, photoenhanced
  df$gamma_NO2_ground <- 8e-6 * df$JNO2 / max_JNO2 # JNO2/JNO2 @ noon
  df$JNO2_NO2 <- df$JNO2 * df$NO2

  # HONO uptake coefficients ---------------------------------------------------
  max_JHONO <- max(df$JHONO) # assume maximum JHONO is at noon
  # df$gamma_HONO_ground <- 8e-6 * df$JHONO / max_JHONO
  # gamma_HONO_ground determined in get_HONO_soil_uptake.R using pH and RH dependence
  df$gamma_HONO_ground <- get_HONO_soil_uptake(df = df)
  df$gamma_HONO_aerosol <- 1.4e-4 * df$JHONO / max_JHONO # JHONO/JHONO @ noon, photoenhanced

  # Deposition Velocities (m/s) ----------------------------------------------------------
  df$v_HONO <- sqrt((3 * initial$R * df$TempK) / (initial$Mass_HONO * 1e3)) # m/s
  df$v_NO2 <- sqrt((3 * initial$R * df$TempK) / (initial$Mass_NO2 * 1e3)) # m/s

  # Estimate boundary layer height (BLH) ---------------------------------------
  # By default BLH_night =  200 m
  BLH_day <- initial$BLH_night * 3 # assume Hnight/Hday = 1/3 ratio Song 2022
  # Set initial values for all hours to day value
  df$H <- BLH_day
  # Set night values for hours from midnight to 8 AM and from 9 PM to midnight
  night_hours <- c(0:8, 21:24)
  df$H[night_hours] <- initial$BLH_night

  return(df)
}
