TUV_core = function(wStart = 280,
                    wStop = 420,
                    wIntervals = 140,
                    inputMode = 0,
                    latitude = 0,
                    longitude = 0,
                    date = 20220725,
                    timeStamp = "12:00:00",
                    zenith = 0,
                    ozone = 300,
                    albedo = 0.1,
                    gAltitude = 0,
                    mAltitude = 0,
                    taucld = 0.00,
                    zbase = 4.00,
                    ztop = 5.00,
                    tauaer = 0.235,
                    ssaaer = 0.990,
                    alpha = 1.000,
                    time = 12,
                    outputMode = 2,
                    nStreams = -2,
                    dirsun = 1.0,
                    difdn = 1.0,
                    difup = NA){
  if(is.na(difup) & (outputMode == 2 | outputMode == 4)){
    difup = 1.0
  }else if(is.na(difup) & (outputMode == 3 | outputMode == 5)){
    difup = 0.0
  }
  url <- paste0(c("https://www.acom.ucar.edu/cgi-bin/acom/TUV/V5.3/tuv?wStart=", wStart, "&wStop=", wStop, "&wIntervals=", wIntervals, "&inputMode=", inputMode, "&latitude=", latitude, "&longitude=", longitude, "&date=", date, "&timeStamp=", timeStamp,  "&zenith=", zenith, "&ozone=", ozone, "&albedo=", albedo, "&gAltitude=", gAltitude, "&mAltitude=", mAltitude, "&taucld=", taucld, "&zbase=", zbase, "&ztop=", ztop, "&tauaer=", tauaer, "&ssaaer=", ssaaer, "&alpha=", alpha, "&time=", time, "&outputMode=", outputMode, "&nStreams=", nStreams, "&dirsun=", dirsun, "&difdn=", difdn, "&difup=", difup), collapse='')
  download.file(url, "file.txt", quiet = TRUE)
  filetext = read.delim("file.txt")
  if(outputMode == 2){
    # PHOTOLYSIS RATES (1/sec)
    strow = which(grepl("PHOTOLYSIS RATES", filetext[,1]))+1
    edrow = nrow(filetext)
    photolysis_rates = filetext[strow:edrow,]
    phlydf = data.frame(do.call(rbind, strsplit(photolysis_rates, ' (?=[^ ]+$)', perl=TRUE)))
    phlydf = phlydf[complete.cases(phlydf),]
    phlydf_value = data.frame(t(phlydf[,2]))
    names(phlydf_value) = phlydf[,1]
    return(phlydf_value)
  }else if(outputMode == 3){
    # WEIGHTED IRRADIANCES (W m-2)
    strow = which(grepl("with normalized action spectra", filetext[,1]))+1
    edrow = nrow(filetext)
    weighted_irradiances = filetext[strow:edrow,]
    weirdf = do.call(rbind.data.frame,strsplit(weighted_irradiances, "\\s{2,}"))
    weirdf_value = data.frame(t(weirdf[,3]))
    names(weirdf_value) = weirdf[,2]
    return(weirdf_value)
  }else if(outputMode == 4){
    # ACTINIC FLUX (# photons/sec/nm/cm2)
    strow=which(grepl("LOWER WVL  UPPER WVL  DIRECT", filetext[,1]))+1
    edrow=nrow(filetext)
    actinic_flux = filetext[strow:edrow,]
    acfldf_value = do.call(rbind.data.frame,strsplit(actinic_flux, "\\s{2,}"))
    names(acfldf_value) = unlist(strsplit(filetext[strow-1,], "\\s{2,}"))
    return(acfldf_value)
  }else if(outputMode == 5){
    # SPECTRAL IRRADIANCE (W m-2 nm-1)
    strow = which(grepl("LOWER WVL  UPPER WVL  DIRECT", filetext[,1]))+1
    edrow = nrow(filetext)
    spectral_irradiance = filetext[strow:edrow,]
    spirdf_value=do.call(rbind.data.frame,strsplit(spectral_irradiance, "\\s{2,}"))
    names(spirdf_value) = unlist(strsplit(filetext[strow-1,], "\\s{2,}"))
    return(spirdf_value)
  }
}
