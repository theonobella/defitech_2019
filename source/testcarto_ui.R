fluidRow(
    h2("Carte de ..."), # Titre de la page
    
    # Box contenant la carte
    box(
      title = "Localisation de ...",
      solidHeader = TRUE, status = "primary", # Couleur autour du titre en bleue foncée
      leafletOutput("mymap"),
      actionButton("recalc", "New points"),
      p("Permet de générer de nouveaux points alétoirement sur la carte")
    ),
    
    # Box de description de la carte
    box(
      background = "olive", # fond de la box en vert olive
      width=4,
      height = "500px",
      tabBox(
        title = "Side box", # Titre de la side box
        height = "300px",
        tabPanel("Description",
                 title = "Description", icon = icon("fas fa-tag"),
                  "Hanc regionem praestitutis celebritati diebus invadere parans dux ante edictus per 
                  solitudines Aboraeque amnis herbidas ripas, suorum indicio proditus, qui admissi flagitii 
                  metu exagitati ad praesidia descivere Romana. absque ullo egressus effectu deinde tabescebat 
                  immobilis."
        ),
        tabPanel("Réglage",
                 title = "Réglages", icon = icon("cog"),
                 sliderInput("slider", "Slider input:", 1, 100, 50),
                 textInput("text", "Text input:")
        ),
        selected = "Réglages"
      )
    )
  )

