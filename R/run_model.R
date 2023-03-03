run_model <- function(df, initial){
  # Calculate production and loss mechanisms
  production <- production_mechanisms(df, initial)
  loss <- loss_mechanisms(df, initial)

  # Merge data frames and remove duplicated columns
  df <- mutate(production, loss)

  # BALANCING MECHANISMS AND UNKNOWN SOURCE ------------------------------------
  df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground
  # df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground + df$kdil
  df$production <- df$P_OH_NO + df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol
  df$diff <- df$production - df$loss
  # Offer to calculate dHONOdt for them?
  df$unknown <- df$dHONOdt - df$production + df$loss

  # MODEL PREDICTIONS ----------------------------------------------------------
  # Include dilution factor?
  # df$HONO_pss <- ((df$P_OH_NO / 3600) / (df$JHONO + df$k_HONO_OH * df$OH)) + df$kdil * 3600 * 1e3
  df$HONO_pss <- (df$P_OH_NO / 3600) / (df$JHONO + df$k_HONO_OH * df$OH)

  # HONO/OH --------------------------------------------------------------------
  df$HONO_OH_meas <- df$HONO / df$OH


  return(df)
}
