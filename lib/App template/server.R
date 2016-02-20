library(fields)
library(rgdal)
library(maps)
library(maptools)
require(rgdal)
library(ggmap)
library(TSP)

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
        shapeData$crimeRate = crimeData$count[match(mapNYC$NTAName,crimeData$nta)]
        #plot(shapeData,col=colors[colorsmatched])
        
        
        
        
        ##################################################################        
        
        sightsRanked <- eventReactive(input$recalc,{
                if(isolate(input$location)!=""){
                        address <-isolate(input$location)
                }else{
                        address <- "Columbia University in the city of New York"
                }
                geocode <- geocode(address)
                start_lat<-as.numeric(geocode$lat)
                start_lng<-as.numeric(geocode$lon)
                startpoint <- c(start_lat,start_lng,paste("start point"),"0")
                
                mustGo<-read.csv("Must-Go-Sights.csv")
                randomSights <- read.csv("Must-Go-Sights.csv")#take out the mustGoSights
                numberOfPlaces <- input$number
                
                neighbor <- "b"
                mustGo$neighbor <- c("a","b","a","a") #need to delete
                randomSights<-mustGo #need to delete
                #randomSights$NAME<-c("abc")#need to delete
                
                #select in neighborhood
                mustGoSelected <- mustGo[mustGo$neighbor == neighbor,]
                
                #sampling
                if(nrow(mustGoSelected) >= numberOfPlaces){
                        mustGoSelected<-mustGoSelected[sample(1:nrow(mustGoSelected),
                                                              numberOfPlaces,replace=FALSE),]
                }else{
                        n<-numberOfPlaces-nrow(mustGoSelected)
                        extra <- randomSights[sample(1:nrow(randomSights),n,replace=FALSE),]
                        mustGoSelected <- rbind(mustGoSelected,extra)      
                }
                #add start-end point
                mustGoSelected <- rbind(startpoint,mustGoSelected)
                
                #distance
                distance <- dist(mustGoSelected[,1:2]) #approximation
                
                #tsp
                tsp <- TSP(distance)
                tour <- solve_TSP(tsp, method = "farthest_insertion")
                path <- c(1,as.vector(cut_tour(tour, 1)))
                
                sightsRanked<-mustGoSelected[path,]
                sightsRanked <- rbind(sightsRanked,sightsRanked[1,])
                sightsRanked[,1]<-as.numeric(sightsRanked[,1])
                sightsRanked[,2]<-as.numeric(sightsRanked[,2])
                
                sightsRanked
                
        }, ignoreNULL = FALSE)
       
        
        
       

        
#############################################################################################################
        #Region popup
        polygon_popup <- paste0("<strong>Name: </strong>", shapeData$NTAName, "<br>",
                                "<strong>Crime Rate: </strong>", shapeData$crimeRate)
        
        
        
        #output
        output$backgroup <- renderLeaflet({
                print("backgroup")
                leaflet() %>%
                #hideGroup(c("Views","Routes"))%>%
                addProviderTiles("CartoDB.Positron")%>%
                #addProviderTiles("Stamen.Toner")%>%
                #addTiles() %>%  # Add default OpenStreetMap map tiles
                addPolygons(data=shapeData, fillColor = colors[colorsmatched],
                            fillOpacity=0.8, stroke = FALSE,popup=polygon_popup)%>%
                #addMarkers(lng=-73.985428, lat=40.748817, popup="The Starting Point")
                addMarkers(data = sightsRanked(),popup = ~NAME,group = "Views")%>%
                addPolylines(data = sightsRanked(), lng = ~lng, lat = ~lat, group = "Routes")%>%
                addLayersControl(
                        overlayGroups = c("Views", "Routes"),
                        options = layersControlOptions(collapsed = FALSE)
                )
        })
})



