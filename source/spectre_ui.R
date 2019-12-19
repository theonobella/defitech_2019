
sidebarLayout(
  sidebarPanel(
    
    uiOutput("specInputDate")
  ),
  
  mainPanel(
    plotlyOutput("plot_spectre")
    
  )
  
)
