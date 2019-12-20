#install.packages("shinydashboard")

library(shiny)
library(leaflet)
library(shinydashboard)
library(plotly)
library(tidyverse)
library(shinyWidgets)
library(mapview)
library(gstat)
library(sp)
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

# Données de Simon
# Donnees <- read.table("data_test_simon.csv", header = TRUE, dec = ",",stringsAsFactors = FALSE)


# Données Vignoble
donnees_raisin <- read.table("data_test_raisin.csv", header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE)
# donnees_vignoble$Date=as.Date(donnees_vignoble$Date,format="%d/%m/%Y")

# Données pommes
donnees_pomme <- read.table("data_test_pomme.csv", header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE)

require(sf)  
require(stars)
require(gstat) 
