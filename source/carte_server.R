


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
              selected = TRUE
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


output$mapplotkrigeage <- renderLeaflet({
  krigeage <- function(datacapteur,indicateur){
    mydata <- st_as_sf(datacapteur, coords = c("CoordX", "CoordY"))
    
    crs.wgs84 <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
    CRS.lambert93 <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
    
    st_crs(mydata) <- crs.wgs84
    mydata_lambert <- st_transform(mydata, CRS.lambert93)
    
    chull <- mydata_lambert %>% st_union() %>% st_convex_hull()
    mydata.points <- mydata_lambert %>% st_make_grid(n=100) %>% st_intersection(chull) %>% st_centroid()
    mydata.grid<-mydata_lambert %>% st_make_grid(n=100) %>% st_intersection(chull)
    
    vargram <- variogram(get(indicateur) ~ 1, data = mydata_lambert)
    plot(vargram)
    fit_vargram <- fit.variogram(vargram, vgm(model = "Sph", nugget = 1))#, anis = c(122, 0.6)))
    graph <- plot(vargram, fit_vargram)
    
    NF.kriged = krige(get(indicateur) ~ 1, locations = mydata_lambert,  #using ordinary kriging]
                      newdata = mydata.points, model = fit_vargram, nmax = 20)
    
    list(variogramme = graph, kriged = NF.kriged, data_lambert = mydata_lambert)
  }
  Donnees_a_afficher_date2 = subset(
    Donnees(),
    Date == input$idSelect_date,
    select = c('ID', 'CoordX', 'CoordY', 'Variete', 'Parcelle', input$idSelect_indicateur)
  )
  
  k=krigeage(datacapteur = Donnees_a_afficher_date2,indicateur = input$idSelect_indicateur)
  #plot(k$kriged)
  m<- mapview(k$kriged, zcol="var1.pred",lwd=0,legend=T) 
  m@map
  
})