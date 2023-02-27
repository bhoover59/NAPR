plot_species <- function(df, species, xlab, ylab){
  ggplot(df, aes(x = Hours, y = df[,species])) +
    geom_point() +
    geom_line() +
    labs(x = xlab, y = ylab)
}
