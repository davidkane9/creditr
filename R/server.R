library(creditr)
data(rates)
options(digits = 5)
## define a helper function of r; the one in base does not work properly in certain ways
r <- function(x){format(round(x, 2), nsmall = 2)}

shinyServer(function(input, output) {
  
  output$curveRates <- renderTable({ 
    data.frame(rates[rates$date == input$tradeDate & rates$currency == input$currency, 2:4], 
               row.names = NULL)
  }, digits = 5)
  cds <- reactive({
    CDS(date = input$tradeDate - 1, name = input$ticker, maturity = input$maturity,
        spread = input$spread, coupon = input$coupon, recovery = input$RR, 
        notional = input$notional * 1000000, currency = input$currency)
  })
  
  'output$calcTable <- data.frame(row.names = c("Price", "Principle", "Accrual Amount", 
                                         "Default Probability", "IR DV01", "Rec Risk (1%)",
                                         "Spread DV01"), 
                           CDS = c(r(cds()@price), r(cds()@principal), r(cds()@accrual),
                                   r(cds()@pd), r(cds()@IR.DV01), r(cds()@rec.risk.01), 
                                   r(cds()@spread.DV01)))'
  
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
  
})