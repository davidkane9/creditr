shinyUI(fluidPage(
  titlePanel("CDS Calculator in R"),
  helpText(strong("Note: Maximize window to view properly")),
  
  ## This row is for titles of column grids
  fluidRow(
    column(2, h4(em("Trade Details and Terms", style = "color:skyblue"))),
    column(2, h4(em("Yield Curve", style = "color:skyblue"))),
    column(2, h4(em("Calculation Results", style = "color:skyblue")))
    #column(2, h4(em("View Code", style = "color:blue")))
  ),
  
  ## Begins the row for body text
  fluidRow(
    
    ## First Column is for trade details and terms
    column(1,
           textInput("ticker", label = "Ticker/Company"),
           selectInput("buySell", label = "Buyer/Seller", 
                       choices = list("Buyer" = "buyer", "Seller" = "seller")),
           numericInput("spread", label = "Spread (bps)", value = 160),
           numericInput("notional", label = "Notional (MM)", value = 10),
           sliderInput("RR", label = "Recovery Rate", min = 0.0, max = 1.0, value = 0.4),
           submitButton("calculate")
           ),
           ## do we need a clear all button?
           ## actionButton("clearAll", label = "Clear All")), 
    
    ## Second column is still for trade details and terms
    column(1,
           dateInput("tradeDate", label = "Trade Date"),
           dateInput("maturity", label = "Maturity Date"),
           numericInput("coupon", label = "Coupon (bps)", value = 100),
           selectInput("currency", label = "Currency", 
                       choices = list("USD" = "USD", "EUR" = "EUR", "JPY" = "JPY")),
           selectInput("holiday", label = "Holiday Code", 
                       choices = list("None" = "None", "JPY" = "JPY"))),
    
    
    ## third column is for yield curve
    column(2,
           tableOutput("curveRates")),
    
    ## First Column is for trade details and terms
    ## the current output looks ugly, prob use data frame output
    fluidRow(
      column(2,
             p(h4(textOutput("price"))),
             p(h4(textOutput("principal"))),
             p(h4(textOutput("accrual"))),
             p(h4(textOutput("pd")))), 
             p(h4(textOutput("CS10"))), 
             p(h4(textOutput("IR.DV01"))), 
             p(h4(textOutput("Spread.DV01"))),
             p(h4(textOutput("rec.risk"))))
      
)))