#List all Crime csvs from Desktop
crime_files <- list.files("C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/csv Files/All_Kent_Crime/",
                          pattern = "*csv", full.names = TRUE,
                          recursive = TRUE, include.dirs = TRUE)

#Read csvs then create single table
crime <- lapply(crime_files, read.csv, stringsAsFactors = FALSE) %>% 
  bind_rows() %>%
  filter(grepl("Cant",LSOA.name)) %>% #filter for Canterbury LSOAs
  select(2,5,6,8,9,10) #Only keep pertinent columns

#Remove crime_files
rm(crime_files)

#Join MSOA Codes

crime <- crime %>%
  left_join(.,lookup, by = c("LSOA.code" = "LSOA11CD"))

#Convert Month to POSTIX format via "as.yearmon" from zoo
crime$Month <- as.yearmon(crime$Month) %>%
  as.POSIXct(crime$Month, format = "%b %Y")

#Turn into tibble - because
crime <- as_tibble(crime)

source("Crime Counts.R")
