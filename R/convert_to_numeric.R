convert_to_numeric <- function(df){
  # Convert all columns to numeric
  for (col in names(df)) {
    df[[col]] <- as.numeric(df[[col]])
  }
}
