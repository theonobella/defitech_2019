
output$hist <- renderPlot({
  
  
  Donnees_a_afficher = subset(
    Donnees,
    DateDebut == input$idSelect_daterange[0],
    DateFin=input$idSelect_daterange[1],
    select = c('ID', 'CoordX','CoordY', input$idSelect_indicateur))
  
  
  
  # calcul de la carte
  pal <- colorNumeric(palette = "Reds",
                      domain = Donnees_a_afficher[,input$idSelect_indicateur])
  
  leaflet(Donnees_a_afficher) %>%
    addTiles() %>%
    addCircleMarkers(~CoordX, ~CoordY, popup = ~as.character(ID), label = ~as.character(ID),
                     #radius = ~ifelse(type == "ship", 6, 10),
                     color = ~pal(Donnees_a_afficher[,input$idSelect_indicateur]),
                     stroke = FALSE, fillOpacity = 0.5
    )
  
})