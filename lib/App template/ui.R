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
                  sliderInput(inputId = "crime",label="I care safety", value = 5, min=0, max = 10),
                  sliderInput(inputId = "wifi",label="I have to be online!", value = 5, min=0, max = 10),
                  sliderInput(inputId = "restuarant",label="I eat goods", value = 5, min=0, max = 10),
                  actionButton("recalc", "Ranks")
          )
        )
        
        
       
        
        
)



