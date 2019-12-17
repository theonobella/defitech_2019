

# Représentation de l'onde 410nm pour tous les capteurs
# pal <- colorNumeric(palette = "Reds",domain = Donnees_a_afficher[input$idSelect_indicateur])
# 
# m <- 
# 
# m

output$map_indic <- renderLeaflet({
  
  # browser()
  
  # extraction des données
  # Donnees_a_afficher <- Donnees_a_afficher[Donnees$Date == input$idSelect_date, c('ID', 'CoordX','CoordY', input$idSelect_indicateur) ]
  
  
  Donnees_a_afficher = subset(
    Donnees,
    Date == input$idSelect_date,
    select = c('ID', 'CoordX','CoordY', input$idSelect_indicateur))
  
  
  
  # calcul de la carte
  pal <- colorNumeric(palette = "Reds",
                      domain = Donnees[,input$idSelect_indicateur])
  
  leaflet(Donnees_a_afficher) %>%
  addTiles() %>%
  addCircleMarkers(~CoordX, ~CoordY, popup = ~as.character(Donnees_a_afficher[,input$idSelect_indicateur]), label = ~as.character(Donnees_a_afficher[,input$idSelect_indicateur]),
                   #radius = ~ifelse(type == "ship", 6, 10),
                   color = ~pal(Donnees_a_afficher[,input$idSelect_indicateur]),
                   stroke = FALSE, fillOpacity = 0.5
  )
  
})