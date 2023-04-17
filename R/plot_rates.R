plot_rates <- function(df){
  # tidy the data
  df_long <- df %>%
    pivot_longer(
      cols = c("L_photo", "L_OH", "L_het", "P_OH_NO", "P_NO2het"),
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
        Reaction == "L_het" ~ "L_het",
        Reaction == "P_OH_NO" ~ "OH+NO",
        Reaction == "P_NO2het" ~ "NO2+H2O"
      )
    )

  # create the stacked area plot
  ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
    geom_area() +
    labs(x = "Hours", y = "Rate (ppb/h)",
         title = "Reaction Mechanisms",
         fill = "") +
    scale_fill_manual(
      values = c("HONO+hv" = "firebrick4", "HONO+OH" = "firebrick3", "L_het" = "red", "OH+NO" = "navy", "NO2+H2O" = "blue"),
      labels = c("HONO+hv", "HONO+OH", "L_het", "OH+NO", "NO2+H2O")
    ) +
    theme_classic() +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_text(hjust = 0.5)
    )
}


# plot_rates <- function(df){
#   # tidy the data
#   df_long <- df %>%
#     pivot_longer(
#       cols = c("L_photo", "L_OH", "L_het", "P_OH_NO", "P_NO2het"),
#       names_to = "Reaction",
#       values_to = "Rate"
#     ) %>%
#     mutate(
#       # adjust the sign of L_photo and L_OH
#       Rate = ifelse(Reaction %in% c("L_photo", "L_OH"), -Rate, Rate),
#       # add a label column for fill scales
#       Label = case_when(
#         Reaction == "L_photo" ~ "HONO+hv",
#         Reaction == "L_OH" ~ "HONO+OH",
#         Reaction == "L_het" ~ "L_het",
#         Reaction == "P_OH_NO" ~ "P_OH_NO",
#         Reaction == "P_NO2het" ~ "P_NO2het"
#       )
#     )
#
#   # create the stacked area plot
#   ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
#     geom_area() +
#     labs(x = "Hours", y = "Rate (ppb/h)",
#          title = "Reaction Mechanisms",
#          fill = "") +
#     scale_fill_manual(
#       values = c("HONO+hv" = "firebrick4", "HONO+OH" = "firebrick3", "L_het" = "red", "P_OH_NO" = "navy", "P_NO2het" = "blue"),
#       labels = c("HONO+hv", "HONO+OH", "HONO+surf", "OH+NO", "NO2+H2O")
#     ) +
#     theme_classic() +
#     theme(
#       legend.position = "top",
#       legend.text = element_text(size = 12),
#       legend.title = element_text(hjust = 0.5)
#     )
# }
