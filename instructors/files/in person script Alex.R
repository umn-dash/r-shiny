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




##Start setting up server.R by adding our server function:
server = function(input, output, session) {
  #ALL EVENTUAL SERVER CODE GOES INSIDE THIS.
}




##Start setting up ui.R by adding our outermost fluidPage():
ui = fluidPage(
  #ALL EVENTUAL CLIENT-SIDE CODE GOES INSIDE THIS.
)



#Adjusting the head box--adding a title:
tags$head(
  tags$title("Check this out!")
),



#Adjusting the head box--linking to a stylesheet:
  tags$link(href = "styles.css",
            rel = "stylesheet"),



#Begin fleshing out our UI's structure by adding elements in a mobile-first design:

h1("Our amazing Shiny app!", #CUSTOM HEADER
   id = "header"), #SEPARATE ALL UI ELEMENTS FROM THE NEXT W/ COMMAS.

fluidRow( #MAIN CONTENT AREA.
  column(width = 4), #SIDEBAR CELL
  column(width = 8) #MAIN PANEL CELL
),

tags$footer("This is my app") #CUSTOM FOOTER


#IN CSS FILE, MODIFY TITLE.
#header {
color: green;
font-weight: bold;
}


# Lesson 3 (Shiny Core Concepts) ------------------------------------------

#FIRST, RENDER THE TABLE SERVER-SIDE, DOING ANY "WORK" INSIDE.
output$table1 = renderTable({
  gap
})


#THEN, PLACE THAT TABLE IN THE UI BY OUTPUTTING IT WITHIN A SPECIFY BOX.
tableOutput(outputId = "table1") #MAIN PANEL CELL



#ADD INPUT WIDGET FOR SORTING TABLE
selectInput(
  inputId = "sorted_column",
  label = "Select a column to sort the table by.",
  choices = names(gap)
)



#WIRE UP INPUT WIDGET BY USING ITS CURRENT VALUE SERVER-SIDE WITHIN A REACTIVE CONTEXT.
    gap %>%
      arrange(!!sym(input$sorted_column)) #DON'T WORRY ABOUT WHAT !!sym() DOES HERE!




#DEMONSTRATE VALUE OF USING print() INSIDE REACTIVE CONTEXTS.
print(input$sorted_column)



#DEMONSTRATE THAT REACTIVE OBJECTS MUST GO ONLY INSIDE REACTIVE CONTEXTS.
input$sorted_column



#ADDING A GO BUTTON INPUT WIDGET TO THE UI
           actionButton(
             inputId = "go_button",
             label = "Go!")
    ),



#MAKING THE GO BUTTON TRIGGER REBUILDS
input$go_button #WILL BE REACTIVE TO THIS NOW TOO.




#USING ISOLATION TO PREVENT EVENTS BUT STILL ALLOW ACCESS TO CURRENT VALUES
arrange(!!sym(isolate(input$sorted_column)))


#RE-CONFIGURING TO USE OBSERVEEVENT.

  #MAKE INITIAL TABLE ON START-UP
  output$table1 = renderTable({
    gap
  })

  #THEN, WATCH FOR EVENTS AND UPDATE WHEN THEY OCCUR.
  observeEvent(input$go_button, #ONLY THE FIRST CONTEXT IS REACTIVE
               ignoreInit = FALSE, {

                 output$table1 = renderTable({
                   gap %>%
                     arrange(!!sym(input$sorted_column)) #NO ISOLATION NEEDED; THIS CONTEXT ISN'T REACTIVE.

                 })
               })



#TURN MAIN CELL INTO TABSET PANEL INSTEAD.
           tabsetPanel(
             tabPanel(title = "Table",
                      tableOutput(outputId = "table1")),
             tabPanel(title = "Map"),
             tabPanel(title = "Graph")
            )



# Lesson 4 (Showstoppers) -------------------------------------------------


## DT ----------------------------------------------------------------------



