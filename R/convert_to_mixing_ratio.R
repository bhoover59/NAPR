convert_to_mixing_ratio <- function(df) {
  # Leave OH in molec/cm3, convert others to ppb
  col_list <- c("HONO", "NO", "NO2", "NOx", "HONO_pss", "O3")
  for(col_name in colnames(df)) {
    if(col_name %in% col_list) {
      df[[col_name]] <- df[[col_name]] / 2.46e10
    }
  }
  return(df)
}
