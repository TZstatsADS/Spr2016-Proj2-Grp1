library(fields)
library(rgdal)
library(maps)
library(maptools)
require(rgdal)

shinyServer(function(input,output){
       # mapzip <- map("county", fill = TRUE,
        #              plot = FALSE,
         #             region = c("New York"))
        
        #load data shapefile
        mapNYC <- readOGR("nynta_15d/nynta.shp",
                          layer = "nynta", verbose = FALSE)
        shapeData <- spTransform(mapNYC, CRS("+proj=longlat +ellps=GRS80"))
        
        #process data
        
        
        crimeData <- read.csv("crime.csv")[,2:3]
        names(crimeData) <- c("nta","count")
        #color matching
        
        colors = c('#ffffd9','#edf8b1','#c7e9b4','#7fcdbb','#41b6c4','#1d91c0','#225ea8','#0c2c84')
        # use cut() to convert numeric to factor
        crimeData$colorBuckets  <- as.numeric(cut(crimeData$count, c(0, 200, 400, 600, 800, 1000,2000,3000)))
        
        
        # align data with map definitions by (partial) matching state,county
        # names, which include multiple polygons for some counties
        colorsmatched = crimeData$colorBuckets[match(mapNYC$NTAName,crimeData$nta)]
        #plot(shapeData,col=colors[colorsmatched])
        
        #popup
        content <- function(shapeData){
                result <- paste("<br/>",shapeData[,1],"<br/>","felony: ",crimeData[crimeData$nta==shapeData[,1]])
                return(result)
        }
        
        #output
        output$backgroup <- renderLeaflet({
                leaflet() %>%
                addProviderTiles("Stamen.Toner")%>%
                 # addTiles("Stamen.Toner") %>%  # Add default OpenStreetMap map tiles
                addPolygons(data=shapeData, fillColor = colors[colorsmatched],fillOpacity=0.8, stroke = FALSE,popup=content)
                #addMarkers(lng=-73.985428, lat=40.748817, popup="The Starting Point")
                 # addMarkers(data = points())
                
        })
})



