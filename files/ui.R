ui = fluidPage(

  tags$head(
    tags$link(href = "styles.css",
              rel = "stylesheet"),
    tags$title("Check this out!")
  ),

  h1("Our amazing Shiny app!",
     id = "header"),

  fluidRow(
    column(width = 4,
           selectInput(
             inputId = "sorted_column",
             label = "Select a column to sort the table by.",
             choices = names(gap)
            )
           ), #SIDEBAR
    column(width = 8,
           tableOutput(outputId = "table1")) #MAIN PANEL
  ),

  tags$footer("This is my app")
)
