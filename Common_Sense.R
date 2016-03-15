
library(shiny)
library(data.table)
library(nycflights13)
library(ggplot2)

flights.DT <- data.table(flights)
flights.DT[,c("yearLog", "monthLog", "dayLog", "dep_timeLog", "arr_timeLog", "air_timeLog", "distanceLog", "hourLog", "minuteLog"):=.(log(year), log(month), log(day), log(dep_time), log(arr_time), log(air_time), log(distance), log(hour), log(minute))]
flights.DT[,date := paste(year,"-", month, "-", day, sep = "")]
options(stringsAsFactors = FALSE)


