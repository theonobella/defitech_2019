sidebarLayout(
  sidebarPanel(


selectInput(inputId = "idSelect_indicateur", 
            label = "Select among the list: ", 
            choices = names(Donnees[5:ncol(Donnees)])),

selectInput(inputId = "idSelect_date", 
            label = "Select among the list: ", 
            choices = Donnees$Date,
            selected = 1
            )

  ),
  mainPanel(
    leafletOutput("map_indic")
  )

)