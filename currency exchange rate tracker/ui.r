library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Track USD - INR conversion rates"),


  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))