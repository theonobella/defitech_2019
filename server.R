#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  Donnees <- reactive({
    # Donnees est une fonction, pour apeller : Donnees()
    # importation des donnees
    # browser()
    
    if (input$id_select_espece == "Raisin"){
      Donnees = donnees_raisin
    }
    else{
      Donnees = donnees_pomme
    }
    Donnees$Date=as.Date.character(Donnees$Date,format="%d/%m/%Y")
    Donnees
  })

    #source("source/testcarto_server.R", local=TRUE,encoding="UTF-8")$value
    # source("source/dashboard_server.R", local=TRUE,encoding="UTF-8")$value
  source("source/carte_server.R", local=TRUE,encoding="UTF-8")$value
  
  source("source/spectre_server.R", local=TRUE,encoding="UTF-8")$value
  # 
  # source("source/testcarto_server.R", local=TRUE,encoding="UTF-8")$value
  # 
  # source("source/graphique_server.R", local=TRUE,encoding="UTF-8")$value
  # 
  # 
  # # Sous-onglet vignoble de l'onglet "Carte"
  # source("source/carte_vignoble_server.R", local=TRUE,encoding="UTF-8")$value
  


})




