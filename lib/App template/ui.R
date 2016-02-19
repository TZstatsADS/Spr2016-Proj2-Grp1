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
        
        #input
        absolutePanel(bottom = "5%", right = "10%",left = "10%",draggable=TRUE,width="100%" ,height="10%",
          splitLayout(
                  sliderInput(inputId = "crime",label="I care safety", value = 5, min=0, max = 10),
                  sliderInput(inputId = "wifi",label="I have to be online!", value = 5, min=0, max = 10),
                  sliderInput(inputId = "restuarant",label="I eat goods", value = 5, min=0, max = 10)
                  
          )
        ),
     div(class = "set1",
        absolutePanel(id = "controls", fixed = TRUE,
                      draggable = TRUE, top = "5%", left = "auto", right = 20, bottom = "auto",
                      width = 250, height = "auto",
                      
                      h2("Trip Planner"),
                      
                      selectInput("category1","Category1",type),
                      selectInput("category2","Category2",type),
                      #selectInput("number","number",vars,selected = "art"),
                      sliderInput(inputId = "number",label="number", value = 5, min=1, max = 10),
                      textInput(inputId = "location",label = "Where you are"),
                      #conditionalPanel(),
                      actionButton("recalc", "My Trip Plan"),
                      
                      plotOutput("hist", height = 200)
                      #plotOutput("scatterCollegeIncome", height = 250)
                      
        )
      )
    )
)



