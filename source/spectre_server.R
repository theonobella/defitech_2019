output$plot_spectre <- renderPlotly({
  
  x <- colnames(Donnees_pomme[8:23])
  
  
   Donnees_pomme_sub = subset(
     Donnees_pomme,
     Date = input$idSelect_date_spectre,
     select = c(Point_mesure, Donnees_pomme[8:23]))
   Donnees_pomme_sub
  
  data_spectre=aggregate(Donnees_pomme_sub, by=list(Donnees_pomme_sub$Point_mesure), FUN=mean)
  
  plot_ly(data_spectre, x=~x, y=~input$idSelect_date_spectre)
  
})
  