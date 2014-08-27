/*
 * ISDA CDS Standard Model
 *
 * Copyright (C) 2009 International Swaps and Derivatives Association, Inc.
 * Developed and supported in collaboration with Markit
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the ISDA CDS Standard Model Public License.
 */

#include "version.h"
#include "macros.h"
#include "cerror.h"
#include "tcurve.h"
#include "cdsone.h"
#include "convert.h"
#include "zerocurve.h"
#include "cds.h"
#include "cxzerocurve.h"
#include "dateconv.h"
#include "date_sup.h"
#include "busday.h"
#include "ldate.h"


/*
***************************************************************************
** Build IR zero curve.
***************************************************************************
*/
TCurve* BuildExampleZeroCurve()
{
  static char  *routine = "BuildExampleZeroCurve";
  TCurve       *zc = NULL;
  char         *types = "MMMMMSSSSSSSSSSSSSS";
  //SSSS";
  char         *expiries[19] = {"1M", "2M", "3M", "6M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y", "10Y", "12Y", "15Y", "20Y", "25Y", "30Y"};
  TDate        *dates = NULL;
  // double        rates[19] = {1.522e-3, 1.929e-3, 2.259e-3, 3.198e-3, 5.465e-3, 5.380e-3, 10.000e-3, 1.4475e-2, 1.8165e-2, 2.1180e-2, 2.3490e-2, 2.5430e-2, 2.6955e-2, 0.02825, 0.030275, 0.032285, 0.03397, 0.03473, 0.03507};
  double        rates[19] = {0.001517, 0.001923, 0.002287, 0.003227, 0.005465, 0.005105, 0.009265, 0.013470, 0.017150, 0.020160, 0.022630, 0.024580, 0.026265, 0.027590, 0.029715, 0.031820, 0.033635, 0.034420, 0.034780};
  TDate         baseDate;
  long          mmDCC;
  TDateInterval ivl, ivl2;
  long          dcc;
  double        freq, freq2;
  char          badDayConv = 'M';
  char         *holidays = "None";
  int           i, n;
  
  baseDate = JpmcdsDate(2014, 4, 17);
   
   if (JpmcdsStringToDayCountConv("Act/360", &mmDCC) != SUCCESS)
     goto done;
   
   if (JpmcdsStringToDayCountConv("30/360", &dcc) != SUCCESS)
     goto done;
   
   if (JpmcdsStringToDateInterval("6M", routine, &ivl) != SUCCESS)
     goto done;

   if (JpmcdsStringToDateInterval("3M", routine, &ivl2) != SUCCESS)
     goto done;
   
   if (JpmcdsDateIntervalToFreq(&ivl, &freq) != SUCCESS)
     goto done;
   if (JpmcdsDateIntervalToFreq(&ivl2, &freq2) != SUCCESS)
     goto done;

    n = strlen(types);

    dates = NEW_ARRAY(TDate, n);
    for (i = 0; i < n; i++)
    {
        TDateInterval tmp;

        if (JpmcdsStringToDateInterval(expiries[i], routine, &tmp) != SUCCESS)
        {
            JpmcdsErrMsg ("%s: invalid interval for element[%d].\n", routine, i);
            goto done;
        }
        
        if (JpmcdsDateFwdThenAdjust(baseDate, &tmp, JPMCDS_BAD_DAY_NONE, "None", dates+i) != SUCCESS)
        {
            JpmcdsErrMsg ("%s: invalid interval for element[%d].\n", routine, i);
            goto done;
        }
    }
 
    printf("calling JpmcdsBuildIRZeroCurve...\n");
    zc = JpmcdsBuildIRZeroCurve(
            baseDate,
            types,
            dates,
            rates,
            n,
            mmDCC,
            (long) freq,
            (long) freq2,
            dcc,
            mmDCC,
            badDayConv,
            holidays);
done:
    FREE(dates);
    return zc;
}


