
# Lessons 1 and 2 (Intro to Web Development and Project Setup) ------------



#Install packages if they haven't already done so:

install.packages("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "sf")

#Set up project folder.
#First, make root. Then add three scripts, naming them server.R, ui.R, and global.R. Then, make three subfolders: www, Rcode, and inputs.
#In the first of these, add a styles.css and a behaviors.js file. Note that this is also where fonts, images, icons, media files, etc. should go.
#Note that custom functions and scripts as well as "module" files should go in the Rcode folder. The inputs folder is for data files and R objects the app needs to run processes.
#Then, make into an R project folder and use the .Rproj file to launch the project. Note the renv and Github integration features that come along with it.

#Start setting up global.R. Add our library calls, our data-reading and manipulating commands
### LOAD PACKAGES
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(leaflet)
library(gapminder)
library(sf)

### LOAD DATA SETS
gap = as.data.frame(gapminder)

##Start setting up server.R by adding the server function:
server = function(input, output, session) {
  #ALL OUR EVENTUAL SERVER-SIDE CODE WILL GO INSIDE HERE.
}

##Start setting up ui.R by adding the outermost fluidPage():
ui = fluidPage(
  #ALL OUR EVENTUAL CLIENT-SIDE CODE WILL GO INSIDE HERE
)

#Adjusting the head box:
tags$head(
  tags$title("Check this out!")
),

#And linking to a stylesheet:
tags$head(
  tags$link(href = "styles.css",
            rel = "stylesheet"),
  tags$title("Check this out!")
),

#Begin fleshing out our UI's structure:
ui = fluidPage(
h1("Our amazing Shiny app!",
   id = "header"),

fluidRow(
  column(width = 4), #SIDEBAR
  column(width = 8) #MAIN PANEL
),

tags$footer("This is my app")
)


##Adding some custom CSS and a link to our stylesheet
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

#In CSS file
#header {
color: green;
font-weight: bold;
}


# Lesson 3 (Shiny Core Concepts) ------------------------------------------

#Outputting a basic table of the gapminder data set.
server = function(input, output, session) {

  #TABLE
  output$table1 = renderTable({
    gap
  })
}

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
    column(width = 8,
           tableOutput(outputId = "table1")) #MAIN PANEL
  ),

  tags$footer("This is my app")
)


#Next, adding an input widget
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

#Now, wire the input server side
server = function(input, output, session) {

  #TABLE
  output$table1 = renderTable({
    gap %>%
      arrange(!!sym(input$sorted_column)) #DON'T WORRY ABOUT WHAT THE !!sym() PART DOES HERE!
  })
}

#Demonstrate the value of print:
server = function(input, output, session) {

  #TABLE
  output$table1 = renderTable({
    print(input$sorted_column)
    gap %>%
      arrange(!!sym(input$sorted_column))
  })
}

#Demonstrate the value of print:
server = function(input, output, session) {

  input$sorted_column #CAN'T DO THIS! NOT IN A REACTIVE CONTEXT!

  #TABLE
  output$table1 = renderTable({
    print(input$sorted_column)
    gap %>%
      arrange(!!sym(input$sorted_column))
  })
}


#Adding a go button
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
             label = "Go!") #NEW
    ), #SIDEBAR
    column(width = 8,
           tableOutput(outputId = "table1")) #MAIN PANEL
  ),

  tags$footer("This is my app")
)

#wiring the go button
server = function(input, output, session) {

  # input$sorted_column #CAN'T DO THIS! NOT IN A REACTIVE CONTEXT!

  #TABLE
  output$table1 = renderTable({
    # print(input$sorted_column)
    input$go_button #WILL BE REACTIVE TO THIS NOW TOO.
    gap %>%
      arrange(!!sym(input$sorted_column))
  })
}

#Isolating
#wiring the go button
server = function(input, output, session) {

  # input$sorted_column #CAN'T DO THIS! NOT IN A REACTIVE CONTEXT!

  #TABLE
  output$table1 = renderTable({
    # print(input$sorted_column)
    input$go_button #WILL BE REACTIVE TO THIS NOW TOO.
    gap %>%
      arrange(!!sym(isolate(input$sorted_column)))
  })
}

