---
title: DTs and Leaflets and Plotlys, Oh my!
teaching: 60
exercises: 10
source: Rmd
editor_options: 
  markdown: 
    wrap: 72
---

::: objectives
-   Name the essential components of the `DT`, `leaflet` and `plotly`
    packages.
-   Experiment with the interactive features that come baked into the
    plots, tables, and maps produced by these packages.
-   Customize the look and feel of these complex interactive graphics.
-   Favor updating complex interactive graphics instead of remaking them
    whenever possible.
-   Use **proxies** to update only those aspects of a complex
    interactive graphic that *need* updating.
-   Recognize the event types a user might trigger with respec to these
    complex interactive graphics and the systems for watching for and
    handling them.
:::

::: questions
-   How do I add an interactive map, table, or graph to my app?
-   What types of interactivity will these widgets come with?
-   How do I adjust the look and feel of these widgets?
-   How can I modify these widgets in response to user actions without
    completely "starting over?"
-   What event types related to these widgets can I watch for, and how
    would I handle them?
:::

## Disclaimer

At two points in this lesson, the example code will produce **warnings**
(not **errors**!) when executed. These can be ignored; the code works as
intended!

## Introduction

While **input widgets** such as sliders, drop-down menus, checkboxes,
and buttons are powerful ways to give our users control, they aren't
always interesting or useful *by themselves*. There are *much* more
powerful widgets!

And, since we're building our apps using R—a programming language
*designed for* working with data—it make senses we'd specifically want
to include some widgets that put *data* at our users' fingertips in
interesting and useful ways.

Of all data-centered widgets, few are more familiar than **tables**,
**maps**, and **graphs**. Because these are *so* ubiquitous, it probably
won't be surprising to learn there are JavaScript-native packages for
creating web-enabled, interactive versions of these graphics. While
there are other such packages, here we'll explore `DT` (for tables),
`leaflet` (for maps), and `plotly` (for graphs), since each has been
ported into R + R Shiny via packages of the same names.

Each of these packages could *easily* be a course unto itself! As such,
we'll look *only* at the basics—greater depth can be found elsewhere
once you have learned the ropes.

Learning `leaflet` and `plotly`, specifically, come with particular
challenges we'll skirt around:

-   `leaflet` is for maps, which depend on **spatial data**. These and
    the packages that work with them (*e.g.*, `sf`), are *complicated*!
    I'll gloss over all the details to focus just on `leaflet`, but
    we'll need to borrow tools from `sf` and others to accomplish
    anything at all.

-   If you are familiar with `ggplot2` (or another data viz package),
    you already know that learning to make graphs programmatically
    demands a new "vocabulary." `plotly` has the same learning curve
    (perhaps steeper for R users, since it's *very* JavaScript-like
    whereas `ggplot2` is more R-like). We'll engage with just the
    minimum of `plotly`, but even that may be a lot for many learners.

Let's start simple—let's upgrade the table we already have by swapping
it for a `DT` table. Of the packages we're learning here, `DT` is
easiest, and it introduces all the key concepts we'll need for `leaflet`
and `plotly`.

### Turning the tables

#### Basic table

Let's start by simply swapping our `renderTable({})` and `tableOutput()`
calls with the equivalent `renderDT({})` and `dataTableOutput()` calls,
which work identically but yield a `DT`-style table instead:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

###TABLE
  output$basic_table = renderDT({ #<--CHANGE FUNCTION NAME HERE.

    input$go_button
    
    gap %>%
      arrange(!!sym(isolate(input$sorted_column)))
  })
```


``` r
##This code should **replace** the "main panel" cell's content within the BODY section of your ui.R file!

##... other UI code...

###MAIN PANEL CELL
    column(width = 8, tabsetPanel(
      ###TABLE TAB
      tabPanel(title = "Table", 
               dataTableOutput("basic_table")), #<--CHANGE FUNCTION NAME HERE.
      ###MAP TAB
      tabPanel(title = "Map",
      ###GRAPH TAB
      tabPanel(
        title = "Graph",
      )
    ))
   )

##... other UI code...
```

Once you've made those swaps, restart your app.

You'll *immediately* notice our table looks *very* different:

-   It's **paginated**, *i.e.*,"divided into pages." Users flip pages
    using buttons in the bottom-right. Users also change the page length
    using a drop-down menu in the top-left. These features allow users
    to limit the data shown at one time, and they also keeps the table
    from being long vertically if there are many rows' worth of data.

-   It's **searchable**—users can type **strings** (chunks of letters,
    numbers, and/or symbols) into the search box in the upper-right; the
    table will filter to only rows containing that string anywhere.

-   It's **sortable**—users can click the up/down arrows next to column
    names to sort the table. You'll note that this functionality makes
    our drop-down menu widget obsolete (for now)!

-   It's (modestly) styled—it's snazzier-looking than our previous Shiny
    table because it comes with some CSS automatically applied (bold
    column names and "zebra striping" of rows, as two examples).

-   It's **selectable**—users can click to highlight ("select") rows.
    This doesn't actually do anything server-side by default, but it
    could.

Now that we have a `DT` table, there are four things we'll *very*
commonly want to do with one (or any similarly complex interactive
graphic): 1) simplify it, 2) restyle it, 3) watch it for **events**, and
4) update it to **handle** those events.

Let's start with the first two of these desires.

#### More (or less) basic DT

As we just saw, `DT` tables come standard with many interactive
features! However, "more" is not always "better" from a **UX** (user
experience) standpoint. Some might find certain features confusing,
especially if they aren't necessary, are poorly explained, or don't do
anything obvious. Others may find having a lot of features overwhelming,
even if they understand them all.

The `datatable()` function's `options` input allows us to reel in the
features included:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

###TABLE
  output$basic_table = renderDT({

    input$go_button
    
    gap %>%
      arrange(!!sym(isolate(input$sorted_column))) %>%
      datatable(
        selection = "none", #<--TURNS OFF ROW HIGHLIGHTING
        options = list(
          info = FALSE, #<--NO BOTTOM-LEFT INFO
          ordering = FALSE, #<--NO SORTING
          searching = FALSE #<--NO SEARCH BAR
        )
      )
  })
```

That's better! This version should be more digestible and intuitive (and
easier to explain and program!).

More broadly, *if a `DT` table or any other complex interactive graphic
has a feature, you should assume there's a way to turn that feature off
(you may just have to Google for the specific input needed to do it).*

Next, let's boost our table's aesthetics a little. Let's make three
changes:

1.  Round the GDP per capita data.

2.  Make the `continent` column center-aligned.

3.  Highlight in pink all rows with `lifeExp` values \> `70`.

We'll use a functions from the `format*()` and `style*()` families to
accomplish these goals, specifically `formatRound()`, `formatStyle()`,
and `styleEqual()`:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

