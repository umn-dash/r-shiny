# Lessons 1 and 2 (Intro to Web Development and Project Setup) ------------

#Install packages if they haven't already done so:

install.packages("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "sf")

#Set up project folder.
#First, make root. Then add three scripts, naming them server.R, ui.R, and global.R. Then, make one subfolder: www.
#In the first of these, add a styles.css file.
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
  tags$link(href = "styles.css",
            rel = "stylesheet"),




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



#In CSS file
#header {
color: green;
font-weight: bold;
}


# Lesson 3 (Shiny Core Concepts) ------------------------------------------

#Adding the table to the UI
column(width = 8,
       tableOutput(outputId = "table1")) #MAIN PANEL
),



#Outputting a basic table of the gapminder data set.
server = function(input, output, session) {

  #TABLE
  output$table1 = renderTable({
    gap
  })
}



#Next, adding an input widget
    column(width = 4,
           selectInput(
             inputId = "sorted_column",
             label = "Select a column to sort the table by.",
             choices = names(gap)
            )
           ), #SIDEBAR




#Now, wire the input server side
  output$table1 = renderTable({
    gap %>%
      arrange(!!sym(input$sorted_column)) #DON'T WORRY ABOUT WHAT THE !!sym() PART DOES HERE!
  })



#Demonstrate the value of print:
  output$table1 = renderTable({
    print(input$sorted_column)
    gap %>%
      arrange(!!sym(input$sorted_column))
  })




#Demonstrate how reactive contexts work:
server = function(input, output, session) {

  input$sorted_column #CAN'T DO THIS! NOT IN A REACTIVE CONTEXT!

}


#Adding a go button
           actionButton(
             inputId = "go_button",
             label = "Go!") #NEW
    ), #SIDEBAR




#wiring the go button
  output$table1 = renderTable({

    input$go_button #WILL BE REACTIVE TO THIS NOW TOO.

    gap %>%
      arrange(!!sym(input$sorted_column))
  })




#Isolating
  output$table1 = renderTable({

    input$go_button #WILL BE REACTIVE TO THIS NOW TOO.
    gap %>%
      arrange(!!sym(isolate(input$sorted_column)))
  })



#Re-configuring to make this an observeEvent instead.
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

#Adding the tabset panel
    column(width = 8, #MAIN PANEL
           tabsetPanel(
             tabPanel(title = "Table",
                      tableOutput(outputId = "table1")),
             tabPanel(title = "Map"),
             tabPanel(title = "Graph")
            )
           )
  ),



# Lesson 4 (Showstoppers) -------------------------------------------------


## DT ----------------------------------------------------------------------



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
      ))
  ...
})

#In the server, wire up new observer to watch for cell selections
observeEvent({input$table1_cells_selected}, {

  print(input$table1_cells_selected)

})


## leaflet -----------------------------------------------------------------



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

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2))



#In the server, set max bounds

  bounds = unname(sf::st_bbox(gap_map2007))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry) %>%
    ##CONVENIENTLY, setMaxBounds() TAKES, AS INPUTS, THOSE EXACT SAME FOUR POINTS IN THE SAME ORDER.
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])




#In server, update map aesthetics
  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black", #CHANGE STROKE COLOR TO BLACK
      weight = 2, #INCREASE STROKE THICKNESS
      opacity = 1 #MAKE FULLY OPAQUE
    )



#In server, establish a color palette function for leaflet to use:

  #ESTABLISH A COLOR SCHEME TO USE FOR OUR FILLS.
  map_palette = colorNumeric(palette = "Blues",
                             domain = unique(gap_map2007$lifeExp))


#In server, attach the color palette function and data to our polygons:
  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp), #<--WE USE OUR NEW COLOR PALETTE FUNCTION, SPECIFYING OUR DATA AS INPUTS.
      fillOpacity = 0.75) %>%  #<--THE DEFAULT, 0.5, WASHES OUT THE COLORS TOO MUCH.


#In server, add a legend
    addLegend(
      position = "bottomleft",
      pal = map_palette,
      values = gap_map2007$lifeExp,
      opacity = 0.75,
      bins = 5,
      title = "Life<br>expectancy ('07)"
    )



