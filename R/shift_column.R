shift_column <- function(df, column_name, shift_amount = 5) {
  # Shift time column to correct TUV (output is GMT)
  shifted_column_name <- paste0(column_name, "_shifted")
  df[[shifted_column_name]] <- numeric(nrow(df))
  for (i in 1:nrow(df)) {
    shiftedIndex <- (df$Hour[i] - shift_amount + 24) %% 24 + 1
    df[[shifted_column_name]][shiftedIndex] <- df[[column_name]][i]
  }
  df[[column_name]] <- df[[shifted_column_name]]
  df[[shifted_column_name]] <- NULL
  return(df)
}
