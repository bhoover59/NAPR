plot_rates <- function(df){
  df_long <- df %>%
    pivot_longer(
      cols = c("L_photo", "L_OH", "L_het", "L_other", "P_OH_NO", "P_NO2het", "P_other"),
      names_to = "Reaction",
      values_to = "Rate"
    ) %>%
    mutate(
      Rate = ifelse(Reaction %in% c("L_photo", "L_OH", "L_het", "L_other"), -Rate, Rate),
      Label = case_when(
        Reaction == "L_photo" ~ "HONO+hv",
        Reaction == "L_OH" ~ "HONO+OH",
        Reaction == "L_het" ~ "L_het",
        Reaction == "L_other" ~ "L_other",
        Reaction == "P_OH_NO" ~ "OH+NO",
        Reaction == "P_NO2het" ~ "NO2+H2O",  # Corrected label
        Reaction == "P_other" ~ "P_other"
      )
    )
  ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
    geom_area() +
    labs(x = "Hours", y = "Rate (ppb/h)",
         title = "Reaction Mechanisms",
         fill = "") +
    scale_fill_manual(
      values = c("HONO+hv" = "firebrick4", "HONO+OH" = "red", "L_het" = "orange", "L_other" = "yellow", "OH+NO" = "lightblue", "NO2+H2O" = "navy", "P_other" = "purple"),
      labels = c("HONO+hv", "HONO+OH", expression(L[het]), expression(L[other]), expression(NO[2] + surf), expression(OH + NO), expression(P[other]))
    ) +
    theme_classic() +
    # coord_cartesian(ylim = c(-max(abs(df_long$Rate)), max(abs(df_long$Rate)))) +
    coord_cartesian(ylim = c(-4e-2, 4e-2)) +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_text(hjust = 0.5)
    )
}
