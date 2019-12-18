
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
      menuItem("Carte", tabName = "carte", icon = icon("map")),
      menuItem("Graphique", tabName = "graphique", icon = icon("bar-chart-o")),
      menuItem("GraphiquePlotly", tabName = "graphiquePlotly", icon = icon("bar-chart-o")),
      menuItem("Wiki raisin", icon = icon("fab fa-wikipedia-w"), 
                href = "https://fr.wikipedia.org/wiki/Raisin")
    )
  ),
  
  
  ### Contenu de la page de droite
  dashboardBody(
    # Contenu des onglets
    tabItems(
      # Contenu de l'onglet Carte
      tabItem(
        tabName = "carte", 
        source("source/carte_ui.R", local=TRUE,encoding="UTF-8")$value),
      # Contenu de l'onglet graphique
      tabItem(
        tabName = "graphique",
        source("source/testcarto_ui.R", local=TRUE,encoding="UTF-8")$value),
      # Contenu de l'onglet graphique avec plotly
      tabItem(
        tabName = "graphiquePlotly",
        source("source/graphique_ui.R", local=TRUE,encoding="UTF-8")$value)
      )
    )
  )
