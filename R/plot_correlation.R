plot_correlation <- function(df) {
  keep_columns <- function(df, columns_to_keep) {
    df <- df[, columns_to_keep, drop = FALSE]
    return(df)
  }
  rename_column <- function(df, old_column_name, new_column_name) {
    names(df)[which(names(df) == old_column_name)] <- new_column_name
    return(df)
  }

  df$JNO2xNO2 <- df$JNO2 * df$NO2
  columns_to_keep <- c("HONO", "OH", "Temp", "RH", "NO2", "NO", "NOx", "JNO2", "JNO2xNO2", "unknown")
  correlation <- keep_columns(df, columns_to_keep)
  correlation$unknown <- correlation$unknown * -1
  colnames(correlation) <- c("HONO", "OH", "Temp", "RH", "NO2", "NO", "NOx", "JNO2", "JNO2xNO2", "Unknown")
  corrMatrix <- round(cor(correlation), 2)

  triangle_mask <- upper.tri(corrMatrix)

  ggplot(data = melt(corrMatrix), aes(Var1, Var2, fill = value)) +
    geom_tile(data = subset(melt(corrMatrix), triangle_mask), color = "white") +
    geom_text(data = subset(melt(corrMatrix), triangle_mask), aes(label = value), vjust = 1) +
    scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0, limits = c(-1, 1), name = "Correlation") +
    theme(panel.background = element_rect(fill = "transparent"),
          panel.border = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.title = element_blank())  # Remove axis titles only
}