#Re-configuring to make this an observeEvent instead.
#Isolating
#wiring the go button
server = function(input, output, session) {

  # input$sorted_column #CAN'T DO THIS! NOT IN A REACTIVE CONTEXT!

  #TABLE
  # output$table1 = renderTable({
  #   # print(input$sorted_column)
  #   input$go_button #WILL BE REACTIVE TO THIS NOW TOO.
  #   gap %>%
  #     arrange(!!sym(isolate(input$sorted_column)))
  # })

  #MAKE INITIAL TABLE ON START-UP
  output$table1 = renderTable({
    gap
  })

  #THEN WATCH FOR EVENTS AND UPDATE WHEN THEY OCCUR.
  observeEvent({input$go_button},
               ignoreInit = FALSE, {

                 output$table1 = renderTable({
                   gap %>%
                     arrange(!!sym(input$sorted_column)) #NO NEED TO ISOLATE

                 })
               })
}

#Adding the tabset panel
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
             label = "Go!") #NEW
    ), #SIDEBAR
    column(width = 8, #MAIN PANEL
           tabsetPanel(
             tabPanel(title = "Table",
                      tableOutput(outputId = "table1")),
             tabPanel(title = "Map"),
             tabPanel(title = "Graph")
            )
           )
  ),

  tags$footer("This is my app")
)

#Swapping for DT table, in server:

output$table1 = renderDT({ #<--CHANGE FUNCTION
  gap
})

observeEvent({input$go_button},
             ignoreInit = FALSE, {

               output$table1 = renderDT({ #<--CHANGE FUNCTION
                 gap %>%
                   arrange(!!sym(input$sorted_column))

               })
             })

#Swapping for DT table, in UI
column(width = 8, tabsetPanel(
  ###TABLE TAB
  tabPanel(title = "Table",
           dataTableOutput(outputId = "table1")), #<--CHANGE FUNCTION
  ###MAP TAB
  tabPanel(title = "Map"),
  ###GRAPH TAB
  tabPanel(title = "Graph")
)
)

#In server, reducing the number of features of our DT table.
output$table1 = renderDT({
  gap %>%
    datatable(
      selection = "none", #<--TURNS OFF ROW SELECTION
      options = list(
        info = FALSE, #<--NO BOTTOM-LEFT INFO
        ordering = FALSE, #<--NO SORTING
        searching = FALSE #<--NO SEARCH BAR
      )
    )
})

observeEvent({input$go_button},
             ignoreInit = FALSE, {

               output$table1 = renderDT({
                 gap %>%
                   arrange(!!sym(input$sorted_column)) %>%
                   #SAME AS ABOVE
                   datatable(
                     selection = "none",
                     options = list(
                       info = FALSE,
                       ordering = FALSE,
                       searching = FALSE
                     )
                   )

               })
             })


#In the server, style the DT table by adding the following to both relevant places:
%>%
  #SAME AS ABOVE
  formatRound(columns = "gdpPercap", digits = 2) %>%
  formatStyle(columns = "continent", textAlign = "center") %>%
  formatStyle(
    columns = "lifeExp",
    target = "row",
    backgroundColor = styleEqual(
      levels = gap$lifeExp,
      values = ifelse(gap$lifeExp > 70, "lightpink", "white")
    )
  )

#In the server, transition to using a proxy to update the table
observeEvent({input$go_button},
             ignoreInit = FALSE, {

               sorted_gap = gap %>%
                 arrange(!!sym(input$sorted_column))

               dataTableProxy(outputId = "table1") %>%
                 replaceData(data = sorted_gap,
                             resetPaging = FALSE)

})


#In the server, turn on cell selection
output$table1 = renderDT({
  gap %>%
    datatable(
      selection = list(mode = "single", target = "cell"), #<--TURN SELECTION ON, TARGET INDIVIDUAL CELLS.
      options = list(
        info = FALSE,
        ordering = FALSE,
        searching = FALSE
      )
    ) %>%
    formatRound(columns = "gdpPercap", digits = 2) %>%
    formatStyle(columns = "continent", textAlign = "center") %>%
    formatStyle(
      columns = "lifeExp",
      target = "row",
      backgroundColor = styleEqual(
        levels = gap$lifeExp,
        values = ifelse(gap$lifeExp > 70, "lightpink", "white")
      )
    )
})

