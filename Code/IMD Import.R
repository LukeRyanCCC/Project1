imd <- read.csv("C:/Users/luke.ryan/Documents/Data Science Accelerator/Data/csv Files/IMD.csv", stringsAsFactors = FALSE) %>%
  filter(Local.Authority.District.name..2013. == "Canterbury") %>%
  select(1,2,5,17,19) %>%
  setNames(c("LSOA11CD", "LSOA11NM", "IMD Score",
             "Barriers to Services Score","Environment Score"))
i <- 3
while(i <= length(imd)){
  imd[,i] <-  as.integer(gsub(",","",imd[,i]))
  i <- i + 1
  }
