#Replicate Shapefiles
lsoa.CXM <- lsoa

# Add ID to Report Data
CXM_data@data <- mutate(CXM_data@data, id_report = as.numeric(rownames(CXM_data@data)))

#Overlay reports over LSOA & create table "CXM.report.lsoa"
CXM.report.lsoa <- over(CXM_data, lsoa.CXM)

#Add ID to new table "CXM.report.lsoa"
CXM.report.lsoa <- mutate(CXM.report.lsoa,
                          id_report = as.numeric(rownames(CXM.report.lsoa)))
CXM.report.lsoa <- subset(CXM.report.lsoa,
                          is.na(CXM.report.lsoa$LSOA11CD)==FALSE)

#Join back to spatial report data by ID

CXM_data@data <- left_join(CXM_data@data, CXM.report.lsoa,
                           by = c("id_report" = "id_report"))


#Now each report has an LSOA code against it. Now we can aggregate by LSOA
#Take report_data                              Count Groups
count.report.lsoa <- CXM_data@data %>%
  group_by(LSOA11CD) %>% #Group by LSOA
  count() %>% #Count
  setNames(c("LSOA11CD", "Total Reports")) 

#Join Count back to LSOA Spatial
lsoa.CXM@data <- left_join(lsoa.CXM@data, count.report.lsoa,
                           by = c("LSOA11CD" = "LSOA11CD")) 
lsoa.CXM$`Total Reports`[is.na(lsoa.CXM$`Total Reports`)] <- 0
  
source("CXM Counts.R")
