---
title: Setup
---

## Required Setup

This lesson assumes you have R and RStudio installed on your computer. If you need either or both of these, use the links below:

-   [Download and install the latest version of R](https://www.r-project.org/) for your operating system.

-   [Download and install RStudio](https://posit.co/download/rstudio-desktop/#download) for your operating system. RStudio is an application (an integrated development environment or IDE) that facilitates the use of R and offers a number of nice additional features. You will need the free Desktop version.

This lesson also takes advantage of several add-on packages for R that do not come bundled with R's default installation. These packages can be installed using the following command within R or RStudio:

```{r installing packages, eval=F}
install.packages("shiny", "dplyr", "ggplot2", "leaflet", "DT", "plotly", "gapminder", "countrycode", "sf")
```

## Data Sets

For the `leaflet` portion of the workshop, we will need to work with some spatial data. Please download [this zipped file of spatial data containing country boundaries](data/TM_WORLD_BORDERS_SIMPL-0.3.zip). Unzip it onto your desktop for now; you will be asked to move it to a new location later.

We'll also be using the `gapminder` data set for this set of lessons. This data set is available via the `gapminder` package within R:

```{r gapminder data, eval=F}
library(gapminder)
gap = gapminder #<--OR WHATEVER YOU'D PREFER TO CALL THIS SHORTCUT.
```

We recommend accessing this data set as shown above. [However, you may also download it via this link](data/gapminder.csv).

## Disclaimers

This lesson assumes a working understanding of programming in R and of navigating the RStudio IDE. [This workshop is **not** an introduction to R or to RStudio, and it is not recommended for users who need either of these things]{.underline}. Those who need R instruction are strongly encouraged to take, at a minimum, [the "R for Reproducible Scientific Analysis" workshop](https://umn-dash.github.io/r-novice-gapminder/index.html) before enrolling in this workshop.
