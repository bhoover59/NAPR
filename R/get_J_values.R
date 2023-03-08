get_J_values <- function(df, JNO2, Jcorr) {
  # About ----------------------------------------------------------------------
  # JNO2 = 1 means you have JNO2 measurements. 2 means you want to use TUV JNO2
  # Jcorr = 1 means you want to calculate Jcorr by JNO2 measured/JNO2 TUV
  # Jcorr = 0 means you want to input your own column of Jcorr values
  # Jcorr = 2 means you don't want to scale by Jcorr, use ideal conditions

  df <- convert_to_numeric(df)

  # Correcting JNO2_TUV --------------------------------------------------------
  # Issue because JNO2_TUV can be 0 which results in infinite Jcorr
  # To fix, we replace JNO2_TUV with the average of smallest 2 in JNO2_TUV that is greater than or equal to 5e-6
  smallest_JNO2_TUV <- mean(sort(unique(df$JNO2_TUV[df$JNO2_TUV >= 5e-7]))[1:5])

  # Replace the values in JNO2_TUV less than 5e-6 with the smallest value that is still greater than or equal to 5e-6
  df$JNO2_TUV[df$JNO2_TUV <= 5e-7] <- smallest_JNO2_TUV

  # JNO2 options ---------------------------------------------------------------
  if(JNO2 == 2) {
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
    # Adjust if Jcorr is greater than 1
    df$Jcorr[df$Jcorr > 1] <- 1
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
    df <- df[, -c("Jcorr")]
  }

  return(df)
}
