sidebarLayout(
  sidebarPanel(

    selectInput(inputId = "idSelect_indicateur",
                label = "Choisir l'indicateur : ",
                choices = c("Couleur", "Fermete")
                ),

    selectInput(inputId = "idSelect_date",
                label = "Choisir la date: ",
                choices = donnees_vignoble$Date,
                selected = 1
                )
    ),

  mainPanel(
    leafletOutput("map_indic_vignoble")

  )

)