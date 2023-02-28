# Input for model is ppb, convert to molec/cm3
convert_to_percc <- function(df) {
  col_list <- c("HONO", "OH", "NO", "NO2", "NOx", "O3", "dHONOdt")
  for(col_name in colnames(df)) {
    if(col_name %in% col_list) {
      df[[col_name]] <- df[[col_name]] * 2.46e10
    }
  }
  return(df)
}
