get_HONO_soil_uptake <- function(df, pH = 6, pH_weight = 0.5, RH_weight = 0.5){

  # pH dependence --------------------------------------------------------------
  # Donaldson et al., 2014 PNAS) R^2 = 0.9567 for quadratic fit
  df$gamma_HONO_pH <- 3.604e-6 * pH^2 - 4.21e-5 * pH + 1.55e-4

  # RH dependence --------------------------------------------------------------
  # El Zein et al 2012, 2013; Romanias et al 2012
  # df$gamma_HONO_RH <- 7e-6 * df$RH^-0.617

  # VandenBoer 2015
  df$gamma_HONO_RH <- 6.26e-7 * df$RH^(-0.617)

  # Default assumes equal dependence on soil pH and relative humidity
  df$gamma_HONO_ground <- df$gamma_HONO_pH * pH_weight + df$gamma_HONO_RH * RH_weight

  return(df$gamma_HONO_ground)
}
