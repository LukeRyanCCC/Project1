#**********************Leaflet*****************
#Create colour palatte. Note - number of bins = number of bands, 
#but pretty will override to create sensible bands
pal <- colorBin('BuPu', (round((lsoa.CXM$Count.Reports/lsoa$Population*1000),1)), bins = 9, pretty = TRUE, na.color = "#808080")

#Create clickable popup
#In the future I should be able to parse other layers/lsoa factors into popup
lsoa_popup <- paste0("<strong>LSOA: </strong>", lsoa.CXM$LSOA11NM,
                     "<br><strong>Code: </strong>", lsoa.CXM$LSOA11CD,
                     "<br><strong>Flytipping Reports (Since Oct 2017): </strong>", lsoa.CXM$Count.Reports,
                     "<br><strong>Population: </strong>", lsoa$Population,
                     "<br><strong>Reports per 1000 Residents: </strong>", (round((lsoa.CXM$Count.Reports/lsoa$Population*1000),1)),
                     "<br><strong>FPN's Issued: </strong>", lsoa.FPN$Count.FPN)
#Creating the leaflet
#data = lsoa
#Not sure atm how to add additonal layers although tutorial did overlay points
cant_leaflet <- leaflet(data = lsoa.CXM) %>% #Not sure the relevance of this code
  addProviderTiles("CartoDB.Positron") %>% #Add basemap - may want to change
  addPolygons(fillOpacity = 0.45, #opacity 0-1. 0 = see through, 1 =block
              fillColor = ~pal((round((lsoa.CXM$Count.Reports/lsoa$Population*1000),1))), #not sure what ~ does
              color = "darkgrey", #of stroke (borders) stroke default = TRUE
              weight = 2, #width of stroke
              popup = lsoa_popup) %>% #link popup to polygon
  setView(1.096257, 51.28103, zoom = 10) %>% #Set centre to Canterbury Coordinates
  addLegend(position = c("bottomright"), #Location of legend
            pal = pal, #to match addPolygon
            values = ~(round((lsoa.CXM$Count.Reports/lsoa$Population*1000),1)), #to match addPolygon, not sure what ~ does
            opacity = 0.45, 
            title = 'Count Flytipping Reports')

cant_leaflet
