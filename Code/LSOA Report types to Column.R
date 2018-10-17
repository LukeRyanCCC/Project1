#Dependencies:

#CXM Import
#CXM Join
#CXM Counts

#Copy count table
LSOA.CXM.Reports <- as.tibble(CXM.LSOA.Type)

#Get list and length of Type of Flytipping Report
Report.Types <- as.character(unique(LSOA.CXM.Reports$Type.of.flytipping))
n <- grep("Other",Report.Types)
Report.Types <- c(Report.Types[-n], Report.Types[n])
No.Report.Types <- length(Report.Types)

#same for areas (lsoas)
areas <- unique(lsoa$LSOA11CD)
nareas <- length(areas)

#set index to 1
i <- 1

LSOA.CXM.wide <- as.tibble(areas)
names(LSOA.CXM.wide) <- "LSOA.code"

while(i <= No.Report.Types){
  data <- LSOA.CXM.Reports[LSOA.CXM.Reports$Type.of.flytipping == Report.Types[i],]
  data <- data[,c(1,3)]
  LSOA.CXM.wide <- left_join(LSOA.CXM.wide,data,by=c("LSOA.code" = "LSOA11CD"))
  i <-  i + 1
}
names(LSOA.CXM.wide) <- c("LSOA.code",Report.Types)
LSOA.CXM.wide[is.na(LSOA.CXM.wide)] <- 0

lsoa.CXM@data <- lsoa.CXM@data %>%
  left_join(.,LSOA.CXM.wide, by = c("LSOA11CD" = "LSOA.code"))

rm(Report.Types, No.Report.Types, areas, nareas, i, LSOA.CXM.Reports, LSOA.CXM.wide, data, n)