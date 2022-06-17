//+------------------------------------------------------------------+
//|                                                       betest.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
double handle;
void OnTick()
  { 
   double mypricearray[];
   handle=iMomentum(_Symbol,Period(),14,PRICE_CLOSE); 
   //---   Comment(_Symbol, " ",Period(), " ", " ",14, " ",PRICE_CLOSE, " ", handle);
   ArraySetAsSeries(mypricearray, true);
   
   CopyBuffer(handle,  0,0,3,mypricearray);
   double mom = NormalizeDouble(mypricearray[0],2);
   Comment(mom);
  }