get_kinetics <- function(df, initial, BLH_night = 200) {
  # Reaction rates -------------------------------------------------------------
  # Low pressure limit
  df$k_OH_NO_LPL <- (7.0e-31 * (df$TempK / 300) ^ -2.6) * initial$M
  # High pressure limit
  df$k_OH_NO_HPL <- (3.6e-11 * (df$TempK / 300) ^ -0.1)
  df$k_OH_NO <- (df$k_OH_NO_LPL / (1 + df$k_OH_NO_LPL / df$k_OH_NO_HPL)) * 0.6 ^ (1.0 / (1 + (log10(df$k_OH_NO_LPL / df$k_OH_NO_HPL)) ^ 2))

  df$k_HONO_OH <- 2.5e-12 * exp(260 / df$TempK)
  # df$kdil <- -df$kdil * 3600 * 2.46e10

  # NO2 Conversion efficiencies ----------------------------------------------------
  # This is only valid for diurnal
  max_JNO2 <- max(df$JNO2) # assume maximum JNO2 is at noon
  df$gamma_NO2_ground <- 8e-6 * df$JNO2 / max_JNO2
  df$gamma_NO2_aerosol <- 1.4e-4 * df$JNO2 / max_JNO2 # JNO2/JNO2 @ noon, photoenhanced
  df$gamma_NO2_ground <- 8e-6 * df$JNO2 / max_JNO2 # JNO2/JNO2 @ noon
  df$JNO2_NO2 <- df$JNO2 * df$NO2

  # Estimate boundary layer height (BLH) ---------------------------------------
  # By default BLH_night =  200 m
  BLH_day <- BLH_night * 3 # assume Hnight/Hday = 1/3 ratio Song 2022
  # Set initial values for all hours to day value
  df$H <- BLH_day
  # Set night values for hours from midnight to 8 AM and from 9 PM to midnight
  night_hours <- c(0:8, 21:24)
  df$H[night_hours] <- BLH_night

  return(df)
}
