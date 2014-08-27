Check this tmrw with server results
```
yang@ubuntu:~/CDS/isda_cds_model_c_v1.8.2/examples/c/build/linux$ make clean; make; ./cds 
rm -rf cds main.o  *_pure_*.o
/usr/bin/gcc -o main.o -g -c -DUNIX -DLINUX -DVERSION="1.8.2" -I../../../../lib/include/isda -I/usr/include "../../../../examples/c/src/main.c"
/usr/bin/g++ -lm -o cds main.o ../../../../lib/build/lib/linux/cds.a  -lc
chmod u+x cds
starting...
CDS version 1.8.2
enabling logging...
building zero curve...
calling JpmcdsBuildIRZeroCurve...


Upfront charge @ cpn = 500bps =  5707435.925488

Error log contains:
------------------:
```

Important Notice: 
when we are comparing CDS R's outcome with Bloomberg's, be sure not to use the printed out version which does rounding internally. Instead, just show the slots value. For example, when I check spread.DV01, if I just compare the spread.DV01 in show(result.1) with Bloomberg, it seems a big difference: 21.15 (Bloomberg) and 21 (R show). But if I compare result.1@spreadDV01 with Bloomberg, our result seems correct: 21.15 (Bloomberg) and 21.15226 (R slot). Be careful about this.


Caesars
========================================================
spreadDV01, accrual, price and pts upfront match with Bloomberg

upfront 5707436 supposed to be 5707438

RecRisk -95439.69 supposed to be -95430.32

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
price, upfront, Principal, accrual, ptsUpfront, default expo match.

default prob 0.1919 supposed to be 0.1915

IRDV01 -169.3 supposed to be -169.33

RecRisk -1123.53 supposed to be -1106.34

spreadDV01 4318.342 supposed to be 4317.54


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