/*
***************************************************************************
** Calculate upfront charge.
***************************************************************************
*/
double CalcUpfrontCharge(TCurve* curve, double couponRate)
{
    static char  *routine = "CalcUpfrontCharge";
    TDate         today;
    TDate         valueDate;
    TDate         startDate;
    TDate         benchmarkStart;
    TDate         stepinDate;
    TDate         endDate;
    TBoolean      payAccOnDefault = TRUE;
    TDateInterval ivl;
    TStubMethod   stub;
    long          dcc;
    double        parSpread = 12354.52;
    double        recoveryRate = 0.4;
    TBoolean      isPriceClean = FALSE;
    double        notional = 1e7;
    double        result = -1.0;

    if (curve == NULL)
    {
        JpmcdsErrMsg("CalcUpfrontCharge: NULL IR zero curve passed\n");
        goto done;
    }

    today          = JpmcdsDate(2014, 4, 15);
    valueDate      = JpmcdsDate(2014, 4, 18);
    benchmarkStart = JpmcdsDate(2014, 3, 20);
    startDate      = JpmcdsDate(2014, 3, 20);
    endDate        = JpmcdsDate(2019, 6, 20);
    stepinDate     = JpmcdsDate(2014, 4, 16);

    if (JpmcdsStringToDayCountConv("Act/360", &dcc) != SUCCESS)
        goto done;
    
    if (JpmcdsStringToDateInterval("Q", routine, &ivl) != SUCCESS)
        goto done;

    if (JpmcdsStringToStubMethod("f/s", &stub) != SUCCESS)
        goto done;

    if (JpmcdsCdsoneUpfrontCharge(today,
                                  valueDate,
                                  benchmarkStart,
                                  stepinDate,
                                  startDate,
                                  endDate,
                                  couponRate / 10000.0,
                                  payAccOnDefault,
                                  &ivl,
                                  &stub,
                                  dcc,
                                  'F',
                                  "None",
                                  curve,
                                  parSpread / 10000.0,
                                  recoveryRate,
                                  isPriceClean,
                                  &result) != SUCCESS) goto done;
done:
    return result * notional;
}


/*
***************************************************************************
** Main function.
***************************************************************************
*/
int main(int argc, char** argv)
{
    int     status = 1;
    char    version[256];
    char  **lines = NULL;
    int     i;
    TCurve *zerocurve = NULL;

    if (JpmcdsVersionString(version) != SUCCESS)
        goto done;

    /* print library version */
    printf("starting...\n");
    printf("%s\n", version);
    
    /* enable logging */
    printf("enabling logging...\n");
    if (JpmcdsErrMsgEnableRecord(20, 128) != SUCCESS) /* ie. 20 lines, each of max length 128 */
        goto done;

    /* construct IR zero curve */
    printf("building zero curve...\n");
    zerocurve = BuildExampleZeroCurve();
    if (zerocurve == NULL)
        goto done;

    /* get discount factor */
    printf("\n");
    /*printf("Discount factor on 3rd Jan 08 = %f\n", JpmcdsZeroPrice(zerocurve, JpmcdsDate(2008,1,3)));
    printf("Discount factor on 3rd Jan 09 = %f\n", JpmcdsZeroPrice(zerocurve, JpmcdsDate(2009,1,3)));
    printf("Discount factor on 3rd Jan 17 = %f\n", JpmcdsZeroPrice(zerocurve, JpmcdsDate(2017,1,3)));*/

    /* get upfront charge */
    printf("\n");
    //printf("Upfront charge @ cpn = 0bps    =  %f\n", CalcUpfrontCharge(zerocurve, 0));
    printf("Upfront charge @ cpn = 500bps =  %f\n", CalcUpfrontCharge(zerocurve, 500));
    //printf("Upfront charge @ cpn = 7200bps = %f\n", CalcUpfrontCharge(zerocurve, 7200));
    
    /* return 'no error' */
    status = 0;

done:
    if (status != 0)
        printf("\n*** ERROR ***\n");

    /* print error log contents */
    printf("\n");
    printf("Error log contains:\n");
    printf("------------------:\n");

    lines = JpmcdsErrGetMsgRecord();
    if (lines == NULL)
        printf("(no log contents)\n");
    else
    {
        for(i = 0; lines[i] != NULL; i++)
        {
            if (strcmp(lines[i],"") != 0)
                printf("%s\n", lines[i]);
        }
    }

    FREE(zerocurve);
    return status;
}
