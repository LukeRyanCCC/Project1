#Import spatial datasets

#Import Canterbury District Shapefile
cant <- readOGR(dsn = "data/shp Files/Canterbury_District.shp")

#Import Wards Shapefile
wards <- readOGR(dsn = "data/shp Files/Wards.shp")

#clip "wards" to Canterbury District
wards <- intersect(wards, cant)

#Import LSOA Shapefile
lsoa <- readOGR(dsn = "data/shp Files/LSOA.shp")

#Transform .shp files to match imported WGS84
cant <- spTransform(cant, crs("+init=epsg:4326"))
wards <- spTransform(wards, crs("+init=epsg:4326"))
lsoa <- spTransform(lsoa, crs("+init=epsg:4326"))

#Replicate LSOA Shapefile
lsoa.CXM <- lsoa
lsoa.FPN <- lsoa
lsoa.Crime <- lsoa
lsoa.Claimant <- lsoa

#Calculate LSOA area
lsoa.list <- sapply(X = slot(object = lsoa, name = "polygons" ), 
            FUN = function(i) sp::coordinates(obj = slot(object = i, name = "Polygons")[[1]]))
lsoa@data$area.km2 <- (sapply(X = lsoa.list, FUN = geosphere::areaPolygon))/1000000
rm(lsoa.list)

#Join Population to LSOA
source("Population Load.R")
lsoa@data <- left_join(lsoa@data, population)

#Population density
lsoa@data$Pop.Denisty <- lsoa@data$Population/lsoa@data$area.km2

#Join IMD to LSOA
source("IMD Import.R")
lsoa@data <- left_join(lsoa@data, imd)

