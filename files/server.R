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
