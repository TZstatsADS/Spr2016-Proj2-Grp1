library(shiny)
library(maptools)
library(fields)
library(leaflet)

type <- c(
        "museum" = "art1",
        "nartural" = "park",
        "theater" = "art2",
        "opera house" = "art3",
        "gallery" = "art4",
        "film" = "site"
        
)

number <- c(
        
)

bootstrapPage (
        #input
        #output
        div(class = "outer",
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        tags$head( includeCSS("styles.css")),
        leafletOutput("backgroup",width = "100%",height= "100%"),
        
        absolutePanel(id = "output.graphs",fixed = T,draggable = TRUE, top = "5%", left = 20, right = "auto", bottom = "auto",
                      width = 250, height = "auto",
                      h2("Information"),
                      plotOutput("hist", height = 200)),
        
        #input

        absolutePanel(id = "controls", fixed = TRUE,
                      draggable = TRUE, top = "5%", left = "auto", right = 20, bottom = "auto",
                      width = 250, height = "auto",
                      
                      h1("Trip Planner"),
                      textInput(inputId = "location",label = "Where you are"),
                      sliderInput(inputId = "crime",label="Safety", value = 5, min=0, max = 10),
                      sliderInput(inputId = "wifi",label="Wifi", value = 5, min=0, max = 10),
                      sliderInput(inputId = "restuarant",label="Resturant", value = 5, min=0, max = 10),
                      selectInput("category1","Category1",type),
                      selectInput("category2","Category2",type),
                      #selectInput("number","number",vars,selected = "art"),
                      sliderInput(inputId = "number",label="number", value = 5, min=1, max = 10),
                    
                      #conditionalPanel(),
                      actionButton("recalc", "My Trip Plan")
                      #plotOutput("scatterCollegeIncome", height = 250)
                      
        )
    )
)



