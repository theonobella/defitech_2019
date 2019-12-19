sidebarLayout(
  sidebarPanel(
    uiOutput("mapInputInd"),
    uiOutput("mapInputDate"),
    uiOutput("mapInputVariete"),
    uiOutput("mapInputParcelle")
  ),
  mainPanel(
    leafletOutput("map_indic")
  )
  
)