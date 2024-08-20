---
title: Setup
---

## Required Setup

This lesson assumes you have R and RStudio installed. If you need either, use the links below:

-   [Download and install the latest version of R](https://www.r-project.org/) for your operating system.

-   [Download and install RStudio](https://posit.co/download/rstudio-desktop/#download) for your operating system.

RStudio is an application (an integrated development environment, or IDE, to be exact) that facilitates the use of R and offers a number of nice features. While R Studio is not *strictly* required to use base R, it is all but required to build Shiny app (to try to build a Shiny app in base R sounds nightmarish to me, and I'm not sure it's even possible).

This lesson also takes advantage of several add-on packages for R that do not come bundled with R's default installation. These packages can be installed using the following command within R/RStudio:

``` R
install.packages("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "countrycode", "sf")
```

## Data Sets

For the `leaflet` portion of the lesson, we'll work with **spatial data**. Download [this zipped file of spatial data containing country boundaries](data/TM_WORLD_BORDERS_SIMPL-0.3.zip). Unzip it and place it on your desktop; you'll move it later in the lessons.

We'll also use the `gapminder` data set for this lesson, available via the `gapminder` package:

``` R
library(gapminder)
gap = gapminder #<--OR WHATEVER YOU'D PREFER TO CALL IT.
```

I recommend accessing it via the code above, [but you may also download it via this link](data/gapminder.csv).

## Disclaimers

This lesson assumes a working understanding of the R programming language and of the RStudio IDE. [This workshop is **not** an introduction to R or RStudio, and it is *not* recommended for users who need either thing]{.underline}. Those who do are *strongly* encouraged to complete, at a minimum, [the "R for Reproducible Scientific Analysis" workshop](https://umn-dash.github.io/r-novice-gapminder/index.html) *before* engaging with in this lesson.
