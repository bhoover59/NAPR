run_model <- function(df, initial){
  # Calculate production and loss mechanisms
  production <- production_mechanisms(df, initial)
  loss <- loss_mechanisms(df, initial)

  # Merge data frames and remove duplicated columns
  df <- mutate(production, loss)

  # BALANCING MECHANISMS AND UNKNOWN SOURCE ------------------------------------
  df$loss <- df$L_photo + df$L_OH + df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light
  df$production <- df$P_OH_NO + df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light + df$P_emis + df$P_soil
  df$diff <- df$production - df$loss

  # Offer to calculate dHONOdt for them?
  df$unknown <- df$dHONOdt - df$production + df$loss

  # MODEL PREDICTIONS ----------------------------------------------------------
  # Include dilution factor?
  # using molec/cm3 due to rate constants units
  df$HONO_pss <- (df$k_OH_NO * df$OH * df$NO) / (df$JHONO + df$k_HONO_OH * df$OH)

  # Need to calculate HONO for all production
  df$HONO_model <- df$production / df$loss

  # HONO/OH --------------------------------------------------------------------
  df$HONO_OH_meas <- df$HONO / df$OH


  return(df)
}
