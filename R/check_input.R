check_input <- function(df){
  # Check if required columns are in the data frame
  required_columns <- c("OH", "NO", "NO2", "HONO")
  # loop through each required column
  missing_cols <- 0  # counter for missing columns
  for (col in required_columns) {
    # check if the column exists in the data frame
    if (!(col %in% colnames(df))) {
      # if it doesn't exist, print out the name of the missing column
      print(paste0("Missing column: ", col))
      missing_cols <- missing_cols + 1  # increment counter
    }
  }
  # check if any columns were missing
  if (missing_cols == 0) {
    print("Congrats, all of the columns needed are here!")
  }
}
