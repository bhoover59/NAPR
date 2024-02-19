run_model <- function(df, initial){
  # Calculate production and loss mechanisms
  production <- production_mechanisms(df, initial)
  loss <- loss_mechanisms(df, initial)

  # Merge data frames and remove duplicated columns
  total <- mutate(production, loss)

  # PSS MODEL PREDICTIONS ------------------------------------------------------
  # Base model: using molec/cm3 due to rate constants units
  total$HONO_pss <- (total$k_OH_NO * total$OH * total$NO) / (total$JHONO + total$k_HONO_OH * total$OH)

  # Added chemistry
  total$delta <- total$production - total$loss
  total$HONO_model <- total$production / total$loss

  # Non Photo Stationary State (NPSS) ------------------------------------------
  total$dHONOdt <- calculate_dHONOdt(total)
  total$unknown <- total$dHONOdt - total$production + total$loss

  total$HONO_model_NPSS[1] <- initial$HONO # assign to first measured value
  for (i in 2:nrow(total)) {
    # Calculate HONO_model using previous value and diff in rates
    total$HONO_model_NPSS[i] <- total$HONO[i-1] + total$delta[i]
  }
  total$HONO_model_NPSS[1] <- total$HONO_model_NPSS[1] * 2.46e10

  total <- convert_to_mixing_ratio(total)
  return(total)
}
