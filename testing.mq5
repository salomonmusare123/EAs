#include<Trade\Trade.mqh>
CTrade trade;
int tracker = 9;
void OnTick(){
double sal =  MathPow(2,3);
Comment( "                                       " , sal);
tracker = tracker+1;

}


