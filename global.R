#install.packages("shinydashboard")

library(shiny)
library(leaflet)
library(shinydashboard)
library(plotly)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

# Données de Simon
Donnees <- read.table("data_test_simon.csv", header = TRUE, dec = ",",stringsAsFactors = FALSE)
Donnees$Date=as.Date(Donnees$Date,format="%d/%m/%Y")
Donnees_a_grapher = subset(
  Donnees,
  select = c(Date, NDVI))


# Données Vignoble
donnees_vignoble <- read.table("data_test_raisin.csv", header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE)
# donnees_vignoble$Date=as.Date(donnees_vignoble$Date,format="%d/%m/%Y")