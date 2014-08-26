Caesars
========================================================
Input spread, price, accrual, spreadDV01

Principal 5,744,936 supposed to be 5,744,938.

IRDV01 -75.64 supposed to be -271.18

Rec Risk -95430.32 supposed to be -330.19!!??

Def Expo 5,712,542 supposed to be 255062

```{r}
> library(CDS)
> result.1 <- CDS(date = as.Date("2014-04-15"),
                   currency = "USD",
                   maturity = as.Date("2019-06-20"),                    
                   spread = 12354.529,
                   coupon = 500,
                   recovery.rate = 0.4,
                   notional = 1e7)
> result.1
CDS Contract 
Contract Type:                      SNAC   Currency:                         USD
Entity Name:                          NA   RED:                               NA
date:                         2014-04-15

Calculation 
price:                             42.55
Spread:                        12,354.53   Pts Upfront:                   0.5745
Principal:                     5,744,936   Spread DV01:                       21
Accrual:                         -37,500   IR DV01:                      -271.16
Upfront:                       5,707,436   Rec Risk (1 pct):          -95,439.69
Default Prob:                          1   Default Expo:                 255,064
```
