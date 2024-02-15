production_mechanisms <- function(df, initial){
  # IF YOU ADD MECHANISMS, YOU NEED TO ADD THE NAME TO convert_to_mixing_ratio() FOR IT TO CONVERT TO PPB/H
  # List of mechanisms ---------------------------------------------------------
  # Homogeneous gas phase: OH+NO = HONO
  # NO2 Conversion on Humid Surfaces:
  #     - Ground: 2NO2+ground+H2O = HONO + HNO3
  #     - Photoenhanced Ground: 2NO2+ground+H2O+hv = HONO + HNO3
  #     - Aerosols: 2NO2+aerosol+H2O = HONO + HNO3
  #     - Photoenhanced Aerosols: 2NO2+aerosol+H2O+hv = HONO + HNO3
  # Vehicle Emissions
  # Soil Emissions
  #     - Based on constant flux rate and boundary layer height
  #     - Should be different rate throughout day
  #     - Boundary layer height should minimize at night, max during day
  #     - Should include [soil nitrite], pH, temp, RH, and WHC dependence
  # Acid Displacement
  # Photolysis of Adsorbed Nitric Acid/Particulate Nitrate: 2HNO3+hv=2HONO+O2
  # Photolysis of ortho nitrophenols: C6H5NO3+hv=HONO

  # PRODUCTION MECHANISMS (percc/h) --------------------------------------------
  # Homogeneous gas phase rxn: OH + NO -> HONO ---------------------------------
  df$P_OH_NO <- df$k_OH_NO * df$OH * df$NO * 3600

    # Ground surfaces ------------------------------------------------------------
  # Dark NO2 conversion on ground
  df$P_NO2het_ground <- (df$k_NO2_het_ground * df$NO2 * 3600)
  # Photo-enhanced NO2 conversion on ground
  df$P_NO2het_ground_light <- (df$k_NO2_het_ground_hv * df$NO2 * 3600)

  # Aerosol surfaces -----------------------------------------------------------
  # Dark NO2 conversion on aerosols
  df$P_NO2het_aerosol <- (df$k_NO2_het_aerosol * df$NO2 * 3600)

  # Photo-enhanced NO2 conversion on aerosols ----------------------------------
  df$P_NO2het_aerosol_light <- (df$k_NO2_het_aerosol_hv * df$NO2 * 3600)

  # Photolysis of orthonitrophenols (C6H5NO3)  ---------------------------------
  df$P_C6H5NO3 <- (df$k_C6H5NO3 * initial$C6H5NO3_conc * 3600)

  # Direct vehicle emissions ---------------------------------------------------
  # Estimate using HONO/NOx ratio?
  df$P_emis <- 0

  # Direct soil emissions (calculate from NO emissions?) -----------------------
  # Currently not photo-sensitive. Constant emission rate
  if(initial$soil_type == 'AM'){
    # convert ng/m3 /s to ppb/s
    # NEED TO SCALE SOIL DUE TO PHOTO ENHANCED?
    initial$F_soil_HONO <- initial$F_soil_HONO * 298 / 12.187 / 47
    df$P_soil <- initial$F_soil_HONO / df$H * 3600
  } else{
    df$P_soil <- 0 # no soil emissions
  }

  # NOT INCLUDED YET AND MIGHT NOT ---------------------------------------------

  # Photolysis of particulate nitrate
  # df$nitrate <- df$nitrate * R * df$Temp * J_HNO3 * initial$EF

  # Acid Displacement
  # ----------------------------------------------------------------------------

  # Lumping together heterogeneous production ----------------------------------
  df$P_NO2het <- (df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light)

  # Other
  df$P_other <- df$P_emis + df$P_soil + df$P_C6H5NO3

  # Total production -----------------------------------------------------------
  df$production <- df$P_OH_NO + df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light + df$P_emis + df$P_soil + df$P_C6H5NO3

  return(df)
}
