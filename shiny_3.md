---
title: R Shiny--The First Floor (Rendering, Inputs, and Reactivity)
teaching: 40
exercises: 10
source: Rmd
editor_options: 
  markdown: 
    wrap: 72
---

::: objectives
-   Build a table to add to your app's UI.
-   Allow users to adjust how the table appears in real time.
-   Give users greater control over when the table's appearance changes.
-   Define the terms **reactive context**, **event**, **event
    handling**, **declarative coding**, and **imperative coding**.
-   Explain how and why R Shiny server-side code executes differently
    than traditional R code.
-   Use **isolation** and **observers** to control event handling more
    tightly.
-   Expand your UI's "real estate" by introducing a tab set.
:::

::: questions
-   How do I add cool features to my app?
-   How do I give my users meaningful things to do?
-   How do I code my app to respond to user actions?
-   How do I give my users greater control over when/how my app
    responds?
-   How do I give myself greater control over when/how my app responds?
-   How is R Shiny server code (likely) different than code I've written
    before?
:::

## Going from nothing to something

As we saw at the end of last lesson, our app doesn't look like much
yet—just a title on an otherwise empty page. In this lesson, we'll fix
that! As we add content, we'll learn three core concepts of building a
website using Shiny: 1) **rendering** and **outputting** complex UI
elements, 2) **input widgets**, and 3) **reactivity**.

We'll create an app for showcasing the `gapminder` data set, which
contains population, life expectancy, and economic data over time for
most countries. The goal will be to give users interesting ways to
interactively engage with these data. As we go, imagine how you might do
the same for your own data sets!

Let's start by giving users a table with which to view the data. If you
think about it, a table is just several boxes (cells) within larger
boxes (rows and columns). So, it makes sense that a table should be
something buildable in HTML, and it can be! However, depending on the
number of cells, it would require typing a LOT of boxes.

Fortunately, we don't have to "code" all those boxes "by hand;" we can
have R do that! To build an element that is complex enough that building
it programmatically is appealing and then insert it into our UI where a
user can see it, we must:

1.  Make (*i.e.*, *render*) that element on the server side of our app.

    1.  This involves first doing whatever "heavy lifting" is needed to
        assemble the product. For a table, *e.g.*, R might need to do
        some data manipulation.

    2.  Then, it involves converting (behind the scenes) what we've put
        together into the equivalent HTML code.

2.  Then, we pass it to the UI side and indicate where *exactly* in our
    UI we'd like the finished element to go.

For virtually every such complex element you'd want to build in Shiny,
there is a pair of functions designed to do those two steps. In this
particular case, that pair with be `renderTable({})` on the server side
and `tableOutput()` on the UI side. [Notice that most Shiny functions
follow a camelCase **naming convention**.]

Let's use these two functions to add a basic table of the `gapminder`
data set to our app:


``` r
##Place this code INSIDE your app's server function INSIDE your server.R file! 

###TABLE
output$basic_table = renderTable({
  gap #<--OR WHATEVER YOU NAMED THIS OBJECT IN GLOBAL.R
})
```

Above, we instructed R to render an "HTML-ized" version of a table
containing the entire gapminder data set. If we wanted to do any
operations on this data set first (such as filtering it or adding
columns to it), we could have done those using "normal" R code inside
`renderTable({})`'s braces. So long as it's a table, the last thing
produced inside these braces is what will be rendered. Here, we wanted
to render entire data set, so that's all we put inside the braces.

*How* the finished table gets passed from the server to the UI, though,
is worth highlighting. Last lesson, recall that the app creates an
object called `output` as soon as the app starts running.

The task of passing rendered elements from the server side to the client
side is what that `output` object is for. If an app is a restaurant, and
rendering is the process of "cooking" elements back in the kitchen area,
then `output` is the waiter that brings those finished element out into
the dining area where users can experience them.

For this to work, we just needed to give the element a nickname (an
`outputId`) to use to stick the element to the `output` object using the
`$` operator. Here, the nickname I provided was `basic_table`. Think of
the `outputId` as a code for the table of diners that ordered the
element. `output` (our "waiter") can use that code to figure out where
to take the element once it's ready.

