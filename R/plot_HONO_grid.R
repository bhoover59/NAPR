plot_HONO_grid <- function(df, xlab, ylab) {
  p1 <- ggplot(df, aes(x = Hours, y = HONO_model * 1e3, color = "HONO_model")) +
    geom_point() +
    geom_line() +
    scale_color_manual(values = c("black"), labels = c("HONO_model")) +
    labs(x = xlab, y = ylab) +
    theme_classic()

  p2 <- ggplot(df, aes(x = Hours, y = HONO_pss * 1e3, color = "HONO_pss")) +
    geom_line() +
    scale_color_manual(values = c("red"), labels = c("HONO_pss")) +
    labs(x = xlab, y = ylab) +
    theme_classic()

  p3 <- ggplot(df, aes(x = Hours, y = HONO * 1e3, color = "HONO_meas")) +
    geom_line() +
    scale_color_manual(values = c("blue"), labels = c("HONO_meas")) +
    labs(x = xlab, y = ylab) +
    theme_classic()

  p4 <- ggplot(df, aes(x = Hours, y = HONO_model_NPSS * 1e3, color = "HONO_NPSS")) +
    geom_line() +
    scale_color_manual(values = c("green"), labels = c("HONO_NPSS")) +
    labs(x = xlab, y = ylab) +
    theme_classic()

  plot_grid(p1, p2, p3, p4, nrow = 2, ncol = 2)
}
