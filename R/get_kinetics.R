get_kinetics <- function(df, initial) {
  # Estimate boundary layer height (BLH) ---------------------------------------
    # By default BLH_night =  200 m
  BLH_day <- initial$BLH_night * 3 # assume Hnight/Hday = 1/3 ratio Song 2022
    # Set initial values for all hours to day value
  df$BLH <- BLH_day
    # Set night values for hours from midnight to 8 AM and from 9 PM to midnight
  night_hours <- c(0:8, 21:24)
  df$BLH[night_hours] <- initial$BLH_night
  df$SA_V_ground <- 2.2 / df$BLH
  df$SA_V_aerosol <- 1e-4

  # Deposition Velocities (m/s) ------------------------------------------------
  df$v_HONO <- sqrt((3 * initial$R * df$TempK) / (initial$Mass_HONO * 1e-3)) # m/s
  df$v_NO2 <- sqrt((3 * initial$R * df$TempK) / (initial$Mass_NO2 * 1e-3)) # m/s
  # ----------------------------------------------------------------------------

  # Deposition and Conversion --------------------------------------------------
  df$beta <- max(df$JNO2) / min(df$JNO2)
  # initial$beta <- 0.00724 # light scaling factor, either change to 0.005 or calculate as max/min

  # NO2 uptake efficiencies ----------------------------------------------------
  df$gamma_NO2_ground <-  7.4e-7 + 5.5e-8 * df$RH
  df$gamma_NO2_aerosol <- 7.4e-7 + 5.5e-8 * df$RH
  df$gamma_NO2_ground_hv <- 1e-6 # 1e-4 surface area of aerosols clean, m2/m3 (https://cires1.colorado.edu/jimenez-group/Press/2015.05.22-Atmospheric.Chemistry.Cheat.Sheet.pdf)
  df$gamma_NO2_aerosol_hv <- 2e-5

  # HONO uptake coefficients ---------------------------------------------------
  if (initial$HONO_uptake == 'calculate'){
    df$gamma_HONO_ground <- get_HONO_soil_uptake(df = df)
  }
  else if(initial$HONO_uptake == 'input'){
    df$gamma_HONO_ground <- df$gamma_HONO_ground_input
  }
  else{
    print("Invalid HONO uptake selected")
  }



  # Reaction Rates -------------------------------------------------------------
  # Production Rates -----------------------------------------------------------
    # Low pressure limit OH+NO
  df$k_OH_NO_LPL <- (7.0e-31 * (df$TempK / 300) ^ -2.6) * initial$M
    # High pressure limit OH+NO
  df$k_OH_NO_HPL <- (3.6e-11 * (df$TempK / 300) ^ -0.1)
  df$k_OH_NO <- (df$k_OH_NO_LPL / (1 + df$k_OH_NO_LPL / df$k_OH_NO_HPL)) * 0.6 ^ (1.0 / (1 + (log10(df$k_OH_NO_LPL / df$k_OH_NO_HPL)) ^ 2))

  # NO2 Conversion on Ground Surfaces
  df$k_NO2_het_ground <- df$gamma_NO2_ground * df$v_NO2 * df$RH / 50 * df$SA_V_ground / 8
  df$k_NO2_het_ground_hv <- df$k_NO2_het_ground * df$gamma_NO2_ground_hv / df$gamma_NO2_ground * (df$JNO2 / df$beta)^3

  # NO2 Conversion on Aerosol Surfaces
  df$k_NO2_het_aerosol <- df$gamma_NO2_aerosol * df$SA_V_aerosol * df$v_NO2 / 4
  df$k_NO2_het_aerosol_hv <- df$k_NO2_het_aerosol * df$gamma_NO2_aerosol_hv / df$gamma_NO2_aerosol * df$JNO2 / df$beta

  # Photolysis of Orthonitrophenols
  df$k_C6H5NO3 <- 3e-5 * df$Jcorr # Bejan 2006

  # Loss Rates -----------------------------------------------------------------
  # HONO+OH
  df$k_HONO_OH <- 2.5e-12 * exp(260 / df$TempK)

  # HONO Deposition on Ground
  df$k_HONO_deposition_ground <- df$gamma_HONO_ground * df$v_HONO * df$SA_V_ground * df$RH / 20 / 8

  # HONO + HONO
  df$k_HONO_HONO <- 5.8e-25 * df$TempK ^ 3.64 * exp(-6109 / df$TempK)

  # HONO + O3
    # Liao 2006 https://www.sciencedirect.com/science/article/pii/S1352231005005856
    # JPL page 84
  df$k_HONO_O3 <- 5e-19

  # Combining for later comparison
  df$JNO2_NO2 <- df$JNO2 * df$NO2
  # ----------------------------------------------------------------------------

  # Estimating OH
  if (initial$estimate_OH == 1){
    # (Ehhalt D., et al. 2000) (https://agupubs.onlinelibrary.wiley.com/doi/epdf/10.1029/1999JD901070)
    JO1D <- (df$JNO2 / 1.61)^2
    df$OH <- 0.83 * JO1D^0.87 * df$JNO2^0.19 * ((140 * df$NO2 + 1)) / ((0.41 * df$NO2^2+1.7*df$NO2+1))
  }

  return(df)
}