The only other thing the app needs to know is *where* it should put this
rendered table in the app's UI—we need to "drop this element off at the
appropriate table." We tell the app where to place the table element
through our placement of the `tableOutput()` call in our UI:


``` r
##This code should **replace** the "main" fluidRow() contained within the BODY section of your ui.R file!

##... other UI code...

fluidRow(
  ###SIDEBAR CELL
  column(width = 4),
  ###MAIN PANEL CELL
  column(width = 8,
         tableOutput("basic_table")#<--PUTTING OUR RENDERED TABLE INTO OUR "MAIN PANEL" CELL.
         )
),

##... other UI code...
```

Here, we've placed our outputted table inside the "main panel" cell of
our central, two-column `fluidRow()`.

A single app might render and display multiple tables. How would the app
know *which* table should be displayed *where*? This is cleared up by
`tableOutput()` because it takes, as its first input, the `outputId` of
the table that should be displayed in that location. So, we use the
`outputId`s we pick server-side to keep our outputs straight UI-side.

If you run your app at this point, you should get something that looks
like this:

![Our Shiny app with our basic HTML table of the gapminder data
set.](fig/basic table.png)

Which is cool! But not *terribly* exciting...it looks a little drab, and
users can't actually **do** anything with this table except look at it.
The first problem we'll start to fix later when we swap it for a much
better one. However, we can fix the second problem now.

## Giving your users input

The value of a Shiny app can be measured by how much it lets users *do*.
To enable meaningful user interactions, we need to add **widgets**. A
widget is an element users can interact with such that the app might
reasonably respond in some way. In web development, user actions that
the webpage can watch for are called **events**; responding to an event
(or choosing to not respond!) is called **event** **handling**.

Let's start by adding an **input widget** to our UI so that new
**events** are possible. Specifically, let's add a `selectInput()` to
our "sidebar" UI container. This will produce a "drop-down menu" style
element that allows users to select a single choice from a pre-defined
list. We'll populate the list with the column names from the `gapminder`
data set:


``` r
##This code should **replace** the "sidebar" cell contained within the main fluidRow() of your ui.R file!

##... other UI code...

###SIDEBAR CELL
    column(
      width = 4,
      ##ADDING A DROP-DOWN MENU WIDGET TO THE SIDEBAR.
      selectInput(
        inputId = "sorted_column",
        label = "Select a column to sort the table by.",
        choices = names(gap) #<--OR WHATEVER YOU NAMED THIS OBJECT IN GLOBAL.R
      )
    ),
  
##... other UI code...
```

Notice we provided `selectInput()` three inputs:

1.  An `inputId` is both an `id` for CSS purposes as well as a nickname
    the app will use for this widget server-side. We'll see how that
    works in a minute.

