sidebarLayout(
  sidebarPanel(
    #Selection intervalle date
    dateRangeInput(inputId = "idDateIntervalle", 
                   label = "Période d'intérêt :", 
                   start= "01/01/2018",
                   end=as.Date(Sys.Date(),format=("%d/%m/%Y")),
                   format="dd/mm/yyyy",
                   separator="à"),
    
    #Selection des différentes catégories dans variete
    categoriesVar <- unique(Donnees$Variete),
    nbreCategoriesVar <- length(categoriesVar),
    
    #Creation des cases à cocher variete
    checkboxGroupInput(inputId = "idCheckVarietes", label = "Please select", selected = nbreCategoriesVar,
                       choices = categoriesVar),
    
    
    #Selection des différentes catégories dans parcelle
    categoriesPar <- unique(Donnees$Parcelle),
    nbreCategoriesPar <- length(categoriesPar),
    
    #Creation des cases à cocher parcelle
    checkboxGroupInput(inputId = "idCheckParcelles", label = "Please select", selected = nbreCategoriesPar,
                       choices = categoriesPar),
    
    
    #Selection des différents indicateurs
    selectInput(inputId = "idSelectIndGR", 
                label = "Select among the list: ", 
                choices = c("couleur","fermete"))
  ),
  mainPanel(
    plotlyOutput("plotRaisins")
  )
  
)
