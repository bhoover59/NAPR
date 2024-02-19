convert_to_mixing_ratio <- function(df) {
  col_list <- c("HONO", "OH", "NO", "NO2", "NOx", "HONO_pss", "HONO_model", "O3",
                "P_OH_NO", "P_NO2het_ground", "P_NO2het_ground_light", "P_NO2het_aerosol", "P_NO2het_aerosol_light",
                "P_emis", "P_soil", "P_C6H5NO3", "P_other",
                "production", "unknown","L_photo", "L_het", "L_OH", "L_uptake_ground",
                "P_NO2het", "L_other", "diff", "HONO_model_NPSS", "loss",
                "delta","HONO_model_NPSS")

  for(col_name in colnames(df)) {
    if(col_name %in% col_list) {
      df[[col_name]] <- df[[col_name]] / (2.46e10)
    }
  }

  return(df)
}
