---
title: Setup
---

## Required Setup

This lesson assumes you have R and RStudio installed. If you need either, use the links below:

-   [Download and install the latest version of R](https://www.r-project.org/) for your operating system.

-   [Download and install RStudio](https://posit.co/download/rstudio-desktop/#download) for your operating system.

RStudio is an application (an integrated development environment, or IDE, to be exact) that facilitates the use of R and offers a number of nice features. While R Studio is not *strictly* required to use base R, it is all but required to build Shiny app (to try to build a Shiny app in base R sounds nightmarish to me, and I'm not sure it's even possible).

This lesson also takes advantage of several add-on packages for R that do not come bundled with R's default installation. While we will also pause to install these packages during the lesson, the process can take some time, so these packages can be installed ahead of time using the following command:

``` r
install.packages(c("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "sf"))
```

## Data Sets

We'll use the `gapminder` data set for this lesson, available via the `gapminder` package:

``` r
library(gapminder)
gap = gapminder
```

I recommend accessing it via the code above, [but you may also download it via this link](data/gapminder.csv).

For the `leaflet` portion of the lesson, we'll need spatial data to work with. You can download a special version of the `gapminder` data set with spatial data attached via this link: [Link to the gapminder data set with attached spatial data](https://drive.google.com/uc?export=download&id=1YePuKxTlBgW1hQ2uwXHi8b9UJEPUCoDh).

## Disclaimers

This lesson assumes a working understanding of the R programming language and of the RStudio IDE. [This workshop is **not** an introduction to R or RStudio, and it is *not* recommended for users who need either thing]{.underline}. Those who do are *strongly* encouraged to complete, at a minimum, [the "Welcome to R" and "Control Flow" lessons available on our website](https://umn-dash.github.io/r-novice-gapminder/welcome-to-r.html) *before* engaging with in this lesson.

A familiarity with the `dplyr`, `ggplot2`, and `sf` packages and their syntax will be helpful later in the lesson, but it is not required.