###TABLE
  output$basic_table = renderDT({

    input$go_button
    
    gap %>%
      arrange(!!sym(isolate(input$sorted_column))) %>%
      datatable(
        selection = "none",
        options = list(
          info = FALSE,
          ordering = FALSE,
          searching = FALSE
        )
      ) %>%
      #HERE, WE WRITE 'R-LIKE' CSS. WE USE camelCase FOR PROPERTIES, TEXT STRINGS FOR VALUES, AND = INSTEAD OF : TO SEPARATE THEM (COMPARE TO [text-align: center;]).
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
```

`format*()` functions ask us to pick 1+ columns to restyle. Then, we
provide **property** and **value** pairings, just as in CSS, but using
an "R-like" syntax instead, *e.g.*, `textAlign = center` in R Shiny
versus `text-align: center;` in CSS.

If we want to format a column **conditionally**, *i.e.*, formatting only
some rows according to a rule, we use the `style*()` functions. In the
example above, we used `styleEqual()` to apply a light pink background
to only rows with life expectancy greater than `70`.

#### Update, don't remake!

So far, when user actions have dictated a change to the data in our
table (*e.g.*, how it's sorted), we've re-rendered the *entire* table to
**handle** those **events**.

While this works, it's undesirable for (at least) three reasons:

1.  With large data sets, it could be slow!

2.  To the user, the table may appear to "flicker" out and in again as
    it's remade, if the process is fast.

    1.  If the process is slow, the table will instead "gray out" and
        the whole app will freeze while the code needed to remake the
        table completes.

3.  If the user had customized the table in any way (they've navigated
    to a specific page, *e.g.*), those customizations will be lost if we
    rebuild the table from scratch.

If you think about it, if *all* we're doing is changing the data in our
table, there's no need to remake the *whole* table—we could just
repopulate the contents of its cells, right? *Whenever possible,* *we
should update a complex element rather than wholly remake it.*

To update widgets "on the fly," we use something called a **proxy**,
which is like a telephone that lets R (on the server side) and
JavaScript (on the client side) talk directly to adjust a widget's
*contents* without redrawing any aspects of the widget other than just
those that need to be redrawn.

`DT`'s function `dataTableProxy()` takes as input the `outputId` of the
table we're updating. We then pipe that call into the helper function
`replaceData()`, which specifically allows us to swap out the data being
shown in a table's cells (and adjusting the number of these as needed).

Before we can use these tools, though, we should create a reason we'd
need to swap one data set for another! Earlier, I mentioned that `DT`
tables have a `selection` feature, which allows users to select
rows/columns/cells. Doing so is an **event** that R Shiny can watch for,
and although these events are not handled by default, we can change
that!

So, let's set up a system in which a user can click any cell in our
table to select it. When they do, we'll filter the table to only rows
sharing that same value in that same column (e.g., clicking a cell
containing `Asia` will filter to only other rows containing data from
`Asia`). Meanwhile, when no cell is selected, the table isn't filtered.

Sounds complicated? It's actually not too bad! Below, we'll take this
step by step. For each step, implement the coding change, run the app,
and make sure you understand any changes you observe in how the app
behaves.

First, let's use `renderTable({})` and `DTOutput()` to make the "base"
version of our table, just as we have been. This time, though, the
"bones" of the table made in this way will *never* change:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

##... other server code...

###TABLE
  output$basic_table = renderDT({
    
    ##STEP 1: WE SIMPLIFY OUR renderDT({}) CALL SO IT CONTAINS NO REACTIVE OBJECTS. THIS WILL RUN ONLY ONCE, AS THE APP STARTS. 
    gap %>%
      datatable(
        selection = "none",
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
```

Next, let's turn on `selection` inside `datatable()` by changing the
input from `"none"` to `list(mode = "single", target = "cell")`, such
that users can select single cells at a time:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

##... other server code...

###TABLE
  output$basic_table = renderDT({
    gap %>%
      datatable(
        selection = list(mode = "single", target = "cell"), #<--STEP 2: WE CHANGE SELECTION FROM NONE (NO SELECTION) TO ESSENTIALLY "SELECT UP TO ONE CELL AT A TIME."
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
```

At this point, our table no longer responds to our drop-down menu or
button because we're removed the corresponding `input` subobjects from
the `renderDT({})` code block.

It also doesn't yet respond to cell selection. Let's fix that by
introducing an '`observeEvent({},{})` that watches for the "Go!" button
and arranges the data according to our selection in our drop-down menu.
This time, though, we'll use `dataTableProxy()` and `replaceData()` to
update, rather than remake, the table:


``` r
##This code should be **added to** your server.R file inside your server function and preferrably below your renderTable({}) call!

##... other server code...

###TABLE OBSERVER (CELL SELECTION)
##STEP 3: ADD AN OBSERVER WATCHING OUR BUTTON. WHEN IT'S PRESSED, SORT OUR DATA. 
observeEvent(input$go_button, {

   gap_sorted = gap %>% 
      arrange(!!sym(input$sorted_column))

   #FEED THE SORTED DATA INTO A PROXY TO UPDATE JUST THE CONTENTS OF OUR TABLE'S CELLS. 
    dataTableProxy("basic_table") %>%
    replaceData(data = gap_sorted, 
                clearSelection = FALSE) #<-BUT KEEP ANY NEWLY SELECTED CELLS SELECTED!
 })
```

This observer restores the original functionality of our button and
drop-down menu, but it *doesn't* yet handle cell selection. We need this
observer to also watch for changes in cell selections too. But how?

Like others widget, *`DT` tables pass information from the UI to the
server constantly using the `input` object.* We can access that
information server-side using `input$outputId_*` format.

In this case, the `*` here will be `cells_selected` because that's the
event type we're interested in. By making our first expression to
`observeEvent({},{})` into a list, we can have our observer watch more
than one input for changes:


``` r
##This code should **replace** the observeEvent({},{}) we introduced in the previous example!

##... other server code...

###TABLE OBSERVER (CELL SELECTION)
##STEP 4: EXTEND THE FIRST EXPRESSION IN OUR OBSERVE TO A LIST INCLUDING BOTH THE GO BUTTON AND THE REACTIVE OBJECT FOR TABLE CELL CLICKS.
observeEvent(list(input$go_button,
                  input$basic_table_cells_selected), {
                    
  ##THIS LINE WILL PRINT TO THE R CONSOLE THE INFO SENT TO THE SERVER WHEN A CELL IS CLICKED. YOU'LL SEE IT'S A MATRIX WITH 1 ROW AND 2 COLUMNS CONTAINING THE ROW AND COLUMN NUMBERS OF THE CELL SELECTED.
  print(input$basic_table_cells_selected)

   gap_sorted = gap %>% 
      arrange(!!sym(input$sorted_column))
   
    dataTableProxy("basic_table") %>%
    replaceData(data = gap_sorted, 
                clearSelection = FALSE) 
 })
```

If you run the app now and start selecting cells, you'll observe that
`input$basic_table_cells_selected` returns a matrix when accessed.
Either this matrix has no rows (when no cell is selected) or one row
with two values: a row number and a column number for the cell selected.

We'll use that info to find the value in the cell selected as well as
the name of the corresponding column. We can then filter our data set
accordingly (all this requires some good-old "R" data wrangling!):


``` r
##This code should **replace** the observeEvent({},{}) we introduced in the previous example!

##... other server code...

  ###TABLE OBSERVER (CELL SELECTION)
  observeEvent(list(input$go_button, input$basic_table_cells_selected), {

    ##STEP 5: WE GET THE VALUE IN THE CELL SELECTED...
      val2match = gap[input$basic_table_cells_selected[1], input$basic_table_cells_selected[2], drop = T]
      
    #...AND THE NAME OF THE COLUMN SELECTED...
      col2match = names(gap)[input$basic_table_cells_selected[2]]
      
    #...AND FILTER TO ONLY ROWS MATCHING THAT VALUE.
      gap_filtered = gap[gap[, col2match] == val2match, ]
      
      #WE ARRANGE AS NORMAL...
      gap_sorted = gap_filtered %>% #<-BUT UPDATE TO gap_filtered here.
        arrange(!!sym(input$sorted_column))
      
      dataTableProxy("basic_table") %>%
        replaceData(data = gap_sorted,
                    clearSelection = FALSE)
      
  })
```

If the "normal R" code in this example looks stressful, don't worry
about the specifics—just read my comments to know what we're trying to
accomplish.

Our observer now works great! Try it and see for yourself.

...Except there's no "undo." Once we select a cell, we filter out all
rows that don't match, and those rows are "lost" to the user because
there's no way to restore them. And further clicks only cause loss of
more rows!

This is because we didn't **handle** the *other* possibility: that the
user has not selected any cell (or that they've de-selected the cell
they just had selected, which is functionally the same).

Whenever no cell is selected, we need to "return" to the original
`gapminder` data set, albeit sorted appropriately. We can handle this
scenario using `if()/else`:


``` r
##This code should **replace** the observeEvent({},{}) we introduced in the previous example!

##... other server code...

  ###TABLE OBSERVER (CELL SELECTION)
  observeEvent(list(input$go_button, input$basic_table_cells_selected), {
    
    ##STEP 6: WE ADD IN AN IF/ELSE PAIR. WE RESPOND ACCORDINGLY WHETHER THERE IS A CELL SELECTED OR NOT.
    if (nrow(input$basic_table_cells_selected) > 0) {
      
      val2match = gap[input$basic_table_cells_selected[1], input$basic_table_cells_selected[2], drop = T]
      
      col2match = names(gap)[input$basic_table_cells_selected[2]]
      
      gap_filtered = gap[gap[, col2match] == val2match, ]
      
      gap_sorted = gap_filtered %>%
        arrange(!!sym(input$sorted_column))
      
      dataTableProxy("basic_table") %>%
        replaceData(data = gap_sorted, clearSelection = FALSE)
      
    } else {
      #OTHERWISE, WE SIMPLY SORT THE ORIGINAL GAPMINDER DATA SET AS WE HAVE PREVIOUSLY. 
      gap_sorted = gap %>%
        arrange(!!sym(input$sorted_column))
      
      dataTableProxy("basic_table") %>%
        replaceData(data = gap_sorted, clearSelection = FALSE)
      
    }
    
  })
```

Now, we can filter and unfilter our table with just a click! This
functionality could empower a variety of dynamic, engaging workflows for
your users.

::: challenge
Using if/else to handle "undoing" previous actions works really well,
but some users could find it unintuitive. They might not even realize
it's something they can do!

A more conventional, "expected" approach might be a "reset" button that
restores the original table when pressed.

See if you can figure out how to build such a button *without* losing
*any* of the app's current functionality.

If you succeed, consider whether you, as a user, would prefer the
"select nothing to undo" functionality or the "reset button"
functionality, or if you'd prefer having both.

::: solution
First, we add the reset button to our UI, just below the current "Go!"
button:


``` r
##This code should **be added to** the "sidebar" content of the Table tabPanel in the BODY section of your ui.R file!

##... other UI code...
actionButton(inputId = "go_button",
                        label = "Go!")),
actionButton(inputId = "reset_button",
                        label = "Reset!")),
  ##... other UI code...
```

Then, in our server file, we add a new observer to watch that button and
handle when a user presses it. This is pretty simple here: we use our
proxy to restore the original `gapminder` data set:


``` r
##This code should be **added to** your server.R file, underneath all other contents inside of your server function!

observeEvent(input$reset_button, {
              
  ##WE REWIND ALL THE WAY BACK TO THE ORIGINAL GAPMINDER DATA AND CLEAR ANY SELECTIONS THE USER MAY ALREADY HAVE MADE.
    dataTableProxy("basic_table") %>%
    replaceData(data = gap, 
                clearSelection = TRUE) 
     
 })
```

As for what I prefer, I think I'd rather have both functionalities.
Together, they make our app more accessible because, while the "click to
undo" approach is easy and precise as an undo mechanism, not every user
may discover or understand it (unless they're trained well!).

A reset button, meanwhile, is something nearly everyone understands
intuitively. The way we've coded it here is pretty "aggressive" in that
it undoes *everything*, but that will at least match with the
expectations of most users.

And, on the plus side, the reset button enables undoing any sorting,
functionality that didn't previously exist in any previous version we've
had!
:::
:::

### Putting us on the map

#### Setup

Before we go any further, we need to "massage" our data set to make it
ready for mapping (spatial data are complicated!). Add the following to
your `global.R` file at the end *verbatim*. Don't worry about what it
does, though!


``` r
###MASSAGE DATA SET FOR MAKING MAPS
gap$country = as.character(gap$country)
gap$continent = as.character(gap$continent)

gap$ID = countrycode(gap$country, "country.name", "iso3c")
world = read_sf("TM_WORLD_BORDERS_SIMPL-0.3.shp") #<--THIS FILE CAN BE DOWNLOADED VIA <https://drive.google.com/file/d/1Ta0GSnoJPyEMFjjbpzE3Z8RD0Mq18RL7/view?usp=sharing>. MAKE SURE TO UNZIP IT AND MOVE IT AND ALL ITS COMPANION FILES INTO YOUR R PROJECT FOLDER!

world2 = world %>% select(ISO3, geometry)
gap_map = left_join(gap, world2, by = c("ID" = "ISO3"))
gap_map = st_as_sf(gap_map)
```

#### Preface

`DT` has shown us how more complex widgets operate in R Shiny, so we can
switch to making map widgets using `leaflet`. We'll follow the same
roadmap we just used for `DT`:

1.  We'll start with a basic map.

2.  Then, we'll adjust some features and dress up its aesthetics.

3.  Lastly, we'll learn about map-specific events and how to handle
    those events *without* redrawing the entire map.

The specifics will be different, but all the concepts here we've already
been introduced to, so we can get another round of practice with them.

#### Basic map

Let's make a `leaflet` map showing the countries in our data set colored
by their 2007 life expectancy data. We'll place the result in our UI's
"Map" tab panel.

Every `leaflet` map has three building blocks:

1.  A `leaflet()` call. This function is like `ggplot()` from the
    `ggplot2` package—it "sets the stage" for the rest of the graphic,
    and you can specify some settings here that'll apply to all
    subsequent components.

2.  A `addTiles()` call. This function place's a "tile," or background,
    on your map. This is that thing indicating where lakes and roads and
    boundaries are! We'll use the default tile here, but there are many
    others to choose from.

3.  At least one `add*()` function call for adding **spatial data** to
    our map. There are others, but the three most commonly used ones
    are:

    1.  `addMarkers()` adds **spatial point** (0-dimensional) **data**
        (like the locations of restaurants).

    2.  `addLines()` adds **spatial line/curve** (1-dimensional)
        **data** (like roads or rivers).

    3.  `addPolygons()` adds **spatial polygon** (2-dimensional)
        **data** (like country boundaries).

Here, we'll use `addPolygons()`:


``` r
##This code should **swapped** for the the "main panel" content in the BODY section of your ui.R file!

##... other UI code...

###MAIN PANEL CELL
    column(width = 8, tabsetPanel(
      ###TABLE TAB
      tabPanel(title = "Table", dataTableOutput("basic_table")),
      ###MAP TAB
      tabPanel(title = "Map", leafletOutput("basic_map")), #<--ADD OUR NEW MAP.
      ###GRAPH TAB
      tabPanel(
        title = "Graph",
      )
    ))
  ##... other UI code...
```


``` r
##This code should be **added to** your server.R file, underneath all other contents inside of your server function!

 ##... other server code...

###MAP
  output$basic_map = renderLeaflet({

    ##FILTER TO ONLY 2007 DATA.
    gap_map2007 = gap_map %>%
      filter(year == 2007)

    leaflet() %>% #<--GETS THINGS STARTED
      addTiles() %>% #<--ADDS A BACKGROUND 
      addPolygons(
        data = gap_map2007$geometry, #SPECIFY OUR SPATIAL DATA (geometry IS AN sf PACKAGE CONSTRUCTION)
        color = "black", #<-BLACK OUTLINE
        weight = 2) #THICKER-THAN-DEFAULT OUTLINE.
    
  })
```

The code above creates a nice, if somewhat basic, interactive map
showing the countries for which we have data, outlined in black. Notice
that you can **pan** the map by clicking anywhere, holding the click,
and moving the mouse.

Notice that you can also **zoom** the map in or out using your mouse
wheel (if you have one), or by using the plus/minus buttons in the
top-left corner. Double-clicking on the map also zooms in.

If you zoom in a lot, you'll see the tile change to show greater detail.
If you zoom out, you'll see the world actually repeat several times
left-to-right, if your screen is wide enough...pretty weird!

#### More (or less) basic map

As we just saw, it often doesn't make sense to allow users to **pan**
and **zoom** without any guardrails—they can get lost or produce
unhelpful visual quirks to arise. As I noted earlier, `leaflet()`
contains many global settings we can apply to our map. For example, we
can set min and max zoom levels like so:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...

###MAP
  output$basic_map = renderLeaflet({

    gap_map2007 = gap_map %>%
      filter(year == 2007)

    ##THE leaflet() FUNCTION HAS A LIST OF OPTIONS WE CAN ADJUST, SUCH AS THE MIN AND MAX ZOOM LEVELS.
    leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
      addTiles() %>%
      addPolygons(
        data = gap_map2007$geometry,
        color = "black", 
        weight = 2)
    
  })
```

A `minZoom` of 2 is one in which *almost* the entire world is visible at
once (on my laptop, anyway!). A `maxZoom` of 6 allows users to zoom into
specific continental regions but no further. This keeps users from
zooming in or out to a degree that doesn't really make sense given our
data.

We can also set **maximum bounds**—users can't **pan** the map past
these:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...

###MAP
  output$basic_map = renderLeaflet({

    gap_map2007 = gap_map %>%
      filter(year == 2007)
    
    #THE SF PACKAGE'S st_bbox() FUNCTION GETS THE FOUR POINTS THAT WOULD CREATE A BOX FULLY BOUNDING ALL SPATIAL DATA WE GIVE IT AS INPUTS.
    bounds = unname(sf::st_bbox(gap_map2007))

    leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
      addTiles() %>%
      addPolygons(
        data = gap_map2007$geometry,
        color = "black", 
        weight = 2) %>%  
      ##setMaxBounds() TAKES, AS INPUTS, THOSE EXACT SAME FOUR POINTS.
      setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])
    
  })
```

When a user tries to pan past the bounds, the map will "snap back" to a
focus point within the bounds.

While there are other features we could adjust or disable, setting
bounds and a minimum and maximum zoom are two things you'll generally
want to do to every map you make.

##### Adding some pizzazz

Our map is still rather basic-looking. In fact, it doesn't even fulfill
the minimum specifications we'd set—it doesn't show the life expectancy
data yet.

To fix that, we need to set up a **color palette** so `leaflet` knows
*how* to fill our country polygons (it's a *little* fussy!). We can
build a color palette using `leaflet`'s `colorNumeric()` function.

This function has two required inputs: a `palette`, the name of the R
color palette we'd like to use, and a `domain`, the set of values we'll
need colors for in our final palette:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...
###MAP
  output$basic_map = renderLeaflet({

    gap_map2007 = gap_map %>%
      filter(year == 2007)
    
    bounds = unname(sf::st_bbox(gap_map2007))
    
    #ESTABLISH A COLOR SCHEME TO USE FOR OUR FILLS.
    map_palette = colorNumeric(palette = "Blues", domain = unique(gap_map2007$lifeExp))
    
    leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
      addTiles() %>%
      addPolygons(
        data = gap_map2007$geometry,
        color = "black", 
        weight = 2) %>%  
      setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])
    
  })
```

Once `leaflet` knows every value it'll need a color for (`domain`) and
every color it should use (`palette`), we can add coloring instructions
to `addPolygons()`:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...

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
        color = "black", #<--NOTICE THAT THE OUTLINE ("STROKE") HAS A DIFFERENT COLOR PARAMETER THAN THE FILL.
        weight = 2,
        fillColor = map_palette(gap_map2007$lifeExp), #<--WE USE OUR NEW COLOR PALETTE LIKE A FUNCTION, SPECIFYING OUR DATA AS INPUTS.
        fillOpacity = 0.75) %>%  #<--THE DEFAULT, 0.5, WASHES OUT THE COLORS TOO MUCH.
      setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4])
    
  })
