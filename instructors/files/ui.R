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
             label = "Go!"),
           sliderInput(
             inputId = "year_slider",
             label = "Pick what year's data are shown in the map.",
             value = 2007,
             min = min(gap$year),
             max = max(gap$year),
             step = 5,
             sep = ""
           ),
           selectInput(
             inputId = "color_scheme",
             label = "Pick a color palette for the graph.",
             choices = c("viridis", "plasma", "Spectral", "Dark2")
           )
    ),
    column(width = 8, tabsetPanel(
      tabPanel(title = "Table", dataTableOutput("table1")),
      tabPanel(title = "Map", leafletOutput("basic_map")),
      tabPanel(title = "Graph",
               plotlyOutput("basic_graph"),
               textOutput("point_clicked")) #<--ADD TEXTOUTPUT TO UI.
    ))
  ),

  tags$footer("This is my app")
)
