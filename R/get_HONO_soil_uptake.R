get_HONO_soil_uptake <- function(df, pH = 4, pH_weight = 0.5, RH_weight = 0.5){

  # pH dependence --------------------------------------------------------------
  # Donaldson et al., 2014 PNAS) R^2 = 0.9567 for quadratic fit
  df$gamma_HONO_pH <- 4e-6 * pH^2 - 4e-5 * pH + 2e-4

  # RH dependence --------------------------------------------------------------
  # El Zein et al 2012, 2013; Romanias et al 2012
  # df$gamma_HONO_RH <- 7e-6 * df$RH^-0.617

  # VandenBoer 2015
  df$gamma_HONO_RH <- 5e-8 * df$RH + 6e-6

  # Default assumes equal dependence on soil pH and relative humidity
  df$gamma_HONO_ground <- df$gamma_HONO_pH * pH_weight + df$gamma_HONO_RH * RH_weight

  return(df$gamma_HONO_ground)
}
