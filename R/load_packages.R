load_packages <- function(libraries) {
  libraries <- c("ggplot2", "diurnals", "psych", "dplyr", "plotly", "cowplot", "patchwork", "tidyr", "devtools")
  # Description of required libraries ------------------------------------------
  # Check https://github.com/bhoover59/diurnals for more information about diurnals package
  # diurnals: allows diurnal averaging and time averaging
  # psych: correct describe function to return data frame
  # library(magrittr): allows %>% operator
  # dplyr: remove duplicated columns
  # plotly: allows interactive ggplot
  # cowplot: allows overlay of plots
  # patchwork: allows fun plot layouts
  # tidyr: allows pivot
  # devtools: enable install of diurnals

  # Load libraries -------------------------------------------------------------
  for (library_name in libraries) {
    # diurnals package on Github not CRAN
    if (library_name == "diurnals") {
      if (!require(library_name, character.only = TRUE)) {
        devtools::install_github("bhoover59/diurnals")
        library(library_name, character.only = TRUE)
      }
    } else {
      if (!require(library_name, character.only = TRUE)) {
        install.packages(library_name, dependencies = TRUE)
        library(library_name, character.only = TRUE)
      }
    }
  }
}
