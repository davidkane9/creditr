

## Create fake data

plot.term <- function(date = as.Date("2014-06-02")){
  data <- rates[which(rates$date == date), ]
  data <- transform(data, expiry = factor(expiry, levels = c("1M", "2M", "3M", "6M", "1Y", "2Y", 
                                                             "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", 
                                                             "9Y", "10Y", "12Y", "15Y", "20Y", 
                                                             "25Y", "30Y")))
  m1   <- dPlot(rate ~ expiry, type = c("line"), groups = "currency", data = data, lineWidth = 5)
  m1$xAxis(orderRule = levels(data$expiry))
  m1$yAxis(outputFormat = "0.5f")
  m1$legend(x = 60,y = 10,width = 400,height = 20,horizontalAlign = "right")
  m1$set(storyboard = "currency", width = 500)
  return(m1)
}

plot.rates <- function(date = as.Date("2014-06-02"), currency = "USD", 
                       expiry = "1Y", previous.days = 30){
  
  data <- rates[which(rates$date >= date - previous.days & rates$date <= date
                      & rates$currency == currency & rates$expiry == expiry), ]
  data$date <- format(data$date, format="%m-%d")
  
  plot <- Highcharts$new()
  plot$chart(type = c("spline"))
  plot$series(data = data$rate, dashStyle = "longdash")
  plot$legend(symbolWidth = 80)
  plot$xAxis(categories = as.character(data$date))
  plot$set(width = 1000)
  return(plot)
}

plot.HH = function(lunch = T){
  map <- Leaflet$new()
  map$setView(c(42.354995, -71.056810), zoom = 15)
  map$marker (c(42.354995, -71.056810), bindPopup = "<p> Welcome to Hutchin Hill @ Boston! </p>")
  if(lunch == T) {
    map$marker (c(42.351556, -71.060615), bindPopup = "<p> We usually have lunch here! </p>")
  }
  return(map)
}