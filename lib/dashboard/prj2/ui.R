library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = "Love New York"
)

siderbar<-dashboardSidebar(
  
  sidebarMenu(
    menuItem("Living in Manhattan", tabName = "Manhattan"),
    menuItem("Trip Planner", tabName = "trip planner")
  )
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("NYmap", height = 500),
               splitLayout(
                 sliderInput(inputId = "crime",label="I care safety", value = 5, min=0, max = 10),
                 sliderInput(inputId = "wifi",label="I have to be online!", value = 5, min=0, max = 10),
                 sliderInput(inputId = "restuarant",label="I eat goods", value = 5, min=0, max = 10))
           ),
           box(width = NULL,
               uiOutput("numVehiclesTable")
           )
           ),
    column(width = 3,
           box(width = NULL, status = "warning",
               uiOutput("routeSelect"),
               selectInput("category1", "category1",
                           choices = c(
                             "Museum" = "M",
                             "Nature" = "N",
                             "Theater" = "T",
                             "Opera House" = "O",
                             "Gallery" = "G",
                             "Film"="F"
                           )
               ),
               selectInput("category2", "category2",
                           choices = c(
                             "Museum" = "M",
                             "Nature" = "N",
                             "Theater" = "T",
                             "Opera House" = "O",
                             "Gallery" = "G",
                             "Film"="F"
                           )
               ),
               
               p(
                 class = "text-muted",
                 paste("Note: a route number can have several different trips, each",
                       "with a different path. Only the most commonly-used path will",
                       "be displayed on the map."
                 )
               ),
               actionButton("zoomButton", "Zoom to fit buses")
           ),
           box(width = NULL, status = "warning",
               sliderInput(inputId = "number",label="number", value = 5, min=1, max = 10),
               uiOutput("timeSinceLastUpdate"),
               actionButton("route", "Trip Planner"),
               p(class = "text-muted",
                 br(),
                 "Choose number of the attractions you want to go for your trip!"
               )
           )
    )
  )
  
)

dashboardPage(
  header,
  siderbar,
  body
)