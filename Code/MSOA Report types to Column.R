#Dependencies:

#CXM Import
#CXM Join
#CXM Counts

#Copy count table
msoa.CXM <- msoa

MSOA.CXM.Reports <- as.tibble(CXM.MSOA.Type)

#Total reports per MSOA
count.report.msoa <- MSOA.CXM.Reports %>%
  group_by(MSOA11CD) %>% #Group by MSOA
  summarise(n = sum(n)) %>% #Count
  setNames(c("MSOA11CD", "Total Reports")) 

#Get list and length of Type of Flytipping Report
Report.Types <- as.character(unique(MSOA.CXM.Reports$Type.of.flytipping))
n <- grep("Other",Report.Types) # Finds place of "other" 
Report.Types <- c(Report.Types[-n], Report.Types[n]) #moves "other" to end
No.Report.Types <- length(Report.Types)

#same for areas (lsoas)
areas <- unique(msoa$MSOA11CD)
nareas <- length(areas)

#set index to 1
i <- 1

MSOA.CXM.wide <- as.tibble(areas)
names(MSOA.CXM.wide) <- "MSOA11CD"

while(i <= No.Report.Types){
  data <- MSOA.CXM.Reports[MSOA.CXM.Reports$Type.of.flytipping == Report.Types[i],]
  data <- data[,c(1,3)]
  MSOA.CXM.wide <- left_join(MSOA.CXM.wide,data,by=c("MSOA11CD" = "MSOA11CD"))
  i <-  i + 1
}
names(MSOA.CXM.wide) <- c("MSOA11CD",Report.Types) 

MSOA.CXM.wide <- left_join(MSOA.CXM.wide, count.report.msoa, by = c("MSOA11CD" = "MSOA11CD"))

MSOA.CXM.wide[is.na(MSOA.CXM.wide)] <- 0

msoa.CXM@data <- msoa.CXM@data %>%
  left_join(., MSOA.CXM.wide, by = c("MSOA11CD" = "MSOA11CD"))

rm(Report.Types, No.Report.Types, areas, nareas, i, count.report.msoa, MSOA.CXM.Reports, MSOA.CXM.wide, data, n)
