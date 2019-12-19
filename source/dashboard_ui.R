
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
      menuItem("Carte", tabName = "carte", icon = icon("map"), startExpanded = TRUE),
      menuItem("Graphiques", tabName = "graphique", icon = icon("bar-chart-o"),
               menuSubItem("Spectres", tabName = "spectres", icon = icon("chart-area")),
               menuSubItem("Indicateurs", tabName = "indicateurs", icon = icon("chart-line"))
               ),
      menuItem("Wiki", tabName="wiki", icon = icon("fab fa-wikipedia-w")
               ),
      radioGroupButtons(
        inputId = "id_select_espece",
        choices = c("Raisin", "Pomme"),
        justified = TRUE
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
      
      # Contenu du sous onglet "spectre" dans l'onglet "Carte"
      tabItem(
        tabName = "spectres",
        source("source/spectre_ui.R", local=TRUE,encoding="UTF-8")$value
        ),
      
      # Contenu de l'onglet Wiki
      tabItem(
        tabName = "wiki",
        source("source/wiki_ui.R", local=TRUE,encoding="UTF-8")$value
      )#,
      
      #   # Contenu du sous onglet "vignoble" dans l'onglet "Carte"
      # tabItem(
      #   tabName = "vignoble",
      #   source("source/carte_vignoble_ui.R", local=TRUE, encoding="UTF-8")$value
      #   ),
      # 
      # # Contenu de l'onglet graphique
      # tabItem(
      #   tabName = "graphique",
      #   source("source/testcarto_ui.R", local=TRUE,encoding="UTF-8")$value
      #   ),
      # # Contenu de l'onglet graphique avec plotly
      # tabItem(
      #   tabName = "graphiquePlotly",
      #   source("source/graphique_ui.R", local=TRUE,encoding="UTF-8")$value
      #   )
      )
    )
  )
