get_met <- function(df, temp_units, temp_column, RH_units){
  # Convert temperature to Kelvin (K)
  if (grepl("F", temp_units, ignore.case = TRUE)) {
    # temperature is in Fahrenheit, convert to Celsius then Kelvin
    df$TempK <- (df[[temp_column]] - 32) * 5/9 + 273.15
  } else if (grepl("C", temp_units, ignore.case = TRUE)) {
    # temperature is in Celsius, convert to Kelvin
    df$TempK <- df[[temp_column]] + 273.15
  } else {
    # temperature is already in Kelvin
    df$TempK <- df[[temp_column]]
  }

  if (RH_units == 'perc'){
    df$RH <- df$RH
  } else if(RH_units == 'decimal'){
    df$RH <- df$RH * 100
  } else {
    print("Invalid RH units selected")
  }

  return(df)
}
