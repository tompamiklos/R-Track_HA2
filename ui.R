
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(data.table)
library(nycflights13)
library(ggplot2)

flights.DT <- data.table(flights)
flights.DT[,c("yearLog", "monthLog", "dayLog", "dep_timeLog", "arr_timeLog", "air_timeLog", "distanceLog", "hourLog", "minuteLog"):=.(log(year), log(month), log(day), log(dep_time), log(arr_time), log(air_time), log(distance), log(hour), log(minute))]
flights.DT[,date := paste(year,"-", month, "-", day, sep = "")]
options(stringsAsFactors = FALSE)

shinyUI(fluidPage(

  
  titlePanel("Eploratory analysis - nycflights13"),

  sidebarLayout(
    sidebarPanel(
      titlePanel("Date&Distance filter"),
      selectInput("dateS", "Pick a start date", selected = "2013-1-1", 
                  choices = c(unique(flights.DT$date))),
      selectInput("dateF", "Pick a finish date", selected = "2013-1-1", 
                  choices = c(unique(flights.DT$date))),
      sliderInput("dist",
                  "Maximum distance:",
                  min = 1,
                  max = max(flights$distance),
                  value = 1),
      titlePanel("Histograms"),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 21,
                  value = 7),
      selectInput("feat", "Pick feature for histogram:", selected = "distance", 
                  choices = c( "year", "month", "day", "dep_time", "dep_delay", "arr_time",  "arr_delay", "air_time", "distance", "hour", "minute")),
      checkboxInput("log", "Logs needed", value = FALSE)

    ),
   

    mainPanel(
      tabsetPanel(
        tabPanel("Statistics",tableOutput("sumstat")),
        tabPanel("Distance&Date",tableOutput("ddlist")),
        tabPanel("Histograms",plotOutput("distPlot")),
        tabPanel("Nr of NAs",tableOutput("nas"))
      )
    )
  )
))


