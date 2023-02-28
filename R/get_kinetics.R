get_kinetics <- function(df) {
  df$gamma_NO2_ground <- 8e-6 * df$JNO2 / df[12,"JNO2"]
  df$TempK <- df$Temp + 273.15
  df$k_OH_NO_LPL <- (7.0e-31 * (df$TempK / 300) ^ -2.6) * M
  df$k_OH_NO_HPL <- (3.6e-11 * (df$TempK / 300) ^ -0.1)
  df$k_OH_NO <- (df$k_OH_NO_LPL / (1 + df$k_OH_NO_LPL / df$k_OH_NO_HPL)) * 0.6 ^ (1.0 / (1 + (log10(df$k_OH_NO_LPL / df$k_OH_NO_HPL)) ^ 2))
  df$k_HONO_OH <- 2.5e-12 * exp(260 / df$TempK)
  # df$kdil <- -df$kdil * 3600 * 2.46e10
  # df$JHONO <- df$JHONO_TUV * df$Jcorr
  df$gamma_NO2_aerosol <- 1.4e-4 * df$JNO2 / df$JNO2[11] # JNO2/JNO2 @ noon, photoenhanced
  df$gamma_NO2_ground <- 8e-6 * df$JNO2 / df$JNO2[11] # JNO2/JNO2 @ noon
  df$JNO2_NO2 <- df$JNO2 * df$NO2
  return(df)
}
