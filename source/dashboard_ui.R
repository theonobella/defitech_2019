
### Création du Dashboard

dashboardPage(
  skin = "red", # Couleur du dashbord
  ### Titre du dashboard
  dashboardHeader(title = "Défi technique"),
  
  
  ### Contenu de la barre laterale
  dashboardSidebar(
    # Creation d'onglets (on pourrait aussi mettre zone de recherche ou autre, voir aide)
    sidebarMenu(
      id="sidebar",
      # pour les icones voir http://fontawesome.io/icons/
      menuItem(" ", tabName = "carte", icon = icon("map"), startExpanded = TRUE),
      menuItem(" ", tabName = "graphique", icon = icon("bar-chart-o"),
               menuSubItem("Spectres", tabName = "spectres", icon = icon("chart-area")),
               menuSubItem("Indicateurs", tabName = "indicateurs", icon = icon("chart-scatter"))
               ),
      menuItem("Wiki raisin", icon = icon("fab fa-wikipedia-w"), 
                href = "https://fr.wikipedia.org/wiki/Raisin"
               ),
      selectInput(
        inputId = "id_select_espece",
        label = "Selectionner l'espèce",
        choices = c("Raisin", "Pomme"),
        multiple = FALSE
        )
    )
  ),
  
  
  ### Contenu de la page de droite
  dashboardBody(
    # Contenu des onglets
    tabItems(
      
      # Contenu de l'onglet Carte
      tabItem(
        tabName = "carte",
        source("source/carte_ui.R", local=TRUE,encoding="UTF-8")$value
        ),
        # Contenu du sous onglet "vignoble" dans l'onglet "Carte"
      tabItem(
        tabName = "vignoble",
        source("source/carte_vignoble_ui.R", local=TRUE, encoding="UTF-8")$value
        ),
      
      # Contenu de l'onglet graphique
      tabItem(
        tabName = "graphique",
        source("source/testcarto_ui.R", local=TRUE,encoding="UTF-8")$value
        ),
      # Contenu de l'onglet graphique avec plotly
      tabItem(
        tabName = "graphiquePlotly",
        source("source/graphique_ui.R", local=TRUE,encoding="UTF-8")$value
        )
      )
    )
  )
