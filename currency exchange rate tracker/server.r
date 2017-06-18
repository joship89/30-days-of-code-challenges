library(shiny)
library(data.table)
library(ggplot2)
library(quantmod)


# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

  output$summary <- renderText({ 
    "Track convergence and divergence of 30, 60 and 90 day moving averages of currency conversion rates." 
    })
  
  
  output$distPlot <- renderPlot({
    
    # devtools::install_github("joshuaulrich/quantmod@144_getFX")
    
    Currencies <- 'USD/INR'
    
    to.date <- Sys.Date() 
    from.date <-  to.date - 149 
      
    getFX(Currencies,
          from = from.date, to = to.date,
          env = .GlobalEnv,
          verbose = FALSE,
          warning = TRUE,
          auto.assign = TRUE)
    
    
    USDINR <- setDT(as.data.frame(USDINR), keep.rownames = TRUE)[]
    colnames(USDINR) <- c("Date","Rate")
    USDINR <- USDINR %>% arrange(desc(Date))
    
    #calculate rolling means. need vector with rates for last 60 days
    USDINR.abs <- data.frame(USDINR$Date[1:30], as.data.frame(USDINR$Rate)[1:30,])
    USDINR.30.ma <- data.frame(USDINR$Date[1:30], as.data.frame(rollmean(USDINR$Rate, 30))[1:30,])
    USDINR.60.ma <- data.frame(USDINR$Date[1:30], rollmean(USDINR$Rate, 60)[1:30]) 
    USDINR.90.ma <- data.frame(USDINR$Date[1:30], as.data.frame(rollmean(USDINR$Rate, 90))[1:30,]) 
    moving.averages <- data.frame(USDINR.30.ma, USDINR.60.ma[,2], USDINR.90.ma[,2], USDINR.abs[,2]) 
    colnames(moving.averages) <- c("Date", "30 Day", "60 Day", "90 Day","Current")
    
    
    
    ma.plot <- ggplot(data=moving.averages, 
      aes(x=Date, y=`30 Day`, group=1)) + 
      geom_line(color="green4") +
      geom_line(aes(y = `60 Day`), colour="darkolivegreen3") +
      geom_line(aes(y = `90 Day`), colour="darkolivegreen1") +
      geom_line(aes(y = `Current`), colour="black") +
      ggtitle('Currency Moving Averages ') + 
      ylab("INR") +
      xlab("") +
      theme_bw() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme(axis.title=element_text(face="bold", size="12", color="darkgreen"))
    plot(ma.plot)
    

    })
})