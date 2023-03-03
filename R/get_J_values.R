get_J_values <- function(df, JNO2, Jcorr){
  # About ----------------------------------------------------------------------
  # JNO2 = 1 means you have JNO2 measurements. 2 means you want to use TUV JNO2
  # Jcorr = 1 means you want to calculate Jcorr by JNO2 measured/JNO2 TUV
  # Jcorr = 0 means you want to input your own column of Jcorr values
  # Jcorr = 2 means you don't want to scale by Jcorr, use ideal conditions

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
    df$JHONO <- df$JHONO_TUV * df$Jcorr_TUV
  }
  else if(Jcorr == 0){
    # User input Jcorr column
    df$JHONO <- df$JHONO_TUV * df$Jcorr
  }
  else{
    # No Jcorr value
    df$JHONO <- df$JHONO_TUV
  }

  return(df)
}
