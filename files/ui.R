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
    column(width = 8, tabsetPanel(
      ###TABLE TAB
      tabPanel(title = "Table", dataTableOutput("table1")),
      ###MAP TAB
      tabPanel(title = "Map", leafletOutput("basic_map")), #<--OUTPUT OUR NEW MAP.
      ###GRAPH TAB
      tabPanel(
        title = "Graph",
      )
    ))
  ),

  tags$footer("This is my app")
)
