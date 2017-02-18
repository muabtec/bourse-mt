//+------------------------------------------------------------------+
//|                                             maxmoyChandelier.mq4 |
//|                                                          muabtec |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern string paire="EURUSD";
extern int tframe=PERIOD_M1;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int bars=Bars,i;
   double chandelier, sommechandelier, maxchandelier, moychandelier;
   for(i=0; i<bars; i++)
   {
      chandelier=iHigh(paire,tframe,i)-iLow(paire,tframe,i);
      sommechandelier+= chandelier;
      if(maxchandelier<chandelier)
      {
         maxchandelier= chandelier;
      }
   }
   moychandelier= sommechandelier/bars;
   Alert ("maxchandelier= " + maxchandelier + " moychandelier= " + moychandelier);
  }
//+------------------------------------------------------------------+
