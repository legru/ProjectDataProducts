# code run only upon loading the application

require(rCharts)
require(shiny)
require(dplyr)

## import modules

# additional geographic names
source("geography.R")

# data processing functions
source("data_processing.R")


shinyServer(function(input, output) {
  
  # General map
  output$Map <- renderChart2({
    
    ichoropleth(Total.Population~Host.Coutry,data = map1.data,
                map = 'world',labels = F,pal = "YlOrRd",
                ncuts = 8)
    
    #ichoropleth(Crime ~ State, data = subset(violent_crime, Year == 2010))
  })
  
  # generate the graph
  output$Refugees <- renderChart2({  ## <- IMPORTANT HERE: use renderChart2
    # within the reactive context of the first histogram
    
    # data preparation
    if (!(1 %in% input$hgrm1)) { refugees.host_areas$Refugees=NULL }
    if (!(2 %in% input$hgrm1)) { refugees.host_areas$Asylum.seekers=NULL }
    if (!(3 %in% input$hgrm1)) { refugees.host_areas$Internally.displaced=NULL }
    if (!(4 %in% input$hgrm1)) { refugees.host_areas$Total.Population=NULL }
    
    # rows selection
    refugees.host_areas= refugees.host_areas[input$area,]
    
    # graph preparation
    host_areas.chart <- Highcharts$new()
    host_areas.chart$chart(type = "column")  
    host_areas.chart$title(text = "istribution of Refugees by Geographic Area")
    host_areas.chart$xAxis(categories = rownames(refugees.host_areas))
    host_areas.chart$yAxis(title = list(text = "Number of Refugees"))
    host_areas.chart$data(refugees.host_areas)
    host_areas.chart$legend(symbolWidth = 80)
    return(host_areas.chart)
  })
  
  ## --- Asylum in Europe ------------------------------------------
  output$Asylum_Europe <- renderChart2({
    boundary <- function(x) {round((x-1999)*202/16)}
    m1 <- mPlot(x = "date", y = input$Asylum_Area, type = "Line", 
                data = syrian_asylum_requests_in_Europe[boundary(input$Range[1]):boundary(input$Range[2]),])
    m1$set(pointSize = 0, lineWidth = 2)
    return(m1)
  })
})