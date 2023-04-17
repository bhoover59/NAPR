loss_mechanisms <- function(df, intial){
  # IF YOU ADD MECHANISMS, YOU NEED TO ADD THE NAME TO convert_to_mixing_ratio() FOR IT TO CONVERT TO PPB/H
  # LOSS MECHANISMS ------------------------------------------------------------
  # Largely driven by uptake coefficients (gamma factor) which have high uncertainty

  # Photolysis of HONO ---------------------------------------------------------
  df$L_photo <- df$JHONO * 3600

  # HONO + OH -> NO2 + H2O -----------------------------------------------------
  df$L_OH <- df$k_HONO_OH * df$OH * 3600 # ppb

  # Ground deposition ----------------------------------------------------------
  df$L_uptake_ground <- (df$v_HONO * initial$gamma_HONO_ground * 3600) / (4 * df$H)

  # Aerosol deposition/uptake --------------------------------------------------
  df$L_aerosol <- (df$v_HONO * initial$gamma_HONO_aerosol * initial$S_aerosol * 3600) / (4)

  # Photoenhanced ground deposition --------------------------------------------
  df$L_ground_light <- (df$v_HONO * df$gamma_HONO_ground * (df$RH/20) * (df$JNO2 / initial$beta)^3 * 3600) / (4 * df$H)

  # Photoenhanced aerosol deposition/uptake ------------------------------------
  df$L_aerosol_light <- (df$v_HONO * df$gamma_HONO_aerosol * (df$JNO2 / initial$beta) * initial$S_aerosol * 3600) / (4)

  # Dilution (24 hour lifetime for species) ------------------------------------
  df$L_dilution <- initial$kdil * df$HONO

  # for(i in 1:24){
  #   if(i == 1){
  #     df$L_photo[i] <- df$JHONO[i] * df$HONO[i] * 3600
  #     df$L_OH[i] <- df$k_HONO_OH[i] * df$OH[i] * 3600
  #     df$L_uptake_ground[i] <- (df$v_HONO[i] * initial$gamma_HONO_ground[i] * df$HONO[i] * 3600) / (4 * df$H[i])
  #     df$L_aerosol[i] <- (df$v_HONO[i] * initial$gamma_HONO_aerosol * df$HONO[i] * initial$S_aerosol * 3600) / (4)
  #     df$L_ground_light[i] <- (df$v_HONO[i] * df$gamma_HONO_ground[i] * df$HONO[i] * (df$RH[i]/20) * (df$JNO2[i] / initial$beta)^3 * 3600) / (4 * df$H[i])
  #     df$L_aerosol_light[i] <- (df$v_HONO[i] * df$gamma_HONO_aerosol[i] * df$HONO[i] * (df$JNO2[i] / initial$beta) * initial$S_aerosol * 3600) / (4)
  #     df$L_dilution[i] <- initial$kdil * df$HONO[i]
  #   }
  #   else{
  #     df$HONO_test1[i] <- df$HONO_test1[i-1] + df$diff[i] * 1e3
  #     df$HONO_test2[i] <- df$HONO_test2[i-1] + df$production[i] / df$loss[i] * 1e3
  #     df$L_photo[i] <- df$JHONO[i] * df$HONO[i] * 3600
  #     df$L_OH[i] <- df$k_HONO_OH[i] * df$OH[i] * 3600
  #     df$L_uptake_ground[i] <- (df$v_HONO[i] * initial$gamma_HONO_ground[i] * df$HONO[i] * 3600) / (4 * df$H[i])
  #     df$L_aerosol[i] <- (df$v_HONO[i] * initial$gamma_HONO_aerosol * df$HONO[i] * initial$S_aerosol * 3600) / (4)
  #     df$L_ground_light[i] <- (df$v_HONO[i] * df$gamma_HONO_ground[i] * df$HONO[i] * (df$RH[i]/20) * (df$JNO2[i] / initial$beta)^3 * 3600) / (4 * df$H[i])
  #     df$L_aerosol_light[i] <- (df$v_HONO[i] * df$gamma_HONO_aerosol[i] * df$HONO[i] * (df$JNO2[i] / initial$beta) * initial$S_aerosol * 3600) / (4)
  #     df$L_dilution[i] <- initial$kdil * df$HONO[i]
  #   }
  # }
  # # Lumping together heterogeneous loss ----------------------------------------
  df$L_het <- df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light

  # Total loss -----------------------------------------------------------------
  df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light

  return(df)
}
