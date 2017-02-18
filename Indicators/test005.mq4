//+------------------------------------------------------------------+
//|                                                      test005.mq4 |
//|                                                          muabtec |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window


extern bool niveauxDimanche = 0;

int date;
double plusHaut;
double plusBas;
bool reperage=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
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
   int heure; // déclaration de nos variables
   int minute;
   int seconde;
   int jour;
   int mois;
   int annee; 
   heure= Hour();
   minute = Minute();
   seconde = Seconds();
   jour = Day(); // La fonction Day() a été décrite dans la première partie   de cet article
   mois = Month();
   annee = Year();
   Comment("Heure : "+heure+":"+minute+":"+seconde+" "+"Date :   "+jour+"/"+mois+"/"+annee);

//---
   if(niveauxDimanche == 0 && DayOfWeek() == 1){ // on n'utilise pas le dimanche et on est lundi
      plusHaut = iHigh(NULL, PERIOD_D1, 2);
      plusBas = iLow(NULL, PERIOD_D1, 2);
   }
   else { // on n'est pas lundi
      plusHaut = iHigh(NULL, PERIOD_D1, 1);
      plusBas = iLow(NULL, PERIOD_D1, 1);
   }
   
   ObjectCreate("NiveauPlusHaut",OBJ_HLINE,0,0,plusHaut,0,0,0,0);
   ObjectSet("NiveauPlusHaut",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet("NiveauPlusHaut", OBJPROP_COLOR, Blue);
   ObjectCreate("PlusHautText",OBJ_TEXT,0,Time[0],plusHaut);
   ObjectSetText("PlusHautText", "Plus haut pour le " +Day()+"/"+Month()+"/"+Year(), 12, "Times New Roman", Blue);
   
   ObjectCreate("NiveauPlusBas",OBJ_HLINE,0,0,plusBas,0,0,0,0);
   ObjectSet("NiveauPlusBas",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet("NiveauPlusBas", OBJPROP_COLOR, Red);
   ObjectCreate("PlusBasText",OBJ_TEXT,0,Time[0],plusBas);
   ObjectSetText("PlusBasText", "Plus bas pour le " +Day()+"/"+Month()+"/"+Year(), 12, "Times New Roman", Red);
   
   double tenkan_sen=iIchimoku(NULL,0,9,26,52,MODE_TENKANSEN,1);
   ObjectCreate("tenkan_sen",OBJ_HLINE,0,0,tenkan_sen,0,0,0,0);
   ObjectSet("tenkan_sen",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet("tenkan_sen", OBJPROP_COLOR, Indigo);


//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
