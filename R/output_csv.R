output_csv <- function(df, file_name){
  # Stack rates for plotting
  df <- stack_rates(df)

  # output data frame to csv in current directory
  path <- getwd()

  # create file name without spacing
  file <- paste(path, '/output/', file_name, '.csv', sep = "")
  write.csv(df, file)

}
