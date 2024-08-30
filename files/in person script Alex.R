
# Lessons 1 and 2 (Intro to Web Development and Project Setup) ------------



#Install packages if they haven't already done so:

install.packages("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "countrycode", "sf")

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
library(countrycode)

### LOAD DATA SETS
gap = as.data.frame(gapminder)
#THESE LINES WILL HELP US MUCH LATER.
gap$country = as.character(gap$country)
gap$continent = as.character(gap$continent)

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
#Adjusting the head box:
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
