library(shiny)
library(maptools)
library(fields)
library(leaflet)
library(shinydashboard)

type <- c(
        "all" = "all",
        "landmark" = "landmark",
        "museum" = "museum",
        "natural" = "natural",
        "theater" = "theater",
        "opera house" = "opera",
        "gallery" = "gallery"
)

number <- c(
        
)

dashboardPage(
        #input
        #output
        dashboardHeader(title = "Trip Planner"),
        
        
        
        
        
        dashboardSidebar(
        sidebarSearchForm(textId = "location", buttonId = "searchButton",
                          label = "Where you are..."),
        sliderInput(inputId = "crime",label="Safety", value = 0, min=0, max = 10,width = "90%"),
        sliderInput(inputId = "wifi",label="Wifi", value = 0, min=0, max = 10,width = "90%"),
        sliderInput(inputId = "restaurant",label="Resturant", value = 0, min=0, max = 10,width = "90%"),
        selectInput("category1","Category1",type,width = "90%"),
        selectInput("category2","Category2",type,width = "90%"),
        #selectInput("number","number",vars,selected = "art"),
        sliderInput(inputId = "number",label="number", value = 0, min=1, max = 10,width = "90%"),
        actionButton("recalc", "My Trip Plan")
        
        ),
        
        
        
        
        
        
        dashboardBody(
        div(class = "outer",
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        tags$head( includeCSS("styles.css")),
        leafletOutput("backgroup",width = "100%",height= "100%"),
        
        absolutePanel(id = "graphs",fixed = T,draggable = TRUE, top = "5%", left = "auto", right = "5%", bottom = "10%",
                      width = "auto", height = "auto",
                      h1("Information"),
                      uiOutput("place"),
                      plotOutput("distplot")
                      )
        
        #input

        # absolutePanel(id = "controls", fixed = TRUE,
        #               draggable = TRUE, top = "5%", left = "auto", right = "5%", bottom = "5%",
        #               width = 300, height = "auto",
        #               
        #               h2("Trip Planner"),
        #               textInput(inputId = "location",label = "Where you are"),
        #               sliderInput(inputId = "crime",label="Safety", value = 0, min=0, max = 10),
        #               sliderInput(inputId = "wifi",label="Wifi", value = 0, min=0, max = 10),
        #               sliderInput(inputId = "restaurant",label="Resturant", value = 0, min=0, max = 10),
        #               selectInput("category1","Category1",type),
        #               selectInput("category2","Category2",type),
        #               #selectInput("number","number",vars,selected = "art"),
        #               sliderInput(inputId = "number",label="number", value = 0, min=1, max = 10),
        #             
        #               #conditionalPanel(),
        #               actionButton("recalc", "My Trip Plan")
        #               #plotOutput("scatterCollegeIncome", height = 250)
        #               
        # )
      )
    )
)



