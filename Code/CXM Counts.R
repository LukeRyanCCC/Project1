#Attempt to run this as a function

#Group and Count by LSOA and Report Type
CXM.LSOA.Type <- CXM_data@data %>%
  group_by(LSOA11CD,Type.of.flytipping) %>%
  count()
source("LSOA Report types to Column.R")

CXM.MSOA.Type <- CXM_data@data %>%
  group_by(MSOA11CD,Type.of.flytipping) %>%
  count()
source("MSOA Report types to Column.R")



#Group by month and count - 
#***Floor date rounds down date to 1st of month***
CXM.month.summary <- CXM_data@data %>% 
  group_by(month=floor_date(Date.created, "month")) %>% 
  count() %>%
  setNames(c("Month", "Count"))

#Day summary - Counts indident by day
CXM.day.summary <- CXM_data@data %>% 
  group_by(day=floor_date(Date.created, "day")) %>% 
  count() %>%
  setNames(c("Day", "Count"))

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

#******************************************************************************
#Potential new method
#Curently changes LSOA to list and loses spatial elements
#Possible to create a intermediate and left_join BUT need to ensue LSOA Code goes with Count
#New join method
#   lsoa <- over(SpatialPolygons(lsoa@polygons), SpatialPoints(report_data), returnList = TRUE)
#   lsoa$count <- unlist(lapply(lsoa, length))