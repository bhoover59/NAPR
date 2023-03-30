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
  # smallest_JNO2_TUV <- mean(sort(unique(df$JNO2_TUV[df$JNO2_TUV >= 5e-7]))[1:5])
  smallest_JNO2_TUV <- 1
  # Replace the values in JNO2_TUV less than 5e-6 with the smallest value that is still greater than or equal to 5e-6
  df$JNO2_TUV[df$JNO2_TUV == 0] <- 1
  # df$JNO2_TUV[df$JNO2_TUV <= 5e-7  ] <- smallest_JNO2_TUV

  # # NEED TO SHIFT TIME BACK BECAUSE TUV OUTPUT IS GMT TIME
  df <- shift_column(df, "JNO2_TUV", shift_amount = 5)
  df <- shift_column(df, "JHONO_TUV", shift_amount = 5)

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
    # df <- shift_column(df, "Jcorr", shift_amount = 5)
    df$JHONO <- df$JHONO_TUV * df$Jcorr
    # Must correct for extreme TUV predictions causing divide by 0 error
    # Correcting JHONO, gives pretty good HONO results
    df$JHONO[df$JHONO <= 5e-6] <- 3.5e-5
    # df$JHONO[16:21] <- df$JHONO[9:14]
    # df$JHONO[21] <- df$JHONO[9]
    # df$JHONO[7:21] <- df$JHONO[7:21] * 5
    # df$JHONO[1:6] <- df$JHONO[1:6] / 5
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
