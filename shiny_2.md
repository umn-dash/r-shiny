---
title: R Shiny--The Ground Floor
teaching: 15
exercises: 0
source: Rmd
editor_options: 
  markdown: 
    wrap: 72
---

::: objectives
-   Build out the files and folders we need to house our app.
-   Learn the names we'll use for these files and folders.
-   Value the convenience granted by a `global.R` file.
-   Link an external stylesheet (CSS file) to our app.
-   Structure our `ui.R` file by nesting UI elements.
:::

::: questions
-   Where do I start when building a Shiny app?
-   What's the minimum code required to get a Shiny app to start up?
-   What goes in my `server.R` file? My `ui.R` file? My `global.R` file?
-   How do I design an app that will look nice and be accessible on a
    range of devices?
:::

### Preface

In the previous lesson, we learned the basics of web development and how
R Shiny relates to other web development **frameworks**. In the next
lesson, we'll start actually building a Shiny app together. First,
though, there are several steps we should take to set ourselves up for
success.

### Installing packages

We'll use a number of add-on R **packages**. These include `shiny`,
`dplyr`, `ggplot2`, `leaflet`, `DT`, `gapminder`, `sf`, `countrycode`,
and `plotly`. If you haven't already, install those now.


``` r
##RUN THIS CODE IN YOUR CONSOLE PANE--**DON'T** INCLUDE IT INSIDE YOUR SHINY FILES. YOU ONLY NEED TO INSTALL PACKAGES **ONCE EVER** TO USE THEM.
install.packages("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "countrycode", "sf")
```

Note that `dplyr` and `ggplot2` are part of the `tidyverse`, which can
be installed using `install.packages('tidyverse')`. However, that
installation process can take a long time, and we won't use other
packages from the `tidyverse`, so it's faster to install just the
packages above *a la carte*.

We need to turn those packages on in order to access their features too,
but we need to get do further set up first.

### Establishing our Shiny app's Project Folder

It's useful to make a single folder (we'll call it our "**root
directory**" or just **root** for short) to house all files associated
with our app, and then we'll make that folder an **R Project folder**.
You don't need to know what this means if you don't already; just know
it's valuable.

Here's how you do it:

1.  In RStudio, go to `File`, then select the second option,
    `New Project`.

2.  In the pop-up that appears, select the first option,
    `New Directory`.

3.  Next, we'll select the type of project we're creating. One of these
    creates a `Shiny application`, but select the *first* option,
    `New Project`, *instead*.

4.  On the next screen, use the `Browse` button to find a location to
    place the project folder on your computer. Then, give the project a
    name related to the app you're going to build. There are some other
    options here that, if you're familiar with Git or `renv`, you might
    consider. Otherwise, click `Create Project`.

**Important**: When the Project is created, you will see a `.Rproj` file
appear inside the new folder. From now on, to work on your Shiny app,
launch this file to start an RStudio session connected to your Project.
Doing so will save you time and energy!

### Creating the necessary files

It's my preference (and recommendation) to build Shiny apps using the
so-called three-file system:

-   Go to `File`, select `New File`, then select `R Script`. Repeat this
    process two more times to create three **script** files in total.

-   Then, give them these *exact* names (all lowercase):

    -   `ui.R`

    -   `server.R`

    -   `global.R`

These files will hold our app's client side (**user interface**) code,
back-end (**server**) code, and setup code, respectively.

R Shiny will recognize these exact names as "special," so using them
enables some handy features. One of these is that, in the top-right
corner of the Script Pane, you should see a "Run App" button with a
green play arrow whenever you are viewing any of these three files in
this Pane.

![](fig/clipboard-2238956949.png)

This button will allow you to start your app at any time to check it out
or test it.

There are some other folders and files to create next:

-   In the "Files, Plots, Packages, etc." Pane in your RStudio window,
    while viewing your Project Folder, click the `New Folder` button.
    Name this new folder *exactly* `www`. R Shiny will automatically
    look inside a folder by this name for many things, including media
    files (like images), custom font files, and CSS files referenced by
    your app.

    -   Speaking of which: Click `File`, `New File`, then `CSS file`.
        Give this file a name like `styles.css`, then save it in your
        new `www` folder.

    -   If you plan to build complex Shiny apps, you may also want to
        create a JavaScript file called something like `behaviors.js`
        and place this new file in your `www` folder as well, but we
        won't use any such file.

-   Create a second new folder inside your Project Folder. Call it
    `inputs`. Use this folder to store input files your app needs to
    start up, like data sets, but that *aren't* media like pictures or
    fonts. We won't use this sub-folder, but, for real projects, it'd be
    invaluable.

-   Create a third new folder inside your Project Folder. Call it
    `Rcode`. As an app's code base gets big, working on it may get
    increasingly complicated unless you stay organized. If you ever want
    to divide your app's code into smaller chunks (such as by building
    custom functions to perform repeat tasks or by dividing your app
    into "modules"), you can place R files for each chunk in this
    folder, then source them in your `global.R` file. We won't use this
    subfolder, but I use such a folder all the time in my apps.

