convert_to_mixing_ratio <- function(df) {
  # Leave OH in molec/cm3, convert others to ppb
  col_list <- c("HONO", "NO", "NO2", "NOx", "HONO_pss", "O3",
                "P_OH_NO", "P_NO2het_ground", "P_NO2het_ground_light", "P_NO2het_aerosol", "P_NO2het_aerosol_light", "P_emis", "P_soil",
                "L_photo", "L_OH", "L_aerosol", "L_dilution", "L_ground_light", "L_aerosol_light", "L_uptake_ground", "production", "loss", "diff", "unknown")
  for(col_name in colnames(df)) {
    if(col_name %in% col_list) {
      df[[col_name]] <- df[[col_name]] / (2.46e10)
    }
  }

  return(df)
}
