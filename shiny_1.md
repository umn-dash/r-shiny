---
title: Web development 101
teaching: 30
exercises: 5
source: Rmd
editor_options: 
  markdown: 
    wrap: 72
---

::: objectives
-   Meet the languages used to build websites.
-   Describe how R Shiny relates to other web development languages.
-   Picture a typical website's structure.
-   List components of a typical website.
:::

::: questions
-   How is a website built?
-   How is building a website using R Shiny similar to/different from
    doing so the "usual" way?
-   What does a website "look like," under the hood? What's one made up
    of?
-   What are the most common website "building blocks?"
:::

**Important**: This course assumes you have working knowledge of the R
programming language and the RStudio Integrated Development Environment
(IDE). If either is new to you, you could struggle with this course
(although the R code we'll be writing is generally basic). You should
consider an Intro R course before this one, in that case.

By contrast, this course assumes you have **no** previous web
development experience at all. If you do, this course may be too
introductory or simplified to capture your full attention, although you
may still find it an interesting overview of the R Shiny framework.

## The web's languages

R is a **programming language.** That's a fancy way of saying that it's
a system with which we can direct a computer to do things for us.

Like a human language, R makes a computer do stuff for us through a
combination of:

-   " nouns" (**objects**),

-   "verbs" (**functions**),

-   "punctuation" (**operators** like `<-` and `%>%`),

-   "questions" (**logical tests** like `x == y`), and

-   "grammar/syntax" (**rules** like `1a` being an unacceptable object
    name but `a1` being valid).

To have R direct our computer to do things for us, we must form valid
and complete R "sentences" (**commands**) and "paragraphs" (**code
blocks**) in which we create nouns, subject them to verbs, and follow
all the rules, just as we would for a human language.

R Shiny, meanwhile, is *not* a **programming language.** Instead, it's
what a web developer might call a **framework**; it's a set of tools you
can use to build a complete, *interactive* website. Specifically, it
leverages R and its coding conventions to accomplish that task (as
opposed to other, comparable tools a web developer could use instead).

To appreciate how R Shiny is distinct as a web development framework,
and to understand how to use it well, we need to understand a few basic
things about "normal" web development:

1.  What *languages* are typically used to build websites that R Shiny
    is *sort of* replacing, what each is for, and how each generally
    works,

2.  The *structure* of a typical website (the "wheres"), and

3.  The typical *components* (the "whats") of a website.

Those will be this first lesson's topics.

#### How the web is woven

To generalize, a website is constructed using several languages, each to
accomplish discrete objectives. The most notable of these are **HTML**,
**CSS**, and **JavaScript** (JS for short):

-   **HTML** is used to *structure* a website. It's how a web developer
    specifies **what** elements a user can see should go **where** on
    the page.

-   **CSS** is used to *design* a website. It's how a web developer
    specifies **how** each element should **look** (its colors, size,
    *etc.*).

-   **JavaScript** is used to code a website's *behaviors*. A website is
    largely just an application running inside of your browser (*e.g.*,
    Edge or Safari). While it runs, any changes to the website that
    occur due to your actions are coded using JavaScript.

    -   For example, if an app contains a button, and if the button
        disappears when pressed (a shift in the site's HTML), the page
        turns green (a shift in the site's CSS), and some data you
        provided are sent to a central database (a shift in the app's
        relationship with the wider internet), JS is likely dictating
        those shifts.

Together, HTML, CSS, and JS make up what's called the "*front end*,"
"*user interface*," or "*client side*" of a website. A website's **user
interface** (UI for short) is what they see and interact with, and it's
based on code running on their computer inside their browser.

Because it may be unintuitive that a significant part of the "work" of
websites happens on your computer rather than "in the cloud," it's worth
spelling out how a website actually works:

1.  When a user visits a website, a server hosting that website sends a
    packet of files (including a bunch of HTML, CSS, and JS files) to
    the user's computer.

2.  These are then opened by that user's browser and deciphered.

3.  The browser then builds the website the user sees using those
    instructions. The web is "alive" on your computer!

4.  When the website needs "further instructions" of how to behave or
    what content to show, a "dialogue" is opened with the server and new
    files are sent/received and deciphered.

::: discussion
Have you ever had to clear your browser's **cache** (files associated
with your browsing activities)? What do you think makes up the bulk of
the files that get deleted when you clear your cache?

::: solution
A good portion of your cache, in terms of numbers of files anyway, will
be HTML, CSS, and JS files sent to you by servers to build the websites
you're visiting! However, there will be some additional files, including
image and video files (which can be very bulky), files for special fonts
that a website may want to use, and JSON files (text files that can
store data), among others.
:::
:::

However, as implied by the 4th point above, there is *always* a second
"half" to a website. Somewhere, a *server* (a computer, basically, but
more automated than a personal computer) must be the website's "host,"
receiving requests for information and sending that information out and
handling new data being collected.

A server might also need to store private data, such as passwords, or do
complex operations that would be awkward to do in a user's browser
(especially if their computer isn't powerful!). It also may perform
security checks to ensure users aren't trafficking malware or spam!

For all these purposes and more, websites have "back ends" or "server
sides." Here, the language SQL might be used to carefully store or read
data from large databases, and a whole host of other programming
languages might be used for complex operations and other tasks,
including JS, PHP, Python, Ruby, and C#, just to name a few!

When a web developer talks about a framework, they are referring to the
entire complement of tools needed to build both halves of a website. So,
"HTML, CSS, JS, PHP, and SQL" is a popular framework.

#### Where R Shiny fits in

When you build a website using R Shiny, you'll be writing two kinds of
code (for the most part):

-   "Normal" R code and

-   "R-like," or "R Shiny" code.

The latter will *look* a lot like R code to you (that's the point!).
However, this code is *really* destined to become HTML, CSS, and JS
code—when a Shiny app is compiled and run, R will translate your R Shiny
code into the equivalent HTML, CSS, and JS code that a browser can
understand. This allows us to build the *entire* UI of a website
*without* needing to know much, if any, HTML, CSS, or JS!

The "normal" R code you're writing, meanwhile, will largely operate
within your website's "back end' (or "server side"), where it may
manipulate data sets, store values, send data to storage locations, or
keep track of user actions. You know—"typical R stuff!" This means that
we can build the entire server side of a website without needing to know
much, if any, JS, PHP, Ruby on Rails, Python, SQL, etc.!

So, R + R Shiny enable you to build both halves of a fully interactive,
complex website without necessarily requiring you to know *any* other
web development languages or frameworks! In particular, R admirably
takes the place of other, general programming languages typically used
for handling server-side tasks, such as Python or PHP, *especially* when
those task revolve around data manipulation, management, or display.

::: discussion
Hopefully, you now recognize that websites can be built both with and
without R Shiny. What is *different* about building a website using R
Shiny, then?

::: solution
A few things are different about building a website using R Shiny, but I
think the two most important differences are:

1.  Whereas writing "pure" HTML, CSS, and JS is often necessary to build
    a website, deep knowledge of these languages is not required to
    build a website with R Shiny. Instead, you will write R code + R
    Shiny code and these will get "translated" into the equivalent HTML,
    CSS, and JS code for you.

2.  Normally, to construct the "back end" of a website, a general
    programming language like PHP or Python is used. These languages are
    quite different from JS, so designing a conventional website often
    requires programming in (at least) two *different* general
    programming languages, at least one of which you may have never
    encountered before if you're not a programmer (JS and PHP are not
    widely used for other purposes). With R Shiny, you can code both the
    front and back ends of a website using a single general programming
    language (R).
:::
:::

## Let's meet HTML and CSS

While R Shiny ensures you don't *need* to learn HTML and CSS to build a
website, it is still translating your R Shiny code into HTML and CSS to
do so, which means it's beholden to these languages in some key ways. As
such, to build a *really* nice Shiny app, it's helpful to understand the
very basics of both languages. Knowing a little will make the R Shiny
code we have to write make a lot more sense than going in blind!

If learning R was difficult for you, **don't panic**! Compared to
learning the basics of R, learning the basics of HTML and CSS is
**much** easier because the latter **aren't** *general* *programming*
languages; because their purposes are much narrower, they need a lot
fewer "words" and "rules" to do their jobs than R does. Knowing even a
little about these two languages will go a long way.

### HTML 101

We'll start with HTML, since it's the foundation of a website. Pretty
much everything an R Shiny developer **really** needs to understand
about HTML can be collapsed into four key concepts:

#### Key concept #1: All websites are "boxes within boxes"

At its core, every website is just a box containing one or more other
boxes, each of which might contain yet more boxes, and so on all the way
down. By "box" here, I mean "a container that holds stuff," not "a
rectangle" (though a lot of website boxes *are* rectangles).

Really, HTML is just the web language used to specify which boxes go
inside which other boxes and what those inner boxes should hold. Besides
other boxes, HTML boxes can hold blocks of text, pictures, links, menus,
lists, and much more.

In terms of raw code, every HTML box looks *something* like this:

``` html
<div id="my box">My box's contents</div>
```

That means (almost) every HTML box has:

-   An **opening tag** (*e.g.*, `<div...>`), which tells the browser
    when the box "starts."

-   A **closing tag** (*e.g.*, `</div>`), which tells the browser when a
    box has "ended."

-   A space for *contents* between the two tags (here, that's the text
    `My box's contents` and is found between the opening tag's `>` and
    the closing tag's `<`), which could include other boxes!

-   Space inside the opening tag for *attributes*, which make our boxes
    "special." Here, we gave our box a unique `id` using
    `attribute = "value"` format.

    -   So, if the boxes themselves are the "nouns," attributes inside
        the opening tag are "adjectives."

In R Shiny, you can build the exact same box, but you'll use "R-like
code" to do it:

``` r
div(id = "my box",
    "My box's contents")
```

So, we've replaced HTML's tag system involving `<>`s with R's function
system and its `( )`s and specify attributes and box contents using R's
traditional function *argument* system.

#### Key concept #2: Websites have heads and bodies

To oversimplify a little, every website is just an HTML box
(`<HTML>...</HTML>`) containing two smaller boxes: a "head"
(`<head>...</head>`) and a "body" (`<body>...</body>`).

The head's contents are (mostly) invisible to a website's users;
instead, the head contains instructions for *how* the browser should go
about constructing the website—we'll discuss the head box more later.

The body box, meanwhile, contains everything the user can see and
interact with.

In R Shiny, we don't need to build the HTML, head, or body boxes—R Shiny
will make these for us. Instead, we will spend most of our time building
the stuff that goes into the body box.

However, we can still put things into the head box if we want to by
using the `tags$head()` function:

``` r
tags$head(#Put contents here...)
```

And, in a few instances, we will need to do this, so it's good to know
it's an option.

#### Key concept #3: Inline vs. block elements

Broadly speaking, there are two kinds of body HTML boxes: **inline**
boxes and **block** boxes. The difference between these two types is how
they are displayed when a website is built.

A *block element* takes up the *entire* horizontal "row" it is played
on. In other words, it'll occupy the *entire* width of the browser
window (if allowed), and it'll force the next item to go below it rather
than next to it, as though the browser was forced to hit the "Enter" key
after building it.

For example, the `<p>...</p>` element (created in Shiny using `p()`)
creates "paragraph" boxes (or, more accurately, boxes for blocks of text
which can be more or less than a paragraph). If you put several
consecutive paragraph boxes inside your body box, they would be
displayed in a column, with the first one at the top and the last one at
the bottom, and each would occupy the full width of the screen available
to them:

![](fig/clipboard-3243983914.png)

*Inline elements*, meanwhile, only take up as much horizontal space as
they have to (by default) and thus can go next to each other on the same
line, and they don't force new lines after them.

For example, the `<a>...</a>` element (made in R using `a()`) is a box
that holds a link. You could use several such boxes within a single
paragraph box without creating a new line after each one.

Web users typically expect certain kinds of elements to "stand alone" or
"stand apart" from others and be treated as their "own thing," such as
headings and navigation bars. These will generally be block elements.
Other elements are expected to "fit together," such as links within
blocks of text. These will generally be inline elements.

#### Key concept #4: The Flow

This one is a *little* hard to explain. These days, a user might view a
website on a very large screen (like that of a projector) or a very
small screen (like that of a cell phone or even a smart watch!).

How much horizontal space your website has available will vary from user
to user, then. This means how your site gets displayed on a wide vs
narrow screen will also vary, and it's something we should consider and
design for with intentionality.

As discussed above, block and inline elements would respond to different
screen widths differently:

-   By default, block elements will *always* take up the full width of
    the box they are in (which may or may not be the same as the width
    of the screen), and they may stretch or squash their contents to do
    so. If the screen isn't wide enough to hold their full widths, they
    may "spill" out of a user's field of view or force scroll bars to
    appear to be fully visible.

-   By default, inline elements will run horizontally until they hit the
    edge of their container or screen, and then they will wrap to the
    next line and continue until they are finished.

::: challenge
Try it: Go to any website (such as
[dictionary.com](www.dictionary.com "A link to dictionary.com, a good site for demonstrating the HTML concept of the "flow.""))
and vary the width of your browser window. What changes as you do that?

::: solution
For me, I saw a number of changes as I shrunk my browser screen: The
menu at the top became a collapsed "hamburger" menu (where you get a
button of three lines, or a "hamburger," that opens to reveal the
options), the links slid below the search bar, the word of the day box
shrank, and the games sidebar vanished, instead appearing much further
down on the page.
:::
:::

So, it's important to remember that *you are never really designing one
website but a bunch: one version for each potential screen size your
users will use to view it*. Much of this designing will be "automatic,"
but we have to choose and place items carefully for that automatic
adjustment to work well.

There are a number of web development techniques/paradigms for coping
with this variable-screen-width challenge:

-   Flexbox: HTML boxes can be made into "flexboxes," which grow and
    shrink according to the size of their contents. They also force
    their contents to either stack next to each other or on top of each
    other as needed to fit the designer's goals and the user's screen
    width.

-   CSS Grid: HTML boxes can also be arranged into CSS grids, which make
    the arrangement of a website more like filling the cells of a
    spreadsheet, with columns and rows that can grow or shrink depending
    on screen size.

-   Media Queries: Media queries are CSS commands that change how the
    website looks (*e.g.*, the size of an image) based on the screen
    size of the user.

By default, R Shiny uses an approach that is a hybrid of the first two
techniques above. Many of Shiny's boxes are "fluid," meaning their size
is flexible and changes according to the size of their contents.
Additionally, they can be divided into rows whose contents may flow
horizontally if there's room or vertically if there's not.

![](fig/clipboard-3147076736.png)

As we'll discuss later, the first step of building any R Shiny app is to
design the *layout* of your app. What needs to go where? Remembering
that your app may not be able to look the same for every user because of
the device they access it on is the first step to designing a great app!

### CSS 101

Compared to HTML, CSS is an even easier language to understand (at
least, that's my opinion!). HTML is the language that tells a browser
**what** to display and **where** to display it; CSS is the language
that tells a browser **how** to display it.

CSS code consists of functional units called **rules**. Each rule
consists of a **selector** and a list of one or more **properties**
paired with **values**:

-   The **selector** is the part that tells a browser which box(es) to
    adjust the appearance of.

-   The list of **properties** tells the browser which characteristics
    of those boxes to change.

-   The list of **values** tells the browser the new values to set for
    each of those characteristics.

Here is what a *CSS rule* might look like:

``` css
p.intro, div#firstintro {
font-style: italic;
font-size: large;
} 
```

On the first line, we have two element types we're targeting in our
selector with our rule, separated from each other by a comma:

-   The first target is paragraph boxes (`p()`s), but specifically only
    those given the `intro` class. A **class** is an *attribute* that
    HTML boxes can have that allows them to be controlled and styled as
    a group, and a period **operator** is used to connect an HTML
    element type with a **class** in a selector (*e.g.*, `p.intro`).

-   Our second target is `div`s (short for "dividers," a generic kind of
    HTML box), but specifically only those with the **id** `firstintro`.
    As we saw earlier, `id`s are also attributes that HTML boxes can
    have, and they allow us to specificially control or style just a
    single element. A hashtag **operator** connects an HTML element type
    with an `id` in a selector (*e.g.*, `div#firstintro`).

    -   If you wanted to target all elements of a type (*e.g.*, all
        `div()`s), you can just write the element name without any
        periods or hashtags (e.g. `div`)

    -   If multiple different types of elements (such as both divs and
        ps) have been given the same class, you can omit a element type
        and just specific the class (e.g., `.intro`).

Then, inside of our rule's curly braces, we have a list. Each list item
is a pairing of a **property name** (*e.g.*, `font-style`) and a new
**value** (*e.g.*, `italic`). The property and the value are separated
with a colon **operator**, and the pairing ends with a semi-colon
**operator**. Pay attention to these punctuation rules—CSS is *very*
particular about its punctuation!

CSS rules can get more complex than this example, but they can also be
much simpler than this example—I've tried to provide a single example
that demonstrates all the key ideas without being too complicated.

::: challenge
Try it: W3Schools is a *fantastic* resource for learning HTML and CSS.
[Go to their CSS page and check out some of the tutorial pages on the
left-hand
side.](https://www.w3schools.com/css/default.asp "W3Schools is a great resource for learning HTML and CSS; check out their CSS tutorial")
Using the "CSS Text" tutorial, write a CSS rule that would change the
font color of all paragraph boxes to red and make all their text
center-aligned.

::: solution
Here's how you'd write this rule:

``` css
p {
color: red;
text-align: center;
}
```

Notice that we can target all p elements by not specifying any classes
or ids. Don't forget your colons or semi-colons! Also, notice that,
unlike R code, text values in CSS (like "red" and "center") shouldn't be
quoted.
:::
:::

Why are we bothering to understand CSS? Unfortunately, understanding CSS
is **essential** for crafting an *attractive* R Shiny app. Without
specifying your own CSS, you will need to:

1.  Accept the very basic-looking default style choices set by R Shiny,
    or

2.  Use generic themes available in add-on packages such as `bslib` that
    are used countless places on the web already.

These are fine things to do if your apps are simple or have limited user
bases, but, in my experience, neither is *nearly* as satisfying as
learning to style your app yourself using some CSS!

## Nothing is new on the web

We've talked about how a website is generally built, and we've looked at
the specific roles that HTML and CSS typically play in that process. In
particular, we discussed the concept of HTML boxes and how a website is
just a series of these boxes, stacked inside each other. Then, the style
of those boxes and their contents is set by CSS.

But what typically goes ***inside*** all those boxes?!

With the internet now over 30 years old, most people have been
interacting with the web for a *long time*! We've all developed many
collective expectations for how websites should look and work. As a
result, most websites are comprised of a set of immediately-recognizable
components. Some of these include:

-   A **header** (a box permanently hooked to the top of the screen/page
    or to the top of a section of the page). This may contain a title, a
    logo, a navigation menu, *etc.*

-   A **footer** (similar to a header but at the bottom of the
    screen/page or section). This might contain contact info, legal
    information, links, disclaimers, version information, *etc.*

-   A "main content area," which might be a single rectangle or multiple
    rectangles of equal or unequal size (such as a "sidebar" and a "main
    panel"). The main content area may contain blocks of text, media
    such as videos, links, articles, *etc.*

    -   Blocks of text may themselves can contain paragraphs, links,
        quotes, articles, lists, headings, and many more sub-boxes!

-   **Forms**, *i.e.*, boxes that contain multiple information-gathering
    **widgets**, which are elements a user can interact with and expect
    some response, such as a drop-down menu or a slider.

    -   Think here about the interactions you have when ordering takeout
        through a restaurant's website, for example. Many of those
        interactions occur via widgets.

-   **Modals**, which you probably know as "pop-ups." These partially or
    wholly obscure the rest of the webpage and may contain additional
    information, options, or alerts.

-   Backgrounds, which may hold images, solid colors, gradients, or
    patterns.

-   Navigation systems, such as buttons, scroll bars, or drop-down menus
    that allow users to move to different pages on the same site.

All of the elements above (and many more!) can be added to the websites
you design using R Shiny. As such, some of the first and most important
decisions you'll make when building a Shiny app (or any website) is
deciding:

1.  **What** elements your app will contain,

2.  **Where** they will go,

3.  **How** they will look, and

4.  What they'll enable a user to **do**.

While the list above is not exhaustive, it should help you start making
these decisions.

::: challenge
Consider the webpage below:

![](fig/clipboard-1560346890.png)

Like all webpages, this is just a series of "boxes inside of other
boxes." Draw a version of the site as just that series of boxes, then
label what each box seems like it is designed to hold (don't bother
drawing every single box, just the "major" or distinctive ones).

As you do that, list different components inside these boxes that are
familiar to you from other websites you've visited (things like buttons,
text blocks, etc.).

::: solution
Here's what I noticed and identified:

![](fig/clipboard-2886539574.png)

You may have noticed more, fewer, or different things—that's ok!
:::
:::

::: keypoints
-   Websites are typically built by using HTML, CSS, and JS to construct
    the "client side" of the site, which runs in a user's browser on
    their computer, and by using SQL plus a general programming language
    like Python to construct the "server side" of the website, which
    runs remotely on a server that communicates back and forth with the
    user's browser.
-   R Shiny allows you to build a website entirely using R + R Shiny
    code such that a deep understanding of other web development
    languages is not required.
-   However, a *little* familiarity with HTML and CSS is helpful for
    building a great app as well as for understanding what you are
    really doing when you are writing "R Shiny" code. That's ok because
    HTML and CSS are much more approachable languages to learn than
    general programming languages.
-   HTML is a system for telling a browser what to put where when it
    builds a website. Most websites are just "boxes" that hold stuff,
    including other boxes. Some of these boxes force new lines after
    them; others don't. How boxes will "flow" on wide versus narrow
    screens depends on how they are set up.
-   CSS is a system for telling a browser how to aesthetically display
    each element on a website. It consists of rules applied to specific
    HTML boxes.
-   Website design has matured to the point that most websites look and
    feel broadly similar and share many elements, such as buttons,
    links, widgets, articles, media blocks, and so on. R Shiny lets us
    add these same elements to our own websites, so we have many options
    when deciding what elements our app will contain.
:::
