#Load librarys
library_load <- c("plyr", "tidyr", "data.table", "readr",
                  "stringr","maps","sp","rgeos","raster",
                  "tmap","ggplot2","ggmap","leaflet",
                  "spatstat","gstat","sf","dplyr","magrittr",
                  "maptools", "rgdal", "lubridate", "corrplot",
                  "httr", "jsonlite", "zoo", "tibble", "broom",
                  "tweenr", "nomisr", "animation", "magick", "shiny",
                  "rsconnect", "geosphere","RColorBrewer")
lapply(library_load, library, character.only = TRUE)
