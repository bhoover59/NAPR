loss_mechanisms <- function(df, initial){
  # IF YOU ADD MECHANISMS, YOU NEED TO ADD THE NAME TO convert_to_mixing_ratio() FOR IT TO CONVERT TO PPB/H
  # List of mechanisms ---------------------------------------------------------
  # Homogeneous gas phase:
    # HONO + OH = NO2 + H2O
  # HONO Deposition on Ground Surfaces
  # Photolysis
    # HONO+hv = OH + NO
  # Self Reaction
    # HONO+HONO = NO2 + NO + H2O
  # Oxidation by O3
    # HONO+O3 = HNO3 + O2
  # Dilution

  # LOSS MECHANISMS (1/h) --------------------------------------------------
  # Photolysis of HONO ---------------------------------------------------------
  df$L_photo <- df$HONO * df$JHONO * 3600

  # HONO + OH -> NO2 + H2O -----------------------------------------------------
  df$L_OH <- df$k_HONO_OH * df$HONO * df$OH * 3600

  # Ground deposition ----------------------------------------------------------
  df$L_uptake_ground <- df$HONO * df$k_HONO_deposition_ground * 3600

  # Aerosol deposition/uptake --------------------------------------------------
  df$L_aerosol <- 0
  # df$L_aerosol <- (df$k_HONO_deposition_aerosol * 3600)

  # Photoenhanced ground deposition --------------------------------------------
  df$L_ground_light <- 0
  # df$L_ground_light <- (df$v_HONO * df$gamma_HONO_ground * (df$RH/20) * (df$JNO2 / initial$beta)^3 * 3600) / (4 * df$H)

  # Photoenhanced aerosol deposition/uptake ------------------------------------
  df$L_aerosol_light <- 0
  # df$L_aerosol_light <- (df$v_HONO * df$gamma_HONO_aerosol * (df$JNO2 / initial$beta) * initial$S_aerosol * 3600) / (4)

  # Dilution (24 hour lifetime for species) ------------------------------------
  df$L_dilution <- initial$kdil

  # Self Reaction --------------------------------------------------------------
  df$L_self <- df$k_HONO_HONO * df$HONO

  # Ozone Oxidation
  df$L_O3 <- df$k_HONO_O3 * df$HONO

  # # Lumping together heterogeneous loss ----------------------------------------
  df$L_het <- df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light

  # Other reactions
  df$L_other <- df$L_dilution + df$L_self + df$L_O3

  # Total loss -----------------------------------------------------------------
  df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light + df$L_self + df$L_O3

  return(df)
}
