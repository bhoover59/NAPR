get_met <- function(df, temp_units, temp_column){
  # Convert temperature to Kelvin (K)
  if (grepl("F", temp_units, ignore.case = TRUE)) {
    # temperature is in Fahrenheit
    df$TempK <- (df$temp_column - 32) * 5/9 + 273.15
  } else if (grepl("C", temp_units, ignore.case = TRUE)) {
    # temperature is in Celsius
    df$TempK <- df$temp_column + 273.15
  } else {
    # temperature is already in Kelvin
    df$TempK <- df$temp_column
  }

  return(df)
}
