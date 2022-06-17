void OnStart() 
  { 
//--- 
   MqlRates rates[]; 
   ArraySetAsSeries(rates,true); 
   int copied=CopyRates(Symbol(),0,0,2,rates); 
   Comment( rates[1].open,rates[0].open  );
      
  }