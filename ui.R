#Chad Burdyshaw
#user interface for twitter location word cloud
library(shiny)
library(shinyIncubator)

shinyUI(
    fluidPage(
    
        # Application title
        headerPanel("Twitter Origin Word Cloud"),
    
        # Sidebar with a slider and selection inputs
        fluidRow(column(width=3,
                        sidebarPanel(width = 30,
                                selectInput("selection", "Choose a time zone:", 
                                            choices = regions),
                                sliderInput("freq", "Minimum Frequency:", 
                                            min = 1,  max = 50, value = 2),
                                sliderInput("max", "Maximum Number of Words:", 
                                            min = 1,  max = 1000,  value = 150)
                        )
                 ),
                 column(width=9,offset=0, plotOutput("plot"))
        ),
        fluidRow(column(4,imageOutput("image", height = 300)),
                 column(5,offset=2,textOutput("text1"))
        )
    )
)