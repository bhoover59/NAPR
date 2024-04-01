plot_rates <- function(df){
  df_long <- df %>%
    pivot_longer(
      cols = c("L_photo", "L_OH", "L_het", "L_other", "P_OH_NO", "P_NO2het", "P_other"),
      names_to = "Reaction",
      values_to = "Rate"
    ) %>%
    mutate(
      # adjust the sign of L_photo and L_OH
      Rate = ifelse(Reaction %in% c("L_photo", "L_OH", "L_het", "L_other"), -Rate, Rate),
      # add a label column for fill scales
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
  # create the stacked area plot
  ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
    geom_area() +
    labs(x = "Hours", y = "Rate (ppb/h)",
         title = "Reaction Mechanisms",
         fill = "") +
    scale_fill_manual(
      values = c("HONO+hv" = "firebrick4", "HONO+OH" = "red", "L_het" = "orange", "L_other" = "yellow", "OH+NO" = "navy", "NO2+H2O" = "lightblue", "P_other" = "purple"),
      labels = c("HONO+hv", "HONO+OH", expression(L[het]), expression(L[other]), expression(NO[2] + surf), expression(OH + NO), expression(P[other]))
    ) +
    theme_classic() +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_text(hjust = 0.5)
    )
}

# plot_rates <- function(df){
#   df_long <- df %>%
#     pivot_longer(
#       cols = c("L_photo", "L_OH", "L_het", "L_other", "P_OH_NO", "P_NO2het", "P_other"),
#       names_to = "Reaction",
#       values_to = "Rate"
#     ) %>%
#     mutate(
#       # adjust the sign of L_photo and L_OH
#       Rate = ifelse(Reaction %in% c("L_photo", "L_OH", "L_het", "L_other"), -Rate, Rate),
#       # add a label column for fill scales
#       Label = case_when(
#         Reaction == "L_photo" ~ "HONO+hv",
#         Reaction == "L_OH" ~ "HONO+OH",
#         Reaction == "L_het" ~ "L_het",
#         Reaction == "L_other" ~ "L_other",
#         Reaction == "P_OH_NO" ~ "OH+NO",
#         Reaction == "P_NO2het" ~ "NO2+H2O",
#         Reaction == "P_other" ~ "P_other"
#       )
#     )
#   # create the stacked area plot
#   ggplot(df_long, aes(x = Hours, y = Rate, fill = Label)) +
#     geom_area() +
#     labs(x = "Hours", y = "Rate (ppb/h)",
#          title = "Reaction Mechanisms",
#          fill = "") +
#     scale_fill_manual(
#       values = c("HONO+hv" = "firebrick4", "HONO+OH" = "red", "L_het" = "orange", "L_other" = "yellow", "OH+NO" = "navy", "NO2+H2O" = "lightblue", "P_other" = "purple"),
#       labels = c("HONO+hv", "HONO+OH", expression(L[het]), expression(L[other]), expression(OH + NO), expression(NO[2] + surf), expression(P[other]))
#     ) +
#     theme_classic() +
#     theme(
#       legend.position = "top",
#       legend.text = element_text(size = 12),
#       legend.title = element_text(hjust = 0.5)
#     )
#
# }
