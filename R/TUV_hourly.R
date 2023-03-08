TUV_hourly <- function(df, date, latitude, longitude, gAltitude, mAltitude) {
  # About ----------------------------------------------------------------------
  # Calculate JNO2 and JHONO for each hour for specified day and location
  # Check NCAR for more information on TUV Model: https://www2.acom.ucar.edu/modeling/tropospheric-ultraviolet-and-visible-tuv-radiation-model
  # OUTPUT IS GMT TIME SO ADJUST ACCORDINGLY

  # Run TUV Model --------------------------------------------------------------
  hours <- 0:23
  TUV <- lapply(hours, function(hour) {
    TUV_core(latitude = latitude, longitude = longitude, gAltitude = gAltitude, mAltitude = mAltitude, date = date, time = hour)
  })

  photolysis <- data.frame(Hours = hours, JNO2_TUV = sapply(TUV, function(x) x[[6]]), JHONO_TUV = sapply(TUV, function(x) x[[12]]))

  # Remove duplicated rows
  df <- df %>% distinct(Hours, .keep_all = TRUE)
  photolysis <- photolysis %>% distinct(Hours, .keep_all = TRUE)

  # Merge data frames
  df <- df %>% full_join(photolysis, by = "Hours")

  return(df)
}