2.  The text we provide to `label` will be the text that accompanies the
    widget in the UI and, usually, explains to the user what the widget
    does (in case it isn't obvious).

3.  For `choices`, we provide a vector of values that will be the
    options that appear in our drop-down menu.

While there are a few variations, most Shiny input widgets work a lot
like `selectInput()`, so it's a good first example.

Now, our app should look like this:

![Our new select input widget.](fig/select input.png)

Very nice!

...*Except* for two things. First, the choices in the drop-down menu
are...ugly. Some are abbreviations that lack spaces between words and
some also lack capital letters.

How could we fix this? Well, we *could* rename the columns in the data
set, but while column names in R *can* contain spaces, at best, it's
annoying. Plus, longer and more complex names require more typing.

Instead, we can provide a **named vector** to `choices`. The names we
give (left of the `=`) will be displayed in the drop-down menu, whereas
the original column names (right of the `=`) will be sent to the server
side to work with:


``` r
##This code should **replace** the "sidebar" cell contained within the main fluidRow() of your ui.R file!

##... other UI code...

###SIDEBAR CELL
    column(
      width = 4,
      selectInput(
        inputId = "sorted_column",
        label = "Select a column to sort the table by.",
        choices = c(
          #BY USING A NAMED VECTOR, WE CAN HAVE HUMAN-READABLE CHOICES AND COMPUTER-READABLE VALUES. TYPE CAREFULLY HERE!
          "Country" = "country",
          "Continent" = "continent",
          "Year" = "year",
          "Life expectancy" = "lifeExp",
          "Population size" = "pop",
          "GDP per capita" = "gdpPercap"
        )
      )
    ),
  
##... other UI code...
```

With that change made, our drop-down menu widget should be looking much
better!

![Now our choices look much more human-readable for our users, but the
original column names are preserved for work behind the scenes
too.](fig/prettier choices.png)

...Except that fiddling with the drop-down still doesn't *do*
anything...*yet*. We've created something a user can interact with,
triggering **events**, but we haven't told the app how to **handle**
those yet.

### R'll handle that

Let's do that next. We'll give the user the ability to re-sort the table
by the column they've selected using the drop-down widget. You might be
surprised to learn this is actually quite straightforward—it just
requires one adjustment to our server-side code:


``` r
##This code should **replace** the renderTable({}) call in your server.R file!

###BASIC GAPMINDER TABLE
output$basic_table = renderTable({
  
  gap %>% 
    #USE dplyr's arrange() VERB FOR SORTING BY THE PICKED COLUMN.
    arrange(!!sym(input$sorted_column)) #!! (PRONOUNCED "BANG-BANG") AND sym() ARE dplyr TRICKS, NOT R SHINY THINGS. LET'S NOT WORRY ABOUT WHAT THEY DO.
})
```

Run the app and try it out. As you select different columns using the
drop-down menu, the table *automatically* rebuilds, sorted by the column
you've picked:

![Now, when a user selects a new column using our drop-down widget, the
table re-sorts by that column.](fig/sorting by column.gif)

Earlier, we met the `output` object, which passes rendered elements from
the server to the UI where they can be seen. Here, we finally meet
`input`, which passes **event data** from the UI to the server where
responses can be crafted.

Here, `input` is passing the *current* value of the widget with the
`inputId` of `sorted_column` (that's the nickname we gave our drop-down
menu when we created it) over to the server when the app starts up and
every time that value changes thereafter. At any time, our server code
can use that value in operations, such as to decide how to sort the data
in our table.

But, more importantly, Shiny knows that, *at any moment*,
`input$sorted_column`'s value could *change*. Objects with values that
could change as a result of events are **reactive objects**—at any
moment, they might change *in reaction to* something.

Because we've used `input$sorted_column` in some of our server code, and
because R knows that `input$sorted_column`'s value could change at any
time, it knows to be *watching* for such changes. Whenever it sees one,
it'll run code including `input$sorted_column` *again*. The logic makes
sense, when you think about it: If `input$sorted_column` has changed,
anything that used its *previous* value to produce outputs may now be
"outdated," so re-running the associated code and producing more current
outputs makes sense!

Because the code inside `renderTable({})` contains
`input$sorted_column`, all that code reruns every time
`input$sorted_column` changes, which happens every time the user selects
a new column from the drop-down menu. We're successfully **handling**
the **events** triggered by our user's interactions with our input
widget!

### Reactivity

There is just one small but important technical detail: Shiny *can't*
watch for changes in **reactive objects** *everywhere* in our server
code—it can *only* do so within **reactive contexts**.

A **reactive context** is a code block that R *knows* it needs to watch
for changes in reactive objects and thus it might need to re-run over
and over again. It makes sense that we can only put "changeable" objects
inside code blocks that R knows it needs to watch for such changes in!

::: challenge
**Try it:** Pause here to prove the previous point. Copy
`input$sorted_column` and paste it anywhere *inside* your server
function but *outside* of `renderTable({})`. Then, try running your app.
It should **immediately** crash! Note the R error in your R Console when
this happens; rephrase it in your own words.

::: solution
You'll get an error that looks a lot like this:\
\
`Error in $: Can't access reactive value 'sorted_column' outside of reactive consumer. ℹ Do you need to wrap inside reactive() or observe()?`

This error notes that `input$sorted_column` is a **reactive object** (to
be technical, a sub-type called a reactive value) and that you've tried
to reference it outside of a reactive context, where R would actually be
"prepared" to watch it.
:::
:::

How do we recognize reactive contexts so we know where we can and can't
put entities like `input$sorted_column`?

*Generally speaking*, when an R Shiny server-side function takes, as an
input, an **expression** bounded by braces ( `{}` ), that expression
becomes a reactive context.

Maybe you've noticed the curly braces in `renderTable({})` and wondered
what they're for? *The main input to every `render*()` function is an
**expression** for creating a **reactive context**!*

That means R *assumes* that every complex element we render server-side
might need to be *re-rendered* because the user changed or did
something. We provided `renderTable({})` with a set of general
instructions that told it how to *handle* changing values of
`input$sorted_column`, no matter what value gets picked or when.

## How R Shiny differs from "normal R"

You're hopefully realizing that coding in R Shiny (on both the UI and
server sides) is different from coding in "normal R" in some key ways.

For many regular R users, the "nestedness" of UI code probably feels
strange (it *should*—we're writing thinly veiled HTML code in our UI
file!).

Meanwhile, server-side, having to imagine/design ways users *might*
interact with our app and then code generalized instructions for how the
app should respond, no matter when or under what circumstances, probably
also feels strange.

It *should*—*R Shiny server code is not like normal R code! In fact,
it's an entirely different paradigm of programming than the one you
might know.*

Normal R code is generally executed **imperatively**. That is, it is run
from the first command to the last as fast as possible as soon as we
(the user) hit "run."

Server-side Shiny code, meanwhile, is generally executed
**declaratively**. That is, it generally runs once when the app starts
up (or not), but, after that, it never runs again *unless* and *until*
it is *triggered* to run by one or more specific **events**.

[Caveat: The above is true when R is deciding which reactive contexts to
run when; however, the R code *within* those contexts will still run
imperatively, once that reactive context begins running.]

These two different paradigms can be understood better via an analogy:
Imagine you are in a sandwich shop ordering a sandwich. You probably
expect the employees to begin making your sandwich as soon after you
place your order as possible, using instructions and supplies their
manager gave them.

In that analogy, the relationship between you and the shop is
**imperative**; you gave a "command" and the sandwich shop "executed"
that command as quickly as it could via a pre-defined set of
instructions.

Meanwhile, the relationship between the manager and their employees is
**declarative**. The manager can't know which customers will come in on
a given day, when those customers will show up, or which sandwiches will
get ordered. So, they can't give their employees precise "commands" and
specific instructions of when to execute them or in what order.

Instead, they have to tell their employees to "watch for customers" and,
when those customers arrive and place orders, they should use a
generalized set of instructions to handle whatever orders have been
placed.

As web developers, our relationship with our users is similar. We can't
know who will show up and what *exactly* they might decide to do and
when. However, we totally *can* anticipate common actions they might
take and give the app detailed but generalized enough instructions that
it can take care of all those different requests whenever (or if ever)
they occur.

::: discussion
**Check for understanding:** How does the code we've written so far in
our `server.R` file execute differently than code we'd write in a
traditional R script? How does the code inside of `renderTable({})`'s
braces differ from traditional R code we might write?

::: solution
Server-side R code is mostly broken up into many reactive contexts, each
tasked with generating one or more complex UI elements and/or handling
user actions. Unlike traditional R code, these reactive contexts run
when a user performs a triggering action, not when an operator hits
"enter," so to speak, so they might run many times, or once and then
never again.

Plus, reactive contexts will (re)-run based on user actions, *not* on
placement within the file. So, your server-side will often run in an
"order" very different than the "top-down" order we usually expect R
code to run in.

*Inside* a reactive context, meanwhile, things are more traditional in
that code inside a reactive context will run just once, from top to
bottom, as quickly as possible as soon as that context is triggered to
(re)run.
:::
:::

### Buttoning this up

By this point, R now knows that:

1.  Users might select new columns in our input widget (**events**),

2.  It should watch out for any such events, specifically inside
    `renderTable({})`'s reactive expression (because it contains a
    linkage to the widget's current value), and

3.  If any events occur, it should re-execute the `renderTable({})` ,
    re-generating the table in line with the generalized instructions
    we've provided.

In this circumstance (a simple table that users can adjust via just one
input widget), this setup is *probably* fine.

However, imagine users had several widgets instead of one. If we used
this same approach to handle events from all those inputs, a user
adjusting any one input would trigger the table re-rendering process.

That might make our table *undesirably* reactive! Users often expect to
have some say in when *exactly* an app changes states. Maybe they expect
to be able to experiment with widgets to find the combination of
selections they are most interested in *before* the app responds. Maybe
the table loads slowly, so users would prefer not to wait through the
rebuilding process until they're "ready." Maybe some users just want to
be "in control" because they'd find the updating process distracting
when it happens not on *their* terms.

In any case, we can give users greater control by adding another input
widget: an `actionButton()`.


``` r
##This code should **replace** the "sidebar" cell contained within the main fluidRow() of your ui.R file!

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
      ##ADD AN actionButton(). PAY ATTENTION TO COMMAS/PARENTHESES AROUND THIS NEW CODE!
      actionButton(inputId = "go_button", label = "Go!")
    ),
  