#In the server, wire up new observer to watch for cell selections
#WATCH FOR CELL SELECTIONS
observeEvent({input$table1_cells_selected}, {

  print(input$table1_cells_selected)

})


#In the UI, add our new map:
column(width = 8, tabsetPanel(
  ###TABLE TAB
  tabPanel(title = "Table", dataTableOutput("table1")),
  ###MAP TAB
  tabPanel(title = "Map",
           leafletOutput("basic_map")), #<--OUTPUT OUR NEW MAP.
  ###GRAPH TAB
  tabPanel(
    title = "Graph",
  )
))

#In the server, add the new map code:
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  leaflet() %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry
    )
})

#In the server, set min and max zoom levels
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  ##THE leaflet() FUNCTION HAS OPTIONS WE CAN ADJUST, SUCH AS THE MIN AND MAX ZOOM.
  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry)

})

#In the server, set max bounds
###MAP
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  #THE SF PACKAGE'S st_bbox() FUNCTION GETS THE FOUR POINTS THAT WOULD CREATE A BOX FULLY BOUNDING ALL SPATIAL DATA GIVEN AS INPUTS.
  bounds = unname(sf::st_bbox(gap_map2007))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry) %>%
    ##CONVENIENTLY, setMaxBounds() TAKES, AS INPUTS, THOSE EXACT SAME FOUR POINTS IN THE SAME ORDER.
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])

})

#In server, update map aesthetics
###MAP
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  bounds = unname(sf::st_bbox(gap_map2007))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black", #CHANGE STROKE COLOR TO BLACK
      weight = 2, #INCREASE STROKE THICKNESS
      opacity = 1 #MAKE FULLY OPAQUE
    ) %>%
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])

})

#In server, establish a color palette function for leaflet to use:
###MAP
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  bounds = unname(sf::st_bbox(gap_map2007))

  #ESTABLISH A COLOR SCHEME TO USE FOR OUR FILLS.
  map_palette = colorNumeric(palette = "Blues",
                             domain = unique(gap_map2007$lifeExp))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2) %>%
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])

})

#In server, attach the color palette function and data to our polygons:
###MAP
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  bounds = unname(sf::st_bbox(gap_map2007))

  map_palette = colorNumeric(palette = "Blues", domain = unique(gap_map2007$lifeExp))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp), #<--WE USE OUR NEW COLOR PALETTE FUNCTION, SPECIFYING OUR DATA AS INPUTS.
      fillOpacity = 0.75) %>%  #<--THE DEFAULT, 0.5, WASHES OUT THE COLORS TOO MUCH.
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])

})

#In server, add a tooltip for country name
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  bounds = unname(sf::st_bbox(gap_map2007))

  map_palette = colorNumeric(palette = "Blues", domain = unique(gap_map2007$lifeExp))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp),
      fillOpacity = 0.75,
      popup = gap_map2007$country) %>% #<--MAKE A TOOLTIP HOLDING THE COUNTRY NAME THAT APPEARS/DISAPPEARS ON MOUSE CLICK.
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
    addLegend(
      position = "bottomleft",
      pal = map_palette,
      values = gap_map2007$lifeExp,
      opacity = 0.75,
      bins = 5,
      title = "Life<br>expectancy ('07)"
    )

})

#In server, expand the tooltip to also contain life expectancy data:
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  bounds = unname(sf::st_bbox(gap_map2007))

  map_palette = colorNumeric(palette = "Blues", domain = unique(gap_map2007$lifeExp))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp),
      fillOpacity = 0.75,
      #EXPANDING THE INFO PRESENTED IN THE TOOLTIPS.
      popup = paste0("County: ",
                     gap_map2007$country,
                     "<br>Life expectancy: ",
                     gap_map2007$lifeExp)
    ) %>%
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
    addLegend(
      position = "bottomleft",
      pal = map_palette,
      values = gap_map2007$lifeExp,
      opacity = 0.75,
      bins = 5,
      title = "Life<br>expectancy ('07)"
    )

})
