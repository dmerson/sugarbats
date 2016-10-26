setwd("C:/Repos/sugarbats/Weatherfiles") #set your path here to get data file
getwd()
data <- read.csv("20160808.csv", header=TRUE, sep=",")
head(data)