We now have all the files and folders we need, so we can start placing
into each one the code needed to get a Shiny app off the ground.

### Starting our global.R file

We'll start with `global.R`. R will run this file first when booting up
your app, so it's job is to load and/or build everything needed to
enable the rest of the app to start up successfully and become
self-reliant.

When your app gets large and complex, this file will hold many different
things but, at a minimum, it will contain two things to start: 1)
`library()` calls to load required packages and 2) `read*()` calls to
load required data sets:


``` r
##Place this code in your global.R file!

### LOAD PACKAGES <--CREATE HEADERS IN YOUR FILES TO KEEP LIKE CODE TOGETHER AND STAY ORGANIZED!
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
gap = gapminder
```

By having a `global.R` file, we can place things like `library()` calls
and code for loading data sets in a single place and have it work for
the entire app. Without it, we'd need these commands in *every* file in
which the results are referenced—what a pain!

### Starting our server.R file

Setting up `server.R` is *relatively* easy because there's only one
block of code we need to place in it at the start:


``` r
##Place this code in your server.R file!

server = function(input, output, session) {
  
  #ALL OUR EVENTUAL SERVER-SIDE CODE WILL GO HERE.
  
}
```

Notice: `server.R` will eventually hold just one **object**: a
**function** called *exactly* `server`. This function will have three
**parameters** called *exactly* `input`, `output`, and `session`. R
Shiny will look for the function by this name when it starts up an app,
and it will create objects called `input`, `output`, and `session` to
feed it as it does so. Using these exact names is critical!

It makes sense, if you think about it, that our app's server file will
create a **function** (a verb) because it's the "half" of the app that
will *do stuff*. By contrast, the **UI** of our app just *"sits there
and looks pretty"* and only changes when directed to do so by the
server, typically in response to user actions.

### Starting our ui.R file

Even less code is *needed* to start with in `ui.R` because our app's UI
file does not produce a function but rather just a single HTML box into
which other boxes will eventually be placed:


``` r
##Place this code in your ui.R file!

ui = fluidPage(
  
  #ALL OUR EVENTUAL CLIENT-SIDE CODE WILL GO INTO ONE OF THE TWO SECTIONS BELOW.
  
  ### HEAD SECTION
  
  
  ### BODY SECTION
  
)
```

However, let's do a little more to get our app building jump-started.

First, let's load our app's **stylesheet**, the `styles.css` file made
earlier. Because the UI is the "visual" part of a website, and because
CSS controls a website's looks, it makes sense we'd load a CSS file in
`ui.R`. It also makes sense we'd do this in our app's `head` box because
it's instructions, not something a user needs to see. Here's how to do
this:


``` r
##Place this code INSIDE your app's fluidPage container in the HEAD section!
tags$head(
  
  tags$link(href = "styles.CSS", #<--OR WHATEVER YOU NAMED THIS FILE IN THE PREVIOUS LESSON.
            rel = "stylesheet") 
), #<--YOU'LL NEED A COMMA AFTER EVERY ELEMENT IN YOUR UI, SO YOU MIGHT WANT TO ADD THIS ONE HERE NOW.
```

Here, we've told the app there is a specific *stylesheet*, a CSS file,
by the name of `styles.CSS` we want a user's browser to use when
constructing our website. Note that we *link* to this file rather than
*load* it—that's an HTML thing!

*By default, the app will look for CSS stylesheets in the `www`
subfolder*, so as long as that's where we put it, we don't need a more
complex file path for the `href` input.

We can also add some additional boxes as contents of our outermost
`fluidPage` container to start giving our app some structure.

In this workshop, we'll practice an approach called **mobile-first
design**. This means designing apps with mobile users top of mind. The
logic of this approach is that, if an app looks and feels good on a
narrow-screened, mouseless mobile device, it should feel and look even
better on a wider, mouse-enabled device, and that designing in the
"opposite direction" is generally much harder.

This means, among other things, we'll aim for a "vertical" or "stacked"
layout, one in which pretty much every major element gets the screen's
full width to occupy, and each subsequent element will go below rather
than next to the previous one.

However, we'll also set things up such that, if a user does have a wider
screen, some things could go side by side, if that would look and feel
better.

So, let's add the following to our app's UI:

1.  A **header**, built using `titlePanel()`.

2.  A **footer**, built using `fluidRow()`.

3.  In between, let's make another row using `fluidRow()`. Inside it,
    let's place two columns using `column()` to create two "cells" in a
    small "table."

The R Shiny function `column()` we're using here has a required input,
`width`. All the `width` values of `column()`s in a given `fluidRow()`
must be whole numbers that sum to 12.

So, let's set the `width`s of these columns to `4` and `8`,
respectively. In practice, this'll make the second column half as wide
as the first. As a result, the second column will take up 2/3rds of the
screen's width, creating the feel of a left-hand "side panel" and a
right-hand "main panel."