```

This is already a *much* cooler map!

But shouldn't there be a **legend** that clarifies what colors go with
what values? We can add one using `addLegend()`:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...
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
        fillColor = map_palette(gap_map2007$lifeExp),
        fillOpacity = 0.75) %>% 
      setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
      #ADD A LEGEND TO THE MAP
      addLegend(
        position = "bottomleft", #<--WHERE TO PUT IT.
        pal = map_palette, #<--COLOR SCHEME TO USE.
        values = gap_map2007$lifeExp, #WHAT SCALE ANCHORS ("BREAKS") TO USE.
        opacity = 0.75, #LEGEND TRANSPARENCY.
        bins = 5, #NUMBER OF BREAKS TO HAVE.
        title = "Life<br>expectancy ('07)" #LEGEND TITLE.
      )
    
  })
```

This is a nice looking map!

...But what if our users don't know much geography, so they don't know
which countries are which? Or what if they wanted to know the *exact*
life expectancy value for a country? This map couldn't easily address
either issue.

Adding **tooltips** would help address both. A tooltip is a small pop-up
that might appear on mouse hover (in `leaflet`, those are called
"labels"), on mouse click (leaflet calls these "popups"), or after some
other action.

Using the `popup` parameter inside `addPolygons()`, we can add tooltips
that appear and disappear on mouse click. Inside these, we'll put the
name of the country being clicked on, in case users don't know their
countries well:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...
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
        fillColor = map_palette(gap_map2007$lifeExp),
        fillOpacity = 0.75,
        popup = gap_map2007$country) %>% #<--MAKE A TOOLTIP HOLDING THE RELEVANT COUNTRY APPEAR/DISAPPEAR ON MOUSE CLICK. 
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
```

This is a nice addition, but what if we wanted to add life expectancy
values too? And keep the result human-readable? There are many
approaches we could take, but one using "Normal R's" versatile
`paste0()` function plus the HTML line break element (`<br>`) is
straightforward:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...
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
        fillColor = map_palette(gap_map2007$lifeExp),
        fillOpacity = 0.75,
        popup = paste0("County: ", #<--WE USE R'S paste0() FUNCTION AND THE HTML LINE BREAK ELEMENT <br> TO MAKE THE TOOLTIP TEXT VERY READABLE AND INFO-RICH.
                       gap_map2007$country,
                       "<br>Life Expectancy: ",
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
```

