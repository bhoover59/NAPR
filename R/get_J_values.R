get_J_values <- function(df, JNO2, Jcorr) {
  # About ----------------------------------------------------------------------
  # JNO2 = 1 : use TUV modeled JNO2, else use measurements
  # Jcorr = 1 : calculate Jcorr by JNO2 measured/JNO2 TUV
  # Jcorr = 0 : input Jcorr values
  # Jcorr = 2 : use ideal conditions (No Jcorr), not recommended

  df <- convert_to_numeric(df)

  # Correcting JNO2_TUV --------------------------------------------------------
  # Issue because JNO2_TUV can be 0 which results in infinite Jcorr
  # To fix, we replace JNO2_TUV with the average of smallest 5 in JNO2_TUV that is greater than or equal to 5e-7
  # smallest_JNO2_TUV <- mean(sort(unique(df$JNO2_TUV[df$JNO2_TUV >= 5e-7]))[1:5])
  df$JNO2_TUV[df$JNO2_TUV <= 5e-8] <- 1
#
#   smallest_JNO2_TUV <- mean(sort(unique(df$JNO2_TUV[df$JNO2_TUV >= 1e-6]))[1:5])
#   df$JNO2_TUV[df$JNO2_TUV <= 1e-6] <- smallest_JNO2_TUV

  # Shift time zone. TUV outputs GMT while we are in EST
  df <- shift_column(df, "JNO2_TUV", shift_amount = 5)
  df <- shift_column(df, "JHONO_TUV", shift_amount = 5)

  # JNO2 options ---------------------------------------------------------------
  if(JNO2 == 1) {
    # Modeled JNO2 instead of input
    df$JNO2 <- df$JNO2_TUV
  } else {
    # User input measured JNO2
    df$JNO2 <- df$JNO2
  }

  # Jcorr options --------------------------------------------------------------
  if(Jcorr == 1) {
    # Use TUV calculated Jcorr
    df$Jcorr <- df$JNO2 / df$JNO2_TUV
    df$JHONO <- df$JHONO_TUV * df$Jcorr
  } else if(Jcorr == 0) {
    # User input Jcorr column
    df$JHONO <- df$JHONO_TUV * df$Jcorr
  } else if(Jcorr == 2){
    # User input JHONO
    df$JHONO <- df$JHONO
  }
  else {
    # No Jcorr value and use JHONO TUV
    df$JHONO <- df$JHONO_TUV
  }


  return(df)
}
