run_model <- function(df){
  # PRODUCTION MECHANISMS ----
  df$P_OH_NO <- df$k_OH_NO * df$OH * df$NO * 3600 # homogeneous reaction OH + NO
  df$P_NO2het_ground <- (v_NO2 * gamma_NO2_ground * df$NO2 * 3600) / (8 * H) # Dark NO2 conversion on ground
  # Aerosols independent of boundary layer H, only ground is?
  df$P_NO2het_ground_light <- (v_NO2 * df$gamma_NO2_ground * df$NO2 * 3600) / (8 * H) # Photo-enhanced NO2 conversion on ground
  #df$P_NO2het_aerosol <- (v_NO2 * gamma_NO2_aerosol * df$NO2 * S_aerosol * 3600) / (4 * H) # Dark NO2 conversion on aerosols
  df$P_NO2het_aerosol <- (v_NO2 * gamma_NO2_aerosol * df$NO2 * S_aerosol * 3600) / (4) # Dark NO2 conversion on aerosols
  df$P_NO2het_aerosol_light <- (v_NO2 * df$gamma_NO2_aerosol * df$NO2 * S_aerosol * 3600) / (4) # Photo-enhanced NO2 conversion on aerosols
  df$P_emis <- 0 # direct emission from vehicles
  df$P_soil <-  0 # direct soil emissions
  # df$P_nitro <- J_nitrophenol * df$nitrophenol * 3600 # photolysis of nitrophenols
  # df$nitrate <- df$nitrate * R * df$Temp * J_HNO3 # photolysis of nitrate

  # LOSS MECHANISMS ----
  df$L_photo <- df$JHONO * df$HONO * 3600 # photolysis of HONO, molec/cm3 /h
  #df$L_OH <- k_HONO_OH * df$HONO * df$OH * 3600 # HONO + OH -> NO2 + H2O
  df$L_OH <- df$k_HONO_OH * df$HONO * df$OH * 3600 # HONO + OH -> NO2 + H2O
  df$L_uptake_ground <- (v_HONO * df$HONO * gamma_HONO_ground * 3600) / (8 * H) # ground deposition

  # df$L_uptake_aerosols <- 5 # aerosol deposition
  # df$L_dry_dep <- (v_HONO * df$HONO * gamma_HONO_ground * 3600) / (H) # ground deposition

  # BALANCING MECHANISMS AND UNKNOWN SOURCE ----
  df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground
  # df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground + df$kdil
  df$production <- df$P_OH_NO + df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol
  # df$unknown <- df$production - df$loss # not true this is difference
  df$unknown <- df$dHONOdt - df$production + df$loss

  # MODEL PREDICTIONS ----
  # df$HONO_pss <- ((df$P_OH_NO / 3600) / (df$JHONO + df$k_HONO_OH * df$OH)) + df$kdil * 3600 * 1e3
  df$HONO_pss <- (df$P_OH_NO / 3600) / (df$JHONO + df$k_HONO_OH * df$OH)
  # df$HONO_pss <- ((df$production - df$loss / df$HONO) / 2.46e10)

  # HONO/OH ----
  df$HONO_OH_meas <- df$HONO / df$OH

  return(df)
}