Now, our map is both snazzy and informative!

::: challenge
In the previous example, we used `popup` to build our tooltips. Try
using the `label` parameter instead. For whatever reason, this requires
more "normal R" data wrangling, so here's the *exact* code you'll need
(feel free to copy and paste it!):


``` r
label = lapply(1:nrow(gap_map2007), function(x){ 
                    HTML(paste0("County: ",
                                 gap_map2007$country[x], 
                                 "<br>Life Expectancy: ", 
                                gap_map2007$lifeExp[x]))})
```

What changes? Which do you prefer? Which would be better if a lot of
your users will use mobile devices, do you think?

::: solution
If we use `label`, we get tooltips that appears on mouse hover instead
of on mouse click. Actually, this is *probably* more intuitive for most
users; many will not expect a click to do anything and may only discover
our on-click-style tooltips by accident!

On the other hand, tooltips that appear on hover can be annoying if a
user is trying to, *e.g.*, trace a path with their mouse and irrelevant
tooltips keep getting in the way or providing distractions.

Also, an advantage of on-click tooltips is that they *don't* disappear
until a user is ready for them to do so, whereas tooltips that disappear
when the mouse is moved can prevent users from consulting a tooltip
while also using their mouse somewhere else on the page.

However, the biggest potential disadvantage of "on-hover" tooltips is
that, while there is an equivalent to a mouse click on touchscreen
devices (a finger press), there is no *universal* equivalent to a mouse
hover (some browsers and platforms use a "long press" for this, but not
all, and many users are not accustomed to taking that action anyway!).

So, mobile users won't generally see tooltips if they appear *only* on
hover. If we're aiming for "mobile-first" design, the `popup` option is
better (which is why I picked it)!

However, note that by using `labelOptions`, we can adjust which events
cause tooltips to appear, *e.g.*, we can make them appear on both hover
and on touch.
:::
:::

### Update, don't remake, `leaflet` edition!

At this stage, our users have *no* control over *which* data are shown
in our map. Let's give them that control by adding a **slider input
widget** that will let them select which year's data is plotted:


