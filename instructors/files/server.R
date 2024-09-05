server = function(input, output, session) {

  #input$sorted_column #BAD!

  #TABLE
  # output$table1 = renderTable({
  # #  print(input$sorted_column)
  #
  #   input$go_button
  #   gap %>%
  #     arrange(!!sym(isolate(input$sorted_column)))
  # })

  #INITIAL TABLE
  output$table1 = renderDT({
    gap %>%
      datatable(
        selection = list(mode = "single", target = "cell"),
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

  #UPDATE UPON BUTTON PRESS USING PROXY
  observeEvent({input$go_button},
               ignoreInit = FALSE, {

                 sorted_gap = gap %>%
                   arrange(!!sym(input$sorted_column))

                 dataTableProxy(outputId = "table1") %>%
                   replaceData(data = sorted_gap,
                               resetPaging = FALSE)

               })

  #WATCH FOR CELL SELECTIONS
  observeEvent({input$table1_cells_selected}, {

    else_condition = renderText({}) #OUR ELSE CONDITION WILL BE TO RENDER NOTHING.

    if(length(input$table1_cells_selected) > 0) {

      row_num = input$table1_cells_selected[1]
      col_num = input$table1_cells_selected[2]

      if(col_num >= 4 & col_num <= 6) {

        #GET BASELINE DATUM FIRST
        datum = gap[row_num, col_num]

        #GENERATE A SORTED DATA SET
        sorted_gap = gap %>%
          arrange(!!sym(input$sorted_column))

        #GET THE VALUE IN THE CELL IN THE SAME LOCATION
        sorted_datum = sorted_gap[row_num, col_num]

        #COMPARE THOSE VALUES. IF THEY'RE THE SAME, THE TABLE *PROBABLY* ISN'T SORTED.
        if(sorted_datum == datum) {
          datum = datum
          country = gap$country[row_num]
          year = gap$year[row_num]
          #IF THEY ARE DIFFERENT, THE TABLE *PROBABLY* IS SORTED, AND WE SHOULD USE THE SORTED VERSION.
        } else {
          datum = sorted_datum
          country = sorted_gap$country[row_num]
          year = sorted_gap$year[row_num]
        }

        if(col_num == 4) {
          col_string = "life expectancy"
        }
        if(col_num == 5) {
          col_string = "population"
        }
        if(col_num == 6) {
          col_string = "GDP per capita"
        }

        output$selection_text = renderText({

          paste0("In ", year, ", ", country, " had a ",
                 col_string, " of ", datum, ".")
        })
        #ADD IN OUR ELSE CONDITIONS
      } else {
        output$selection_text = else_condition
      }
    } else {
      output$selection_text = else_condition
    }
  })

  ###MAP
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

  ###MAP OBSERVER (POLYGON CLICKS)
  observeEvent(input$basic_map_shape_click, {

    leafletProxy("basic_map") %>%
      flyTo(
        lat = input$basic_map_shape_click$lat,
        lng = input$basic_map_shape_click$lng,
        zoom = 5
      )

  })

  ###GRAPH
  output$basic_graph = renderPlotly({

    p2 %>%
      layout(
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE),
        legend = list(itemclick = FALSE,
                      y = 0.5,
                      yanchor = "middle"
                      )
      ) %>%
      config(modeBarButtonsToRemove = list("lasso2d"))

  })

  ##THIS OBSERVER UPDATES THE GRAPH WHEN EVENTS ARE TRIGGERED.
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

  #WE USE THE event_data() CALL LIKE ANY OTHER REACTIVE OBJECT.
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

}
