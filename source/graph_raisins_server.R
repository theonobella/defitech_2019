output$plot <- renderPlotly({
  
  #
  lignes -> date>dateDebut & date<dateFin & parcelle == input$idCheckParcelles & variete==input$idCheckVarietes
  colonnes -> input$idSelectIndGR
  
  #Graphique
  plot_ly(data, x=~Date, y=~input$idSelect_indicateur)
  
})