``` r
##This code should **replace** the "sidebar panel" cell's content within the BODY section of your ui.R file!

##... other UI code...

###SIDEBAR CELL
    column(
      width = 4,
      selectInput(
        inputId = "sorted_column",
        label = "Select a column to sort the table by.",
        choices = c(
          "Country" = "country",
          "Continent" = "continent",
          "Year" = "year",
          "Life expectancy" = "lifeExp",
          "Population size" = "pop",
          "GDP per capita" = "gdpPercap"
        )
      ),
      actionButton(inputId = "go_button", label = "Go!"),
      # actionButton(inputId = "reset_button",
      #                   label = "Reset!"),
      #ADD OUR NEWEST SLIDER WIDGET
      sliderInput(
        inputId = "year_slider",
        label = "Pick what year's data are shown in the map.",
        value = 2007, #<--SET THE DEFAULT CHOICE
        min = min(gap$year), #<--MIN AND MAX POSSIBLE SELECTIONS
        max = max(gap$year),
        step = 5, #<--HOW FAR APART CAN CHOICES BE?
        sep = "" #<--DON'T USE COMMAS TO SEPARATE THE THOUSANDS PLACE.
      )),
  ##... other UI code...
```


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...
###MAP
  output$basic_map = renderLeaflet({
    ##WE'LL KEEP THIS DATASET NAMED AFTER YEAR 2007. WE'LL SEE WHY A BIT LATER.
    gap_map2007 = gap_map %>%
      filter(year == as.numeric(input$year_slider)) #<--INTRODUCE THE  SLIDER'S CURRENT VALUE. EVERY CHANGE TO THIS WILL TRIGGER'S OUR renderLeaflet({}) CODE TO RERUN.
    
    bounds = unname(sf::st_bbox(gap_map2007))
    
    map_palette = colorNumeric(palette = "Blues", domain = unique(gap_map2007$lifeExp))
    
    leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
      addTiles() %>%
      addPolygons(
        data = gap_map2007$geometry,
        color = "black",
        weight = 2,
        fillColor = map_palette(gap_map2007$lifeExp),
        fillOpacity = 0.75,
        popup = paste0("County: ",
                       gap_map2007$country,
                       "<br>Life Expectancy: ",
                       gap_map2007$lifeExp)
        # label = lapply(1:nrow(gap_map2007), function(x) {
        #   HTML(
        #     paste0(
        #       "County: ",
        #       gap_map2007$country[x],
        #       "<br>Life Expectancy: ",
        #       gap_map2007$lifeExp[x]
        #     )
        #   )
        # })
      ) %>%
      setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
      addLegend(
        position = "bottomleft",
        pal = map_palette,
        values = gap_map2007$lifeExp,
        opacity = 0.75,
        bins = 5,
        title = paste0("Life<br>expectancy (", gap_map2007$year[1], ")") #<-HERE, WE GET FANCY USING R's paste0() FUNCTION TO MAKE SURE THE "RIGHT" YEAR IS ALWAYS THE ONE IN THE LEGEND TITLE.
      )
    
  })
```

This new functionality gives users a new and exciting way to explore the
data!

...However, the way we handle events involving this new input is *not*
ideal. Each time a user adjusts the slider, the map is *entirely*
rebuilt. With maps, this can be *especially* problematic because spatial
data can be *very* voluminous, so re-rendering a map from scratch can
cause long loading times.

Just as with `DT`, `leaflet` features a **proxy system** that will let
us update a map, only changing features that *need* to change.

Let's switch to using that proxy system. The approach will be the same
as with `DT`:

1.  We use `renderLeaflet({})` to produce *just* the "starting" version
    of the map that the user sees upon startup.

2.  We use a new `observeEvent({},{})` to watch for relevant events.

3.  Inside the observer, we use a proxy built using `leafletProxy()`,
    which is analogous to `dataTableProxy()`, to update our map:


``` r
##This code should be **swapped for** the renderLeaflet({}) code provided previously, inside of your server function!

 ##... other server code...

###MAP
#renderLeaflet({}) ONLY BUILDS THE FIRST VERSION OF THE MAP. NO REACTIVE OBJECTS HERE, SO IT'LL NEVER RERUN.
  output$basic_map = renderLeaflet({
    gap_map2007 = gap_map %>%
      filter(year == 2007) #<--RESTORE THIS TO 2007 (OUR DEFAULT YEAR).
    
    bounds = unname(sf::st_bbox(gap_map2007))
    
     #WE MOVE THE CODE MAKING map_palette TO GLOBAL.R SO IT ONLY RUNS ONCE EVER.
    
    leaflet(options = tileOptions(maxZoom = 6, minZoom = 2)) %>%
      addTiles() %>%
      addPolygons(
        data = gap_map2007$geometry,
        color = "black",
        weight = 2,
        fillColor = map_palette(gap_map2007$lifeExp),
        fillOpacity = 0.75,
        popup = paste0("County: ",
                       gap_map2007$country,
                       "<br>Life Expectancy: ",
                       gap_map2007$lifeExp)
        # label = lapply(1:nrow(gap_map2007), function(x) {
        #   HTML(
        #     paste0(
        #       "County: ",
        #       gap_map2007$country[x],
        #       "<br>Life Expectancy: ",
        #       gap_map2007$lifeExp[x]
        #     )
        #   )
        # })
      ) %>%
      setMaxBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
      addLegend(
        position = "bottomleft",
        pal = map_palette,
        values = gap_map2007$lifeExp,
        opacity = 0.75,
        bins = 5,
        title = paste0("Life<br>expectancy (", gap_map2007$year[1], ")")
      )
    
  })
  
  ###MAP OBSERVER (SLIDER)
  #A NEW OBSERVER WATCHES FOR EVENTS INVOLVING OUR NEW SLIDER.
  observeEvent(input$year_slider, {
    gap_map = gap_map %>% #<--NOTE THE NAME CHANGE OF THE PRODUCT HERE.
      filter(year == as.numeric(input$year_slider)) #<--SLOT THAT SLIDER'S INPUT OBJECT HERE.
    
  #WE USE leafletProxy({}) TO UPDATE OUR MAP INSTEAD OF RE-RENDERING IT. 
    leafletProxy("basic_map") %>%
      #WE DON'T HAVE TO MESS WITH THE ZOOM, BOUNDS, OR TILES BECAUSE THOSE ASPECTS AREN'T CHANGING. 
      clearMarkers() %>% #<--WE DO NEED TO REMOVE THE OLD MARKERS THOUGH BECAUSE THEIR COLORS WILL CHANGE.
      clearControls() %>% #<--SAME WITH THE LEGEND ("CONTROL") FOR THE SAME REASON.
      addPolygons( #<--WE RE-BUILD OUR POLYGONS EXACTLY THE SAME AS ALWAYS...
        data = gap_map$geometry, #<--EXCEPT WE REFERENCE gap_map THROUGHOUT.
        color = "black",
        weight = 2,
        fillColor = map_palette(gap_map$lifeExp),
        fillOpacity = 0.75,
        popup = paste0("County: ",
                       gap_map$country,
                       "<br>Life Expectancy: ",
                       gap_map$lifeExp)
        # label = lapply(1:nrow(gap_map), function(x) {
        #   HTML(
        #     paste0(
        #       "County: ",
        #       gap_map$country[x],
        #       "<br>Life Expectancy: ",
        #       gap_map$lifeExp[x]
        #     )
        #   )
        # })
      ) %>%
      addLegend( #<--WE RE-BUILD OUR LEGEND EXACTLY THE SAME WAY TOO. 
        position = "bottomleft",
        pal = map_palette,
        values = gap_map$lifeExp,
        opacity = 0.75,
        bins = 5,
        title = paste0("Life<br>expectancy (", gap_map$year[1], ")")
      )
    
  })
```


``` r
##This code should be **added** to the bottom of your global.R file, after gap_map is made!

