plot_production <- function(df_model){
  df_model$production <- df_model$P_OH_NO +
  df_model$P_NO2het_ground +
  df_model$P_NO2het_ground_light +
  df_model$P_NO2het_aerosol +
  df_model$P_NO2het_aerosol_light +
  df_model$P_emis +
  df_model$P_soil +
  df_model$P_C6H5NO3

matplot(df_model[, c("P_OH_NO", "P_NO2het_ground", "P_NO2het_ground_light",
                     "P_NO2het_aerosol", "P_NO2het_aerosol_light", "P_emis",
                     "P_soil", "P_C6H5NO3", "production")],
        type = 'l', col = c("red", "green", "blue", "purple", "orange", "brown", "pink", "gray", "black"),
        lwd = 2, xlab = 'Hour', ylab = 'Rxn rate (ppb/h)')

# Add legend
legend("topright", legend = c("P_OH_NO", "P_NO2het_ground", "P_NO2het_ground_light",
                              "P_NO2het_aerosol", "P_NO2het_aerosol_light", "P_emis",
                              "P_soil", "P_C6H5NO3", "Production"),
       col = c("red", "green", "blue", "purple", "orange", "brown", "pink", "gray", "black"),
       lty = 1, cex = 0.8)
}
plot_production_rates <- function(df){
  df_long <- df_model %>%
    pivot_longer(
      cols = c("P_OH_NO", "P_NO2het_ground", "P_NO2het_ground_light",
               "P_NO2het_aerosol", "P_NO2het_aerosol_light",
               "P_emis", "P_soil", "P_C6H5NO3"),
      names_to = "Reaction",
      values_to = "Rate"
    ) %>%
    mutate(
      Label = case_when(
        Reaction == "P_OH_NO" ~ "OH+NO",
        Reaction == "P_NO2het_ground" ~ "NO2+Ground",
        Reaction == "P_NO2het_ground_light" ~ "NO2+Ground+Light",
        Reaction == "P_NO2het_aerosol" ~ "NO2+Aerosol",
        Reaction == "P_NO2het_aerosol_light" ~ "NO2+Aerosol+Light",
        Reaction == "P_emis" ~ "Emissions",
        Reaction == "P_soil" ~ "Soil",
        Reaction == "P_C6H5NO3" ~ "C6H5NO3"
      )
    )

  # create the stacked area plot
  ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
    geom_area() +
    labs(x = "Hours", y = "Production Rate",
         title = "Stacked Production Rates",
         fill = "") +
    scale_fill_manual(
      values = c("OH+NO" = "black", "NO2+Ground" = "green", "NO2+Ground+Light" = "blue",
                 "NO2+Aerosol" = "purple", "NO2+Aerosol+Light" = "orange",
                 "Emissions" = "brown", "Soil" = "yellow", "C6H5NO3" = "gray"),
      labels = c("OH+NO", "NO2+Ground", "NO2+Ground+Light", "NO2+Aerosol",
                 "NO2+Aerosol+Light", "Emissions", "Soil", "C6H5NO3")
    ) +
    theme_classic() +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 10),
      legend.title = element_text(hjust = 0.5)
    )
}

