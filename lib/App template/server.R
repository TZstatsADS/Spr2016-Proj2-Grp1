library(fields)
library(rgdal)
library(maps)
library(maptools)
require(rgdal)
library(ggmap)
library(TSP)
library(ggplot2)
library(osrm)
source("weight.R")

shinyServer(function(input,output){
        #read data
        neighborData <- read.csv("neighborhood_stat.csv")[,-1]
        names(neighborData) <- c("nta","wifi","crime","restaurants")
        #basemap&shape
        mapNYC <- readOGR("nynta_15d/nynta.shp",
                          layer = "nynta", verbose = FALSE)
        shapeData <- spTransform(mapNYC, CRS("+proj=longlat +ellps=GRS80"))
        neighborData <- read.csv("neighborhood_stat.csv")[,-1]
        names(neighborData) <- c("nta","wifi","crime","restaurants")
        shapeData$crimeRate = neighborData$crime[match(mapNYC$NTAName,neighborData$nta)]
        shapeData$wifi = neighborData$wifi[match(mapNYC$NTAName,neighborData$nta)]
        shapeData$restaurants = neighborData$restaurants[match(mapNYC$NTAName,neighborData$nta)]
        
                
        colors = c('#ffffd9','#edf8b1','#c7e9b4','#7fcdbb','#41b6c4','#1d91c0','#225ea8','#0c2c84')
        
        #process data

        selectedNeighbor_rec <- reactive({
                w1<-input$wifi
                w2 <- input$crime
                w3<-input$restaurant
                cat1<-input$category1
                cat2<-input$category2
                neighbor_ranks <- weight_calculation(cat1,cat2,w1,w2,w3)
                selectedNeighbor_r<-as.vector(neighbor_ranks[1:5,1])
                selectedNeighbor_r
        })
        
        colorsmatched_re<-reactive({
                print("colorsmatched_re called")
                w1<-input$wifi
                w2 <- input$crime
                w3<-input$restaurant
                cat1<-input$category1
                cat2<-input$category2
                
                neighbor_ranks <- weight_calculation(cat1,cat2,w1,w2,w3)
                
                
                neighborData$scores <- rep(0,195)
                #print(head(neighborData$scores))
                #print(head(neighbor_ranks))
                neighborData$scores[match(neighbor_ranks$neighborpool,neighborData$nta)] <- neighbor_ranks[,2]
                neighborData$scores[is.na(neighborData$scores)]<-0
                
                shapeData$scores = neighborData$scores[match(mapNYC$NTAName,neighborData$nta)]
                
                
                print(head(neighborData))
                #color matching
                     # use cut() to convert numeric to factor
                neighborData$colorBuckets  <- as.numeric(cut(neighborData$scores, c(0, 0.15, 0.30, 0.45, 0.60, 0.75,0.90,1)))
                
                # align data with map definitions by (partial) matching state,county
                # names, which include multiple polygons for some counties
                colorsmatched = neighborData$colorBuckets[match(mapNYC$NTAName,neighborData$nta)]
               
                #plot(shapeData,col=colors[colorsmatched])
                colorsmatched[is.na(colorsmatched)] = 1
                #print(cbind(colorsmatched,neighborData$scores,neighborData$colorBuckets))
                
                colorsmatched
        ##################       ##################
        })
        
        
        
        sightsRanked <- eventReactive(input$recalc,{
                temp<-selectedNeighbor_rec()
                selectedNeighbor<-isolate(temp)
                if(isolate(input$location)!=""){
                        address <-isolate(input$location)
                        geocode <- geocode(address)
                        start_lat<-as.numeric(geocode$lat)
                        start_lng<-as.numeric(geocode$lon)
                        #print(geocode)
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
                #nr <- nrow(mustGoSelected)
                #distance2 <- matrix(nrow = nr,ncol=nr)
                #for(i in 1:nr){
                #        for(j in 1:nr){
                #               distance2[i,j] <- osrmViaroute(c(1,
                #                                mustGoSelected[i,1],
                #                                mustGoSelected[i,2]), 
                #                                c(2,mustGoSelected[j,1],
                #                                  mustGoSelected[j,2]))[1]
                #        }
                #}
     
                #tsp
                #tsp <- ATSP(as.matrix(distance2))
                tsp <- TSP(distance)
                tour <- solve_TSP(tsp, method = "farthest_insertion")
                path <- c(1,as.vector(cut_tour(tour, 1)))
                
                sightsRanked<-mustGoSelected[path,]
                sightsRanked <- rbind(sightsRanked,sightsRanked[1,])
                sightsRanked[,1]<-as.numeric(sightsRanked[,1])
                sightsRanked[,2]<-as.numeric(sightsRanked[,2])
                
                ##########################################################################################
                output$place <- renderUI({
                        if(is.null(sightsRanked[,3]))
                                return()
                        selectInput("attraction", "attractions",as.character(sightsRanked[-c(1,nrow(sightsRanked)),3]))
                })
                
                output$distplot <- renderPlot({
                        if(input$attraction>0){
                                neighbor_select<- sightsRanked[sightsRanked[,3] == input$attraction,]
                                print("display")
                                print(sightsRanked[, 3])
                                count_stat[which(count_stat$NTAName == as.character(neighbor_select[,4])),]
                                
                                new_count <- cbind(t(count[,3:5]),c("wifi","crime","restaurant"))
                                colnames(new_count) <- c("number","type")
                                new_count <- data.frame(new_count)
                                ggplot(data=new_count, aes(x=type, y=number, fill=type)) +geom_bar(stat="identity")+scale_fill_manual(values=c("#edf8b1", "#7fcdbb", "#2c7fb8"))
                        }
                })
                
                ############################################################################################            
                
                
                
                
                
                sightsRanked
                
                #osrmViarouteGeom(c(1,40.80772,-73.96411), c(2,40.75874, -73.97867),sp=TRUE)
                
        }, ignoreNULL = FALSE)
        
        route_re<- eventReactive(input$recalc,{
                
                sightsRanked2 <- isolate(sightsRanked())
                print(head(sightsRanked2))
                routes<-data.frame()
                for(j in 2:nrow(sightsRanked2)){
                        routes1 <- osrmViarouteGeom(c(1,sightsRanked2[j-1,1],sightsRanked2[j-1,2]), c(2,sightsRanked2[j,1],sightsRanked2[j,2]),sp=FALSE)
                        routes<-rbind(routes,routes1)
                        #plot(routes)
                }
                routes
        }, ignoreNULL = FALSE)
       

        
#############################################################################################################
        #Region popup
        polygon_popup <- paste0("<strong>Name: </strong>", shapeData$NTAName, "<br>",
                                "<strong>Crime Rate: </strong>", shapeData$crimeRate,"<br>",
                                "<strong>Wifi: </strong>", shapeData$wifi, "<br>",
                                "<strong>Restaurants: </strong>", shapeData$restaurants)
        
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
                hideGroup(c("Routes"))%>%
                addProviderTiles("CartoDB.Positron")%>%
                #addProviderTiles("Stamen.Toner")%>%
                #addTiles() %>%  # Add default OpenStreetMap map tiles color = colors[color()]
                addPolygons(data=shapeData, fillColor = colors[colorsmatched_re()],
                            fillOpacity=0.6, stroke = FALSE,popup=polygon_popup,group="ColoredMap")%>%
                #addMarkers(lng=-73.985428, lat=40.748817, popup="The Starting Point")
                addMarkers(data = sightsRanked(),popup = ~NAME,group = "Views")%>%
                addPolylines(data = route_re(), fillOpacity = 0.5,lng = ~lon, lat = ~lat, group = "Routes")%>%
                addPolylines(data = sightsRanked(), lng = ~lng, lat = ~lat, group = "Ranks") %>%
                
                addLayersControl(
                        position = "bottomright",
                        overlayGroups = c("Views", "Routes","Ranks","ColoredMap"),
                        options = layersControlOptions(collapsed = FALSE)
                )
        })
})



