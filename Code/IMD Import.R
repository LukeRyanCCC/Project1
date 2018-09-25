imd <- read.csv("data/csv Files/IMD.csv", stringsAsFactors = FALSE) %>%
  filter(Local.Authority.District.name..2013. == "Canterbury") %>%
  select(1,2,5,6) %>%
  setNames(c("LSOA11CD", "LSOA11NM", "IMD.Rank", "IMD.Decile"))
imd$IMD.Rank <-  as.integer(gsub(",","",imd$IMD.Rank))
