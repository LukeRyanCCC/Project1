#List all Crime csvs from Desktop
crime_files <- list.files("C:/Users/luke.ryan/Desktop/All_Kent_Crime/", pattern = "*csv", full.names = TRUE, recursive = TRUE, include.dirs = TRUE)

#Read csvs then create single table
crime <- lapply(crime_files, read.csv, stringsAsFactors = FALSE) %>% 
  bind_rows() %>%
  dplyr::filter(grepl("Cant",LSOA.name)) %>% #filter for Canterbury LSOAs
  select(2,5,6,8,9,10,11) #Only keep pertinent columns

#Remove crime_files
rm(crime_files)
#Convert Month to POSTIX format via "as.yearmon" from zoo
crime$Month <- as.yearmon(crime$Month) %>%
  as.POSIXct(crime$Month, format = "%b %Y")

#Turn into tibble - because

crime <- as_tibble(crime)

#Basic LSOA Count
crime.count <- crime %>%
  group_by(LSOA.code) %>%
  count() %>%
  setNames(c("LSOA11CD", "Crime.Count"))

#Group by LSOA then Month
lsoa.month.summary <- crime %>%
  group_by(LSOA.code) %>%
  group_by(Month, add = TRUE) %>%
  count()

#rename Columns
colnames(lsoa.month.summary) <- c("LSOA.code", "Month", "Count.Crime")

#Reverse
month.lsoa.summary <- crime %>%
  group_by(Month) %>%
  group_by(LSOA.code, add = TRUE) %>%
  count()

#rename Columns
colnames(month.lsoa.summary) <- c("Month", "LSOA.code", "Count.Crime")

#Basically creates LSOA as table with all spatial data, but isn't actually spatial
gp_lsoa <- fortify(lsoa)
#Assign row names (numbers) - used later in  ggplot
lsoa$id <- row.names(lsoa)
#Attributes like LSOA11CD are dropped during fortify so we left_join LSOA@data back via the ID
gp_lsoa <- left_join(gp_lsoa, lsoa@data, by = c("id"="id"))

#Now we can join the LSOA crime data summaried earlier to table
gp_lsoa <- left_join(gp_lsoa, lsoa.month.summary, by = c("LSOA11CD" = "LSOA.code")) 

#Add formatted date field to act as titles
gp_lsoa$New.Month <- format(gp_lsoa$Month, "%B %Y")


