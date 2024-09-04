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

}
