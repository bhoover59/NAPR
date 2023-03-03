# Maybe nested to loop over dates and hours
dates <- c(20220728, 20220729, 20220730) # list of dates
hours <- 1:24 # list of 24 hours
TUV <- list()
for (date in dates) {
  for (hour in hours) {
    TUV[[paste0(date, "_", hour)]] <- TUV_core(latitude = 45.568100, longitude = -84.682869, gAltitude = 0.2667, mAltitude = 0.26715, date = date, time = hour)
  }
}

JNO2 <- data.frame(matrix(ncol = length(hours), nrow = length(dates)))
colnames(JNO2) <- hours
rownames(JNO2) <- dates
JHONO <- data.frame(matrix(ncol = length(hours), nrow = length(dates)))
colnames(JHONO) <- hours
rownames(JHONO) <- dates

for (date in dates) {
  for (hour in hours) {
    JNO2[date, hour] <- TUV[[paste0(date, "_", hour)]][[6]]
    JHONO[date, hour] <- TUV[[paste0(date, "_", hour)]][[12]]
  }
}

photolysis <- cbind(data.frame(JNO2), data.frame(JHONO))
photolysis$Hour <- rep(hours, length(dates))
photolysis$Date <- rep(dates, each = length(hours))
