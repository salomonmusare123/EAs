#include<Trade\Trade.mqh>


bool salomon = PositionSelect(_Symbol);
Comment( "salomon : ". salomon)
CTrade trade;
//bool salomon = PositionSelect(_Symbol);
void OnTick(void)
  {
   //Comment("salomon : " , salomon);
   //int  err  = GetLastError();
   //Comment(err , "\n" );
   //if (!PositionSelect( _Symbol  )){
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK), _Digits);
  
      //Comment(Ask , " posistion : " ,  PositionsTotal());
      if (PositionsTotal()<20){
         trade.Buy(0.10, NULL , NULL, NULL); // (Ask - 1000*_Point) this is stop loss
      }
      if (PositionsTotal()==20){
         closeAllBuyPositions();
      }
   //}
}

void closeAllBuyPositions(){
   for (int  i = PositionsTotal()-1 ; i>=0 ; i--){
      int ticket = PositionGetTicket(i);
      int positionDirection = PositionGetInteger(POSITION_TYPE);
      if (positionDirection == POSITION_TYPE_BUY){
         trade.PositionClose(ticket);
      }
   }
   
}
void OnTrade()
{
   //double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   //double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   //double RSIArray = [];
   //ArraySetAsSeries(RSIArray , true);
   
 }
 
 