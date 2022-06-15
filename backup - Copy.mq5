#include<Trade\Trade.mqh>
CTrade trade;
int oneOrder = 1; int debug = 0;int hghln = 0;int hghlnb = 0; double PositionPriceCurrent= 0 ;int aaction = 0;int aactionb = 0;double rnet =0; double blc = 0; double lowst = 0 ;double lowstb = 0 ; 
double ctr = 42;double ctrb= 42;double len = 1; //code to get total number of open sell trades ,       ctr = contrade
double plm = 42 ;double lenb = 1;double plmb = 42 ;  //code to get total number of open buy trades
int tracker  = 0 ;double Bid =0; double cbid = 0;double Ask = 0 ; double cask = 0;double  pprofit_loss = 0;double pprofit_lossb;//cask current ask
double ctrbid = 0; double ctrbask = 0;
void OnTick()
  { plm = 42; plmb = 42 ;debug = 0;if (oneOrder == 1){trade.Buy(0.01, NULL , NULL, NULL); Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK), _Digits);trade.Sell(0.01, NULL , NULL, NULL); Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID), _Digits);Comment("sending order");oneOrder += 2;};bool salomon = PositionSelect(_Symbol);
   pprofit_loss = totalprofit();pprofit_lossb = totalprofitb(); blc = rnet + pprofit_loss+ pprofit_lossb; if ( lowst > pprofit_loss ){lowst = pprofit_loss;}; if ( lowstb>pprofit_lossb ){lowstb = pprofit_lossb;};
   if(len >0){plm = 42*len;debug=1;};if(lenb >0){plmb = 42*lenb;};  tracker = tracker + 1;aaction = 0;aactionb = 0;
   if (pprofit_loss>= plm ){aaction = 1;};if (pprofit_lossb>= plmb ){aactionb = 1;};
   cask =  NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK), _Digits);
   cbid =  NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID), _Digits);
   if (len>0){ctrbid = ctr+Bid;if(cbid>=ctrbid){ aaction  = 2;};}; step(aaction ,len ); if(hghln<len){hghln = len; };
   if (lenb>0){ctrbask = -ctrb+Ask;if( cask <= ctrbask){ aactionb  = 2;};};stepb(aactionb ,lenb ); if(hghlnb<lenb){hghlnb = lenb ;};
   Comment( " @               ",   "           len : ", len,"       lenb : ", lenb, "          Bid : ", Bid, "         Ask : ", Ask, "         time local : ", TimeLocal(),"         diffb:  ", ( Ask -ctrbask ) ,"        ctrb : ", ctrb, "\n", 
            "                     ",   "           pl : ", pprofit_loss  ,"         plb : " , pprofit_lossb  , "        ctrbid : ", ctrbid, " lowst : ", lowst, "        lowstb : ", lowstb,  "         diff:  ", (ctrbid - Bid) , "        ctr : ", ctr, "\n",
            "                     ",   "           ctrbask : ", ctrbask, "       plm : ", plm, "         plmb : ", plmb, "         hghlnb : ", hghlnb, "        hghln : ", hghln, "\n",
            "                     ",   "           aaction : " , aaction,"       aactionb : " , aactionb, "          debug : ", debug , "          rnet : ", rnet, "          blc : ", blc );
   
   
   len = 0;lenb = 0;
  };


void step(int saaction , int slen){
   if (saaction == 1){
      rnet = rnet + pprofit_loss;
      closeAllSellPositions();
      trade.Sell(0.01, NULL , NULL, NULL); // (Ask - 1000*_Point) this is stop loss;
      }
   if (saaction == 2){ 
      double lotie = 0.01*(2*slen + 1)*2;
      trade.Sell(lotie, NULL , NULL, NULL); // (Ask - 1000*_Point) this is stop loss;
      }
}
void stepb(int saactionb , int slenb){
   if (saactionb == 1){ 
      rnet = rnet + pprofit_lossb;
      closeAllBuyPositions();
      trade.Buy(0.01, NULL , NULL, NULL); // (Ask - 1000*_Point) this is stop loss;
      }
   if (saactionb == 2){ 
      double lotieb = 0.01*(2*slenb + 1)*2;
      trade.Buy(lotieb, NULL , NULL, NULL); // (Ask - 1000*_Point) this is stop loss;
      }
}
 
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

  