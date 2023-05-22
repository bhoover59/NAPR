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
  # Photolysis of Adsorbed Nitric Acid: 2HNO3+hv=2HONO+O2
  # Photolysis of Particulate Nitrate (same as above?)
  # Photolysis of ortho nitrophenols: orthonitrophenol+hv=HONO

  # Aerosols
  # Explanation of photo-enhanced notation:
    # df$gamma_NO2_aerosol has photo-enhanced calculated in get_kinetics
      # Uses ratio of JNO2 to max JNO2
      # Actually now it uses Beta factor
    # initial$gamma_NO2_aerosol is constant for dark conversion

  # PRODUCTION MECHANISMS (percc/h) --------------------------------------------
  # Later gets converted to ppb/h
  # Homogeneous gas phase rxn: OH + NO -> HONO ---------------------------------
  df$P_OH_NO <- df$k_OH_NO * df$OH * df$NO * 3600 * 10

  # Ground surfaces ------------------------------------------------------------
  # Dark NO2 conversion on ground
  df$P_NO2het_ground <- (df$v_NO2 * initial$gamma_NO2_ground * df$NO2 * (df$RH/50) * 3600) / (4 * df$H)
  # Aerosols independent of boundary layer H, only ground is
  # Photo-enhanced NO2 conversion on ground
  df$P_NO2het_ground_light <- (df$v_NO2 * initial$gamma_NO2_ground * (df$JNO2 / initial$beta)^3 * (df$RH/50) * df$NO2 * 3600) / (4 * df$H)
  # df$gamma_NO2_ground has a scaled NO2 uptake but different method

  # Aerosol surfaces -----------------------------------------------------------
  # Dark NO2 conversion on aerosols
  df$P_NO2het_aerosol <- (df$v_NO2 * initial$gamma_NO2_aerosol * df$NO2 * initial$S_aerosol * 3600) / (4)

  # Photo-enhanced NO2 conversion on aerosols ----------------------------------
  df$P_NO2het_aerosol_light <- (df$v_NO2 * initial$gamma_NO2_aerosol * (df$JNO2 / initial$beta) * df$NO2 * initial$S_aerosol * 3600) / (4)

  # Direct vehicle emissions ---------------------------------------------------
  # Estimate using HONO/NOx ratio
  df$P_emis <- 0

  # Direct soil emissions (calculate from NO emissions?) -----------------------
  # Related to soil nitrite
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
  # Photolysis of nitrophenols
  # df$P_nitro <- J_nitrophenol * df$nitrophenol * 3600

  # Photolysis of particulate nitrate
  # df$nitrate <- df$nitrate * R * df$Temp * J_HNO3

  # Acid Displacement

  # Lumping together heterogeneous production ----------------------------------
  df$P_NO2het <- (df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light) * 1e3

  # Total production -----------------------------------------------------------
  df$production <- df$P_OH_NO + df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light + df$P_emis + df$P_soil

  return(df)
}