##... other UI code...
```

This adds a simple, button-style input widget to our app's sidebar. It
says `Go!` on it (`label`), and it's current value (a number equal to
the number of times it has been pressed, or `NULL` if it hasn't been
pressed yet) will be passed from the UI to the server via
`input$go_button`.

![A new "Go" button has been added to the app's sidebar
panel.](fig/go button.png)

Now, we need to tell R how to **handle** presses of our button (until
then, pressing it won't do anything!).

Here, we want the table to update *only* whenever the button is pressed
(*i.e.*, whenever `input$go_button` changes). By extention, then, we no
longer want changes to `input$sorted_column` to cause the table to
update.

Here's where we hit a snag: `renderTable({})`'s reactive context is
"indiscriminate;" *any* change in *any* reactive object it contains will
trigger the reactive context to rerun. So, simply adding
`input$go_button` to that reactive context will *not* prevent changes in
`input$sorted_column` from triggering a rerun. And we can't just remove
`input$sorted_column` from the reactive context because, then, we
couldn't use its value to decide what column to sort by. We're stuck!

Thankfully, Shiny has a function for these kinds of sticky situations:
`isolate()`. Wrapping any reactive object in `isolate()` allows R to use
its current value to do work but prevents changes in that value from
**invalidating** (*i.e.*, rendering "outdated") the reactive context it
appears in.

Here's how we can use `isolate()` to achieve our goal:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

output$basic_table = renderTable({
  
  #BY PLACING input$go_button IN THIS REACTIVE EXPRESSION (EVEN IF WE DON'T ACTUALLY USE IT!), THIS EXPRESSION WILL RE-RUN EVERY TIME input$go_button CHANGES IN VALUE. 
  input$go_button
  
  #USING isolate() PREVENTS input$sorted_column FROM BEING REACTIVE (ITS EVENTS HERE ARE NO LONGER WATCHED) BUT STILL ALLOWS USE OF ITS CURRENT VALUE.
  gap %>% 
    arrange(!!sym(isolate(input$sorted_column))) 
  
})
```