#Swapping for DT table, in server:
output$table1 = renderDT({ #<--CHANGE FUNCTION

  output$table1 = renderDT({ #<--CHANGE FUNCTION



#Swapping for DT table, in UI
           dataTableOutput(outputId = "table1") #<--CHANGE FUNCTION



#Reducing number of features of our DT table.
  gap %>%
    datatable(
      selection = "none", #<--TURNS OFF ROW SELECTION
      options = list(
        info = FALSE, #<--NO BOTTOM-LEFT INFO
        ordering = FALSE, #<--NO SORTING
        searching = FALSE #<--NO SEARCH BAR
      )
    )

#MUST DO TWICE
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




#In server, style DT  by adding the following in both relevant places:
  formatRound(columns = "gdpPercap",
              digits = 2) %>%
  formatStyle(columns = "continent",
              textAlign = "center") %>%
  formatStyle(
    columns = "lifeExp",
    target = "row",
    backgroundColor = styleEqual(
      levels = gap$lifeExp,
      values = ifelse(gap$lifeExp > 70,
                      "lightpink",
                      "white")
    )
  )




#In server, transition to using a proxy system to update table instead of rebuilding it
               sorted_gap = gap %>%
                 arrange(!!sym(input$sorted_column))

               dataTableProxy(outputId = "table1") %>%
                 replaceData(data = sorted_gap,
                             resetPaging = FALSE)




#In the server, turn on cell selection
      selection = list(mode = "single", target = "cell"), #<--TURN SELECTION ON, TARGET INDIVIDUAL CELLS.



#In server, wire up new observer to watch for cell selections
observeEvent({input$table1_cells_selected}, {

  print(input$table1_cells_selected)

})




## leaflet -----------------------------------------------------------------

#In global.R, load in our spatial data set version
gap_map = readRDS("gapminder_spatial.rds")



#In server, add new map code:
output$basic_map = renderLeaflet({

  gap_map2007 = gap_map %>%
    filter(year == 2007)

  leaflet() %>%
    addTiles() %>%
    addPolygons(
      data = gap_map2007$geometry
    )
})




#In UI, add our new map:
leafletOutput("basic_map"), #<--OUTPUT OUR NEW MAP.



#In server, set min and max zoom levels on leaflet map

  leaflet(options = tileOptions(maxZoom = 6, minZoom = 2))



#In server, set max bounds on leaflet map for panning
  bounds = unname(sf::st_bbox(gap_map2007))

    addPolygons(
      data = gap_map2007$geometry) %>%
    ##CONVENIENTLY, setMaxBounds() TAKES, AS INPUTS, THOSE EXACT SAME FOUR POINTS IN THE SAME ORDER.
    setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])




#In server, crisp up map polygons
    addPolygons(
      data = gap_map2007$geometry,
      color = "black", #CHANGE STROKE COLOR TO BLACK
      weight = 2, #INCREASE STROKE THICKNESS
      opacity = 1 #MAKE FULLY OPAQUE
    )



#In server, establish a color palette function for leaflet to use to fill country polgyons by lifeExp values:
  map_palette = colorNumeric(palette = "Blues",
                             domain = unique(gap_map2007$lifeExp))



#In server, attach color palette function and data to our polygons:
    addPolygons(
      ...,
      fillColor = map_palette(gap_map2007$lifeExp), #<--USE NEW COLOR PALETTE FUNCTION, SPECIFYING DATA AS ITS INPUTS.
      fillOpacity = 0.75) %>%  #<--THE DEFAULT, 0.5, WASHES OUT THE COLORS TOO MUCH.



#In server, add a legend TO THE MAP
    addLegend(
      position = "bottomleft",
      pal = map_palette,
      values = gap_map2007$lifeExp,
      opacity = 0.75,
      bins = 5,
      title = "Life<br>expectancy ('07)"
    )




#In server, add tooltips for country name
    addPolygons(
      ...
      popup = gap_map2007$country)



#In server, expand tooltip to also contain life expectancy data:
    addPolygons(
      ...,
      popup = paste0("County: ",
                     gap_map2007$country,
                     "<br>Life expectancy: ",
                     gap_map2007$lifeExp)
      )



#In UI, add slider widget
       sliderInput(
         inputId = "year_slider",
         label = "Pick what year's data are shown in the map.",
         value = 2007, #<--DEFAULT CHOICE
         min = min(gap$year), #<--MIN AND MAX OPTIONS
         max = max(gap$year),
         step = 5, #<--HOW FAR APART ARE CHOICES ? HERE, 5 IS THE SAME AS THOSE IN THE DATA.
         sep = "" #<--DON'T USE COMMAS TO SEPARATE THE THOUSANDS PLACE (WE DON'T DO THAT FOR YEARS).
       )



#In the server, wire up our renderLeaflet to handle slider events

  gap_map2007 = gap_map %>%
    filter(year == as.numeric(input$year_slider)) #<--INTRODUCE SLIDER'S CURRENT VALUE TO FILTER BY WHATEVER YEAR CHOSEN. EVERY CHANGE IS AN EVENT THAT WILL TRIGGER'S renderLeaflet({})'S EXPRESSION TO RERUN.

  ...

    addLegend(
      ...,
      #HERE, A LITTLE TRICK TO ENSURE THE LEGEND'S TITLE IS ALWAYS ACCURATE.
      title = paste0("Life<br>expectancy ('",
                     substr(input$year_slider, 3, 4),
                     ")")
    )




#In global.R, generalize by making one global map palette
map_palette = colorNumeric(palette = "Blues",
                           domain = unique(gap_map$lifeExp)) #<--CHANGE TO REFERENCE THE WHOLE DATA SET.
#THEN, REMOVE map_palette CODE THRUOUT SERVER.




#In server, switch to using a proxy system for updates:
#RENDERLEAFLET GOES BACK TO MAKING JUST THE BASE, 2007 VERSION.
output$basic_map = renderLeaflet({
  gap_map2007 = gap_map %>%
    filter(year == 2007) #<--CHANGE BACK

  ...

    addLegend(
      ...,
      title = paste0("Life<br>expectancy ('07)") #<--CHANGE BACK
    )
})

#NEW OBSERVER WATCHES FOR EVENTS INVOLVING SLIDER.
observeEvent({input$year_slider}, {

  gap_map2007 = gap_map %>%
    filter(year == as.numeric(input$year_slider)) #FILTER BY SELECTED YEAR

  #WE USE leafletProxy({}) TO UPDATE OUR MAP INSTEAD OF RE-RENDERING IT.
  leafletProxy("basic_map") %>%
    clearMarkers() %>% #REMOVE THE OLD POLYGONS ("MARKERS")--THEIR FILLS MUST CHANGE.
    clearControls() %>% #REMOVE THE LEGEND ("CONTROL")--ITS TITLE MUST CHANGE.
    addPolygons( #REBUILD THE POLYGONS EXACTLY AS BEFORE.
      ...
    ) %>%
    addLegend( #REBUILD THE LEGEND EXACTLY AS BEFORE.
      ...,
      title = paste0("Life<br>expectancy ('",
                     substr(input$year_slider, 3, 4),
                     ")") #<-RETAIN THE TRICK HERE.
    )

})



#NEW OBSERVER TO USE FLY_TO IN RESPONSE TO MAP CLICKS
observeEvent(input$basic_map_shape_click, {

  leafletProxy("basic_map") %>% #USE THE PROXY SYSTEM FOR EFFICIENCY
    flyTo( #USE FLY_TO TO ONLY UPDATE FOCUS (WHERE THE CAMERA CENTERS) AND ZOOM LEVEL.
      lat = input$basic_map_shape_click$lat,
      lng = input$basic_map_shape_click$lng,
      zoom = 5
    )

})



## plotly ------------------------------------------------------------------


https://z.umn.edu/Rshiny


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


#SHOW, THEN CONVERT, THEN SHOW AGAIN
p2 = ggplotly(p1)




#IN SERVER, RENDER THE PLOTLY GRAPH
output$basic_graph = renderPlotly({
  p2
})



#IN ui, ADD NEW PLOTLY GRAPH
plotlyOutput("basic_graph")



#In server, disable/remove some interactive features in our plotly graph:
  p2 %>%
    layout(
      xaxis = list(fixedrange = TRUE), #DISABLE ZOOM
      yaxis = list(fixedrange = TRUE),
      legend = list(itemclick = FALSE) #STOP SINGLE-CLICK LEGEND EVENTS
    ) %>%
    config(modeBarButtonsToRemove = list("lasso2d")) #REMOVE LASSOING BUTTON




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
selectInput(
  inputId = "color_scheme",
  label = "Pick a color palette for the graph.",
  choices = c("viridis", "plasma", "Spectral", "Dark2")
)



#In the server, add the new color scheme observer:
observeEvent(input$color_scheme, {

  #WE FIRST DESIGN AN APPROPRIATE COLOR PALETTE FOR THE DATA, GIVEN THE USER'S CHOICE
  new_pal = colorFactor(palette = input$color_scheme,
                        domain = unique(gap2007$continent))

  plotlyProxy("basic_graph", session) %>% #<--WE HAVE TO INCLUDE session THIS TIME.
    plotlyProxyInvoke("restyle", #<-THE TYPE OF CHANGE WE PLAN TO MAKE
                      list(marker = list(
                        color = new_pal(gap2007$continent), #FOR OUR MARKERS, USE THESE COLORS.
                        size = 11.3 #AND THIS SIZE.
                      )),
                      0:4) #APPLY THIS CHANGE TO ALL 5 GROUPS OF MARKERS WE HAVE.

})




#In the UI, add the textOutput
textOutput("point_clicked")



#In global.R, add the source and event registration for our plotly event tracking
p2 = ggplotly(p1,
              tooltip = "text",
              source = "our_graph") %>% #<--UNIQUE ID JUST FOR THIS SYSTEM
  style(hoverinfo = "text") %>%
  event_register("plotly_click") #WHAT TYPE OF EVENT WE WANT TO WATCH FOR.



#In server, add new observer for tracking plotly clicks
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

