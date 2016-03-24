### LECTURE 1 ## 

list.files()
rxOptions(reportProgress = 0)
airline = "AirOnTime2012.xdf"
rxGetInfo(data = airline, getVarInfo = T, varsToKeep = c("AirTime", "ArrDelay", "DepDelay", "Distance"))
rxSummary(~ AirTime + ArrDelay + DepDelay + Distance, data = airline)
rxHistogram(~DepDelay, data = airline, xAxisMinMax = c(-50, 300)) 
newAirlineXdf = file.path(getwd(), "airSpeeds.xdf")
system.time(rxDataStep(inData = airline, outFile = newAirlineXdf, varsToKeep=c("AirTime", "Distance", "DepDelay", "ArrDelay"), 
			transforms = list(airSpeed = Distance / AirTime), overwrite = T))
		
rxGetInfo(data = newAirlineXdf, getVarInfo = T)
rxSummary(~airSpeed, data = newAirlineXdf)
rxHistogram(~airSpeed, data = newAirlineXdf)
rxDataStep(inData = newAirlineXdf, outFile = newAirlineXdf, varsToKeep=c("airSpeed"),
	transforms = list(airSpeed = airSpeed*60), overwrite = T)
rxHistogram(~airSpeed, data = newAirlineXdf)
rxCor(formula = ~DepDelay + ArrDelay + airSpeed, data  = newAirlineXdf)
rxCor(formula = ~DepDelay + ArrDelay + airSpeed, data  = newAirlineXdf, rowSelection = (airSpeed > 50) & (airSpeed <800))
reg1 <- rxLinMod(formula = airSpeed ~ DepDelay, data = newAirlineXdf, rowSelection = (airSpeed >50) & (airSpeed < 800))
class(reg1)
 

#discretizing delays
rxDataStep(inData = newAirlineXdf, outFile = newAirlineXdf, varsToKeep = "DepDelay", 
        transformVars = "DepDelay", transforms = list(F_DepDelay=cut(DepDelay, breaks = seq(from = -10, to=100, by=10))), append = "cols", overwrite = TRUE)
print(rxSummary(~F_DepDelay, data = newAirlineXdf), header = T)

rxGetInfo(data = newAirlineXdf, getVarInfo = T)

#linMod for categorical variables
reg2 <- rxLinMod(formula = airSpeed ~ F_DepDelay, data = newAirlineXdf, dropFirst = T)
print(summary(reg2), header = FALSE)
