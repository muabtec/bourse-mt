//+------------------------------------------------------------------+
//|                                                        Volat.mq4 |
//|                                                          muabtec |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_level1     30.0
#property indicator_level2     70.0

extern color Color = Green;
extern color ColorMy = Blue;
extern int longueur = 10;
double BufChandelier[], BufChandelierMoy[], maxchandeliermoy=0, minchandeliermoy=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   //--- indicator buffers mapping
   //--------------------------------------------------------------------
   SetIndexBuffer(0,BufChandelier);         // Assigning an array to a buffer
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2,Color);// Line style
   //--------------------------------------------------------------------
   SetIndexBuffer(1,BufChandelierMoy);         // Assigning an array to a buffer
   SetIndexStyle (1,DRAW_LINE,STYLE_SOLID,1,ColorMy);// Line style
   
   Affichage("axe_0", 0, "axe_0", STYLE_SOLID, Silver);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   //---
   int bars=Bars,n;                // Number of counted bars
   double sommechandelier, moychandelier;
//--------------------------------------------------------------------
   //Counted_bars=IndicatorCounted(); // Number of counted bars
   n=bars-longueur-1;
   while(n>=0)
   //for(n=0;n<bars;n++) // Loop of summing values
   {
      sommechandelier=0;
      for(int i=n; i<n+longueur; i++)
      {
         sommechandelier+=iClose(NULL,0,i)-iOpen(NULL,0,i);
         
      }
      
      moychandelier= sommechandelier/longueur;
      if(moychandelier>maxchandeliermoy)
         maxchandeliermoy=moychandelier;
      if(moychandelier<minchandeliermoy)
         minchandeliermoy=moychandelier;
      BufChandelier[n]=moychandelier;//iHigh(NULL,0,n)-iLow(NULL,0,n);
      //BufChandelierMoy[n]=moychandelier;
      n--;
   }
   
   Affichage("axe_100", maxchandeliermoy, "axe_100", STYLE_SOLID, Silver);
   Affichage("axe_61", maxchandeliermoy*61.8/100, "axe_61", STYLE_SOLID, Silver);
   Affichage("axe_50", maxchandeliermoy/2, "axe_50", STYLE_SOLID, Silver);
   Affichage("axe_38", maxchandeliermoy*38.2/100, "axe_38", STYLE_SOLID, Silver);
   Affichage("axe_23", maxchandeliermoy*23.6/100, "axe_23", STYLE_SOLID, Silver);
   
   Affichage("axe_-100", minchandeliermoy, "axe_-100", STYLE_SOLID, Silver);
   Affichage("axe_-61", minchandeliermoy*61.8/100, "axe_-61", STYLE_SOLID, Silver);
   Affichage("axe_-50", minchandeliermoy/2, "axe_-50", STYLE_SOLID, Silver);
   Affichage("axe_-38", minchandeliermoy*38.2/100, "axe_-38", STYLE_SOLID, Silver);
   Affichage("axe_-23", minchandeliermoy*23.6/100, "axe_-23", STYLE_SOLID, Silver);
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void Affichage(string nom, double niveau, string text,double style, color couleur)
{
   ObjectDelete(nom);
   ObjectCreate(nom,OBJ_HLINE,0,0,niveau,0,0,0,0);
   ObjectSet(nom,OBJPROP_STYLE,style);
   ObjectSet(nom, OBJPROP_COLOR, couleur);
}