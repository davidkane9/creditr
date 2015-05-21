

data(rates)
options(digits = 5)
## define a helper function of r; the one in base does not work properly in certain ways
r <- function(x){format(round(x, 2), nsmall = 2)}

shinyServer(function(input, output) {
  
  output$curveRates <- renderTable({ 
    data.frame(rates[rates$date == input$tradeDate & rates$currency == input$currency, 2:4], 
               row.names = NULL)
  }, digits = 5)
  
  'termTable <- renderTable({ 
    data.frame(rates[rates$date == input$date, ]$rate, 
               factor(rates[rates$date == input$date, ]$expiry, 
                      levels = c("1M", "2M", "3M", "6M", "1Y",
                                 "2Y", "3Y", "4Y", "5Y", "6Y", 
                                 "7Y", "8Y", "9Y", "10Y", "12Y",
                                 "15Y", "20Y", "25Y", "30Y")),
               row.names = NULL)
  }, digits = 5)'
  
  cds <- reactive({
    CDS(date = input$tradeDate - 1, name = input$ticker, maturity = input$maturity,
        spread = input$spread, coupon = input$coupon, recovery = input$RR, 
        notional = input$notional * 1000000, currency = input$currency)
  })
  
  output$price <- renderText({
    paste("Price:", r(cds()@price))
  })
  
  output$principal <- renderText({
    paste("Principal:", r(cds()@principal))
  })
  
  output$accrual <- renderText({
    paste("Accrual Amount:", r(cds()@accrual))
  })
  
  output$pd <- renderText({
    paste("Default Probability:", r(cds()@pd))
  })
  
  output$IR.DV01 <- renderText({
    paste("IR DV01:", r(cds()@IR.DV01))
  })
  
  output$rec.risk <- renderText({
    paste("Rec Risk (1%):", r(cds()@rec.risk.01))
  })
  
  output$spread.DV01 <- renderText({
    paste("Spread DV01:", r(cds()@spread.DV01))
  })

  output$termChart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
    m1   <- dPlot(rate ~ expiry, type = c("line"), groups = "currency", 
                  data = rates[rates$date == input$date, ])
                                    
    m1$xAxis(orderRule = levels(factor(rates$expiry, levels = c("1M", "2M", "3M", "6M", "1Y",
                                                                 "2Y", "3Y", "4Y", "5Y", "6Y", 
                                                                 "7Y", "8Y", "9Y", "10Y", "12Y",
                                                                 "15Y", "20Y", "25Y", "30Y"))))
    m1$yAxis(outputFormat = "0.5f")
    m1$legend(x = 60,y = 10,width = 400,height = 20,horizontalAlign = "right")
    m1$set(storyboard = "currency", width = 500)
    m1
    return(m1)
  })
  
  
  'output$calcTable <- data.frame(row.names = c("Price", "Principle", "Accrual Amount", 
  "Default Probability", "IR DV01", "Rec Risk (1%)",
  "Spread DV01"), 
  CDS = c(r(cds()@price), r(cds()@principal), r(cds()@accrual),
  r(cds()@pd), r(cds()@IR.DV01), r(cds()@rec.risk.01), 
  r(cds()@spread.DV01)))'
})