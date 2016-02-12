library(fields)
library(rgdal)
library(maps)

shinyServer(function(input,output){
        
        points <- eventReactive(input$recalc, {
                cbind(rnorm(40) * .01 + -73.985428, rnorm(40)*.01 + 40.748817)
        }, ignoreNULL = FALSE)
        
        
        output$backgroup <- renderLeaflet({
                leaflet() %>%
                  addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%  # Add default OpenStreetMap map tiles
                  addMarkers(lng=-73.985428, lat=40.748817, popup="The Starting Point")%>% 
                  #addMarkers(data = points())
                
                  
                
        })
})



