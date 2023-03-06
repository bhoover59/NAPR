get_J_values <- function(df, JNO2, Jcorr){
  # About ----------------------------------------------------------------------
  # JNO2 = 1 means you have JNO2 measurements. 2 means you want to use TUV JNO2
  # Jcorr = 1 means you want to calculate Jcorr by JNO2 measured/JNO2 TUV
  # Jcorr = 0 means you want to input your own column of Jcorr values
  # Jcorr = 2 means you don't want to scale by Jcorr, use ideal conditions

  df <- convert_to_numeric(df)

  # Correcting JNO2_TUV --------------------------------------------------------
  # Issue because JNO2_TUV can be 0 which results in infinite Jcorr
  # To fix, we replace JNO2_TUV with minimum (excluding 0) of the column
  # Assumes the next smallest is close to 0
  min_JNO2_TUV <- min(df$JNO2_TUV[df$JNO2_TUV > 0])

  # Replace the 0 values in JNO2_TUV with the smallest non-zero value
  df$JNO2_TUV[df$JNO2_TUV == 0] <- min_val

  # Calculate Jcorr with adjusted JNO2_TUV
  df$Jcorr <- df$JNO2 / df$JNO2_TUV

  # JNO2 options ---------------------------------------------------------------
  if(JNO2 == 2){
    # Modeled JNO2 instead of input
    df$JNO2 <- df$JNO2_TUV
  }
  else{
    # User input measured JNO2
    df$JNO2 <- df$JNO2
  }

  # Jcorr options --------------------------------------------------------------
  if(Jcorr == 1){
    # Use TUV calculated Jcorr
    df$JHONO <- df$JHONO_TUV * df$Jcorr
  }
  else if(Jcorr == 0){
    # User input Jcorr column
    df$JHONO <- df$JHONO_TUV * df$Jcorr
  }
  else{
    # No Jcorr value
    df$JHONO <- df$JHONO_TUV
    df <- df[, -c("Jcorr")]
  }

  return(df)
}
