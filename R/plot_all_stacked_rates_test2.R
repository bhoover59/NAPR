plot_all_stacked_rates_test <- function(df){
  # Categorizing mechanisms
  df$P_NO2het <- df$P_NO2het_ground + df$P_NO2het_ground_light + df$P_NO2het_aerosol + df$P_NO2het_aerosol_light
  df$L_het <- df$L_uptake_ground + df$L_aerosol + df$L_ground_light + df$L_aerosol_light

  # tidy the data
  df_long <- df %>%
    pivot_longer(
      cols = c("L_photo", "L_OH", "L_dilution", "L_uptake_ground", "L_aerosol",
               "L_ground_light", "L_aerosol_light", "P_OH_NO", "P_NO2het_ground",
               "P_NO2het_ground_light", "P_NO2het_aerosol", "P_NO2het_aerosol_light", "P_soil", "P_NO2het", "L_het"),
      names_to = "Reaction",
      values_to = "Rate"
    ) %>%
    mutate(
      # adjust the sign of L_photo and L_OH
      Rate = ifelse(Reaction %in% c("L_photo", "L_OH"), -Rate, Rate),
      # add a label column for fill scales
      Label = case_when(
        Reaction == "L_photo" ~ "HONO+hv",
        Reaction == "L_OH" ~ "HONO+OH",
        Reaction == "L_dilution" ~ "Dilution",
        Reaction == "L_uptake_ground" ~ "Ground deposition",
        Reaction == "L_aerosol" ~ "Aerosol deposition",
        Reaction == "L_ground_light" ~ "HONO+ground+hv",
        Reaction == "L_aerosol_light" ~ "HONO+aerosol+hv",
        Reaction == "P_OH_NO" ~ "OH+NO",
        Reaction == "P_NO2het_ground" ~ "NO2+ground",
        Reaction == "P_NO2het_ground_light" ~ "NO2+ground+hv",
        Reaction == "P_NO2het_aerosol" ~ "NO2+aerosol",
        Reaction == "P_NO2het_aerosol_light" ~ "NO2+aerosol+hv",
        Reaction == "P_soil" ~ "Soil",
        Reaction == "P_NO2het" ~ "NO2+H2O",
        Reaction == "L_het" ~ "HONO+surface",
      )
    )

  # create the stacked area plot
  ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
    geom_area(position = "stack", alpha = 1.0) +
    labs(x = "Hours", y = "Rate (ppb/h)",
         title = "Reaction Mechanisms",
         fill = "") +
    scale_fill_manual(
      values = c("L_photo" = "firebrick4", "L_OH" = "firebrick3", "L_dilution" = "firebrick2", "L_het" = "firebrick1",
                 "P_OH_NO" = "navy", "P_NO2het" = "blue", "P_soil" = "dodgerblue"),
      labels = c("HONO+hv", "HONO+OH", "Dilution", "HONO+surf", "OH+NO", "NO2+H2O", "Soil")
      # name = ""
    ) +
    theme_classic() +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_text(hjust = 0.5)
    )
}
# scale_fill_manual(
#   values = c("L_photo" = "firebrick4", "L_OH" = "firebrick3", "L_dilution" = "firebrick2", "L_uptake_ground" = "firebrick1", "L_aerosol" = "firebrick", "L_ground_light" = "coral",
#              "L_aerosol_light" = "darksalmon", "P_OH_NO" = "navy", "P_NO2het_ground" = "blue4",
#              "P_NO2het_ground_light" = "blue", "P_NO2het_aerosol" = "royalblue",
#              "P_NO2het_aerosol_light" = "steelblue1", "P_soil" = "lightskyblue"),
#   labels = c("HONO+hv", "HONO+OH", "Dilution", "HONO+ground", "HONO+aerosol", "HONO+ground+hv", "HONO+aerosol+hv",
#              "OH+NO", "NO2+ground", "NO2+ground+hv", "NO2+aerosol", "NO2+aerosol+hv", "Soil"),
#   name = ""
# )
# scale_fill_colorblind() +
# max number of variables for spectral is 11