Now, when users fiddle with the drop-down widget, nothing
happens...*until* they press the button. Then, and only then, does the
table re-render, using their most recent selection in the drop-down as
guidance.

![Thanks to isolate(), our table only re-renders when the "Go" button is
pressed, but the drop-down menu's current value is still used in that
process.](fig/go button works.gif)

### Being observant

This *works*, but it can get unwieldy if you have *many* inputs that
would need isolating. For those situations in which you want the app to
respond a *specific* way *only* when a *specific* reactive object
changes, especially when the response involves a bunch of other reactive
objects you *don't* want watched, we can make our event handling way
more precise using `observeEvent({},{})`:


``` r
##This code should **replace** the renderTable({}) call contained within your server.R file!

#FIRST, WE REDUCE OUR renderTable({}) CALL BACK TO BASICS. THIS WILL PRODUCE ONLY THE DEFAULT VERSION OF OUR TABLE.
output$basic_table = renderTable({
  gap
})


##TABLE OBSERVER (BUTTON)
#observeEvent({},{}) TAKES TWO EXPRESSIONS, WATCHING THE FIRST FOR EVENTS AND, WHEN IT SPOTS ONE, RESPONDING BY RUNNING THE SECOND. 
#SO, THE **FIRST** EXPRESSION IS REACTIVE, BUT NOT THE **SECOND**!
observeEvent(input$go_button, { 

  output$basic_table = renderTable({
  gap %>% 
    arrange(!!sym(input$sorted_column)) #<--NO NEED FOR isolate(); EVENTS RELATED TO input$sorted_column DON'T MATTER HERE. 
  })
  
})

#IF YOU RUN THE APP WITH THIS CHANGE, IT SHOULD BEHAVE THE SAME AS IN THE PREVIOUS EXAMPLE!
```

