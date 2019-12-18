sidebarLayout(
  sidebarPanel(

  uiOutput("mapInputInd"),
  uiOutput("mapInputDate")
  ),
  mainPanel(
    leafletOutput("map_indic")
  )

)