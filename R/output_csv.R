output_csv <- function(df, file_name){
  # output data frame to csv in current directory
  path <- getwd()
  # create file name without spacing
  file <- paste(path, '/', file_name, '.csv', sep = "")
  write.csv(df, file)
}
