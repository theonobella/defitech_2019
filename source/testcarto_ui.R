

fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
)