library(shiny)
library(lucr)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

  # Conversion rate USD - INR tracked with its 30, 60 and 90 day averages tracked
  
  
  x <- 1
  inr <- currency_convert(x, from = "USD", to = "INR", key = "59246459138d401cae7835a7cf252ac4")[1]
  
  print(paste0("1 USD = ", inr ," INR on ", Sys.Date()))
  
  output$distPlot <- renderPlot({
    
    # generate an rnorm distribution and plot it
    dist <- rnorm(input$obs)
    hist(dist)
  })
})