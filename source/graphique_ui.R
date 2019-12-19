sidebarLayout(
  sidebarPanel(
    selectInput(inputId = "idSelect_indicateurgraph", 
                label = "Select among the list: ", 
                choices = names(dta[5:ncol(Donnees)])),
    
    dateRangeInput(inputId = "idSelect_daterange", 
                   label = "Période d'intérêt :", 
                   start= "01/01/2018",
                   end=as.Date(Sys.Date(),format=("%d/%m/%Y")),
                   format="mm/dd/yyyy",
                   separator="to")
  ),
  mainPanel(
    plotlyOutput("plot")
  )
  
)
