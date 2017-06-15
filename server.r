library(shiny)
library(Quandl)
library(data.table)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {


  devtools::install_github("joshuaulrich/quantmod@144_getFX")
  library(quantmod)

  Currencies <- 'USD/INR'
  getFX(Currencies,
        from = Sys.Date() - 149, to = Sys.Date(),
        env = .GlobalEnv,
        verbose = FALSE,
        warning = TRUE,
        auto.assign = TRUE)

  
  USDINR <- setDT(as.data.frame(USDINR), keep.rownames = TRUE)[]
  colnames(USDINR) <- c("Date","Rate")
  USDINR <- USDINR %>% arrange(desc(Date))

  #calculate rolling means. need vector with rates for last 60 days
  USDINR.30.ma <- data.frame(USDINR$Date[1:30], as.data.frame(rollmean(USDINR$Rate, 30))[1:30,])
  USDINR.60.ma <- data.frame(USDINR$Date[1:30], rollmean(USDINR$Rate, 60)[1:30]) 
  USDINR.90.ma <- data.frame(USDINR$Date[1:30], as.data.frame(rollmean(USDINR$Rate, 90))[1:30,]) 
  moving.averages <- data.frame(USDINR.30.ma, USDINR.60.ma[,2], USDINR.90.ma[,2]) 
  colnames(moving.averages) <- c("Date", "30 Day", "60 Day", "90 Day")
  
  library(ggplot2)
  ggplot(data=moving.averages, aes(x=Date, y=`30 Day`, group=1)) +
    geom_line(color="red") +
    geom_line(aes(y = `60 Day`), colour="blue") +
    geom_line(aes(y = `90 Day`), colour="green") 
  
  
  
  output$distPlot <- renderPlot({
    
    print(paste0("1 USD = ", inr ," INR on ", Sys.Date()))
    
    })
})