library(shiny)
library(maptools)
library(fields)
library(leaflet)

type <- c(
        "landmark" = "landmark",
        "museum" = "museum",
        "nartural" = "nartural",
        "theater" = "theater",
        "opera house" = "opera",
        "gallery" = "gallery",
        "film" = "film",
        "all" = "all"
        
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
        
        absolutePanel(id = "graphs",fixed = T,draggable = TRUE, top = "5%", left = "5%", right = "auto", bottom = "10%",
                      width = 250, height = "auto",
                      h1("Information"),
                      for (i in 1:4){
                      actionButton("recalc", "1")
                              },
                      plotOutput("hist_forall", height = 200)),
        
        #input

        absolutePanel(id = "controls", fixed = TRUE,
                      draggable = TRUE, top = "5%", left = "auto", right = "5%", bottom = "5%",
                      width = 250, height = "auto",
                      
                      h2("Trip Planner"),
                      textInput(inputId = "location",label = "Where you are"),
                      sliderInput(inputId = "crime",label="Safety", value = 0, min=0, max = 10),
                      sliderInput(inputId = "wifi",label="Wifi", value = 0, min=0, max = 10),
                      sliderInput(inputId = "restuarant",label="Resturant", value = 0, min=0, max = 10),
                      selectInput("category1","Category1",type),
                      selectInput("category2","Category2",type),
                      #selectInput("number","number",vars,selected = "art"),
                      sliderInput(inputId = "number",label="number", value = 0, min=1, max = 10),
                    
                      #conditionalPanel(),
                      actionButton("recalc", "My Trip Plan")
                      #plotOutput("scatterCollegeIncome", height = 250)
                      
        )
    )
)



