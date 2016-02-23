library(fields)
library(rgdal)
library(maps)
library(maptools)
require(rgdal)
library(ggmap)
library(TSP)
library(ggplot2)
library(osrm)

shinyServer(function(input,output){
       # mapzip <- map("county", fill = TRUE,
        #              plot = FALSE,
         #             region = c("New York"))
        
        #load data shapefile
        mapNYC <- readOGR("nynta_15d/nynta.shp",
                          layer = "nynta", verbose = FALSE)
        shapeData <- spTransform(mapNYC, CRS("+proj=longlat +ellps=GRS80"))
        #process data
        
        neighborData <- read.csv("neighborhood_stat.csv")[,-1]
        names(neighborData) <- c("nta","wifi","crime","restaurants")
        
        neighbor_ranks <- weight(neighborData,input$wifi,input$crime,input$restaurant)
        
        neighborData$scores <- neighbor_ranks[,2]
        #color matching
        colors = c('#ffffd9','#edf8b1','#c7e9b4','#7fcdbb','#41b6c4','#1d91c0','#225ea8','#0c2c84')
        # use cut() to convert numeric to factor
        neighborData$colorBuckets  <- as.numeric(cut(neighborData$scores, c(0, 200, 400, 600, 800, 1000,2000,3000)))
         
        # align data with map definitions by (partial) matching state,county
        # names, which include multiple polygons for some counties
        colorsmatched = neighborData$colorBuckets[match(mapNYC$NTAName,neighborData$nta)]
        shapeData$crimeRate = neighborData$scores[match(mapNYC$NTAName,neighborData$nta)]
        #plot(shapeData,col=colors[colorsmatched])
        
        selectedNeighbor <- sample(as.vector(shapeData$NTAName),4)
        selectedNeighbor<-c(selectedNeighbor,"Midtown-Midtown South")
        
        ##################################################################        
        
        sightsRanked <- eventReactive(input$recalc,{
                if(isolate(input$location)!=""){
                        address <-isolate(input$location)
                        geocode <- geocode(address)
                        start_lat<-as.numeric(geocode$lat)
                        start_lng<-as.numeric(geocode$lon)
                        print(geocode)
                }else{
                        address <- "Columbia University in the city of New York"
                        start_lat <- 40.80772
                        start_lng <- -73.96411
                }

                
                startpoint <- c(start_lat,start_lng,paste("start point"),"0")
                
                #number of place input
                numberOfPlaces <- input$number
                
                #select category 1
                if ( input$category1 == "landmark" ){
                        c1<-read.csv("landmarks.csv")
                        
                } else if (input$category1 == "museum"){
                        c1<-read.csv("museum.csv")
                }
                else if (input$category1 == "nartural"){
                        c1<-read.csv("nartural.csv")
                }
                else if (input$category1 == "theater"){
                        c1<-read.csv("theater.csv")
                }
                else if (input$category1 == "opera"){
                        c1<-read.csv("opera.csv")
                }
                else if (input$category1 == "gallery"){
                        c1<-read.csv("gallery.csv")
                }
                else if (input$category1 == "film"){
                        c1<-read.csv("film.csv")
                }
                else{
                        c1<-read.csv("landmarks.csv")
                }
                
                #select category 2
                if ( input$category2 == "landmark" ){
                        c2<-read.csv("landmarks.csv")
                
                }else if (input$category2 == "museum"){
                        c2<-read.csv("museum.csv")
                }
                else if (input$category2 == "nartural"){
                        c2<-read.csv("nartural.csv")
                }
                else if (input$category2 == "theater"){
                        c2<-read.csv("theater.csv")
                }
                else if (input$category2 == "opera"){
                        c2<-read.csv("opera.csv")
                }
                else if (input$category2 == "gallery"){
                        c2<-read.csv("gallery.csv")
                }
                else if (input$category2 == "film"){
                        c2<-read.csv("film.csv")
                }
                else{
                        c2<-read.csv("landmarks.csv")
                } 
                #select in neighborhood
                c2<-na.omit(c2)
                c1<-na.omit(c1)
                c1Selected <- c1[(c1$NTAName == selectedNeighbor[1]|
                                                  c1$NTAName ==  selectedNeighbor[2]|
                                                  c1$NTAName ==  selectedNeighbor[3]|
                                                  c1$NTAName ==  selectedNeighbor[4]|
                                                  c1$NTAName ==  selectedNeighbor[5])
                                         ,] 
                c2Selected <- c2[(c2$NTAName == selectedNeighbor[1]|
                                          c2$NTAName ==  selectedNeighbor[2]|
                                          c2$NTAName ==  selectedNeighbor[3]|
                                          c2$NTAName ==  selectedNeighbor[4]|
                                          c2$NTAName ==  selectedNeighbor[5])
                                 ,] 
                
                #first sampling
                if(nrow(c1Selected) >= 10){
                        c1_s1 <- c1Selected[sample(1:nrow(c1Selected),10,replace=FALSE),]
                }else{
                        c1_s1 <- c1Selected
                }
                
                if (nrow(c2Selected) >=5){
                        c2_s1<-c2Selected[sample(1:nrow(c2Selected),5,replace=FALSE),]
                }else{
                        c2_s1<-c2Selected
                }
                
                mustGoPool <- rbind(c1_s1,c2_s1)
                #fills with landmarks
                if (nrow(mustGoPool)<15){
                        n<-15-nrow(mustGoPool)
                        landmarks <- read.csv("landmarks.csv")
                        landmarksSelected<-landmarks[sample(1:nrow(landmarks),
                                         n,replace=FALSE),]
                        mustGoPool <- rbind(mustGoPool,landmarksSelected)
                }
                
                #2nd sampling
                mustGoPoolSelected<-mustGoPool[sample(1:nrow(mustGoPool),
                                        numberOfPlaces,replace=FALSE),]
                
                mustGoSelected <- mustGoPoolSelected[,c(3,4,2,5)]
                        
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
                print(sightsRanked)
                #osrmViarouteGeom(c(1,40.80772,-73.96411), c(2,40.75874, -73.97867),sp=TRUE)
                
        }, ignoreNULL = FALSE)
       
        
        
       

        
#############################################################################################################
        #Region popup
        polygon_popup <- paste0("<strong>Name: </strong>", shapeData$NTAName, "<br>",
                                "<strong>Crime Rate: </strong>", shapeData$crimeRate)
        
        output$hist_forall <- renderText({
                regionPassed<-sightsRanked()
                regionPassed<-as.vector(unique(isolate(regionPassed)$NTAName))
                regionPassed<-na.omit(regionPassed)
                print("text")
                print(a)
                a
        })
        
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



