plot_loss <- function(df_model){
df_model$loss <- df_model$L_photo +
  df_model$L_OH +
  df_model$L_uptake_ground +
  df_model$L_aerosol +
  df_model$L_ground_light +
  df_model$L_aerosol_light +
  df_model$L_self +
  df_model$L_O3

# Plot each component along with the total loss
matplot(df_model[, c("L_photo", "L_OH", "L_uptake_ground",
                     "L_aerosol", "L_ground_light", "L_aerosol_light",
                     "L_self", "L_O3", "loss")],
        type = 'l', col = c("red", "green", "blue", "purple",
                            "orange", "brown", "pink", "gray", "black"),
        lwd = 2, xlab = 'Observation Index', ylab = 'Contribution to Loss')

# Add legend
legend("topright", legend = c("L_photo", "L_OH", "L_uptake_ground",
                              "L_aerosol", "L_ground_light", "L_aerosol_light",
                              "L_self", "L_O3", "Loss"),
       col = c("red", "green", "blue", "purple", "orange", "brown", "pink", "gray", "black"),
       lty = 1, cex = 0.8)
}
