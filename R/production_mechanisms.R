production_mechanisms <- function(df, initial){
  # IF YOU ADD MECHANISMS, YOU NEED TO ADD THE NAME TO convert_to_mixing_ratio() FOR IT TO CONVERT TO PPB/H
  # Aerosols
  # Explanation of photo-enhanced notation:
    # df$gamma_NO2_aerosol has photoenhanced calculated in get_kinetics
    # initial$gamma_NO2_aerosol is constant for dark conversion

  # PRODUCTION MECHANISMS (percc/h) --------------------------------------------
  # Later gets converted to ppb/h

  # Homogeneous gas phase rxn: OH + NO -> HONO
  df$P_OH_NO <- df$k_OH_NO * df$OH * df$NO * 3600

  # Ground surfaces
  # Dark NO2 conversion on ground
  df$P_NO2het_ground <- (initial$v_NO2 * initial$gamma_NO2_ground * df$NO2 * 3600) / (8 * initial$H)
  # Aerosols independent of boundary layer H, only ground is?
  # Photo-enhanced NO2 conversion on ground
  df$P_NO2het_ground_light <- (initial$v_NO2 * df$gamma_NO2_ground * df$NO2 * 3600) / (8 * initial$H)

  # Aerosol surfaces
  # Dark NO2 conversion on aerosols
  # DIVIDE BY 4 OR NOT OR 8
  #df$P_NO2het_aerosol <- (initial$v_NO2 * initial$gamma_NO2_aerosol * df$NO2 * initial$S_aerosol * 3600) / (4 * H)
  # Dark NO2 conversion on aerosols
  df$P_NO2het_aerosol <- (initial$v_NO2 * initial$gamma_NO2_aerosol * df$NO2 * initial$S_aerosol * 3600) / (4)
  # Photo-enhanced NO2 conversion on aerosols
  df$P_NO2het_aerosol_light <- (initial$v_NO2 * df$gamma_NO2_aerosol * df$NO2 * initial$S_aerosol * 3600) / (4)

  # Direct vehicle emissions
  df$P_emis <- 0
  # Direct soil emissions (calculate from NO emissions?)
  # Currently not photo-sensitive. Constant emission rate
  if(initial$soil_type == 'AM'){
    # convert ng/m3 s to ppb/s
    initial$F_soil_HONO <- initial$F_soil_HONO * 298 / 12.187 / 47
    df$P_soil <- initial$F_soil_HONO / initial$H * 3600
  }

  # NOT INCLUDED YET AND MIGHT NOT
  # Photolysis of nitrophenols
  # df$P_nitro <- J_nitrophenol * df$nitrophenol * 3600
  # Photolysis of particulate nitrate
  # df$nitrate <- df$nitrate * R * df$Temp * J_HNO3
  # acid displacement
  # soil nitrite

  return(df)
}
