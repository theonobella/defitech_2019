

output$wiki_page <- renderUI({
  #browser()
  
  if (input$id_select_espece == "Raisin") {
    source = "https://fr.wikipedia.org/wiki/Raisin"
  } else {
    source = "https://fr.wikipedia.org/wiki/Pomme"
  }
  tags$iframe( src = source,
               style = "width: 100%;height: 470px")
    
})

  
  

    
