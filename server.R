
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Common variables, libraries etcs
source("Common_Sense.R", local=TRUE)


shinyServer(function(input, output) {


  output$distPlot <- renderPlot({
    
    if (input$log == TRUE){
      ggplot(data = flights.DT, aes_string(x = input$feat))+
        scale_x_log10()+
        geom_histogram(bins = input$bins)} 
    else {
      ggplot(data = flights.DT, aes_string(x = input$feat))+
      geom_histogram(bins = input$bins)}

  })
  
  output$ddlist <- renderDataTable({
    
    #validate(
      #need(input$dates[2]<=input$dates[1], "Uhmm, something is wrong with the dates. Check dates, please!")
    #)
    flights.DT[date>=as.Date(input$dates[1], origin = "1970-01-01")&date<=as.Date(input$dates[2], origin = "1970-01-01")&distance<=input$dist, 
               .(date, distance, carrier, tailnum, flight, origin, dest)]
  }, options = list(lengthMenu = list(c(10, 100, 1000, -1), list("10", "100", "1000", "All")), pageLength = 10)
  )
 
  
  output$sumstat <- renderTable({
    
    summary(flights.DT)
  }) 
  
  output$nas <- renderDataTable({
    DT.NA <- data.table("Feature" = character(), "NrNAs" = integer())
    for (i in 1:length(names(flights.DT))){
      DT.NA <- rbind(DT.NA, list(names(flights.DT)[i],flights.DT[is.na(get(names(flights.DT)[i]))==TRUE, .N]))
    }
    
    #renderTable({
    #DT.NA <- data.frame("Feature" = character(), "NrNAs" = integer())
    #setDF(flights.DT)
    #for (i in 1:length(names(flights.DT))){
    #  DT.NA <- rbind(DT.NA, c(names(flights.DT)[i],sum(is.na(flights.DT[i]))))
    #  cat(paste(names(flights.DT)[i], " ", i, ","))
    #}
   
    colnames(DT.NA) <- c("Features", "Nr of NAs")
    DT.NA
  }, options = list(lengthMenu = list(c(5, 10, 20, -1), list("5", "10", "20", "All")), pageLength = 10)
  ) 
  
  
  
})
