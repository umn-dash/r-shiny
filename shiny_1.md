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
-   Develop a foundational understanding of HTML and CSS.
:::

::: questions
-   How is a website built?
-   How is building a website using R Shiny similar to/different from
    doing so the "usual" way?
-   What does a website "look like," under the hood? What are the most
    common website "building blocks?"
:::

**Important**: This course assumes you have working knowledge of the R
programming language and the RStudio Integrated Development Environment
(IDE). If either is new to you, you could struggle with this course
(although the "normal R code" we'll write will generally be basic). You
may consider taking an Intro R course before this one.

By contrast, this course assumes **no** web development experience. If
you have some, this course may be too introductory or simplified to
capture your full attention, though you may still find it interesting as
an overview of the R Shiny framework.

## The web's languages

R is a **programming language,** a fancy way of saying *it's a system
with which we can direct a computer to do things for us*.

Just like a human language, R possesses:

-   " nouns" (**objects**),

-   "verbs" (**functions**),

-   "punctuation" (**operators** like `<-` and `%>%`),

-   "questions" (**logical tests** like `x == y`), and

-   "grammar/syntax" (**rules** like `1a` being an unacceptable object
    name but `a1` being valid).

To have a successful "R conversation," we must form valid and complete R
"sentences" (**commands**) and "paragraphs" (**code blocks**) in which
we create nouns, subject them to verbs, and follow all the rules, just
as we would for a human language.

R Shiny, meanwhile, is *not* a **programming language.** Instead, it (in
combination with R) is what a web developer might call a **framework**:
a set of tools used to build a complete website. Specifically, it
leverages R and its conventions/grammar/syntax to accomplish that task
(as opposed to using other, comparable tools).

To appreciate how R Shiny is distinct as a web development framework,
and to understand how to use it *well*, we need to understand a few
basic things about "normal" web development. These are:

1.  What *languages* are typically used to build websites, what each is
    for, and how each works at a basic level,

2.  The *structure* of a typical website (the "wheres"), and

3.  The typical *components* (the "whats") of a website.

Those will be this first lesson's topics.

## How the web is woven

To generalize, a website is constructed using several languages, each to
accomplish discrete objectives. The most notable of these are **HTML**,
**CSS**, and **JavaScript** (**JS** for short):

-   **HTML** is used to *structure* a website. It's how a web developer
    specifies **what** elements a user can see and **where** these
    should go on the page.

-   **CSS** is used to *design* a website. It's how a web developer
    specifies **how** each element should **look** (its colors, size,
    *etc.*).

-   **JavaScript** is used to code a website's *behaviors*. A website is
    largely just an application running inside of your browser (*e.g.*,
    Edge or Safari). While it runs, any changes to the website are
    likely coded using JavaScript.

    -   For example, if a webpage contains a button, and if the button
        disappears when pressed (a shift in the site's HTML), the page
        turns green (a shift in the site's CSS), and some data you
        provided are sent to a database (a shift in the app's
        relationship with the wider internet), JS is likely dictating
        those shifts.

Together, HTML, CSS, and JS make up the languages commonly used to
assemble the "*front end*," "*user interface*," or "*client side*" of a
website. A website's **user interface** (UI for short) is what a user
sees and interacts with.

As far as most users are concerned, the UI that they see *is* the
website; most assume a website is just the "one thing" and that it lives
somewhere "out there," on the internet.

However, there is *always* a second "half" to a website. Somewhere in
the world, a *server* (a computer, basically, but more automated than a
personal computer) acts as a website's **host**, receiving requests for
information, sending that information out to users, and handling new
data collection.

A server might also need to store private data, such as passwords, or do
complex operations that would be awkward to have a user's computer do.
It also may perform security checks to ensure users aren't trafficking
malware or spam.

For all these purposes and more, websites have "back ends" or "server
sides" that run on their servers. Here, SQL might be used to carefully
store or read data from large databases, and a whole host of other
programming languages might be used for complex operations and other
tasks, including JS again but also PHP, Python, Ruby on Rails, and C#,
just to name a few!

When a web developer talks about a framework, they are referring to the
*entire* set of tools and languages needed to build both halves of a
website. So, for example, HTML + CSS + JS (front end) + PHP + SQL (back
end) is a popular framework.

To recap, here's how a website actually works:

1.  When you visit a website, a server hosting that website gets a
    request from your browser to "see the website."

2.  The server responds by sending your browser a packet of files
    (including a bunch of HTML, CSS, and JS files, usually).

3.  These are opened by your browser and deciphered (it's fluent in all
    these languages).

4.  Your browser then builds the website you can then see and interact
    with per the instructions the server sent. The website is not "out
    there somewhere;" it's "alive" on *your* computer!

5.  When the website needs "further instructions" of how to behave or
    what content to show, the "dialogue" you've started with the server
    continues, and new files are sent, received, and deciphered.

::: discussion
Have you ever had to clear your browser's **cache**? What do you think
gets deleted when you do that?

::: solution
A good portion of your cache (in terms of numbers of files, anyway) will
be HTML, CSS, and JS files sent to you by servers to build the websites
you've been visiting! However, there will be additional files, including
image and video files (which can be *very* bulky), files for special
fonts that website want you to use (perhaps because their logo uses
them), and JSON files (text files that can store data), among others.
:::
:::

#### Where R Shiny fits in

When you build a website using R Shiny, you'll be writing two kinds of
code (for the most part):

-   "Normal" R code and

-   "R-like," or "R Shiny" code.

The latter will *look* a lot like R code to you (that's the point!).
However, when a Shiny app is compiled, your R Shiny code will be
translated into the equivalent HTML, CSS, and JS code so a browser can
understand it. This means we can build the *entire* UI of a website
*without* needing to know much, if any\*, HTML, CSS, or JS (\*sort of)!

The "normal" R code you'll write into your app, meanwhile, will largely
operate within your website's "back end' (or "server side"), where it
may manipulate data sets, send data to storage locations, keep track of
user actions, etc. This means we can build the entire server side of a
website without needing to know much, if any\*, JS, PHP, Ruby on Rails,
Python, SQL, etc. (\*unless we want to)!

So, the R + R Shiny framework enables us to build both halves of a fully
interactive, complex website without necessarily knowing *any* other web
development languages or frameworks!

In particular, R admirably takes the place of other, general programming
languages typically used for handling server-side tasks, such as Python
or PHP, *especially* when those tasks revolve around data manipulation,
management, or display—R excels at all things "data!"

::: discussion
Hopefully, you now recognize that websites can be built both with and
without R Shiny. What is *different* about building a website using R
Shiny, then?

::: solution
A few things are different about building a website using R Shiny, but I
think the two most important differences are:

1.  Whereas writing "pure" HTML, CSS, and JS is often necessary to build
    a website's UI, (deep) knowledge of these languages is **not**
    required to build a website using R Shiny. Instead, you will write R
    code + R Shiny code, and these will get "translated" into the
    equivalent HTML, CSS, and JS code for you. \
    \
    Granted, this means you *still* need to learn how to write "R Shiny
    code," and you may or may not find this code much more familiar than
    the code it's replacing (though you *probably* will). More on that
    in a sec...

2.  Normally, to construct the "back end" of a website, a general
    programming language like PHP or Python is used. These languages are
    quite different from JS, so designing a conventional website often
    requires programming in (at least) two *different* general
    programming languages (*e.g.*, JS and PHP), at least one of which
    you may never have encountered before (JS and PHP are not widely
    used for other purposes). \
    \
    With R Shiny, you can code *both* the front and back ends of a
    website using the "look and feel," at least, of just *one* general
    programming language (R).
:::
:::

## Let's meet HTML and CSS

I said above that R Shiny ensures you don't *need* to learn HTML and CSS
to build a website. That statement is no lie!

...However, because some of your R Shiny code must be *translated into*
HTML/CSS code, there is a forced similarity between the two systems such
that, much of the time, you'll *really* be writing more or less thinly
veiled HTML/CSS code, even when you're writing "Shiny code."

This code may *look* "R-like," but it won't always *feel* "R-like," and
some of the Shiny code you'll be asked to write will seem downright
foreign because of all the ways it will be beholden to these other two
languages.

As such, to build a *really* nice Shiny app, and to feel like you know
not just *what* your code is doing but *why* it looks the way it does,
it's helpful to understand the very basics of HTML and CSS.

If the prospect of learning two more languages sounds daunting, perhaps
because learning R was difficult, *don't panic*! Compared to learning R,
learning the basics of HTML and CSS is *much* easier because these
languages aren't *general* *programming* languages like R is. They have
much narrower purposes, so they need a lot fewer "words" and "rules" to
do their jobs than R does. Knowing even a *little* about these two
languages will go a *long* way, I promise!

### HTML 101

We'll start with HTML, since it's the foundation of a website. Pretty
much everything an R Shiny developer **really** needs to understand
about HTML can be collapsed into four key concepts:

#### Key concept #1: All websites are just "boxes within boxes"

At its core, every website is just a box containing one or more
additional boxes, each of which might contain *yet more* boxes, and so
on all the way down.

By "box" here, I mean "a container that holds stuff," not "a rectangle"
(though a lot of website boxes *are* rectangles).

All HTML does is tell your browser which boxes go inside which other
boxes and what every box should contain. Besides other boxes, HTML boxes
can hold blocks of text, pictures, links, menus, lists, and much
more—all the stuff we associate with the websites we visit.

In terms of raw code, every HTML box looks *something* like this:

``` html
<div id = "my_box">My box's contents</div>
```

That means (almost) every HTML box has:

-   An **opening tag** (*e.g.*, `<div...>`), which tells the browser
    where the box "starts."

-   A **closing tag** (*e.g.*, `</div>`), which tells the browser where
    a box has "ended."

-   Space for *contents* (here, that's the text `My box's contents`),
    found between the opening tag's `>` and the closing tag's `<`.

-   Space inside the opening tag for *attributes*, which are things that
    make boxes "special."

    -   Here, we gave our box a unique `id` attribute called `"my_box"`
        using `attribute = "value"` format.

In R Shiny, you can build the exact same box but using "R-like code:"

``` r
div(id = "my box",
    "My box's contents")
```

Here, we've replaced HTML's **tag notation system** involving `<>`s with
R's **function notation system** and its `( )`s, and we specify
attributes and box contents using R's traditional **function argument
system**.

#### Key concept #2: Websites have heads and bodies

To oversimplify a little, every website is just an HTML box
(`<HTML>...</HTML>`) containing two smaller boxes: a "head"
(`<head>...</head>`) and a "body" (`<body>...</body>`).

The head's contents are (mostly) invisible to a user; instead, the head
contains further instructions for *how* the browser should construct the
website.

The body box, meanwhile, contains everything the user can see and
interact with.

In R Shiny, we don't need to build the HTML, head, or body boxes—those
will be made for us. Instead, we will spend most of our time just
specifying the stuff that will go inside the body box.

However, we can (and sometimes will need to) put things in the head box.
This is done using the `tags$head()` function:

``` r
tags$head(#...)
```

#### Key concept #3: Inline vs. block elements

Broadly speaking, there are two kinds of body HTML boxes: **inline**
boxes and **block** boxes. The difference is how each type is displayed
when a website is built.

A **block element** takes up the *entire* horizontal "row" it is played
on. In other words, it'll occupy the *entire* width of the browser
window (if allowed), and it'll force the next item to go *below* it
rather than *next* to it, as though the browser was forced to hit the
"Enter" key after building it.

For example, the `<p>...</p>` element (created in Shiny using `p()`)
creates "paragraph" boxes (or, more accurately, boxes for text blocks,
which can be more or less than one paragraph in size). If you put
several consecutive paragraph boxes inside your body box, they would
display in a column, with the first one at the top and the last one at
the bottom, and each would occupy the full width of the screen available
to them:

![](fig/clipboard-3243983914.png)

**Inline elements**, meanwhile, only take up as much horizontal space as
they have to (by default) to accommodate the size of their contents, and
thus they can go next to each other on the same line (if there's room);
they don't *force* new lines after them.

For example, the `<a>...</a>` element (made in R using `a()`) is a box
that holds a link. You could use several such boxes within a single
paragraph box without creating a new line after each one.

Certain kinds of website elements "stand alone" or "stand apart" from
others, such as headings and navigation bars. These will generally be
block elements. Other elements "fit together," such as links and images.
These will generally be inline elements.

#### Key concept #4: The Flow

These days, a user might view your website on a very *wide* screen (like
that of a projector) or a very *narrow* small screen (like that of a
cell phone in portrait mode, or even a smart watch!).

If your website has, say, five elements to display, it may not make
sense to *arrange* those five elements the same way on a narrow screen
as you would on a wide screen, just as you probably wouldn't arrange the
same furniture in a tiny room the same as you would in a huge room.

Careless arrangement of elements is often obvious to even casual users.
On narrow screens, elements that are too big "spill" visibly out of the
containers meant to hold them, and when too many elements are stacked
side by side, tedious scroll bars may be the only way of seeing elements
that are otherwise "off-screen."

On wide screens, meanwhile, small elements (especially small block
elements) may look silly without constraints, such as when a single
sentence spans the entire width of the screen. As another example, font
sizes that feel appropriate on a small screen might be unacceptable when
viewed on a computer monitor.

It's hard *enough* to craft *one* great website, though—it'd be a
*nightmare* having to design a different-looking website for *every*
*possible* screen size your users might have!

Thankfully, then, most websites are designed to "flow," or automatically
reorganize their contents according to the size of the user's screen.
For example:

-   Elements that could sit side by side on a large screen may shift to
    being stacked vertically.

-   Elements that might be large on wide screens (such as images) may be
    shrunk to fit comfortably inside their boxes on narrow screens.

-   Some elements may even "teleport" to new locations on the page as a
    screen narrows so that, if all elements are now arranged vertically,
    their order is more logical to a user encountering them that way.

::: challenge
Try it: Go to
[dictionary.com](www.dictionary.com "A link to dictionary.com, a good site for demonstrating the HTML concept of the "flow."")
and vary the width of your browser window by pulling its edges inward.
How does this website "flow?"

::: solution
For me, I saw a number of changes as I shrunk my browser screen: The
menu at the top became a collapsed "hamburger" menu (a button with three
lines that opens to reveal options), the links slid below the search
bar, the word of the day box shrank, and the games sidebar teleported to
much further down on the page.
:::
:::

R Shiny comes with some custom HTML boxes that are "fluid," meaning
their size is flexible and changes automatically according to the size
of their contents. Like inline elements, these boxes will only take up
as much space as necessary. However, their contents will automatically
stack vertically if the screen becomes too narrow. Additionally, they
can be divided into "rows" and "columns" so that elements can be
arranged in a grid-like fashion on wide-enough screens:

![](fig/clipboard-3147076736.png)

The first step of building a great Shiny app is to design your app's
*layout*. What elements should exist, and where should they go? How big
does each need to be? What kinds of devices will your users use? It's
important to remember that your app may not look the same for every user
and to design it with that in mind!

### CSS 101

If HTML is the language that tells a browser **what** to display and
**where** to display it, then CSS is the language that tells a browser
**how** to display it.

Compared to HTML, CSS is even easier to learn (at least, that's my
opinion!). CSS code consists of functional units called **rules**. Each
rule consists of a **selector** and a list of one or more **properties**
paired with **values**:

-   The **selector** is the part that tells a browser which box(es) to
    adjust the appearance of.

-   The list of **properties** tells the browser which characteristics
    of those boxes to change.

-   The list of **values** tells the browser the new values to set for
    each of those characteristics.

Here is what a **CSS rule** might look like:

``` css
p.intro, div#firstintro {
font-style: italic;
font-size: large;
} 
```

On the first line, we have our selector, which is targeting two
different groups of entities simultaneously, with the two targets
separated by a comma:

1.  The first target is paragraph boxes (`p()`s), but *only* those with
    the `intro` class attribute. A **class** is an HTML ***attribute***
    that allows many boxes to be controlled and styled as one. A period
    is used to connect an HTML element type with a **class** in a CSS
    selector (*e.g.*, `p.intro`).

2.  Our second target is `div`s (a generic HTML box), but *only* the one
    with the **id** attribute `firstintro`. `id`s allow us to control or
    style just one specific element. A hashtag connects an HTML element
    type with an `id` in a CSS selector (*e.g.*, `div#firstintro`).

    -   To target all elements of a type (*e.g.*, all `div()`s), write
        only the element name without any periods or hashtags (e.g.
        `div`)

    -   If multiple different types of elements (such as divs and ps)
        have the same class, you can omit an element type and just
        specify the class (e.g., `.intro`).

Inside of our rule's braces, we have a list. Each list item is a pairing
of a **property name** (*e.g.*, `font-style`) and a new **value**
(*e.g.*, `italic`). The property and the value are separated with a
colon, and the pairing ends with a semi-colon. If you get the
punctuation or spelling of a CSS rule wrong (easy to do!), it won't
work, so watch out!

CSS rules get more complex than this one, but they can also be much
simpler, so if this rule makes sense to you, you're in great shape!

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
or ids—just our element name. Don't forget your colons or semi-colons!
Also, notice that, unlike in R, text values in CSS (like "red" and
"center") aren't quoted.
:::
:::

Why should you bother learning any CSS? Unfortunately, understanding
some CSS is **essential** to craft an *attractive* R Shiny app. Without
specifying your own CSS, you'll need to:

1.  Accept the *very* basic default stylingof R Shiny stuff, or

2.  Use generic themes available from packages such as `bslib` that are
    used on countless websites already.

These are fine options if your apps are simple or have limited or
indifferent user bases, but, in my experience, neither is *nearly* as
satisfying as learning to style your app yourself!

## Nothing is new on the web

We've talked about how a website is built, and we've looked at the
specific roles played by HTML and CSS in that process. In particular, we
discussed the concept of HTML boxes and how a website is just a series
of these boxes, stacked inside each other. Then, the style of those
boxes and their contents is customized using CSS.

But what typically goes ***inside*** all those boxes?!

With the internet now over 30 years old, most people have been
interacting with the web for a *long time*! We've developed many
collective expectations for how websites should look and feel. As such,
most websites are comprised of immediately-recognizable components,
including:

-   A **header** (a box permanently hooked to the top of the screen/page
    or to the top of a section of the page). This could contain elements
    like a title, a logo, a navigation menu, *etc.*

-   A **footer** (similar to a header but at the bottom of the
    screen/page/section). This might contain contact info, legal
    information, links, disclaimers, version information, *etc.*

-   A "main content area," which might be a single rectangle or multiple
    rectangles of (un)equal size (such as a smaller "sidebar" and a
    larger "main panel"). This area may contain blocks of text, media
    such as videos, articles, graphics, *etc.*

-   Text blocks, which might contain paragraphs, links, quotes,
    articles, lists, headings, etc.

-   Forms containing information-gathering **widgets**, elements a user
    interact withs and expects a response, such as a drop-down menu or a
    slider.

-   **Modals** (which you may know as "pop-ups"), which partially or
    wholly obscure the webpage and may contain additional information,
    options, or alerts.

-   Backgrounds holding images, solid colors, gradients, or patterns.

-   Navigation systems, such as buttons, scroll bars, or drop-down menus
    that allow users to move around a site.

All these elements (and more!) can be added to the websites you design
using R Shiny. As such, some of the first, and most important, decisions
you'll make when building a Shiny app is deciding:

1.  **What** elements your app will contain,

2.  **Where** they will go, and

3.  What they'll enable a user to **do**.

While the list above is not exhaustive, it should help you start making
these decisions.

::: challenge
Consider the webpage below:

![](fig/clipboard-1560346890.png)

Like all webpages, this one is just a series of "boxes inside of other
boxes." Draw a version of the site as a series of nested boxes, labeling
what each box seems designed to hold (don't bother drawing every box,
just the "major" ones).

As you do, list the different components that you recognize (buttons,
text blocks, etc.).

::: solution
Here's what I noticed and identified:

![](fig/clipboard-2886539574.png)

You may have noticed more, fewer, or different things—that's ok!
:::
:::

::: keypoints
-   Websites are typically built using HTML, CSS, and JS to construct
    the "client side" of the site, which runs in a user's browser on
    their computer, and by using SQL plus a general programming language
    like Python to construct the "server side" of the website, which
    runs remotely on a server that communicates back and forth with the
    user's browser.
-   R Shiny allows you to build a website using just R + R Shiny code,
    such that a deep understanding of other web development languages is
    not required.
-   However, a *little* familiarity with HTML and CSS is helpful for
    building a great app as well as for understanding what you are doing
    when you are writing "R Shiny" code.
-   That's ok because HTML and CSS are more approachable languages than
    general programming languages like R.
-   HTML is a system for telling a browser what to put where when
    building a website. Websites are just "boxes holding stuff and other
    boxes." Some of these boxes force new lines after them; others
    don't. How boxes "flow" on wide versus narrow screens is an
    important design consideration.
-   CSS is a system for telling a browser how to display each element on
    a website. It consists of rules applied to specific HTML boxes that
    specify new values for those boxes' aesthetic properties.
-   Website design has matured enough that most websites look and feel
    similar and share many elements, such as buttons, links, widgets,
    articles, media blocks, and so on. R Shiny lets us add these same
    elements to our websites, so we have many options when deciding what
    elements to include.
:::
