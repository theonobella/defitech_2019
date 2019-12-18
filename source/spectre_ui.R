sidebarLayout(
  sidebarPanel(
    selectInput(inputId = "idSelect_fruit", 
                label = "Pomme ou raisin ? ", 
                choices = c("pommes", "raisins"), 
                selected = 1
                ),
    
    selectInput(inputId = "idSelect_date_spectre", 
                label = "Choisir une date de mesure : ", 
                choices = Donnees_pomme$Date,
                selected = 1
    )
  ),
  mainPanel(
    plotlyOutput("plot_spectre")
  )
  
)