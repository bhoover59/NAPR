percent_contribution <- function(df, view_percentages){
  # Production rates
  df$Unknown_positive <- ifelse(df$unknown > 0, df$unknown, 0)
  df$production_perc <- df$production + df$Unknown_positive
  df$perc_OH_NO <- df$P_OH_NO / df$production_perc
  df$perc_NO2het_ground <- df$P_NO2het_ground / df$production_perc
  df$perc_Pother <- (df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light + df$P_emis + df$P_soil + df$P_C6H5NO3) / df$production_perc
  df$perc_unknown_pos <- df$Unknown_positive / df$production_perc

  # Loss rates
  df$Unknown_negative <- ifelse(df$unknown < 0, df$unknown, 0)
  df$loss_perc <- df$loss + df$Unknown_negative * -1
  df$perc_photo <- df$L_photo / df$loss_perc
  df$perc_HONO_OH <- df$L_OH / df$loss_perc
  df$perc_deposition <- df$L_uptake_ground / df$loss_perc
  df$perc_Lother <- (df$L_aerosol + df$L_ground_light + df$L_aerosol_light + df$L_self + df$L_O3) / df$loss_perc
  df$perc_unknown_neg <- df$Unknown_negative * -1 / df$loss_perc

  # Day and night production averages
  avg_day_prod <- colMeans(df[8:20, c("perc_OH_NO", "perc_NO2het_ground", "perc_Pother", "perc_unknown_pos")])
  avg_night_prod <- colMeans(df[c(21:24, 1:7), c("perc_OH_NO", "perc_NO2het_ground", "perc_Pother", "perc_unknown_pos")])

  # Day and night loss averages
  avg_day_loss <- colMeans(df[8:20, c("perc_photo", "perc_HONO_OH", "perc_deposition", "perc_Lother", "perc_unknown_neg")])
  avg_night_loss <- colMeans(df[c(21:24, 1:7), c("perc_photo", "perc_HONO_OH", "perc_deposition", "perc_Lother", "perc_unknown_neg")])

  # Round the % to three decimal places
  avg_day_prod <- round(avg_day_prod, 3) * 100
  avg_night_prod <- round(avg_night_prod, 3) * 100
  avg_day_loss <- round(avg_day_loss, 3) * 100
  avg_night_loss <- round(avg_night_loss, 3) * 100

  prod <- data.frame(
    Day = avg_day_prod,
    Night = avg_night_prod
  )
  loss <- data.frame(
    Day = avg_day_loss,
    Night = avg_night_loss
  )
  if(view_percentages == 1){
    View(prod)
    View(loss)
  }


  return(df)

}
