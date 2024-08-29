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
