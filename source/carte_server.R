


# Generation des boutons
output$mapInputInd <- renderUI({
  
  # browser()
  data <- Donnees() # Pour éviter l'écriture avec les parenthèses
  radioGroupButtons(inputId = "idSelect_indicateur", 
              label = "Indicateur : ",
              choices = names(data[26:27]),
              selected = "Couleur"
              )
})
output$mapInputDate <- renderUI({
  # browser()
  data <- Donnees()
  selectInput(inputId = "idSelect_date", 
              label = "Date : ",
              choices = data$Date,
              selected = TRUE,
              width = '50%'
              )
})
output$mapInputVariete <- renderUI({
  # browser()
  data <- Donnees()
  radioGroupButtons(inputId = "idSelect_variete",
              label = "Variété : ",
              choices = unique(data$Variete),
              selected = data[1,"Variete"]
  )
})

output$mapInputParcelle <- renderUI({
  # browser()
  data <- Donnees()
  checkboxGroupButtons(inputId = "idSelect_parcelle",
              label = "Parcelle(s) : ",
              choices = unique(data$Parcelle),
              selected = data[1,"Parcelle"],
              checkIcon = list(
                yes = tags$i(class = "fa fa-check-square", 
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-square-o", 
                            style = "color: steelblue"))
  )
})

output$map_indic <- renderLeaflet({
  # browser()
  
  # on sélectionne les lignes correspondant à la date choisie
  Donnees_a_afficher_date = subset(
    Donnees(),
    Date == input$idSelect_date,
    select = c('ID', 'CoordX', 'CoordY', 'Variete', 'Parcelle', input$idSelect_indicateur)
  )
  
  # on sélectionne les lignes correspondant à la variété choisie 
  Donnees_a_afficher_variete = subset(
    Donnees_a_afficher_date,
    Variete == input$idSelect_variete,
    select = c('ID', 'CoordX', 'CoordY','Parcelle', input$idSelect_indicateur)
  )
  
  # on sélectionne les lignes correspondant à la parcelle choisie 
  Donnees_a_afficher = subset(
    Donnees_a_afficher_variete,
    Parcelle %in% input$idSelect_parcelle,
    select = c('ID', 'CoordX', 'CoordY', input$idSelect_indicateur)
  )

  # calcul de la carte
  pal <- colorNumeric(palette = "Reds",
                      domain = Donnees()[, input$idSelect_indicateur])

  leaflet(Donnees_a_afficher) %>%
    addTiles() %>%
    addLegend(
      title = input$idSelect_indicateur,
      values = Donnees()[, input$idSelect_indicateur],
      pal = pal,
      opacity = 0.95,
      position = "bottomright"
    ) %>%
    addCircleMarkers(
      ~ CoordX,
      ~ CoordY,
      popup = ~ as.character(Donnees_a_afficher[, input$idSelect_indicateur]),
      label = ~ as.character(Donnees_a_afficher[, input$idSelect_indicateur]),
      #radius = ~ifelse(type == "ship", 6, 10),
      color = ~ pal(Donnees_a_afficher[, input$idSelect_indicateur]),
      stroke = FALSE,
      fillOpacity = 0.5
    )

})