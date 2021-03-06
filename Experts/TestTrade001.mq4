//+------------------------------------------------------------------+
//|                                                 TestTrade001.mq4 |
//|                                                          muabtec |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern string paire="EURUSD";
extern int tframe=PERIOD_H1;
extern double lots = 0.02;
//extern int limite = 50;


int magic = MathRand(), nombrelots=1, nombrelotsinverse=2,operation=1, sommelotsachat=0, sommelotsvente=0, limite;
double prixin, prixinverse, prixout, prixout2, prixoutinverse, moyChandelier, minmoychandelier;
bool etatoperation=true, premierout=false, annuler=false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   switch (tframe)
   {
   case PERIOD_M1: limite = 40; break;
   case PERIOD_M5: limite = 80; break;
   case PERIOD_M15: limite = 120; break;
   case PERIOD_M30: limite = 200; break;
   case PERIOD_H1: limite = 280; break;
   case PERIOD_H4: limite = 600; break;
   case PERIOD_D1: limite =1200; break;
   case PERIOD_W1: limite = 6000; break;
   case PERIOD_MN1: limite = 14000; break;
   }
   minmoychandelier=limite*Point/2;
   moyChandelier=MoyChandelier(paire, tframe, 1, 10);
   if (operation==1 && moyChandelier > minmoychandelier)
   {
      OrderSend(paire, OP_BUY, lots, Ask, 3, 0, 0, "Ordre Achat", magic, 0, Green);
      prixin = Ask;
      prixinverse = Ask - (limite * Point)/3;
      prixout = Ask + (limite * Point);
      prixout2 = Ask + 2*(limite * Point)/3;
      prixoutinverse = Ask - (limite * Point);
      
      operation=2;
      
      Affichage("prixin", prixin, "prixin", Blue);
      Affichage("prixinverse", prixinverse, "prixinverse", Red);
      Affichage("prixout", prixout, "prixout", Green);
      Affichage("prixout2", prixout2, "prixout2", Green);
      Affichage("prixoutinverse", prixoutinverse, "prixoutinverse", Green);
   }
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
   
   moyChandelier=MoyChandelier(paire, tframe, 1, 10);
   if(operation==1 && moyChandelier > minmoychandelier)
   {
      OrderSend(paire, OP_BUY, lots, Ask, 3, 0, 0, "Ordre Achat", magic, 0, Green);
      prixin = Ask;
      prixinverse = Ask - (limite * Point)/3;
      prixout = Ask + (limite * Point);
      prixout2 = Ask + 2*(limite * Point)/3;
      prixoutinverse = Ask - (limite * Point);
      operation=2;
   }
   if (operation==2)
   {
      if (Bid>=prixout)
      {
         Annuler();
         //Alert("Annuler");
      }
      if(Bid<= prixinverse && etatoperation  && sommelotsachat<=8)
      {
         
         OrderSend(paire, OP_SELL, nombrelotsinverse*lots, Bid, 3, 0, 0, "Ordre Vente", magic, 0, Red);
         sommelotsvente += nombrelotsinverse;
         nombrelotsinverse = sommelotsvente*3;
         etatoperation=false;
         premierout=false;
      }
      if(Ask<= prixoutinverse)
      {
         Annuler();
         //Alert("Annuler");
      }
      if(Ask>= prixin && !etatoperation && sommelotsachat<16)
      {
         sommelotsachat += nombrelots;
         nombrelots = sommelotsachat*3;
         OrderSend(paire, OP_BUY, nombrelots*lots, Ask, 3, 0, 0, "Ordre Achat", magic, 0, Green);
         etatoperation=true;
      }
      if (Bid>=prixout2 && !premierout)
      {
         Annuler();
         //Alert("Annuler");
      }
   }
   if(operation==3)
   {
      Annuler();
   }
}
//+------------------------------------------------------------------+

void Affichage(string nom, double niveau, string text, color couleur)
{
   ObjectDelete(nom);
   ObjectCreate(nom,OBJ_HLINE,0,0,niveau,0,0,0,0);
   ObjectSet(nom,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(nom, OBJPROP_COLOR, couleur);
}

double MoyChandelier(const string symbol, int timeframe, int shift, int longueur)
{
   double sommechandelier, moychandelier;
   for(int i=shift; i<shift+longueur; i++)
   {
      sommechandelier+=iHigh(paire,tframe,i)-iLow(paire,tframe,i);
      
   }
   moychandelier= sommechandelier/longueur;
   return moychandelier;
}


//+------------------------------------------------------------------+
void Annuler()
{
   Print(" Annuler : Début annuler");
   int Ticket;           // Order ticket
   double Lot;
   int nombreOrdreAchat = 0;
   int nombreOrdreVente = 0;
   int nmbrorders;
   bool close;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderMagicNumber() == magic)
         {
            if (OrderType()==OP_SELL)
            {
               //OrderDelete(OrderTicket());
               nombreOrdreVente++;
               Ticket=OrderTicket();           // Order ticket
               Lot=OrderLots();   
               close = OrderClose(Ticket,Lot,Ask,2);
               if (close)
               {
                  Print(" Annuler : annuler Ticket = " + Ticket + " Ask = " + Ask);
                  //Alert(" Annuler : annuler Ticket = " + Ticket + " Ask = " + Ask);
                  
               }
               else
               {
                  Print(" Annuler : annuler Ticket erreur= " + Ticket + " Ask = " + Ask);
                  //Alert(" Annuler : annuler Ticket erreur= " + Ticket + " Ask = " + Ask);
               }
            }
            if (OrderType()==OP_BUY)
            {
               //OrderDelete(OrderTicket());
               nombreOrdreAchat++;
               Ticket=OrderTicket();           // Order ticket
               Lot=OrderLots();   
               close = OrderClose(Ticket,Lot,Bid,2);
               if (close)
               {
                  Print(" Annuler : annuler Ticket = " + Ticket + " Bid = " + Bid);
                  //Alert(" Annuler : annuler Ticket erreur= " + Ticket + " Bid = " + Bid);
               }
               else
               {
                  Print(" Annuler : annuler Ticket erreur= " + Ticket + " Bid = " + Bid);
                  //Alert(" Annuler : annuler Ticket erreur= " + Ticket + " Bid = " + Bid);
               }
               //Print(" Annuler : annuler Ticket = " + Ticket + " Ask = " + Ask);
            }
         }
      }
   }
   nmbrorders=OrdersTotal();
   if(nmbrorders==0)
   {
      operation=1;
   }
   else
   {
      operation=3;
   }
   //annuler=true;
   Print(" Annuler : Fin annuler nombreOrdreAchat = " + nombreOrdreAchat + " nombreOrdreVente = " + nombreOrdreVente);
   //Alert(" Annuler : Fin annuler nombreOrdreAchat = " + nombreOrdreAchat + " nombreOrdreVente = " + nombreOrdreVente);
}
