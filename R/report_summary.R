report_summary <- function(df){
  # subset data frame to only keep columns in list
  cols_to_keep <- c("unknown", "HONO_pss")
  report <- df[, cols_to_keep]

  # Report table of modeled HONO and unknown source strength
  report <- psych::describe(report)

  return(report)
}
