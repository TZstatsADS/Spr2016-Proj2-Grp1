
shinyApp(ui = ui, server = server)



##### couple questions to solve


###################################
# 1.how to customized markers

#        iconData = data.frame(
#        lat = c(rnorm(10, 0), rnorm(10, 1), rnorm(10, 2)),
#        lng = c(rnorm(10, 0), rnorm(10, 3), rnorm(10, 6)),
#        group = rep(sort(c('green', 'red', 'orange')), each = 10),
#        stringsAsFactors = FALSE
#)

# addMarkers(
#data = iconData,
#icon = ~ icons(
#        iconUrl = sprintf('http://leafletjs.com/docs/images/leaf-%s.png', group),
#        shadowUrl = 'http://leafletjs.com/docs/images/leaf-shadow.png',
#        iconWidth = 38, iconHeight = 95, shadowWidth = 50, shadowHeight = 64,
#        iconAnchorX = 22, iconAnchorY = 94, shadowAnchorX = 4, shadowAnchorY = 62,
#        popupAnchorX = -3, popupAnchorY = -76
#))

##################################################
# 2. how to track route.
#http://zevross.com/blog/2014/09/30/use-the-amazing-d3-library-to-animate-a-path-on-a-leaflet-map/
#http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/

#        library(rgdal)
#        library(maps)
        
        # Fetch the route of the PCT and convert it into a SpatialLine object
 #       url <- "http://hiking.waymarkedtrails.org/en/routebrowser/1225378/gpx"
  #      download.file(url, destfile = "pct.gpx", method = "wget")
   #     pct <- readOGR("pct.gpx", layer = "tracks")
        
        # Import list with shapefiles of the three states the PCT is crossing
    #    mapStates <- map("state", fill = TRUE,
    #                     plot = FALSE,
     #                    region = c('california', 'oregon', 'washington:main'))
        
      #  your.map <- leaflet(pct) %>%
                
                # Add layer
       #         addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
        
#        addPolylines(color="red", popup="PCT")  %>%
 #               addMarkers(-116.4697, 32.60758, popup = "Campo") %>%
  ##              addMarkers(-120.7816, 49.06465, popup = "Manning Park, Canada") %>%
    #            addPolygons(data=mapStates, fillColor = heat.colors(3, alpha = NULL), stroke = FALSE) %>%
                
                # Add legend
    #            addLegend(position = 'topright', colors = "red", labels = "PCT", opacity = 0.4,
   #                       title = 'Legend')
  #      
 #       your.map

##################################################
# 3. how to change map.
#http://leaflet-extras.github.io/leaflet-providers/preview/
#https://rstudio.github.io/leaflet/basemaps.html
#addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
#http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/

# 4. how to change popup
# 5. how to change type in color