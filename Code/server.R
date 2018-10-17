maplabel <- c("TBC")
mapvariables <- c("TBC")

server <- function(input, output){
  output$corr_point <- renderPlot({
    plot(lsoa.Crime@data[,c(input$corrdrop1)], lsoa.CXM@data[,c(input$corrdrop2)],
         xlab = input$corrdrop1, ylab = input$corrdrop2)
    
    
    
    })
  
  
  output$corr <- renderText({
    cor(lsoa.Crime@data[,c(input$corrdrop1)],
        lsoa.CXM@data[,c(input$corrdrop2)])
    
    })
  
}