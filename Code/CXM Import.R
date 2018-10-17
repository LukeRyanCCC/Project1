#Import Flytipping Reports - original data from website
CXM_data <- as_tibble(read.csv("C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/csv Files/CXM1510.csv",
                               header = TRUE, stringsAsFactors = TRUE))

#Get unique Report Types
i <- 1
t <- sort(unique(CXM_data$Type.of.flytipping))
l <- length(t)
new_values <- as.character(c("Furniture", "Household waste & bin bags",
                             "Needles/Chemical Waste", "Other", 
                             "Trolleys", "White Goods"))
while(i <= l){
  CXM_data$Type.of.flytipping <- gsub(t[i],new_values[i], 
                                       CXM_data$Type.of.flytipping)
  i <- i + 1
}
rm(i, t, l, new_values)

#Split coordinates from Google Maps URL
coords <-as_tibble(unlist(str_split_fixed(str_sub(CXM_data$Coordinates,34,str_length(CXM_data$Coordinates)),",",n=2)))
#Set coordinate column names
names(coords) <- c("Latitude","Longitude")
#Change to numeric
coords$Latitude <- as.numeric(coords$Latitude)
coords$Longitude <- as.numeric(coords$Longitude)


#Join to original data
CXM_data <- as_tibble(cbind(CXM_data,coords))
#Remove Coords to keep environment clean
rm(coords)
#Strip NA Coords
CXM_data <- subset(CXM_data, is.na(CXM_data$Latitude)==FALSE)


#Coerse DateTime field to "acceptable datetime format
CXM_data$Date.created <- as.POSIXct(CXM_data$Date.created, tz = "", "%d/%m/%Y %H:%M")
#Make reports data spatial
coordinates(CXM_data) <- c("Longitude","Latitude")
#Set CRS
proj4string(CXM_data) <- CRS("+init=epsg:4326")


#Trim results to Canterbury polygon
CXM_data <- CXM_data[cant,]
CXM_data@data <- CXM_data@data[,-4]

source("CXM Join.R")