#In server, add a tooltip for country name
  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp),
      fillOpacity = 0.75,
      popup = gap_map2007$country)
})




#In server, expand the tooltip to also contain life expectancy data:
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
    )




#In UI, add slider widget
       sliderInput(
         inputId = "year_slider",
         label = "Pick what year's data are shown in the map.",
         value = 2007, #<--SET THE DEFAULT CHOICE
         min = min(gap$year), #<--MIN AND MAX OPTIONS
         max = max(gap$year),
         step = 5, #<--HOW FAR APART CAN CHOICES BE? HERE, 5 IS THE SAME AS THOSE IN THE DATA.
         sep = "" #<--DON'T USE COMMAS TO SEPARATE THE THOUSANDS PLACE (WE DON'T DO THAT FOR YEARS).
       )



#In the server, wire up our renderLeaflet to handle slider events

output$basic_map = renderLeaflet({
  ##KEEP THE PRODUCT NAMED AFTER 2007 FOR NOW.
  gap_map2007 = gap_map %>%
    filter(year == as.numeric(input$year_slider)) #<--INTRODUCE THE SLIDER'S CURRENT VALUE TO FILTER BY WHATEVER YEAR HAS BEEN CHOSEN. EVERY CHANGE IS AN EVENT THAT WILL TRIGGER'S renderLeaflet({})'S EXPRESSION TO RERUN.

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
      #HERE, WE'LL PULL A LITTLE TRICK TO ENSURE THE LEGEND'S TITLE IS ALWAYS ACCURATE.
      title = paste0("Life<br>expectancy ('",
                     substr(input$year_slider, 3, 4),
                     ")")
    )

})




#In global.R, generize by making one global map palette
map_palette = colorNumeric(palette = "Blues",
                           domain = unique(gap_map$lifeExp)) #<--CHANGE TO REFERENCE THE WHOLE DATA SET.



#In server, switch to using a proxy system for updates:
#RENDERLEAFLET GOES BACK TO MAKING JUST THE BASE, 2007 VERSION.
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007) #<--CHANGE BACK

  bounds = unname(sf::st_bbox(gap_map2007))

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp),
      fillOpacity = 0.75,
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
      title = paste0("Life<br>expectancy ('07)") #<--CHANGE BACK
    )

})

#A NEW OBSERVER WATCHES FOR EVENTS INVOLVING OUR SLIDER.
observeEvent({input$year_slider}, {

  gap_map2007 = gap_map %>%
    filter(year == as.numeric(input$year_slider)) #FILTER BY SELECTED YEAR

  #WE USE leafletProxy({}) TO UPDATE OUR MAP INSTEAD OF RE-RENDERING IT.
  leafletProxy("basic_map") %>%
    clearMarkers() %>% #REMOVE THE OLD POLYGONS ("MARKERS")--THEIR FILLS MUST CHANGE.
    clearControls() %>% #REMOVE THE LEGEND ("CONTROL")--ITS TITLE MUST CHANGE.
    addPolygons( #REBUILD THE POLYGONS EXACTLY AS BEFORE.
      data = gap_map2007$geometry,
      color = "black",
      weight = 2,
      opacity = 1,
      fillColor = map_palette(gap_map2007$lifeExp),
      fillOpacity = 0.75,
      popup = paste0("County: ",
                     gap_map2007$country,
                     "<br>Life expectancy: ",
                     gap_map2007$lifeExp)
    ) %>%
    addLegend( #REBUILD THE LEGEND EXACTLY AS BEFORE.
      position = "bottomleft",
      pal = map_palette,
      values = gap_map2007$lifeExp,
      opacity = 0.75,
      bins = 5,
      title = paste0("Life<br>expectancy ('",
                     substr(input$year_slider, 3, 4),
                     ")") #<-RETAIN THE TRICK HERE.
    )

})



## plotly ------------------------------------------------------------------



##In global.R, add the following to create a ggplot and plotly graph:
gap2007 = gap %>%
  filter(year == 2007)


###BASE GGPLOT FOR CONVERSION TO PLOTLY
p1 = ggplot(
  gap2007,
  aes(
    x = log(pop),
    y = gdpPercap,
    color = continent,
    group = continent
  )
) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = F) +
  theme(
    text = element_text(
      size = 16,
      color = "black",
      face = "bold"
    ),
    panel.background = element_rect(fill = "white"),
    panel.grid.major = element_line(color = "gray"),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 1.5)
  ) +
  scale_y_continuous("GDP per capita\n") +
  scale_x_continuous("\nPopulation size (log)") +
  scale_color_discrete("Continent\n")


