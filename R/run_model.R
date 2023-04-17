run_model <- function(df, initial){
  # Calculate production and loss mechanisms
  production <- production_mechanisms(df, initial)
  loss <- loss_mechanisms(df, initial)

  # Merge data frames and remove duplicated columns
  total <- mutate(production, loss)

  # BALANCING MECHANISMS AND UNKNOWN SOURCE ------------------------------------
  # Offer to calculate dHONOdt for them? MAKE SURE dHONOdt same units as production and loss
  total$unknown <- total$dHONOdt - total$production + total$loss

  # MODEL PREDICTIONS ----------------------------------------------------------
  # Base model: using molec/cm3 due to rate constants units
  total$HONO_pss <- (total$k_OH_NO * total$OH * total$NO) / (total$JHONO + total$k_HONO_OH * total$OH)

  # HONO/OH --------------------------------------------------------------------
  total$HONO_OH_meas <- total$HONO / total$OH # both in molec/cm3

  total <- convert_to_mixing_ratio(total) # convert output to ppb except OH

  total$delta <- total$production - total$loss
  print(total$delta)
  # Added chemistry # units of initial$HONO
  # total$HONO_model <- total$production / total$loss + initial$HONO

  # Set initial HONO value MAJOR ASSUMPTION
  total$HONO_model[1] <- initial$HONO

  # Loop over all rows in total, starting from the second row
  for (i in 2:nrow(total)) {
    # Calculate HONO_model using previous value and diff in rates
    total$HONO_model[i] <- total$HONO_model[i-1] + total$delta[i]
  }


  return(total)
}
