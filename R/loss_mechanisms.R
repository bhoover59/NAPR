loss_mechanisms <- function(df, intial){
  # IF YOU ADD MECHANISMS, YOU NEED TO ADD THE NAME TO convert_to_mixing_ratio() FOR IT TO CONVERT TO PPB/H
  # LOSS MECHANISMS ------------------------------------------------------------
  # molec/cm3 but will later be converted to ppb/h
  # Largely driven by uptake coefficients (gamma factor) which have high uncertainty

  # Photolysis of HONO ---------------------------------------------------------
  df$L_photo <- df$JHONO * 3600

  # HONO + OH -> NO2 + H2O -----------------------------------------------------
  df$L_OH <- df$k_HONO_OH * df$HONO * df$OH * 3600

  # Ground deposition ----------------------------------------------------------
  df$L_uptake_ground <- (df$v_HONO * initial$gamma_HONO_ground * 3600) / (4 * df$H)

  # Aerosol deposition/uptake --------------------------------------------------
  df$L_aerosol <- (df$v_HONO * initial$gamma_HONO_aerosol * initial$S_aerosol * 3600) / (4)

  # Photoenhanced ground deposition --------------------------------------------
  df$L_ground_light <- (df$v_HONO * df$gamma_HONO_ground * (df$RH/20) * 3600) / (4 * df$H)

  # Photoenhanced aerosol deposition/uptake ------------------------------------
  df$L_aerosol_light <- (df$v_HONO * df$gamma_HONO_aerosol * initial$S_aerosol * 3600) / (4)

  # Dilution (24 hour lifetime for species) ------------------------------------
  df$L_dilution <- initial$kdil

  return(df)
}
