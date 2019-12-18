output$plot_spectre <- renderPlotly({
  
  #browser()
  
  #data_spectre=aggregate(Donnees_pomme, by=list(Point_mesure = Donnees_pomme$Point_mesure, Variete=Donnees_pomme$Variete), FUN=mean)
  # data_spectre=aggregate(Donnees_pomme, by=list(Point_mesure = Donnees_pomme$Variete, Variete=Donnees_pomme$Point_mesure), FUN=mean)
  data_spectre=aggregate(Donnees_pomme, by=list(Variete=Donnees_pomme$Variete), FUN=mean)
  
  
  library(tidyverse)
  dta <- data_spectre
  
  newDta <- pivot_longer(dta, cols = 8:25, names_to = "waveLength")
  dim(dta)
  dim(newDta)
  
  newDta$waveLength <- as.numeric(gsub("\\D","", newDta$waveLength))
  
  plot_ly(data = newDta,
          type = "scatter",
          mode ="markers + lines",
          x = ~waveLength,
          y = ~value,
          name = ~Variete)
})
  