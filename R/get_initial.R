get_initial <- function(){
  # Initialize data frame
  initial <- data.frame(matrix(NA, nrow = 1, ncol = 1))

  # Aerosols
  initial$gamma_NO2_aerosol <- 1.4e-4 # Liu 2019, Xue 2022a from Song 2022, Song 2022
  initial$S_aerosol <- 1e-4 # surface area of aerosols, m2/m3
  initial$R <- 0.0820574 # L atm/ mol K
  initial$Mass_NO2 <- 46.0055 # g/mol
  initial$Mass_HONO <- 47.013 # g/mol
  initial$Mass_nitrate <- 62.0049 # g/mol
  initial$M <- 2.46e19

  # HONO Deposition
  initial$v_HONO <- 2 / 100 # cm/s converted to m/s
  initial$H <- 200 # boundary layer height (m)
  initial$gamma_HONO_ground <- 7.3e-5
  initial$noon_JNO2 <- 1e-5

  # NO2 Deposition
  # https://pubs.acs.org/doi/full/10.1021/acs.est.8b06367, Liu 2019
  initial$v_NO2 <- 2 / 100 # cm/s converted to 2 m/s
  # CHECK SONG 2022 SUPPLEMENT FOR EQUATIONS AND PARAMETERS

  # Ground surface
  # Dark conversion/deposition
  initial$gamma_NO2_ground <-  8e-6  # Liu 2019
  # Photo enhanced NO2 conversion

  # HNO3 Deposition
  initial$v_HNO3 <- 2 / 100 # cm/s converted to 2 m/s
  initial$J_HNO3 <- 2 / 100 # cm/s converted to 2 m/s

  # Vehicle emissions
  initial$HONO_NOx <- 1e-3

  # Soil type & emissions
  # ECM: no soil emissions
  # AM: soil emissions
  # you can edit production_mechanisms to change how soil emissions are handled
  # Right now it is just turn on or off default
  initial$soil_type <- 'AM'
  initial$F_soil_HONO <- 5 # ng/m2 s flux emission of HONO estimate

  # Delete first column used to initialize
  initial <- initial[,-1]

  return(initial)
}
