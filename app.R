#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlotly({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- input$bins + 1

        #hist
        plot_ly(x = x,
                type = "histogram",
                histnorm = "",# "" | "percent" | "probability"
                name = "Histogram of waiting times",
                nbinsx = bins,
                hovertemplate = "x: (%{x})\ny: %{y}",
                marker = list(color = "green",
                              line = list(color = "black",
                                          width = 1))
                ) %>%
          layout(
            title = "x",
            xaxis = list(title = "Waiting time to next eruption (in mins)"),
            yaxis = list(title = "Count", # "percent" | "probability"
                          zeroline = TRUE)
          )
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
