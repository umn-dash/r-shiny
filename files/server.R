server = function(input, output, session) {

  #input$sorted_column #BAD!

  #TABLE
  output$table1 = renderTable({
    print(input$sorted_column)
    gap %>%
      arrange(!!sym(input$sorted_column))
  })
}
