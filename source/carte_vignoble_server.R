
output$map_indic_vignoble <- renderLeaflet({
  
  # Pour débugger code, décommenter ligne dessous
  # browser()

  # Selection des donnees en fonction de ce qui est choisi dans l'interface
  donnees_a_afficher = subset(
    donnees_vignoble,
    date = input$idSelect_date,
    select = c('ID', 'CoordX', 'CoordY', input$idSelect_indicateur)
  )


  # Génération d'une palette de couleurs
  pal <- colorNumeric(palette = "Reds",
                      domain = donnees_vignoble[, input$idSelect_indicateur])

  # Création de la carte
  leaflet(donnees_a_afficher) %>%
    addTiles() %>%
    addLegend(
      title = input$idSelect_indicateur,
      values = donnees_vignoble[, input$idSelect_indicateur],
      pal = pal,
      opacity = 0.9,
      position = "bottomright"
    ) %>%
    addCircleMarkers(
      ~ CoordX,
      ~ CoordY,
      popup = ~ as.character(donnees_a_afficher[, input$idSelect_indicateur]),
      label = ~ as.character(donnees_a_afficher[, input$idSelect_indicateur]),
      #radius = ~ifelse(type == "ship", 6, 10),
      color = ~ pal(donnees_a_afficher[, input$idSelect_indicateur]),
      stroke = FALSE,
      fillOpacity = 0.5
    )

})