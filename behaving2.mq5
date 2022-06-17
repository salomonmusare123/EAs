#include<Trade\Trade.mqh>
CTrade trade;double previous_OP;int psell ; int pbuy ;int counter  = 0; double handle; int previous_pips= 0 ; int total ;double lowest ; double current_OP; input double multiplier = 1.6; input int minilot = 1; input int minilotb = 1; double lot = minilot ; double lotb = minilot;//1.04293 
double Bid; int len = 0; double Ask; int lenb = 0; double PositionPriceCurrent; double profits; double profitb;double plm; double plmb; double pips = 0; int counterb = 0;
void OnInit(  ){trade.Buy(lotb/100, NULL , NULL, NULL) ;  trade.Sell(lot/100, NULL , NULL, NULL) ; };
void OnTick()
  { 
  MqlRates pricedata[3]; //price array  trade.Buy(lotb/100, NULL , NULL, NULL) ;     trade.Sell(lot/100, NULL , NULL, NULL) ;
  ArraySetAsSeries(pricedata,true);
  CopyRates(_Symbol,_Period,0,3,pricedata);
  static datetime timestamplast; datetime currenttimestamp;
  currenttimestamp = pricedata[0].time;double mypricearray[];
   handle=iMomentum(_Symbol,Period(),14,PRICE_CLOSE); 
   //---   Comment(_Symbol, " ",Period(), " ", " ",14, " ",PRICE_CLOSE, " ", handle);
   ArraySetAsSeries(mypricearray, true);
   
   CopyBuffer(handle,  0,0,3,mypricearray);
   double mom = NormalizeDouble(mypricearray[0],2);
  if (len ==0 && mom > 100.48) { lot = minilot; trade.Sell(lot/100, NULL , NULL, NULL) ; len = 1;}
  if (lenb ==0 && mom < 99.55) { lotb = minilotb; trade.Buy(lotb/100, NULL , NULL, NULL) ; lenb = 1;}
  if(currenttimestamp!=timestamplast){ timestamplast = currenttimestamp ;previous_pips = pips;
  if (len > 0){
    psell = len ; 
        counter = counter + 1;  
      plm = 4.2*len;
      current_OP = iOpen(Symbol(),Period(),0);  previous_OP = iOpen(Symbol(),Period(),1);  pips = (current_OP - previous_OP )*100000    ;len = 0; profits = totalprofit() ;
      if (profits>= plm ){closeAllSellPositions();lot = minilot;    Print("--------------closing all sell profit: " , profits); len = 0;};
      if (pips>30&& counter >1){lot = MathRound( lot  *multiplier ) ; trade.Sell(lot/100, NULL , NULL, NULL) ; len  = len+1;  Print("_____________continue sell as pip = " , pips); } ;
      if (lowest>profits){lowest = profits;}; 
  
   
  };
  if (lenb > 0){
      pbuy = lenb; counterb = counterb + 1;  
      plmb = 4.2*lenb;
      current_OP = iOpen(Symbol(),Period(),0);  previous_OP = iOpen(Symbol(),Period(),1);  pips = (current_OP - previous_OP )*100000    ; lenb = 0; profitb = totalprofitb() ;
      if (profitb>= plmb ){closeAllBuyPositions();lotb = minilotb; Print("--------------closing all buys profit : " , profitb);lenb  = 0; };     
      if (pips<-30 && counterb >1){lotb = MathRound( lotb *multiplier ); trade.Buy(lotb/100, NULL , NULL, NULL) ;lenb  = lenb+1 ; Print("_____________continue buy as pip = " , pips); }
      if (lowest>profitb){lowest = profitb;}; 
  
   
  }; 
  
      Comment( counter , "-" ,counterb , "                                         previous_OP : " , previous_OP , " current_OP : " ,current_OP , " pips : " , MathRound(pips), " previous_pips : ",MathRound(previous_pips), "\n",
      "                                                sell trades : " , len , " psell : ", psell ,  " buy trades : " , lenb , " pbuy : ", pbuy, "\n",
      "                                             profits : " , profits , " profitb : " , profitb , "\n",
      "                                             lot : " , lot , " lotb : " , lotb , " lowest : " , lowest , " total : ", total 
      );
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
  
  
  
  