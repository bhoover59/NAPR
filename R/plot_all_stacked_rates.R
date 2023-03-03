plot_all_stacked_rates <- function(df){
  # ggplot(data = df, aes(x = Hours)) +
  #   geom_area(aes(y = -L_photo, fill = "L_photo")) +
  #   geom_area(aes(y = -L_OH, fill = "L_OH")) +
  #   geom_area(aes(y = P_OH_NO, fill = "P_OH_NO")) +
  #   geom_area(aes(y = P_NO2het_ground, fill = "P_NO2het_ground")) +
  #   labs(fill = "Reaction") +
  #   labs(x = "Hours", y = "Rate (ppb/h)", color = "Reaction",
  #        fill = "Reaction") +
  #   scale_fill_manual(values = c("L_photo" = "blue", "L_OH" = "purple",
  #                                "P_OH_NO" = "red", "P_NO2het_ground" = "orange"),
  #                     labels = c("HONO+hv", "HONO+OH", "OH+NO", "NO2+ground")) +
  #   theme_classic() +
  #   theme(
  #     # legend.position = c(0.95, 0.75),
  #     legend.justification = c("right", "center"),
  #     legend.box.just = "right",
  #     legend.title.align = 0.5,
  #     legend.background = element_blank(),
  #     legend.text = element_text(size = 12)
  #   )
    ggplot(data = df, aes(x = Hours, y = production)) +
      geom_area(aes(y = -L_photo, fill = "L_photo")) +
      geom_area(aes(y = -L_OH, fill = "L_OH")) +
      geom_area(aes(y = P_OH_NO, fill = "P_OH_NO")) +
      geom_area(aes(y = P_NO2het_ground, fill = "P_NO2het_ground")) +
      scale_fill_manual(values = c("L_photo" = "blue", "L_OH" = "purple", "P_OH_NO" = "green", "P_NO2het_ground" = "red"),
                        labels = c("HONO+hv", "HONO+OH", "P_OH_NO", "P_NO2het_ground")) +
      labs(x = "Hours", y = "Rate (ppb/h)", fill = "Reaction") +
      theme_classic() +
      theme(legend.position = "bottom",
            legend.justification = c("center", "center"),
            legend.box.just = "center",
            legend.title.align = 0.5,
            legend.background = element_blank(),
            legend.text = element_text(size = 12)) +
      guides(fill = guide_legend(ncol = 2, title.position = "top", title.hjust = 0.5,
                                 override.aes = list(size = 3, alpha = 1),
                                 title = "Reaction type",
                                 title.theme = element_text(size = 14, face = "bold"),
                                 keyheight = unit(1, "cm"),
                                 byrow = TRUE,
                                 order = 1,
                                 label.hjust = 0.5),
             fill = guide_legend(ncol = 2, title.position = "bottom", title.hjust = 0.5,
                                 override.aes = list(size = 3, alpha = 1),
                                 title = "Reaction category",
                                 title.theme = element_text(size = 14, face = "bold"),
                                 keyheight = unit(1, "cm"),
                                 byrow = TRUE,
                                 order = 2,
                                 label.hjust = 0.5))
}
