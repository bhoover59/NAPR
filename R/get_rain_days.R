get_rain_days <- function(df, compare){
  if(compare == 1){
    # subset df for rain days only
    df <- subset(df, Rain == 1)
  }
  else if(compare == 2){
    # subset df for dry days only
    df <- subset(df, Rain == 0)
  }
  else{
    # Keep all data
    df = df
  }
  return(df)
}
