library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

Donnees <- read.table("data_test.csv", header = TRUE, dec = ",")