Notice we write `observeEvent({},{})` with *two* sets of braces. That's
because we give it, as inputs, *two* **expressions**. These have a
particular and interesting relationship:

1.  R watches *only* the *first* for events (it's the only **reactive**
    **expression**).

2.  R only ever actually **executes** the *second* expression, and
    *only* in response to changes in the *first*). In a sense, it's like
    the *entire* second expression is `isolate()`d!

So, `observeEvent({},{})` is the equivalent of telling R "if *exactly*
[first expression] changes, do *exactly* [second expression]," which is
a level of precision we very often want when handling events!

It's for this reason I use many `observeEvent({},{}`s in my own
apps—they make an app's behaviors far more predictable. [However, if you
have a lot of events to handle, this may be a verbose way to handle
them. Check out `observe({})` as a potential alternative.]

### Totally tabular

We now have all the conceptual tools needed to build a really cool app!
In the next lesson, we'll replace this table with a cooler one, and
we'll add map and graph widgets. To keep all this organized, though,
let's add **tabs** to our main content area, one for each new feature
we'll add.

We do this using the Shiny functions `tabsetPanel()`, a box to hold all
the individual tabs, and `tabPanel()`, which makes the box for the
contents of one tab:


``` r
##This code should **replace** the content of the "main panel" cell within the BODY section of your ui.R file!

##... other UI code...

###MAIN PANEL CELL
##NEST YOUR UI ELEMENTS **CAREFULLY**!
    column(width = 8, tabsetPanel(
      ###TABLE TAB
      tabPanel(title = "Table", 
               tableOutput("basic_table")),
      ###MAP TAB
      tabPanel(title = "Map"),
      ###GRAPH TAB
      tabPanel(title = "Graph")
    ))
   )

##... other UI code...
```

Now, if we look at our app, we'll see we have three tabs in our main
panel area, with `title`s as specified in our code.

![We've split our "main panel" into three tab panels inside a tabset
panel, with one tab per fancy widget we will eventually have.
](fig/new tabset .png)

We can swap between tabs using each tab panel's tab (yes, the
terminology here is awkward), just like in a browser. The second and
third tab panels are empty, but we'll soon fix that!

::: keypoints
-   Complex UI elements, like tables, first need to be **rendered**
    server-side and then placed within our UI using an `*Output()`
    function.
-   Rendered entities are passed from the server to the UI via the
    `output` object using the `outputId`'s we gave these entities when
    we **rendered** them.
-   **Input widgets** are UI elements that allow users to interact with
    our app in simple, pre-defined and familiar ways. The current values
    of these widgets are passed from the UI to the server via the
    `input` object using the `inputId`'s we gave these widgets when we
    created them.
-   R knows to watch **reactive objects** (like those attached to
    `input`) for changes. Any such changes are **events**. **Event
    handling** is coding how the app should respond to an event.
-   The primary way Shiny handles events is by re-running any **reactive
    contexts** containing the reactive object(s) that changed (unless
    they're `isolate()`d).
-   Server-side, reactive contexts are triggered to run **directively**
    (when a precipitating event occurs), not **imperatively** (when a
    coder hits "run"). They might run in any order, or never—it all
    depends on what the user and app do.
-   However, *once* a reactive context begins executing, it's contents
    are executed imperatively like "normal" R code until they complete
    (even if that takes a long time!), during which time the app will be
    unresponsive.
-   **Observers** (like `observeEvent({},{})`) allow for more precise
    event-handling; `observeEvent({},{})`s only rerun their second
    expression and only when events occur in their first expression, so
    they enable "If X, then Y" event handling.
-   `tabPanel()` and `tabsetPanel()` create a "tabular layout," dividing
    up one UI space into several, only one of which is visible at a
    time.
:::
