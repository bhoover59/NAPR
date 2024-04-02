calculate_dHONOdt <- function(df) {
  # Calculate the difference between consecutive values in the HONO column
  dHONOdt <- diff(df$HONO, differences = 1)

  # Calculate the rate of change for the first value based on the difference between the last and first values
  first_difference <- df$HONO[1] - df$HONO[length(df$HONO)]

  # Concatenate the first difference with the other differences
  dHONOdt <- c(first_difference, dHONOdt)

  return(dHONOdt)
}


# calculate_dHONOdt <- function(df) {
#   dHONOdt <- diff(df$HONO, differences = 1)
#   dHONOdt <- c(df$HONO[24] - df$HONO[1], dHONOdt) * 2.46e10
#   return(dHONOdt)
# }
