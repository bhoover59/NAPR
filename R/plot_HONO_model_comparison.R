# Function to plot HONO_model with a secondary y-axis for HONO_pss
# Input:
#   - df: dataframe containing columns "Hours", "HONO_model", and "HONO_pss"
# Output: ggplot object
plot_HONO_model_comparison <- function(df) {
  plot <- ggplot(df, aes(x = Hours)) +
    # Primary y-axis for HONO_model
    geom_point(aes(y = HONO_model), color = "black") +
    geom_line(aes(y = HONO_model), color = "black") +
    # Secondary y-axis for HONO_pss
    scale_y_continuous(sec.axis = sec_axis(~., name = "Base model (ppt)", limits = c(0, max(df$HONO_pss*1e3)))) +
    geom_point(aes(y = HONO_pss * 1e3), color = "blue") +
    geom_line(aes(y = HONO_pss * 1e3), color = "blue") +
    # Axis labels and theme
    labs(x = "Hour", y = "Added chemistry (ppt)") +
    theme_classic() +
    # Add legend
    scale_color_manual(values = c("black", "blue"),
                       labels = c("HONO_model", "HONO_pss"),
                       name = "HONO",
                       guide = guide_legend(override.aes = list(linetype = c(1, 1),
                                                                shape = c(16, 16))))
  return(plot)
}





