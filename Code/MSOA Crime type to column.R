msoa.crimes <- crime.type.MSOA
# Find out how many unique crimes there are...
crime.types <- unique(msoa.crimes$Crime.type)
n <- grep("Other",crime.types) # Finds place of "other" 
crime.types <- c(crime.types[-n], crime.types[n]) #moves "other" to end
no.crime.types <- length(crime.types)

# And how many msoas there are
areas <- unique(msoa$MSOA11CD)
nareas <- length(areas)

i <- 1

# Create a new table with one column - the vector of unique msoas...
MSOA.crime.wide <- as.tibble(areas)
names(MSOA.crime.wide) <- "MSOA11CD"

while(i <= no.crime.types){
  
  # Select out only the msoas with values for the current crime type
  data <- msoa.crimes[msoa.crimes$Crime.type == crime.types[i],]
  # Drop everything except the msoa code and the count of crimes
  data <- data[,c(1,3)]
  # join this data onto the msoa_wide table...
  MSOA.crime.wide <- left_join(MSOA.crime.wide,data,by=c("MSOA11CD" = "MSOA11CD"))
  
  i <- i + 1
}

names(MSOA.crime.wide) <- c("MSOA11CD",crime.types)
MSOA.crime.wide[is.na(MSOA.crime.wide)] <- 0
msoa.Crime <- msoa
msoa.Crime@data <- msoa.Crime@data %>% 
  left_join(.,MSOA.total.crime, by = c("MSOA11CD" = "MSOA11CD")) %>%
  left_join(., MSOA.crime.wide, by = c("MSOA11CD" = "MSOA11CD"))
rm(crime.types, no.crime.types, msoa.crimes, areas, nareas, MSOA.total.crime, data)
