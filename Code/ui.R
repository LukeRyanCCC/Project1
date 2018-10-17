ui <- fluidPage(
  titlePanel("Civil Enforcement Data Explorer"),
  tabsetPanel(tabPanel("Thematic Maps",
                sidebarLayout(
        sidebarPanel(selectInput("lsoa", label = "Choose metric",
                               choices = colnames(lsoa.CXM@data[,7:18])),
                     (selectInput("msoa", label = "Choose metric",
                                  choices = colnames(msoa.CXM@data[,4:10]))),
                      selectInput("overlay", label = "Choose boundaries",
                                              choices = c("No overay" = "null",
                                                          "LSOA" = "lsoa",
                                                          "MSOA" = "msoa",
                                                          "Ward" = "ward"))
    
    ),
    mainPanel())),
    tabPanel("Correlation Chart", 
             sidebarLayout(
               sidebarPanel(
                 selectInput("corrdrop1",
                             label = "Choose crime type",
                             choices = colnames(lsoa.Crime@data[,12:26])),
                 selectInput("corrdrop2",
                             label = "Choose flytipping type",
                             choices = colnames(lsoa.CXM@data[,12:18]))),
               mainPanel(
                 plotOutput(
                   outputId = "corr_point"),
                 strong("Correllation Score: ",
                        textOutput(outputId = "corr"))
                 )
               )
             ))
    )
  
  