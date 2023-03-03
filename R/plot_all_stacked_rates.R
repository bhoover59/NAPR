plot_all_stacked_rates <- function(df){
  # tidy the data
  df_long <- df %>%
    pivot_longer(
      cols = c("L_photo", "L_OH", "P_OH_NO", "P_NO2het_ground"),
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
        Reaction == "P_OH_NO" ~ "P_OH_NO",
        Reaction == "P_NO2het_ground" ~ "P_NO2het_ground"
      )
    )

  # create the stacked area plot
  ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
    geom_area() +
    labs(x = "Hours", y = "Rate (ppb/h)",
         title = "Reaction Mechanisms",
         fill = "") +
    scale_fill_manual(
      values = c("HONO+hv" = "red", "HONO+OH" = "orange", "P_OH_NO" = "green", "P_NO2het_ground" = "blue"),
      labels = c("HONO+hv", "HONO+OH", "OH+NO", "NO2+ground")
    ) +
    theme_classic() +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_text(hjust = 0.5)
    )
}
