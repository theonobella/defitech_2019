sidebarLayout(
  sidebarPanel(

    dateRangeInput(inputId = "idSelect_daterange", 
                   label = "Période d'intérêt :", 
                   start= "2000-01-01",
                   end=format(Sys.Date(),format="%d/%m/%Y"),
                   language='fr',
                   separator="to")
  ),
  mainPanel(
    plotOutput("hist")
  )
  
)
