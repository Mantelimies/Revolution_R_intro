list.files()
rxOptions(reportProgress = 0)
airline = "AirOnTime7Pct.xdf"
rxGetInfo(data = airline, getVarInfo = T, varsToKeep = c("Arrdelay", "DepDelay", "Distance")
