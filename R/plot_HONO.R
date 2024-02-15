plot_HONO <- function(df, xlab, ylab){
  ggplot(df, aes(x = Hours, y = HONO_model * 1e3)) +
    geom_point() +
    geom_line(aes(color = "HONO_model")) +
    geom_line(aes(y = HONO_pss * 1e3, color = "HONO_pss")) +
    geom_line(aes(y = HONO * 1e3, color = "HONO_meas")) +
    geom_line(aes(y = HONO_model_NPSS * 1e3, color = "HONO_NPSS")) +
    labs(x = xlab, y = ylab) +
    scale_color_manual(values = c("black", "red", "blue", "green"), labels = c("Added chemistry", "Base model", "Measured", "NPSS")) +
    theme_classic() +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_blank()
    )
}

