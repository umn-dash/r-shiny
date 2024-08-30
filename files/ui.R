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
            ),
           actionButton(
             inputId = "go_button",
             label = "Go!")
           ), #SIDEBAR
    column(width = 8,
           tabsetPanel(
             tabPanel(title = "Table",
                      tableOutput(outputId = "table1")),
             tabPanel(title = "Map"),
             tabPanel(title = "Graph")
           )
    ) #MAIN PANEL
  ),

  tags$footer("This is my app")
)
