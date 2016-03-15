
# This is the server logic for a Shiny web application.
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

shinyServer(function(input, output) {


  output$distPlot <- renderPlot({
    
    if (input$log == TRUE){
    feat = paste(input$feat,"Log", sep = "")} else {feat=input$feat}
    validate(
      need(sum(names(flights.DT) == feat)!=0, "Sorry, no log() data for this feature!")
    )
    ggplot(data = flights.DT, aes_string(x = feat))+
      geom_histogram(bins = input$bins)

  })
  
  output$ddlist <- renderTable({
    
    validate(
      need(input$dateS<=input$dateF, "Uhmm, something is wrong with the dates. Check dates, please!")
    )
    head(flights.DT[date>=as.Date(input$dateS)&date<=as.Date(input$dateF)&distance<=input$dist, .(date, distance, carrier, tailnum, flight, origin, dest)],5)
    ### Sorry, I had to use head(...,5), because otherwise it took ages to run this code
  })
 
  
  output$sumstat <- renderTable({
    
    summary(flights.DT)
  }) 
  
  output$nas <- renderTable({
    DT.NA <- data.frame("Feature" = character(), "NrNAs" = integer())
    #setDT(DT.NA)
    setDF(flights.DT)
    for (i in 1:length(names(flights.DT))){
      DT.NA <- rbind(DT.NA, c(names(flights.DT)[i],sum(is.na(flights.DT[i]))))
      cat(paste(names(flights.DT)[i], " ", i, ","))
    }
   
    colnames(DT.NA) <- c("Features", "Nr of NAs")
    setDT(flights.DT)
    DT.NA
  
  }) 
  
  
  
})