###MAP COLOR PALETTE
#WE MOVE THIS CODE TO GLOBAL.R SO IT NEED ONLY EVER RUN ONCE.
map_palette = colorNumeric(palette = "Blues", domain = unique(gap_map$lifeExp))
```

Since this overhaul was a little involved, let's break down the key
pieces:

1.  First, for simplicity, we removed the code producing our
    `map_palette` from `renderLeaflet({})`. Why? Now that we will use
    this palette in two places, it's more efficient to have this code in
    `global.R` where it can run just once ever and be reused whenever
    needed.

    -   This has the added benefit of ensuring every version of our map
        will always use the exact same color-value mapping! Otherwise,
        our `domain`s would shift, depending upon which year's data are
        being shown, making it harder to see patterns over time.

2.  We "strip back" the code in `renderLeaflet({})` such that it
    contains no reactive objects (*e.g.*, `input$year_slider`). As such,
    it'll run once when the app starts up but never again.

3.  We create a new `observeEvent({},{})` watching our slider. When it's
    value changes, `leafletProxy()` will dictate what happens.

4.  We feed our proxy *only* commands affecting aspects that *need* to
    change—in this case, we reference just our polygons and legend
    (because their colors need to change).

    -   We first remove the old versions using `clear*()` functions.

    -   Then, we rebuild each exactly as we built them originally but
        based on new data selected by the user.

Once you've made these changes, start the app and observe what happens
when you adjust the slider. You'll hopefully notice that doing so
results in "smoother" updates than before.

### Watch and learn

`leaflet` maps are **widgets** just like all the rest we've seen, so
information about user interactions with them are being *constantly*
passed from the UI to the server by `input`. These data can be accessed
using `input$outputId_*` format.

For example, whenever a user **double-clicks** a location, this is
registered as a "double click event," and we can access information
about that location using `input$outputId_dblclick` format server-side.
[There is "single-click event tracking" too, but because our popups
respond to single clicks already, let's consider double-clicks here.]

A cool feature of `leaflet` maps is `flyTo()`, which will pan and zoom a
map to center on a specific location.

Let's combine these two features (`flyTo` plus double-click event
tracking)! Let's create a new observer that watches for double-clicks,
and, when one happens, a `leafletProxy()` centers the map on that
location:


``` r
##This code should be **added** to the bottom of your server.R file, but still within your server function!

###MAP OBSERVER (DOUBLE CLICKS)
#WE TRACK CHANGES IN THE DOUBLE-CLICK STATUS OF OUR MAP AND USE THAT INFO TO FLY TO THE LOCATION OF THE DOUBLE-CLICK.
  observeEvent(input$basic_map_dblclick, {
    leafletProxy("basic_map") %>%
      flyTo(
        lat = input$basic_map_dblclick$lat,
        lng = input$basic_map_dblclick$lng,
        zoom = 5
      )
    
  })
```

## Getting graphic

We'll now turn to `plotly`, a package for producing graphs, similar to
`ggplot2`, but that are *interactive* *by design*.

Regular R users who know `ggplot2` know that learning a graphics package
is like learning a new language! The learning curve is *significant*;
these packages give users *all* the tools needed to design an entire,
complex graph piece by piece. That's a lot of tools to learn and to keep
straight!

`plotly` is no different—you can create ultra-detailed,
publication-quality graphics with `plotly` too, but you'll need to learn
a new vernacular to do it, one that may feel similar to `ggplot2` but
probably not ultra-similar.

As such, covering `plotly` in depth is outside our scope here.
Thankfully, we actually don't *need* to learn it; `plotly` comes with an
*incredible* "cheat code" that, while imperfect, will work fine here:
the `ggplotly()` function.

`ggplotly()` takes a fully realized `ggplot`, breaks it down into
pieces, and rebuilds it piece by piece in `plotly`'s system (as best as
it can). Because the two systems are ultimately similar, you'll get a
similar-looking graph out the end, but it'll now have all the
interactive features a scratch-built `plotly` graph would have.

However, the two systems *don't* map 1-to-1, so the result will never
look *exactly* the same as the input graph. In particular, complex
customizations using `ggplot`'s `theme()`, text-related components,
advanced or new features, and so on don't make the transition well.

So, it's probably correct to say that `ggplotly` produces a `plotly`
graph in the spirit of the `ggplot2` graph we put in, not an exact
replica.

Still, that means we don't need to learn how to produce a `plotly` graph
to explore the associated features and use cases, so that's a pretty
good deal!

To get started, let's build the `ggplot2` graph we'll use as an input.
Let's make it a scatterplot of GDP vs. population for a given year
(we'll start by looking at 2007), with each continent getting a
different color. Additionally, we'll plot a best-fit regression line for
each continent:


``` r
##This code should be **added** to the bottom of your global.R file!

###FILTERED DATA SET FOR MAP
gap2007 = gap %>%
  filter(year == 2007)

###BASE GGPLOT FOR CONVERSION TO PLOTLY
#IF GGPLOT IS FAMILIAR TO YOU, STUDY THE SPECIFICS HERE TO GET A SENSE OF THE GRAPH WE'RE BUILDING. IF NOT, DON'T WORRY ABOUT THE DETAILS! JUST COPY-PASTE THIS CODE INTO PLACE.
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
```

If you don't know `ggplot2`, the above code will probably look
terrifying! No worries—just copy-paste the code and don't worry too much
about what each piece does.

For those who *do* know `ggplot2`, you'll hopefully agree that, although
this graph is not terrible remarkable, it looks pretty good. More
importantly, it's just complex enough that it'll be a good test of how
well `ggplotly()` does:


``` r
##This code should be **added** to the bottom of your global.R file!
p2 = ggplotly(p1)
```

Now that we have our `plotly`-ized version of our graph, it hopefully
won't surprise you to learn there are `renderPlotly({})` and
`plotlyOutput()` functions we can use to add this graph to our app:


``` r
##This code should **swapped** for the the "main panel" content in the BODY section of your ui.R file!

##... other UI code...
###MAIN PANEL CELL
    column(width = 8, tabsetPanel(
      ###TABLE TAB
      tabPanel(title = "Table", dataTableOutput("basic_table")),
      ###MAP TAB
      tabPanel(title = "Map", leafletOutput("basic_map")),
      ###GRAPH TAB
      tabPanel(
        title = "Graph",
        plotlyOutput("basic_graph") #<--ADD THE GRAPH HERE.
      )
    ))
##... other UI code...
```


``` r
##This code should be **added to** your server.R file, underneath all other contents inside of your server function!

 ##... other server code...

output$basic_graph = renderPlotly({
    
    p2 #Put our pre-built ggplotly() output here.
    
})
```

If we launch our app, we should see our new `plotly` graph on the Graph
tab panel. It looks quite similar to our `ggplot` graph!

The only difference I really notice is in the placement of the legend;
while `ggplot`s center their legends vertically in the available space
by default, `plotly` graphs top-align them instead.

We'll adjust that in a moment! Meanwhile, let's focus on the new
interactive features this graph comes with out of the box (it's a lot!):

-   **Tooltips**: If you hover over a point, you'll get a **tooltip**
    showing the data point's associated `x`, `y`, and `group`
    (continent) values. These tooltips don't look "pretty" in a
    human-readability sense, but that too is something we'll soon
    change.

-   **Click+drag to zoom**: If you click anywhere, drag your cursor to
    highlight a region, and let go, you will zoom the graph to only the
    highlighted region. Double-clicking will restore the original zoom
    level.

-   **Interactive "modebar:"** `plotly` graphs come with a toolbar
    (called a "modebar") in the top-right (when hovering over the graph)
    featuring several buttons. These allow you to download an image of
    the graph, zoom and pan, select specific data in various ways, reset
    the graph in various ways, and change how the tooltips work. In
    particular, click the "compare data on hover" button and see how
    this changes the behavior of the tooltips!

-   **Legend group (de)selection**: If you click any of the legend keys
    (such as "Asia"), all the data points from that group will be
    redacted, and the axes will readjust as though those data weren't
    present. Double-clicking a legend key will reduce the data shown to
    *only* those from that group. This functionality might allow a user
    to exclude data extraneous to them personally and to focus of data
    that *are* of interest.

That's a lot of interactivity for minimal effort on our part!

### More (or less) basic graph

...which means it's time to discuss how to disable features if we want.
Unfortunately, disabling features in `plotly` is not *as* easy as in
`DT` or `leaflet`; to do so, we must engage with two of the core
functions involved in assembly of a scratch-made `plotly` graph:
`layout()` and `config()`.

`layout()` is *sort of* equivalent to `ggplot2`'s `theme()` in that it
controls many of the specifics of how the plot looks. Inside `layout()`
are `xaxis` and `yaxis` parameters, which we can provide with specific
instructions.

If we give both of these parameters a list containing the instruction
`fixedrange = TRUE`, this will prohibit zooming:


``` r
##This code should **replace** the renderPlotly({}) code in your server.R file, inside of your server function!

 ##... other server code...
