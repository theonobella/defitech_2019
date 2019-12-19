

# Gnerate selcet input
output$GrRai <- renderUI({
  dta <- Donnees()
  
  
  #Selection des différentes catégories dans variete
  categoriesVar <- unique(dta$Variete)
  nbreCategoriesVar <- length(categoriesVar)
  
  #Selection des différentes catégories dans parcelle
  categoriesPar <- unique(dta$Parcelle)
  nbreCategoriesPar <- length(categoriesPar)
  
  div(
    #Selection intervalle date
    dateRangeInput(inputId = "idDateIntervalle",
                   label = "Période d'intérêt :",
                   start= "01/01/2018",
                   end=as.Date(Sys.Date(),format=("%d/%m/%Y")),
                   format="dd/mm/yyyy",
                   separator="à"),

    #Creation des cases à cocher variete
    checkboxGroupInput(inputId = "idCheckVarietes", label = "Selectionnez une ou plusieurs varietes", selected=categoriesVar[1],
                       choices = categoriesVar),

    #Creation des cases à cocher parcelle
    checkboxGroupInput(inputId = "idCheckParcelles", label = "Selectionnez une ou plusieurs parcelles", selected=categoriesPar[1],
                       choices = categoriesPar),


    #Selection des différents indicateurs
    selectInput(inputId = "idSelectIndGR",
                label = "Selectionnez l'indicateur à afficher ",
                choices = c("Couleur","Fermete")),

    #Selection de l'indicateur moyen par date ou de l'indicateur par individu
    selectInput(inputId = "idAffichParDateOuInd",
                label = "Selectionnez le graphique ",
                choices = c("Boxplot par variete et par date",
                            "Indicateur moyen par variete"))
  )
  
})




output$plotRaisins <- renderPlotly({
  
  dta <- Donnees()
  
  # Selection lignes et colonnes
  lignes <- dta$Date >= input$idDateIntervalle[1] & dta$Date <= input$idDateIntervalle[2] & 
    dta$Parcelle %in% input$idCheckParcelles & dta$Variete %in% input$idCheckVarietes
  
  colonnes <- c("Date","Variete",input$idSelectIndGR)
 
  DonneesSelection <- dta[lignes, colonnes] 
  
  if (input$idAffichParDateOuInd =="Boxplot par variete et par date") 
  {

    # boxplot
    
    p1 <- plot_ly(x = DonneesSelection$Date,
                 y = DonneesSelection[, input$idSelectIndGR],
                 color = DonneesSelection$Variete,
                 type = "box") %>%
      layout(boxmode = "group")
    
    p1
  }
  
  if (input$idAffichParDateOuInd =="Indicateur moyen par variete")
  { 
    #Moyenne indicateur des lignes selectionnées par date. Faire une fonction if pour faire par indiv (avec input)
    donneesMoyDateVar=aggregate( DonneesSelection, 
                                 by=list(Dates=DonneesSelection$Date, Varietes=DonneesSelection$Variete), FUN=mean)
    
    # graph
    p2 <- ggplot(donneesMoyDateVar, 
                 aes(x = Dates, 
                     y = donneesMoyDateVar[, input$idSelectIndGR], color = Varietes)) +  
    geom_point() 
    p2
  }
  
})
