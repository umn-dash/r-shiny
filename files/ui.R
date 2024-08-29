ui = fluidPage(

  tags$head(
    tags$link(href = "styles.css",
              rel = "stylesheet"),
    tags$title("Check this out!")
  ),

  h1("Our amazing Shiny app!",
     id = "header"),

  fluidRow(
    column(width = 4), #SIDEBAR
    column(width = 8) #MAIN PANEL
  ),

  tags$footer("This is my app")
)
