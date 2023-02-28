loss_mechanisms <- function(df, intial){
  # NEED TO INPUT V_HONO AS CONSTANT

  # LOSS MECHANISMS ----------------------------
  # Photolysis of HONO
  df$L_photo <- df$JHONO * df$HONO * 3600 # photolysis of HONO, molec/cm3 /h
  #df$L_OH <- k_HONO_OH * df$HONO * df$OH * 3600 # HONO + OH -> NO2 + H2O
  df$L_OH <- df$k_HONO_OH * df$HONO * df$OH * 3600 # HONO + OH -> NO2 + H2O
  df$L_uptake_ground <- (initial$v_HONO * df$HONO * initial$gamma_HONO_ground * 3600) / (8 * initial$H) # ground deposition

  # df$L_uptake_aerosols <- 5 # aerosol deposition
  # df$L_dry_dep <- (v_HONO * df$HONO * gamma_HONO_ground * 3600) / (H) # ground deposition

  return(df)
}
