library(dplyr)
library(shiny)
library(data.table)
library(ggplot2)
library(quantmod)
library(curl)
# 
# source("http://bioconductor.org/biocLite.R")
# devtools::install_github("joshuaulrich/quantmod@144_getFX")
# setwd("~/github/data-science/projects/extras/useful-shiny-applications")

shinyServer(function(input, output) {

  # output$summary <- renderText({ 
  #   "Track convergence and divergence of 30, 60 and 90 day moving averages of currency conversion rates." 
  #   "Moving Average Convergence Divergence is a technical indicator developed by Gerald Appel in the late 1970s. It is supposed to reveal changes in the strength, direction, momentum, and duration of a trend in a time series."
  #   
  #   "This app tracks moving averages of currency conversion rates to detect strong trend changes and momentum indicators."
  #   
  #   "The idea is to track the relationship between moving averages of the currency conversion rates for time periods of 30 days, 60 days and 90 days."
  #   
  #   "As the shorter term moving average diverges further from the longer term moving average it indicates that the upside momentum is increasing. Divergence signals the end of momentum or current trend."
  #   })
  
  output$maPlot <- renderPlot({
    
    currencies <- paste0("USD/",input$currency)
    to.date <- Sys.Date() 
    from.date <-  to.date - 149 
      
    # get conversion rates for the time interval
    
    getFX(currencies,
          from = from.date, to = to.date,
          env = .GlobalEnv,
          verbose = FALSE,
          warning = TRUE,
          auto.assign = TRUE)
    curr.time.series <- setDT(as.data.frame(get(paste0("USD","INR"))), keep.rownames = TRUE)[]
    curr.time.series <- setDT(as.data.frame(get(paste0("USD",input$currency))), keep.rownames = TRUE)[]
    colnames( curr.time.series) <- c("Date","Rate")
    curr.time.series <-  curr.time.series %>% arrange(desc(Date))
    
    # Calculate moving averages: 
    curr.time.series.abs <- data.frame( curr.time.series$Date[1:30], as.data.frame( curr.time.series$Rate)[1:30,])
    curr.time.series.30.ma <- data.frame( curr.time.series$Date[1:30], as.data.frame(rollmean(curr.time.series$Rate, 30))[1:30,])
    curr.time.series.60.ma <- data.frame( curr.time.series$Date[1:30], rollmean( curr.time.series$Rate, 60)[1:30]) 
    curr.time.series.90.ma <- data.frame( curr.time.series$Date[1:30], as.data.frame(rollmean( curr.time.series$Rate, 90))[1:30,]) 
    moving.averages <- data.frame( curr.time.series.abs[,1], curr.time.series.30.ma[,2],  curr.time.series.60.ma[,2],  curr.time.series.90.ma[,2],  curr.time.series.abs[,2]) 
    colnames(moving.averages) <- c("Date", "30 Day", "60 Day", "90 Day","Current")
    
    # line plots of moving averages
    ma.plot <- ggplot(data=moving.averages, 
      aes(x=Date, y=`30 Day`, group=1)) + 
      geom_line(color="green4") +
      geom_line(aes(y = `60 Day`), colour="darkolivegreen3") +
      geom_line(aes(y = `90 Day`), colour="darkolivegreen1") +
      geom_line(aes(y = `Current`), colour="black") +
      ggtitle('Currency Moving Averages ') + 
      ylab(input$currency) +
      xlab("") +
      theme_bw() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme(axis.title=element_text(face="bold", size="12", color="darkgreen"))

    plot(ma.plot)
    })
})