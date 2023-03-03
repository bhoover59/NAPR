plot_stacked_rates <- function(df){
    ggplot(data = df, aes(x = Hours, y = production)) +
      geom_area(aes(y = -L_photo, fill = "L_photo")) +
      geom_area(aes(y = -L_OH, fill = "L_OH")) +
      geom_line(aes(y = production, color = "Total production")) +
      labs(fill = "Reaction", color = "Reaction") +
      labs(x = "Hours", y = "Rate (ppb/h)", fill = "Reaction") +
      scale_fill_manual(values = c("L_photo" = "blue", "L_OH" = "purple"),
                        labels = c("HONO+hv", "HONO+OH")) +
      scale_color_manual(values = c("Total production" = "black"),
                         labels = c("Total production")) +
      theme_classic() +
      theme(
        # legend.position = c(0.95, 0.75),
        legend.justification = c("right", "center"),
        legend.box.just = "right",
        legend.title.align = 0.5,
        legend.background = element_blank(),
        legend.text = element_text(size = 12)
      )
}
