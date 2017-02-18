//+------------------------------------------------------------------+
//|                                                    testOrdre.mq4 |
//|                                                          muabtec |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern double lots = 0.01;
extern double lots1 = 0.01;
int magic = 12345678;
int bars;
int i=0;
bool reperage=false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   int b=iBars(NULL,1);
   if(i==0)
   {
      OrderSend(Symbol(), OP_SELL, lots, Bid, 3, 0, 0, "Ordre Vente Stop - High-Low EA", magic, 0, Red);
   }
   if (reperage == false){
      bars = b;
      i++;
      reperage = true;
   }
   if (bars != b)
   {
      reperage = false;
      //Annuler();
   }
   if(i>=3)
   {
      Annuler();
   }
  }
//+------------------------------------------------------------------+
void Annuler()
{
   int Ticket;           // Order ticket
   double Lot;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderMagicNumber() == magic)
         {
            if (OrderType()==OP_SELL)
            {
               //OrderDelete(OrderTicket());
               Ticket=OrderTicket();           // Order ticket
               Lot=OrderLots();   
               OrderClose(Ticket,Lot,Ask,2);
            }
            if (OrderType()==OP_BUY)
            {
               //OrderDelete(OrderTicket());
               Ticket=OrderTicket();           // Order ticket
               Lot=OrderLots();   
               OrderClose(Ticket,Lot,Bid,2);
            }
         }
      }
   }
}
