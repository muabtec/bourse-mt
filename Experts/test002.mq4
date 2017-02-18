//+------------------------------------------------------------------+
//|                                                      test002.mq4 |
//|                                                          muabtec |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      ""
#property version   "1.00"
#property strict

#import "Ichimoku.ex4"
#import

extern double lots = 0.1;
extern int stop = 50;
extern int limite = 100;
int magic = 12345678;
int date;
double plusHaut;
double plusBas;
bool reperage=false;
extern bool niveauxDimanche = 0;



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
    if (reperage == false){
      date = TimeDay(Time[0]);
      if(DayOfWeek() == 1 && TimeDayOfWeek(Time[1])==0){
         plusHaut = iHigh(NULL, PERIOD_D1, 2);
         plusBas = iLow(NULL, PERIOD_D1, 2);
      }
      else {
         plusHaut = iHigh(NULL, PERIOD_D1, 1);
         plusBas = iLow(NULL, PERIOD_D1, 1);
      }
      Affichage("NiveauPlusHaut", "PlusHautText", plusHaut, "Plus haut pour le ", Blue);
      Affichage("NiveauPlusBas", "PlusBasText", plusBas, "Plus bas pour le", Red);
      
      plusHaut = iHigh(NULL, PERIOD_D1, 0);
      plusBas = iLow(NULL, PERIOD_D1, 0);
      //OrderSend(Symbol(),OP_SELL,lots,Ask,3,0,0,"",magic,0,Blue); 
      OrderSend(Symbol(), OP_BUY, lots, Ask, 3, Ask - (stop * Point), Ask + (limite * Point), "Ordre Achat Stop - High-Low EA", magic, 0, Green);
      OrderSend(Symbol(), OP_SELL, lots, Bid, 3, Bid + (stop * Point), Bid - (limite * Point), "Ordre Vente Stop - High-Low EA", magic, 0, Red);
      reperage = true;
    }
    if (date != TimeDay(Time[0]))
    {
      reperage = false;
      //Annuler();
    }
    
  }
//+------------------------------------------------------------------+

void Affichage(string nom, string nom2, double niveau, string text, color couleur)
{
   ObjectDelete(nom);
   ObjectDelete(nom2);
   ObjectCreate(nom,OBJ_HLINE,0,0,niveau,0,0,0,0);
   ObjectSet(nom,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(nom, OBJPROP_COLOR, couleur);
   ObjectCreate(nom2,OBJ_TEXT,0,Time[0],niveau);
   ObjectSetText(nom2, text +Day()+"/"+Month()+"/"+Year(), 12, "Times New Roman", couleur);
}

void Annuler()
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderMagicNumber() == magic)
         {
            if (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
               OrderDelete(OrderTicket());
         }
      }
   }
}
