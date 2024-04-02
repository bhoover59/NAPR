stack_rates <- function(df){
  # Production rates stacked
  df$IGOR_OH_NO <- df$P_OH_NO
  df$IGOR_NO2het_ground <- df$P_OH_NO + df$P_NO2het_ground
  df$IGOR_Pother <- df$P_OH_NO + df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light + df$P_emis + df$P_soil + df$P_C6H5NO3

  df$IGOR_unknown_pos <- df$IGOR_Pother + df$Unknown_positive

  # Loss rates stacked
  df$IGOR_photo <- df$L_photo * -1
  df$IGOR_HONO_OH <- (df$L_photo + df$L_OH) * -1
  df$IGOR_deposition <- (df$L_photo + df$L_OH + df$L_uptake_ground) * -1
  df$IGOR_Lother <- (df$L_photo + df$L_OH + df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light + df$L_self + df$L_O3) * -1
  df$Unknown_negative <- ifelse(df$unknown < 0, df$unknown, 0)
  df$IGOR_unknown_neg <- df$IGOR_Lother + df$Unknown_negative

  return(df)
}
