
output$plot <- renderPlotly({
  
    Donnees_a_grapher = subset(
    Donnees,
    Date >= input$idSelect_daterange[1] && Date <= input$idSelect_daterange[2],
    select = c(Date, NDVI))
  Donnees_a_grapher
 
  data=aggregate( Donnees_a_grapher, by=list(Donnees_a_grapher$Date), FUN=mean)
  
  plot_ly(data, x=~Date, y=~input$idSelect_indicateur)

})


