#Import spatial datasets

#Import Canterbury District Shapefile
cant <- readOGR(dsn = "C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/shp Files/Canterbury_District.shp") %>%
  spTransform(crs("+init=epsg:4326"))

#Import Wards Shapefile & clip to Canterbury
wards <- readOGR(dsn = "C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/shp Files/Wards.shp")%>%
  spTransform(crs("+init=epsg:4326")) %>%
  intersect(.,cant)

#Import msoa Shapefile and clip to Canterbury
msoa <- readOGR(dsn = "C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/shp Files/MSOA.shp") %>%
  subset(., grepl("Cant", msoa11nm)) %>%
  spTransform(crs("+init=epsg:4326")) %>%
  intersect(.,cant)
msoa@data <- msoa@data %>% 
  select(2,3,5) %>%
  setnames(c("MSOA11CD", "MSOA11NM", "Area"))

#Import LSOA Shapefile
lsoa <- readOGR(dsn = "C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/shp Files/LSOA.shp")%>%
  spTransform(crs("+init=epsg:4326"))

#use look up table to attach MSOA code to each LSOA
lookup <- read.csv("C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/csv Files/OA_Lookup.csv") %>%
  filter(LAD11NM == "Canterbury") %>%
  select(2,4,5)
lookup <- lookup[!duplicated(lookup$LSOA11CD),]

lsoa@data <- lsoa@data %>%
  left_join(.,lookup, by = c("LSOA11CD" = "LSOA11CD"))

#Calculate LSOA area
lsoa.list <- sapply(X = slot(object = lsoa, name = "polygons" ), 
            FUN = function(i) sp::coordinates(obj = slot(object = i, name = "Polygons")[[1]]))
lsoa@data$area.km2 <- (sapply(X = lsoa.list, FUN = geosphere::areaPolygon))/1000000
rm(lsoa.list)

#Join Population to LSOA
source("Population Load.R")
lsoa@data <- left_join(lsoa@data, population)
rm(population)

#Population density
lsoa@data$Pop.Denisty <- lsoa@data$Population/lsoa@data$area.km2

#Join IMD to LSOA
source("IMD Import.R")
lsoa@data <- left_join(lsoa@data, imd)
remove(imd)

