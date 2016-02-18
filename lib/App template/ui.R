install.packages("shiny")
library(shiny)
library(maptools)
library(fields)
library(leaflet)


bootstrapPage(
        #input
        #output
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        leafletOutput("backgroup",width = "100%",height= "100%"),
        #input
        absolutePanel(bottom = "10%", right = "10%",left = "10%",draggable=TRUE,width="100%" ,height="20%",
          splitLayout(
                  sliderInput(inputId = "timeSpent",label="Choose an average time you will spend in one scenery", value = 10, min=1, max = 30),
                      textInput(inputId = "start",label="Starting Location"),
                      textInput(inputId = "end", label = "Ending Location"),
                      
                      
                      actionButton("recalc", "New points")
          )
        )
        
        
       
        
        
)