p2 = ggplotly(p1)



#In server, disable/remove some interactive features:
output$basic_graph = renderPlotly({

  p2 %>%
    layout(
      xaxis = list(fixedrange = TRUE),
      yaxis = list(fixedrange = TRUE),
      legend = list(itemclick = FALSE)
    ) %>%
    config(modeBarButtonsToRemove = list("lasso2d"))

})



#In the server, adjust the legend location to be more like original graph:
legend = list(itemclick = FALSE,
              y = 0.5,
              yanchor = "middle"
)




#In global, adjust the graph-making code to pass along custom tooltip text:
gap2007 = gap %>%
  filter(year == 2007) %>%
  mutate(tooltip_text = paste0( #<--HERE, WE GENERATE A NEW COLUMN CALLED tooltip_text USING paste0() TO MAKE A TEXT STRING CONTAINING THE GDP AND POPULATION DATA IN A READABLE FORMAT.
    "GDP: ",
    round(gdpPercap, 1),
    "<br>",
    "Log population: ",
    round(log(pop), 3)
  ))

p1 = ggplot(
  gap2007,
  aes(
    x = log(pop),
    y = gdpPercap,
    color = continent,
    group = continent,
    text = tooltip_text #<--HERE, WE PASS OUR CUSTOM TOOLTIP TEXT IN TO THE TEXT AESTHETIC. EVEN THOUGH OUR GGPLOT NEVER USES THIS INFO, IT'LL BE PASSED TO OUR PLOTLY GRAPH BY ggplotly() ANYHOW.
  )
)

p2 = ggplotly(p1,
              tooltip = "text") %>% #<--HERE, WE TELL GGPLOTLY() TO POPULATE TOOLTIPS WITH ONLY TEXT DATA AND NOT ALSO X/Y/COLOR INFO.
  style(hoverinfo = "text") #<--HERE, WE USE style() TO REQUEST THAT ONLY OUR CUSTOM TOOL-TIPS BE SHOWN, OR ELSE WE'D GET PLOTLY'S DEFAULT ONES TOO!




#In the UI, add the color scheme selector:
selectInput( #ADD A COLOR PALETTE SELECTOR
  inputId = "color_scheme",
  label = "Pick a color palette for the graph.",
  choices = c("viridis", "plasma", "Spectral", "Dark2")
)



#In the server, add the new color scheme observer:
observeEvent(input$color_scheme, {

  #WE FIRST DESIGN AN APPROPRIATE COLOR PALETTE FOR THE DATA, GIVEN THE USER'S CHOICE
  new_pal = colorFactor(palette = input$color_scheme,
                        domain = unique(gap2007$continent))

  plotlyProxy("basic_graph", session) %>% #<--WE HAVE TO INCLUDE session THIS TIME TOO.
    plotlyProxyInvoke("restyle", #<-THE TYPE OF CHANGE WE PLAN TO MAKE
                      list(marker = list(
                        color = new_pal(gap2007$continent), #FOR OUR MARKERS, USE THESE COLORS.
                        size = 11.3 #AND THIS SIZE.
                      )),
                      0:4) #APPLY THIS CHANGE TO ALL 5 GROUPS OF MARKERS WE HAVE.

})


#In the UI, add the textOutput
textOutput("point_clicked")



#In the global.R, add the source and event registration
p2 = ggplotly(p1,
              tooltip = "text",
              source = "our_graph") %>%
  style(hoverinfo = "text") %>%
  event_register("plotly_click")



#In the server, add the new observer
observeEvent(event_data(event = "plotly_click",
                        source = "our_graph"), {

                          output$point_clicked = renderText({
                            paste0(
                              "The exact population for this point was: ",
                              prettyNum(round(exp(
                                event_data(event = "plotly_click", source = "our_graph")$x
                              )), big.mark = ",") #<--WE CAN ACCESS THE X VALUE OF THE POINT CLICKED THIS WAY.
                            )

                          })

                        })

