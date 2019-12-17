#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

Donnees <- read.table("data_test.csv", header = TRUE)


# Define UI for application that draws a histogram
shinyUI(
    source("source/testcarto_ui.R", local=TRUE,encoding="UTF-8")$value
)
