
# Gnerate selcet input
output$ISIG <- renderUI({
  browser()
  
  dta <- Donnees()
  
  div(
    selectInput(inputId = "idSelect_indicateurgraph", 
                label = "Select among the list: ", 
                choices = names(dta[5:ncol(dta)])),
    
    dateRangeInput(inputId = "idSelect_daterange", 
                   label = "Période d'intérêt :", 
                   start= "01/01/2018",
                   end=as.Date(Sys.Date(),format=("%d/%m/%Y")),
                   format="mm/dd/yyyy",
                   separator="to")
  )
})


output$plot <- renderPlotly({
  
  dta <- Donnees()
  
  selectedLines <- dta$Date >= input$idSelect_daterange[1] & dta$Date <= input$idSelect_daterange[2] 
  selectedCols <-  c("Date", input$idSelect_indicateurgraph) 
  Donnees_a_grapher <- dta[selectedLines, selectedCols] 
 
  data=aggregate( Donnees_a_grapher, by=list(Donnees_a_grapher$Date), FUN=mean)
  
  
  # build graph with ggplot syntax 
  p <- ggplot(data, aes_string(x = data$Date, y = input$idSelect_indicateurgraph)) +  
    geom_point() 
  ggplotly(p)  

})


