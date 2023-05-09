plot_HONO <- function(df, xlab, ylab){
  ggplot(df, aes(x = Hours, y = HONO_model)) +
    geom_point() +
    geom_line() +
    ylim(0, NA) +
    labs(x = xlab, y = ylab) +
    theme_classic()
}

# plot_HONO <- function(df, xlab, ylab){
#   ggplot(df, aes(x = Hours, y = HONO_model)) +
#     geom_point() +
#     geom_line(aes(color = "HONO_model")) +
#     geom_line(aes(y = HONO_pss * 1e3, color = "HONO_pss")) +
#     labs(x = xlab, y = ylab) +
#     scale_color_manual(values = c("black", "red"), labels = c("added chemistry", "base model")) +
#     theme_classic() +
#     theme(
#       legend.position = "top",
#       legend.text = element_text(size = 12),
#       legend.title = element_text(hjust = 0.5)
#     )
# }
