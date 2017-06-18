
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("MACD tracker - USD"),

  sidebarPanel(
   
     selectInput("currency", "Currency:",
                choices = c("INR", "EUR", "JPY"))
    
    
  ),

  # Plot of moving averages
  mainPanel(
    verbatimTextOutput("summary"),
    plotOutput("distPlot")
  )
))