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
    "output_csv.R",
    "TUV_core.R",
    "load_packages.R",
    "TUV_hourly.R",
    "shift_column.R",
    "get_HONO_soil_uptake.R",
    "plot_HONO_grid.R",
    "calculate_dHONOdt.R",
    "stack_rates.R",
    "percent_contribution.R",
    "plot_correlation.R"
  )
  path <- getwd()
  for (file_name in file_list) {
    file <- paste(path, '/R/', file_name, sep = "")
    source(file)
  }
}

