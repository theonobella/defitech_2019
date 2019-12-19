
# Generate select input
output$specInputDate <- renderUI({
  #browser()
  dta <- Donnees()
  selectInput(inputId = "idSelect_date_spec",
              label = "Choisir une date : ",
              selected = 1,
              choices = Donnees()$Date)
})


output$plot_spectre <- renderPlotly({
  
  #browser()
  
  # dta_s <- Donnees()
  # dta_s$Date=as.Date(dta_s$Date,format="%d/%m/%Y")
  # dta_s

  
  Donneesspec_a_afficher = subset(
    Donnees(),
    Date == input$idSelect_date_spec
  )
  
  
  
  #data_spectre=aggregate(dta, by=list(Point_mesure = dta$Point_mesure, Variete=dta$Variete), FUN=mean)
  #data_spectre=aggregate(dta, by = list(Point_mesure = dta$Point_mesure), FUN=mean)
  #data_spectre=aggregate(dta, by=list(Variete=dta$Variete), FUN=mean)
  data_spectre=aggregate(Donneesspec_a_afficher, by = list(Point_mesure = Donneesspec_a_afficher$Point_mesure), FUN=mean)
  #stringAsFactors=FALSE
  #dta <- data_spectre
  
  newDta <- pivot_longer(data_spectre, cols = 8:25, names_to = "waveLength")
  #dim(dta)
  #dim(newDta)
  
  newDta$waveLength <- as.numeric(gsub("\\D","", newDta$waveLength))
  
  library("RColorBrewer")
  #browser()
  plot_ly(data = newDta,
          type = "scatter",
          mode ="markers + lines",
          x = ~waveLength,
          y = ~value,
          name = ~Point_mesure,
          color = ~as.character(Point_mesure),
          colors = brewer.pal(n = 28, name = 'YlGnBu')
          )
})
  
