setwd("C:/Repos/sugarbats/Weatherfiles") #set your path here to get data file
getwd()
file.names <- dir(getwd(), pattern =".csv")
for(i in 1:length(file.names)){
  file.newName= gsub(".csv","",file.names[i])
  data <- read.csv(file.names[i], header=TRUE, sep=",")
  cleanData <-data
  cleanData$Temperature=as.numeric(gsub(" °F","",cleanData$Temperature))
  cleanData$Dew.Point=as.numeric(gsub(" °F","",cleanData$Dew.Point))
  cleanData$Humidity=as.numeric(gsub("%","",cleanData$Humidity))
  cleanData$Speed=as.numeric(gsub(" mph","",cleanData$Speed))
  cleanData$Gust=as.numeric(gsub(" mph","",cleanData$Gust))
  cleanData$Pressure=as.numeric(gsub(" in","",cleanData$Pressure))
  cleanData$Precip..Accum.=as.numeric(gsub(" in","",cleanData$Precip..Accum.))
  cleanData$Precip..Rate.=as.numeric(gsub(" in","",cleanData$Precip..Rate.))
  cleanData$Solar=as.numeric(gsub(" w/m²","",cleanData$Solar))
  file.newFile=paste(getwd(),"/",file.newName,".nounits.csv",sep="")
  write.csv(cleanData,file.newFile)
}

dateTest=as.Date(gsub(".csv","","20160808.csv"), format = "%y%M%d")