###GRAPH
  output$basic_graph = renderPlotly({
    p2 %>%
      layout( #<--layout() ADJUSTS PLOTLY GRAPH AESTHETICS.
        #PLOTLY CODE LOOKS "JAVASCRIPT-LIKE" RATHER THAN "R-LIKE," HENCE LISTS!
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE))
    
  })
```

In my experience, most (but not all!) graphs don't benefit from zooming,
and some users find it hard to figure out how to reverse an accidental
zoom.

We can also use `layout()` to adjust how the legend responds to clicks.
For example, if we want to turn off the functionality that redacts a
group when its legend key is clicked on, we can set the `itemclick`
instruction for the `legend` parameter to `FALSE`:


``` r
##This code should **replace** the renderPlotly({}) code in your server.R file, inside of your server function!

 ##... other server code...
###GRAPH
  output$basic_graph = renderPlotly({
    p2 %>%
      layout(
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE),
        legend = list(
          itemclick = FALSE) #<--THE ONLY ADDITION--TURN OFF GROUP REDACTION UPON CLICKING ON LEGEND KEYS.
      )
    
  })
output$basic_graph = renderPlotly({
    
    p2 %>% 
     layout(xaxis = list(fixedrange = TRUE),
            yaxis = list(fixedrange = TRUE),
            legend = list(itemclick = FALSE)) #<-THE ONLY ADDITION HERE.
    
  })
```

The `config()` function, meanwhile, can remove buttons from the modebar,
although you may need Google's help to find the names of the buttons you
want to remove:


``` r
##This code should **replace** the renderPlotly({}) code in your server.R file, inside of your server function!

 ##... other server 
###GRAPH
  output$basic_graph = renderPlotly({
    p2 %>%
      layout(
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE),
        legend = list(
          itemclick = FALSE)
      ) %>%
      config(modeBarButtonsToRemove = list("lasso2d")) #<--REMOVING THE "LASSO" SELECTION BUTTON.
  })
```

As noted earlier, when considering UX, "less" can be "more." If your
user might not understand it or won't use it, remove it!

#### Making some adjustments

Earlier, we identified two dissatisfying aspects of our graph. First,
the legend isn't centered vertically, like in our original. Second, the
tooltip text could look nicer.

The first issue is easily solved using the `legend` parameter inside of
`layout()`, which we've already dabbled with:


``` r
##This code should **replace** the renderPlotly({}) code in your server.R file, inside of your server function!

 ##... other server code...
###GRAPH
  output$basic_graph = renderPlotly({
    p2 %>%
      layout(
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE),
        legend = list(
          itemclick = FALSE,
          y = 0.5, #<--PUT THE LEGEND HALFWAY DOWN.
          yanchor = "middle" #<--SPECIFICALLY, PUT THE **CENTER** HALFWAY DOWN.
        )
      ) %>%
      config(modeBarButtonsToRemove = list("lasso2d"))
    
  })
```

As for the second issue, the best way to beautify our tooltip contents
will be to use the `style()` function.

This is a multi-step process:

1.  First, let's "pre-generate" the text we want to use in each tooltip,
    (using the `dplyr` verb `mutate()`).

2.  Second, let's pass this text through our `ggplot` call so it gets
    packaged up with everything else being passed to `ggplotly()`.

3.  Lastly, let's use `style()` to make the contents of our tooltips
    *only* the custom text we've cooked up:


``` r
##This code should **replace** the previous plotly-related code in your global.R file!

 ##... other global code...
###FILTERED DATA SET FOR MAP
gap2007 = gap %>%
  filter(year == 2007) %>%
  mutate(tooltip_text = paste0( #<--HERE, WE GENERATE A NEW COLUMN CALLED tooltip_text USING paste0() THAT CONTAINS THE GDP AND POPULATION DATA IN A MORE READABLE FORMAT. 
    "GDP: ",
    round(gdpPercap, 1),
    "<br>",
    "Population: ",
    round(pop, -3)
  ))

