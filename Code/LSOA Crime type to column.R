lsoa.crimes <- crime.type.LSOA
# Find out how many unique crimes there are...
crime.types <- unique(lsoa.crimes$Crime.type)
n <- grep("Other",crime.types) # Finds place of "other" 
crime.types <- c(crime.types[-n], crime.types[n]) #moves "other" to end
no.crime.types <- length(crime.types)

# And how many LSOAs there are
areas <- unique(lsoa$LSOA11CD)
nareas <- length(areas)

i <- 1

# Create a new table with one column - the vector of unique LSOAs...
LSOA.crime.wide <- as.tibble(areas)
names(LSOA.crime.wide) <- "LSOA.code"

while(i <= no.crime.types){
  
  # Select out only the LSOAs with values for the current crime type
    data <- lsoa.crimes[lsoa.crimes$Crime.type == crime.types[i],]
    # Drop everything except the LSOA code and the count of crimes
    data <- data[,c(1,3)]
    # join this data onto the lsoa_wide table...
    LSOA.crime.wide <- left_join(LSOA.crime.wide,data,by=c("LSOA.code" = "LSOA.code"))
  
  i <- i + 1
}

names(LSOA.crime.wide) <- c("LSOA.code",crime.types)
LSOA.crime.wide[is.na(LSOA.crime.wide)] <- 0

lsoa.Crime <- lsoa
lsoa.Crime@data <- lsoa.Crime@data %>%
  left_join(.,LSOA.total.crime, by = c("LSOA11CD" ="LSOA.code")) %>%
  left_join(.,LSOA.crime.wide, by = c("LSOA11CD" = "LSOA.code"))

rm(crime.types, no.crime.types, areas, nareas, LSOA.total.crime, data, lsoa.crimes)
