check_input <- function(df){
  # Check if required columns are in the data frame
  required_columns <- c("OH", "NO", "NO2", "HONO", "dHONOdt")
  # loop through each required column
  for (col in required_cols) {
    # check if the column exists in the data frame
    if (!(col %in% colnames(df))) {
      # if it doesn't exist, print out the name of the missing column
      print(paste0("Missing column: ", col))
    }
  }
}