###BASE GGPLOT FOR CONVERSION TO PLOTLY
p1 = ggplot(
  gap2007,
  aes(
    x = log(pop),
    y = gdpPercap,
    color = continent,
    group = continent,
    text = tooltip_text #<--HERE, WE PASS OUR CUSTOM TOOLTIP TEXT IN AS AN AESTHETIC. EVEN THOUGH OUR GGPLOT NEVER USES THIS INFO, IT'LL BE PASSED ALONG TO OUR PLOTLY GRAPH BY ggplotly(). 
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

###PLOTLY CONVERSION
p2 = ggplotly(p1, 
              tooltip = "text") %>% #<--HERE, WE TELL GGPLOTLY() TO POPULATE TOOLTIPS WITH OUR CUSTOM TEXT AESTHETICS. 
  style(hoverinfo = "text") #<--HERE, WE USE style() TO ASK THAT TOOLTIPS CONTAIN ONLY THE CUSTOM TEXT PROVIDED--OTHERWISE, WE'LL GET OURS PLUS THE DEFAULT ONES!
```

Now those tooltips are looking great!

Between `layout()`, `style()`, and `config()`, you can adjust virtually
any aspect of a `plotly` graph to meet your desires, much as you can use
various `ggplot2` functions to customize your `ggplot`s. It just may
require some Googling and experimentation to figure out *exactly* how to
do it.

### Update, don't remake, `plotly` edition!

Once again, it's time to see how to update a `plotly` graph "on the fly"
in response to user actions without re-rendering the whole thing!

That means first giving users a means of affecting the graph beyond what
the graph itself already provides. Let's create a drop-down selector
that lets users pick a new color scheme:


``` r
##This code should **replace** the "sidebar panel" cell's content within the BODY section of your ui.R file!

##... other UI code...
###SIDEBAR CELL
    column(
      width = 4,
      selectInput(
        inputId = "sorted_column",
        label = "Select a column to sort the table by.",
        choices = c(
          "Country" = "country",
          "Continent" = "continent",
          "Year" = "year",
          "Life expectancy" = "lifeExp",
          "Population size" = "pop",
          "GDP per capita" = "gdpPercap"
        )
      ),
      actionButton(inputId = "go_button", label = "Go!"),
    # actionButton(inputId = "reset_button",
      #                   label = "Reset!"),
      sliderInput(
        inputId = "year_slider",
        label = "Pick what year's data are shown in the map.",
        value = 2007,
        min = min(gap$year),
        max = max(gap$year),
        step = 5,
        sep = ""
      ),
      selectInput(  #<--ADD IN A COLOR SCHEME SELECTOR
        inputId = "color_scheme",
        label = "Pick a color scheme for the graph.",
        choices = c("viridis", "plasma", "magma")
      )
    ),
##... other UI code...
```

In `plotly`, the color scheme is generally specified inside the
`plot_ly()` call (the equivalent of `ggplot()`) or inside an `add_*()`
function call (the equivalents of `geom`s in `ggplot2`). However, one
can be specified or modified using `style()` too.

To update rather than remake our graph, we'll use the `plotly` functions
`plotlyProxy()` and `plotlyProxyInvoke()`, which are a like
`dataTableProxy()` and its helper functions like `replaceData()` in that
they are a "package deal;" both are needed to accomplish the task.
Specifically, we'll use the `"restyle"` method inside
`plotProxyInvoke()` to trigger a re-styling of the graph.

As in previous examples, we'll also need to separate the
`renderPlotly({})` call that makes our original, default graph from a
new observer that watches `input$color_scheme` and triggers restyling
using `plotlyProxy()`. Let's see all these pieces in action:


``` r
##This code should **replace** all your plotly-related code to date in your server.R file!

##... other server code...

##ALL OUR renderPlotly({}) call will now do is make a "base" version of the graph.
###GRAPH
  output$basic_graph = renderPlotly({
    p2 %>%
      layout(
        xaxis = list(fixedrange = TRUE),
        yaxis = list(fixedrange = TRUE),
        legend = list(
          itemclick = FALSE,
          y = 0.5,
          yanchor = "middle"
        )
      ) %>%
      config(modeBarButtonsToRemove = list("lasso2d"))
    
  })
  
  ###GRAPH OBSERVER (COLOR SCHEME SELECTOR)
#A NEW OBSERVER WILL WATCH FOR CHANGES TO OUR INPUT WIDGET.
  observeEvent(input$color_scheme, {
    
    #WE "BORROW" LEAFLET'S colorFactor() TO DESIGN AN APPROPRIATE COLOR SCHEME GIVEN THE USER'S SELECTION.
    new_pal = colorFactor(palette = input$color_scheme,
                          domain = gap2007$continent)
    
    plotlyProxy("basic_graph", session) %>% #<--plotlyProxy() JUST NEEDS WHICH GRAPH (OF POTENTIALLY MANY) TO UPDATE.
      plotlyProxyInvoke("restyle", list(marker = list(
        color = new_pal(gap2007$continent), size = 11.3
      )), 0:4) #<--INPUTS TO plotProxyInvoke() INCLUDE A METHOD (HERE, "RESTYLE"), A LIST OF LISTS (WHAT STUFF TO CHANGING AND HOW), AND A LIST OF TRACES BEING CHANGED (HERE, ALL FIVE WE HAD BEFORE).
    
  })
```

The first input to `plotlyProxyInvoke()` is a method name. Here, we're
using `"restyle"` to adjust things the `style()` function would
regulate, such as the graph's color scheme. There's also a `"relayout"`
method for adjusting things that `layout()` controls, such as the
legend.

The second input is a list of lists—this is another place where we're
*very nearly* writing JavaScript code, because if there's one thing JS
loves, it's lists! Each aspect we want to restyle gets named (here,
`marker`s are the only thing we want to restyle.

Then, we give each named aspect a list of inputs—what features do we
want to change about that aspect of the graph? Here, we're changing the
`color`s, setting them equal to the new colors we've generated using
`colorFactor()` from `leaflet`.

However, we also specify `size`s for these points. Why? Because, if
`plotlyProxy()` redraws our graph's markers, it will do so "from
scratch," using defaults for any properties we don't specify. Since our
original graph featured custom-sized points, we need to "override the
default" size to arrive at the same size of points as though we have
before the restyle.

The last input to `plotlyProxyInvoke()` is a list of **trace numbers**.
A `plotly` **trace** is one "set" of data being graphed. In our case, we
have five traces, one for each continent, and we're modifying all five,
so you'd think we'd put `1:5` here.

However, JS starts counting all things at 0, not 1 (it's a "zero-indexed
language," whereas R is a "one-indexed language"), so we specify `0:4`
for this last input instead.

You'll notice that, with this new proxy in place, our points change
colors as we adjust our new selector. However, our lines don't, and our
legend keys also change to the wrong colors. These are fixable problems,
but not without *some* grief in our case—the TL:DR version is that the
graph conversion performed by `ggplotly()` comes with baggage we're
running up against here. If we want to go further down this route, we'd
be better off rebuilding our graph in `plotly`.

### **Point and click**

As with all other widgets we've seen, user interactions with `plotly`
graphs can constitute events we can handle server-side.

However, `plotly` is unusual in that info about these events is *not*
being passed automatically and constantly from the UI to the server via
`input`. Instead, `plotly` has an alternative passing system that uses
the functions `event_register()` to specify which events to track and
`event_data()` to pass the relevant event data from the UI to the
server. This *sounds* a more complicated than what we're used to, but
it's really the same idea, just with more parts:


``` r
##This code should **replace** the "main panel" cell's content within the BODY section of your ui.R file!

##... other UI code...
###MAIN PANEL CELL
    column(width = 8, tabsetPanel(
      ###TABLE TAB
      tabPanel(title = "Table", dataTableOutput("basic_table")),
      ###MAP TAB
      tabPanel(title = "Map", leafletOutput("basic_map")),
      ###GRAPH TAB
      tabPanel(
        title = "Graph",
        plotlyOutput("basic_graph"),
        textOutput("point_clicked") #<--ADD AN OUTPUT REPORTING DATA ON WHAT'S BEEN CLICKED.
      )
    ))
##... other UI code...
```


``` r
##This code should **replace** the ggplotly() call within your global.R file!

##... other global code...
###PLOTLY CONVERSION
p2 = ggplotly(p1, tooltip = "text", 
              source = "our_graph") %>%  #<--PLOTLY EVENT TRACKING USES A SPECIAL ATTRIBUTE CALLED "SOURCE."
  event_register("plotly_click") %>%  ##<--WATCH THIS GRAPH FOR USER CLICKS, SPECIFICALLY.
  style(hoverinfo = "text")
```


``` r
##This code should **added to** the bottom of your server.R file, within the server function!

##... other server code...

#WE USE EVENT_DATA() LIKE input HERE, SPECIFYING WHICH GRAPH AND EVENT TO WATCH FOR.
observeEvent(event_data(event = "plotly_click", source = "our_graph"), {
    output$point_clicked = renderText({
      paste0(
        "The exact GDP per capita value for this point is: ",
        event_data(event = "plotly_click", source = "our_graph")$y #<--WE ACCESS THE EXACT Y VALUE OF THE POINT CLICKED LIKE THIS.
      )
      
    })
    
  })
```

In this setup, we are creating something equivalent to `input`—but the
values being passed by this new thing are related only to our graph and
only to specific events we've designated.

We've also had to give our graph a new "nickname" for use in just this
system: a `source` attribute, which we set to `our_graph`. This really
is not much different from how we specify and use `inputId`s as
nicknames when interfacing with `input`, except that `source` values
don't double as CSS `id`s.

We also had to specify what type of event we want to watch:
`plotly_clicks`. For whatever reason, `plotly` graphs don't watch for
all possible events, just those we specify.

Lastly, we watch our `event_data()` call, just like we would watch
`input$widget_name`, with our new observer. Whenever an event triggers,
we use `renderText({})` and `textOutput()` to print into the UI some
specific information about the point clicked. This is not a very
exciting use of this functionality, but it hopefully shows what's
possible.

So, ultimately, this system of event watching and handling is not *much*
harder the one used elsewhere in R Shiny apps involving `input`; it's
more difficult only in that it's different.

::: keypoints
-   The `DT`, `leaflet`, and `plotly` packages can be used to produce
    web-ready, interactive tables, maps, and graphs, respectively, for
    incorporation into Shiny apps.
-   Each of the graphics created by these packages come with tons of
    interactive functionality out of the box. Because some of this
    functionality might be confusing or unnecessary for all users, it's
    valuable to know you can adjust or disable any or all of these
    features.
-   Any aesthetic component of these graphics can be adjusted or
    customized, but the specifics of how to do this (and how easy or
    intuitive it will be) will vary quite widely between packages and
    aesthetics.
-   We should strive to update graphics, changing only the aspects that
    need changing, rather than remaking graphics from scratch wherever
    possible. This often means handling events using observers and
    proxies rather than using `render*({})` functions.
-   Like with other widgets, user interactions with these graphics can
    be tracked by the UI and passed to the server for handling. This
    passing happens with the `input` object for `DT` and `leaflet`, but
    an equivalent system must be used for `plotly`.
:::
