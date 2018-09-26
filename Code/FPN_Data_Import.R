#FPN table
#Aggregate to LSOA
FPN_data <- read_csv("data/csv Files/FPN_data.csv", col_types = cols(log_effective_date = col_datetime(format = "%d/%m/%Y %H:%M")))

#Turn into tibble - because

FPN_data<- as_tibble(FPN_data)

#Define Coordinates
coordinates(FPN_data) <- c("site_cent_east", "site_cent_north")

#Set CRS as BNG
proj4string(FPN_data) <- CRS("+init=epsg:27700")

#Convert to WGS84
FPN_data <- spTransform(FPN_data, crs("+init=epsg:4326"))
#Trim to Cant Distict
FPN_data <- FPN_data[cant,]

#Rename Column
names(FPN_data@data)[names(FPN_data@data)=="subject_name"] <- "FPN.Type"


# Add ID to FPN Data
FPN_data@data <- mutate(FPN_data@data, id_report = as.numeric(rownames(FPN_data@data)))

#Overlay reports over LSOA & create table "report_lsoa"
FPN_report_lsoa <- over(FPN_data, lsoa.FPN)

#Add ID to new table "report_lsoa"
FPN_report_lsoa <- mutate(FPN_report_lsoa, id_report = as.numeric(rownames(FPN_report_lsoa)))
FPN_report_lsoa <- subset(FPN_report_lsoa, is.na(FPN_report_lsoa$LSOA11CD)==FALSE)

#Join back to spatial report data by ID
FPN_data@data <- left_join(FPN_data@data, FPN_report_lsoa, by = c("id_report" = "id_report"))

#Now each report has an LSOA code against it. Now we can aggregate by LSOA
#Take report_data                   Group by LSOA           Count Groups
FPN_report_lsoa <- FPN_report_lsoa %>% 
  group_by(LSOA11CD) %>% 
  count() %>%
  setNames(c("LSOA11CD", "Count.FPN"))

#Join Count back to LSOA Spatial
lsoa.FPN@data <- left_join(lsoa.FPN@data, FPN_report_lsoa)
colnames(lsoa.FPN@data) <- c("OBJECTID","LSOA11CD" ,"LSOA11NM", "Count.FPN")

#Group by Month
FPN.month.summary <- FPN_data@data %>%
  group_by(month=floor_date(log_effective_date, "month")) %>%
  count()

#rename Columns
colnames(FPN.month.summary) <- c("Month", "Count.FPN.pcm")

#Day summary - Counts indident by day
FPN.day.summary <- FPN_data@data %>% 
  group_by(day=floor_date(log_effective_date, "day")) %>% 
  count()
colnames(FPN.day.summary) <- c("Day", "Count.per.day")

#Add day of week
FPN.day.summary$Weekday <- wday(FPN.day.summary$Day, label = TRUE, abbr = FALSE)

#Count by day of the week
FPN.dow.summary <- FPN.day.summary %>% 
  group_by(Weekday) %>% 
  count()

#LSOA/Time Count
FPN.lsoa.month.count <- FPN_data@data %>%
  group_by(LSOA11CD, month=floor_date(log_effective_date, "month")) %>%
  count() %>%
  set_colnames(c("LSOA11CD","Month", "Count.per.LSOA.per.Month"))

#LSOA/Type Count
FPN.type.LSOA <- FPN_data@data %>%
  group_by(LSOA11CD, FPN.Type) %>%
  count() %>%
  set_colnames(c("LSOA11CD","FPN.Type", "Count.Type.LSOA"))

#LSOA/Litter Count
LSOA.litter.count <- FPN_data@data %>%
  group_by(LSOA11CD) %>%
  count(FPN.Type == "Depositing Litter"| FPN.Type == "Fixed Penalty Notice Litter") %>%
  set_colnames(c("LSOA11CD","Littering", "Count.Litter.FPN")) %>%
  filter(Littering == TRUE)
LSOA.litter.count <- LSOA.litter.count[,c(1,3)]
