plot_HONO <- function(df, xlab, ylab){
  ggplot(df, aes(x = Hours, y = HONO_model)) +
    geom_point() +
    geom_line() +
    labs(x = xlab, y = ylab)
}
