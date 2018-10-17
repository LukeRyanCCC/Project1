#Count total crime by LSOA
LSOA.total.crime <- crime %>%
  group_by(LSOA.code) %>%
  count() %>%
  setNames(c("LSOA.code", "Total Crime"))
#Count by type & LSOA
crime.type.LSOA <- crime %>%
  group_by(LSOA.code, Crime.type) %>%
  count() %>%
  setNames(c("LSOA.code", "Crime.type", "Count.Type"))
source("LSOA Crime type to column.R")
rm(crime.type.LSOA)


#Count total crime by MSOA
MSOA.total.crime <- crime %>%
  group_by(MSOA11CD) %>%
  count() %>%
  setNames(c("MSOA11CD", "Total Crime"))  
#Count by type & MSOA
crime.type.MSOA <- crime %>%
  group_by(MSOA11CD, Crime.type) %>%
  count() %>%
  setNames(c("MSOA11CD", "Crime.type", "Count.Type"))
source("MSOA Crime type to column.R")
rm(crime.type.MSOA)



#Count by Month 
crime.month.summary <- crime %>%
  group_by(Month) %>%
  count()

#Group by LSOA then Month
lsoa.month.summary <- crime %>%
  group_by(LSOA.code, Month) %>%
  count() %>% 
  setNames(c("LSOA.code", "Month", "Count.Crime"))

#Group by MSOA then Month
msoa.month.summary <- crime %>%
  group_by(MSOA11CD, Month) %>%
  count() %>% 
  setNames(c("MSOA11CD", "Month", "Count.Crime"))

#Group by Month and Crime type
crimetype.month.summary <- crime %>%
  group_by(LSOA.code, Month, Crime.type) %>%
  count() %>%
  setNames(c("LSOA11CD", "Month", "Crime.Type", "Count"))

#Basically creates LSOA as table with all spatial data, but isn't actually spatial
#gp_lsoa <- fortify(lsoa)
#Assign row names (numbers) - used later in  ggplot
#soa$id <- row.names(lsoa)
#Attributes like LSOA11CD are dropped during fortify so we left_join LSOA@data back via the ID
#gp_lsoa <- left_join(gp_lsoa, lsoa@data, by = c("id"="id"))

#Now we can join the LSOA crime data summaried earlier to table
#gp_lsoa <- left_join(gp_lsoa, lsoa.month.summary, by = c("LSOA11CD" = "LSOA.code")) 

#Add formatted date field to act as titles
#gp_lsoa$New.Month <- format(gp_lsoa$Month, "%B %Y")