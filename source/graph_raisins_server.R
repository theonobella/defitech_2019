  colonnes -> input$idSelectIndGR

# Gnerate selcet input
output$GrRai <- renderUI({
  # browser()
  dta <- Donnees()
  
  #Selection intervalle date
  dateRangeInput(inputId = "idDateIntervalle", 
                 label = "Période d'intérêt :", 
                 start= "01/01/2018",
                 end=as.Date(Sys.Date(),format=("%d/%m/%Y")),
                 format="dd/mm/yyyy",
                 separator="à")
  
  #Selection des différentes catégories dans variete
  categoriesVar <- unique(dta$Variete)
  nbreCategoriesVar <- length(categoriesVar)
  
  #Creation des cases à cocher variete
  checkboxGroupInput(inputId = "idCheckVarietes", label = "Please select", selected = nbreCategoriesVar,
                     choices = categoriesVar)
  
  
  #Selection des différentes catégories dans parcelle
  categoriesPar <- unique(dta$Parcelle)
  nbreCategoriesPar <- length(categoriesPar)
  
  #Creation des cases à cocher parcelle
  checkboxGroupInput(inputId = "idCheckParcelles", label = "Please select", selected = nbreCategoriesPar,
                     choices = categoriesPar)
  
  
  #Selection des différents indicateurs
  selectInput(inputId = "idSelectIndGR", 
              label = "Select among the list: ", 
              choices = c("couleur","fermete"))
  
  #Selection de l'indicateur moyen par date ou de l'indicateur par individu
  selectInput(inputId = "idAffichParDateOuInd", 
              label = "Select among the list: ", 
              choices = c("Indicateur moyen par date",
                          "Indicateur par individu"))
  

})




output$plotRaisins <- renderPlotly({
  
  dta <- Donnees()
  
  # Selection lignes et colonnes
  lignes -> dta$Date >= input$idDateIntervalle[1] & dta$Date <= input$idDateIntervalle[2] 
            & parcelle == input$idCheckParcelles & variete==input$idCheckVarietes
  colonnes -> c("Date",input$idSelectIndGR)
 
  DonneesSelection <- dta[lignes, colonnes] 
  
  if (input$idAffichParDateOuInd =="Indicateur moyen par date") 
  {
    #Moyenne indicateur des lignes selectionnées par date. Faire une fonction if pour faire par indiv (avec input)
    donneesMoyDate=aggregate( DonneesSelection, by=list(DonneesSelection$Date), FUN=mean)
    # build graph with ggplot syntax 
    p <- ggplot(donneesMoyDate, aes_string(x = donneesMoyDate$Date, y = input$idSelectIndGR)) +  
      geom_point() 
    ggplotly(p) 
  }
  
  if (input$idAffichParDateOuInd =="Indicateur par individu")
  { # build graph with ggplot syntax 
    p <- ggplot(DonneesSelection, aes_string(x = DonneesSelection$Date, y = input$idSelectIndGR)) +  
    geom_point() 
    ggplotly(p) 
  }
  
})
