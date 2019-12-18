output$plot <- renderPlotly({
  

  selectedLines <- Donnees$Date >= input$idSelect_daterange[1] & Donnees$Date <= input$idSelect_daterange[2]
  selectedCols <-  c("Date", input$idSelect_indicateurgraph)
  Donnees_a_grapher <- Donnees[selectedLines, selectedCols]
 
  data=aggregate( Donnees_a_grapher, by=list(Donnees_a_grapher$Date), FUN=mean)
  
  # build graph with ggplot syntax
  p <- ggplot(data, aes_string(x = data$Date, y = input$idSelect_indicateurgraph)) + 
    geom_point()
  ggplotly(p) 

})


