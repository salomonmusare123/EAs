#include<Trade\Trade.mqh>
CTrade trade;double previous_OP;int counter  = 0;int previous_pips= 0 ; double current_OP; double multiplier = 1.6; double lot = 1 ; double lotb = 1;//1.04293 
double Bid; int len = 0; double Ask; int lenb = 0; double PositionPriceCurrent; double profits; double profitb;double plm; double plmb; double pips = 0;
void OnInit(  ){trade.Buy(1, NULL , NULL, NULL) ;  trade.Sell(1, NULL , NULL, NULL) ; };
void OnTick()
  {
  MqlRates pricedata[3]; //price array
  ArraySetAsSeries(pricedata,true);
  CopyRates(_Symbol,_Period,0,3,pricedata);
  static datetime timestamplast; datetime currenttimestamp;
  currenttimestamp = pricedata[0].time;
  if(currenttimestamp!=timestamplast){Print("-----------------------");       timestamplast = currenttimestamp ; previous_pips = pips;
        counter = counter + 1;  len = 0; lenb = 0;
      MqlRates rates[2];   ArraySetAsSeries(rates,true);  int copied=CopyRates(Symbol(),0,0,2,rates); if(len >0){plm = 4.2*len;};if(lenb >0){plmb = 4.2*lenb;};
      current_OP = rates[1].open;  previous_OP = rates[0].open; pips = (current_OP - previous_OP )*100000    ;profits = totalprofit() ; profitb = totalprofitb();
      if (profits>= plm ){closeAllSellPositions();lot = 1; trade.Sell(0.01, NULL , NULL, NULL) ;};if (profitb>= plmb ){closeAllBuyPositions();lotb = 1; trade.Buy(0.01, NULL , NULL, NULL) ;};
      if (pips>30){lot = MathRound( lot *multiplier ) ; trade.Sell(lot/100, NULL , NULL, NULL) ; }        ; if (pips<30){lotb = MathRound( lotb *multiplier ); trade.Buy(lotb/100, NULL , NULL, NULL) ;}
      Comment( counter , " previous_OP : " , previous_OP , " current_OP : " ,current_OP , " pips : " , pips, " previous_pips : ",previous_pips, "\n",
      " sell trades : " , len , " buy trades : " , lenb , "\n",
      " profits : " , profits , " profitb : " , profitb
      );
  
  
  
  //Comment(pricedata[0]);
   
   //Comment( "yeah" );
   
  };
  }
  
 
   
double totalprofit()
  {
   double totalprofit=0.0;
   double PositionPriceOpen = 0;
   if ( PositionSelect(_Symbol) == true ){
      for(int i = 0 ; i <PositionsTotal() ; i++){
      ulong ticket = PositionGetTicket(i);
         string PositionSymbol = PositionGetString(POSITION_SYMBOL) ;
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);
         int PositionSwap = (int)PositionGetDouble(POSITION_SWAP);
         double PositionNetProfit = PositionProfit+PositionSwap;
         Comment("in for loop : PositionSymbol == " , PositionSymbol , "_Symbol : " ,_Symbol );
         
         if (PositionSymbol == _Symbol){
            Comment("in adding");
            long positionDirection = PositionGetInteger(POSITION_TYPE);
            if (positionDirection == POSITION_TYPE_SELL){
               Bid = PositionGetDouble(POSITION_PRICE_OPEN);
               len = len + 1;
               totalprofit = totalprofit + PositionNetProfit;
          }  
         };
      }
   }
  return(totalprofit);
  };


 
double totalprofitb()
  {
   //Comment("in ");
   double totalprofit=0.0;
   if ( PositionSelect(_Symbol) == true ){
      for(int i = 0 ; i <PositionsTotal() ; i++){  //int i = 0 ; i <PositionsTotal() ; i++
      ulong ticket = PositionGetTicket(i);
         string PositionSymbol = PositionGetString(POSITION_SYMBOL) ;
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);
         PositionPriceCurrent =  PositionGetDouble(POSITION_PRICE_CURRENT);
         int PositionSwap = (int)PositionGetDouble(POSITION_SWAP);
         double PositionNetProfit = PositionProfit+PositionSwap;
         Comment("in for loop : PositionSymbol == " , PositionSymbol , "_Symbol : " ,_Symbol );
         
         if (PositionSymbol == _Symbol){
            Comment("in adding");
            long positionDirection = PositionGetInteger(POSITION_TYPE);
            if (positionDirection == POSITION_TYPE_BUY){
               Ask = PositionGetDouble(POSITION_PRICE_OPEN);
               lenb = lenb + 1;
               totalprofit = totalprofit + PositionNetProfit;
          }  
         };
      }
   }
  return(totalprofit);
  };


 
void closeAllBuyPositions(){
   for (int  i = PositionsTotal()-1 ; i>=0 ; i--){
      ulong ticket = PositionGetTicket(i);
      ulong positionDirection = PositionGetInteger(POSITION_TYPE);
      string PositionSymbol = PositionGetString(POSITION_SYMBOL) ;
      if (PositionSymbol == _Symbol){
         if (positionDirection == POSITION_TYPE_BUY){
            trade.PositionClose(ticket);
         };
      }
   }
   
}
  
void closeAllSellPositions(){
   for (int  i = PositionsTotal()-1 ; i>=0 ; i--){
      ulong ticket = PositionGetTicket(i);
      ulong positionDirection = PositionGetInteger(POSITION_TYPE);
      string PositionSymbol = PositionGetString(POSITION_SYMBOL) ;
      if (PositionSymbol == _Symbol){
         if (positionDirection == POSITION_TYPE_SELL){
            trade.PositionClose(ticket);};}}
   
}
  
  
  
  