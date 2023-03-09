plot_rates <- function(df){
  ggplot(df, aes(x = Hours)) +
    geom_line(aes(y = -L_photo, color = "HONO+hv")) +
    geom_line(aes(y = -L_OH, color = "HONO+OH")) +
    geom_line(aes(y = production, color = "Total production")) +
    labs(x = "Hours", y = "Rate (ppb/h)", color = "Reaction") +
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
