library(fields)

shinyServer(function(input,output){
        
        points <- eventReactive(input$recalc, {
                cbind(rnorm(40) * .01 + -73.985428, rnorm(40)*.01 + 40.748817)
        }, ignoreNULL = FALSE)
        
        
        output$backgroup <- renderLeaflet({
                leaflet(quakes) %>%
                  addTiles() %>%  # Add default OpenStreetMap map tiles
                  addMarkers(lng=-73.985428, lat=40.748817, popup="The Starting Point")%>% 
                  addMarkers(data = points())
                
                  
                
        })
        
})



