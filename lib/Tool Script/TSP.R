library(TSP)
library(XML)
library(ggmap)

address <- "155 Claremont Ave, New York"
geocode <- geocode(address)
start_lat<-geocode$lat
start_lng<-geocode$lon
startpoint <- c(start_lat,start_lng,address,"","")



#input



#fakedata
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
sightsRanked <- cbind(sightsRanked,1:6)
#plot
plot(sightsRanked[,1:2],pch=".")
text(sightsRanked[,1:2],labels=sightsRanked[,5])


#shiny

#sightsRanked<-mustGoSelected[path,]
#sightsRanked <- rbind(sightsRanked,sightsRanked[1,])


#points <- eventReactive(input$recalc, {
#        sightsRanked[,1:2]
#}, ignoreNULL = FALSE)

#leaflet()
#addMarkers(data = points())%>%
 #       addPolylines(data = sightsRanked, lng = ~lng, lat = ~lat, group = ~NAME)

