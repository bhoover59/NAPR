report_summary <- function(df){
  # Report table of modeled HONO and unknown source strength
  report <- describe(df)
  # create list of columns to keep
  cols_to_keep <- c("unknown", "HONO_pss")

  # subset data frame to only keep columns in list
  report <- report[, cols_to_keep]

  return(report)
}
