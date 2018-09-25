#Import Flytipping Reports - original data from website
CXM_data <- as_tibble(read.csv("data/csv Files/CXM1009.csv", header = TRUE, stringsAsFactors = TRUE))

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

#******************************************************************************
#Potential new method
#Curently changes LSOA to list and loses spatial elements
#Possible to create a intermediate and left_join BUT need to ensue LSOA Code goes with Count
#New join method
#   lsoa <- over(SpatialPolygons(lsoa@polygons), SpatialPoints(report_data), returnList = TRUE)
#   lsoa$count <- unlist(lapply(lsoa, length))

# Add ID to Report Data
CXM_data@data <- mutate(CXM_data@data, id_report = as.numeric(rownames(CXM_data@data)))

#Overlay reports over LSOA & create table "CXM.report.lsoa"
CXM.report.lsoa <- over(CXM_data, lsoa.CXM)

#Add ID to new table "CXM.report.lsoa"
CXM.report.lsoa <- mutate(CXM.report.lsoa, id_report = as.numeric(rownames(CXM.report.lsoa)))
CXM.report.lsoa <- subset(CXM.report.lsoa, is.na(CXM.report.lsoa$LSOA11CD)==FALSE)

#Join back to spatial report data by ID
CXM_data@data <- left_join(CXM_data@data, CXM.report.lsoa, by = c("id_report" = "id_report"))

#Now each report has an LSOA code against it. Now we can aggregate by LSOA
#Take report_data                              Count Groups
CXM.report.lsoa <- CXM_data@data %>%
  group_by(LSOA11CD) %>% #Group by LSOA
  count() %>% #Count
  setNames(c("LSOA11CD", "Count.Reports")) 

#Join Count back to LSOA Spatial
lsoa.CXM@data <- left_join(lsoa.CXM@data, CXM.report.lsoa, by = c("LSOA11CD" = "LSOA11CD"))

#Remame coulmn "n" to "Count"
colnames(lsoa.CXM@data) <- c("OBJECTID", "LSOA11CD", "LSOA11NM", "Count.Reports")
lsoa.CXM$Count.Reports[is.na(lsoa.CXM$Count.Reports)] <- 0

#Group by month and count - 
#***Floor date rounds down date to 1st of month***
CXM.month.summary <- CXM_data@data %>% 
  group_by(month=floor_date(Date.created, "month")) %>% 
  count()

#rename Columns
colnames(CXM.month.summary) <- c("Month", "Count")

#Day summary - Counts indident by day
CXM.day.summary <- CXM_data@data %>% 
  group_by(day=floor_date(Date.created, "day")) %>% 
  count()
colnames(CXM.day.summary) <- c("Day", "Count")

#Add day of week
CXM.day.summary$Weekday <- wday(CXM.day.summary$Day, label = TRUE, abbr = FALSE)

#Count by day of the week
CXM.dow.summary <- CXM.day.summary %>% 
  group_by(Weekday) %>% 
  count()

#DO NOT RUN YET, need to assess outcomes

# # # row.names(month_summary) <- month(month_summary$month)


#Week summary
week_summary <- CXM_data@data %>% 
  group_by(week=floor_date(Date.created, "week")) %>% 
  count()
colnames(week_summary) <- c("Week", "Count")
week_summary$Week <- week(week_summary$Week)



#LSOA Crime Count Method
#lsoa_crime <- over(SpatialPolygons(lsoa@polygons), SpatialPoints(report_data), returnList = TRUE)
#lsoa_crime$count <- unlist(lapply(lsoa, length))











