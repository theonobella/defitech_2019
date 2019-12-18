#install.packages("shinydashboard")

library(shiny)
library(leaflet)
library(shinydashboard)
library(plotly)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

Donnees <- read.table("data_test_simon.csv", header = TRUE, dec = ",",stringsAsFactors = FALSE)
Donnees$Date=as.Date(Donnees$Date,format="%d/%m/%Y")
Donnees_a_grapher = subset(
  Donnees,
  select = c(Date, NDVI))