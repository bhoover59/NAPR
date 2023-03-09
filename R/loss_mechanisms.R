loss_mechanisms <- function(df, intial){
  # LOSS MECHANISMS ------------------------------------------------------------
  # molec/cm3 but will later be converted to ppb/h
  # Photolysis of HONO
  df$L_photo <- df$JHONO * df$HONO * 3600
  # HONO + OH -> NO2 + H2O
  df$L_OH <- df$k_HONO_OH * df$HONO * df$OH * 3600
  # Ground deposition
  df$L_uptake_ground <- (initial$v_HONO * df$HONO * initial$gamma_HONO_ground * 3600) / (8 * df$H)
  # Aerosol deposition/uptake

  # NOT INCLUDED YET
  # df$L_uptake_aerosols <- 5 # aerosol deposition

  return(df)
}
