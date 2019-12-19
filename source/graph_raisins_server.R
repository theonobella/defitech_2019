output$plotRaisins <- renderPlotly({
  
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
