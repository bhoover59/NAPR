calculate_dHONOdt <- function(df) {
  dHONOdt <- diff(df$HONO, differences = 1)
  dHONOdt <- c(df$HONO[24] - df$HONO[1], dHONOdt) * 2.46e10
  return(dHONOdt)
}