However, `fluidRow()`s are smart—on narrow screens, elements in same row
will flow vertically if there's not enough room for all of them to fit
in their side-by-side configuration comfortably. This means that our
"side panel" will actually go *above* our main panel on a cell phone
screen automatically (because it's specified *first*), better than these
elements being crammed side-by-side when there isn't enough room:


``` r
##Place this code INSIDE your app's fluidPage container in the BODY section!

titlePanel(title = "Our amazing Shiny app!"), #<--EVERY NEW UI ELEMENT IS SEPARATED FROM EVERY OTHER BY COMMAS, JUST AS ITEMS IN "LISTS" IN R ARE SIMILARLY SEPARATED.

fluidRow(
  ###SIDEBAR CELL
  column(width = 4),
  ###MAIN PANEL CELL
  column(width = 8)
),

fluidRow(id = "footer")
```

A couple of things about UI boxes in R Shiny based on this example:

1.  Most R Shiny boxes (though `titlePanel` is an exception) have an
    `id` or `inputId` or `outputId` **parameter**. The `id` values
    provided to these boxes will often serve a Shiny-specific purpose
    too, but they can be used in CSS selectors as well.

2.  Most Shiny boxes also have a `class` parameter for use in CSS code
    also. This one is optional, as is any `id` parameter a box may have.
    However, if an element has an `inputId` or `outputId` parameter,
    those will *mandatory*—we'll see why later!

3.  Every Shiny UI element is separated from every other using commas,
    much as separate items are distinguished in R code in many other
    contexts. Forgetting these commas is a very common mistake for
    beginners!

4.  Because R Shiny UI code is *really* just HTML code, writing it
    involves **nesting** a lot of function calls inside other function
    calls. For many, this can be confusing initially! Keep your code
    organized, use lots of comments, and divide your UI up into
    sub-sections—whatever helps you!

::: discussion
Start up your app at this point. What do you see? Explain why the app
looks the way it does so far.

::: solution
Besides our title, our app will actually look completely empty! This is
because we have made several HTML boxes (a footer, a side panel, a main
panel, and a box holding the latter two), but we have not actually put
anything in them yet! HTML boxes are empty until we provide them with
contents that aren't other HTML boxes. That's what we will do in the
next several lessons!

By most standards, our app will also look very basic—just a white screen
with a blank-looking title. This is because the default CSS applied to
Shiny apps is very basic! This is why I argued that learning some CSS is
essentially to crafting an attractive Shiny app.

Sure, we've linked to a separate CSS stylesheet, but we haven't actually
put any code in it yet. Until we do, the default, bland style rules will
still be used.
:::
:::

::: exercise
Let's practice applying some CSS to our app! In your `styles.css` file,
write a rule that will make the title of our app bold. The **selector**
we'll need to use here is weird: `body>div>h2`. See if you can guess
what it's doing. Meanwhile, the property to set here is called
`font-weight` and the value we want is `bold`. Run your app to make sure
your rule is working.

::: solution
Here's what this should look like:

``` css
body>div>h2 {
font-weight: bold
}
```

Why did we need such a goofy-looking selector? Well, our title ends up
being a "2nd level heading," and these are called `h2`s in HTML. This
heading has no id or class (and we can't give it one, directly, which is
pretty annoying!). So, we could just style all `h2` elements with bold
font by putting `h2` in our selector.

But, since that might be messy if we have many such selectors, instead,
we're targeting only `h2` elements that are directly inside `div`s that
are directly inside the `body` element. That's what the `>` operator is
doing—it's representing a specific "nesting order" that helps to make
our selector much more specific!

Don't worry if this feels a little over your head; it's a more
challenging example, but it demonstrates both how complex CSS rules can
get as well as how valuable it can be to learn a little CSS if you want
to style your app nicely.

Incidentally, if you can't tell if your title has been successfully
styled, add `color: green;` to your rule, which will turn your title
green if your rule is working properly!
:::
:::

::: keypoints
-   Use the three-file system to organize your app's code and to benefit
    from R Shiny features built into RStudio.
-   A `global.R` file is handy for storing all code needed to power app
    start-up as well as any code that needs to run only once.
-   A CSS stylesheet for dictating your app's aesthetics can be linked
    to an app inside of `ui.R`, specifically using `tags$head()` to put
    the linkage into our app's head HTML container.
-   UI elements get nested inside one another and must all be placed
    inside the UI's outermost container (here, a `fluidPage()`). Most UI
    elements can be given `id`s and `class`es for styling with CSS and
    enabling other R Shiny features. Elements must be separated from one
    another with commas.
-   `fluidRow()` and `column()` can be used to create a "grid," within
    which elements could be arranged next to each other on wide screens
    but which will automatically flow vertically on narrow screens,
    creating a responsive, mobile-first design with little fuss.
:::
