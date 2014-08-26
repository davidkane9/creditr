Caesars
========================================================
price and pts upfront match with Bloomberg

upfront 5707436 supposed to be 5707438

RecRisk -95439.69 supposed to be -95430.32

spreadDV01 21 supposed to be 21.15

Principal 5,744,936 supposed to be 5,744,938.

IRDV01 -271.16 supposed to be -271.18

Def Expo 255,064 supposed to be 255062

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

Chorus
========================================================
Principal, accrual, ptsUpfront, default expo match.

default prob 0.1919 supposed to be 0.1915
IRDV01 -169.3 supposed to be -169.33


```{r}
>   result.2 <- CDS(date = as.Date("2014-04-15"),
+                   currency = "USD",                    
+                   maturity = as.Date("2019-06-20"),                    
+                   spread = 243.28,
+                   coupon = 100,
+                   recovery.rate = 0.40,
+                   notional = 1e7)
> result.2
CDS Contract 
Contract Type:                      SNAC   Currency:                         USD
Entity Name:                          NA   RED:                               NA
date:                         2014-04-15

Calculation 
price:                             93.42
Spread:                           243.28   Pts Upfront:                   0.0658
Principal:                       658,080   Spread DV01:                    4,318
Accrual:                          -7,500   IR DV01:                       -169.3
Upfront:                         650,580   Rec Risk (1 pct):           -1,123.53
Default Prob:                     0.1919   Default Expo:               5,341,920
```
