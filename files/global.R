### LOAD PACKAGES
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(leaflet)
library(gapminder)
library(sf)

### LOAD DATA SETS
gap = as.data.frame(gapminder)
gap_map = readRDS("gapminder_spatial.rds")
