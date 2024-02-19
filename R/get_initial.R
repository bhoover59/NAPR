get_initial <- function(){
  # Initialize data frame ------------------------------------------------------
  initial <- data.frame(matrix(NA, nrow = 1, ncol = 1))
  # Constants ------------------------------------------------------------------
  initial$R <- 8.314 # J / mol K
  initial$Mass_NO2 <- 46.0055 # g/mol
  initial$Mass_HONO <- 47.013 # g/mol
  initial$Mass_nitrate <- 62.0049 # g/mol
  initial$M <- 2.46e19 # concentration of intermediate air molecules
  initial$HONO <- 20 # ppt HONO initialization
  initial$C6H5NO3_conc <- 1 # ppb

  # HONO uptake option
  initial$HONO_uptake <- 'calculate' # calculate or input

  # Boundary layer height initialization
  initial$BLH_night <- 200 # m, night time boundary layer height, Daytime = 3 * Night
  # Boundary layer rain = 0.5 * BLH dry Che 2021 (https://acp.copernicus.org/articles/21/5253/2021/acp-21-5253-2021.pdf), Li 2011; Zuo 2004

  # HNO3 Deposition
  initial$v_HNO3 <- 2 / 100 # cm/s converted to 2 m/s
  initial$J_HNO3 <- 1e-4
  initial$J_HNO3_enh <- 32.4

  # Vehicle emissions ----------------------------------------------------------
  initial$HONO_NOx <- 0.85 / 100 # 0.85% ratio to estimate influence of anthropogenic emissions

  # Soil Emissions ------------------------------------------------------
  # ECM: no soil emissions
  # AM: soil emissions
  # you can edit production_mechanisms.R to change how soil emissions are handled
  # Right now it is just turn on or off default
  initial$soil_type <- 0 # 'AM' to turn on
  initial$F_soil_HONO <- 5 # ng/m2 s flux emission of HONO estimate
  initial$F_soil_NO <- 1.2 # ng/m2 s flux emission of NO estimate based on average of deciduous forest in Europe (Pilegaard et al 2006)

  # Dilution
  initial$kdil <- 1/86400 # s- lifetime of species in box 1/day

  # Estimate OH
  initial$estimate_OH <- 0 # 1 to estimate OH using NOx and O3 NEED TO USE J10D PHOTOLYSIS , 0 to use measurements

  # Delete first column used to initialize
  initial <- initial[,-1]

  return(initial)
}
