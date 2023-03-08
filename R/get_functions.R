get_functions <- function() {
  file_list <- c(
    "check_input.R",
    "convert_to_mixing_ratio.R",
    "convert_to_percc.R",
    "get_initial.R",
    "get_input_file.R",
    "get_kinetics.R",
    "get_met.R",
    "get_rain_days.R",
    "loss_mechanisms.R",
    "plot_HONO.R",
    "production_mechanisms.R",
    "report_summary.R",
    "run_model.R",
    "plot_rates.R",
    "get_J_values.R",
    "convert_to_numeric.R",
    "plot_stacked_rates.R",
    "output_csv.R",
    "plot_all_stacked_rates.R",
    "TUV_core.R",
    "load_packages.R",
    "TUV_hourly.R",
    "plot_all_stacked_rates_test.R",
    "plot_species.R",
    "shift_column.R"
  )
  path <- getwd()
  for (file_name in file_list) {
    file <- paste(path, '/R/', file_name, sep = "")
    source(file)
  }
}
