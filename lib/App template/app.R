library(shiny)
shinyApp(ui = ui, server = server)



##### couple questions to solve
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

# 2. how to track route.
#http://zevross.com/blog/2014/09/30/use-the-amazing-d3-library-to-animate-a-path-on-a-leaflet-map/
#http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/
# 3. how to change map.
#http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/
# 4. how to change popup
# 5. how to change type in color