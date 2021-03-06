//+------------------------------------------------------------------+
//|                                                   IndTest001.mq4 |
//|                                                          muabtec |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window


bool ordreachat=false;
bool ordrevente=false;
int operationTenkanKijun;
int operationKumo;
int operationBarTenkanKijun;
bool first=true;

double achatprix, aretachatprix, venteprix, aretventeprix;
int achat, aretachat, vente, aretvente;

double EtatOperation[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,EtatOperation);
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
   int i;
   ArraySetAsSeries(EtatOperation,false);
   
   for (i=rates_total-200; i>=0; i--)
   {
      operationTenkanKijun = OperationTenkanKijun(NULL, 0,i);
      operationKumo = OperationKumo(NULL, 0,i);
      operationBarTenkanKijun = OperationBarTenkanKijun(NULL, 0,i);
      if ( operationKumo == 1 && ordrevente)
      {
         EtatOperation[i]=4;
         ordrevente=false;
      }
      else if (operationKumo == 2 && ordreachat)
      {
         EtatOperation[i]=2;
         ordreachat=false;
      }
      else if (operationTenkanKijun <= 2 && operationKumo == 1 && operationBarTenkanKijun == 1 && !ordreachat)
      {
         EtatOperation[i]=1;
         ordreachat=true;
      }
      else if (operationTenkanKijun >= 2 && operationKumo == 2  && operationBarTenkanKijun == 2 && !ordreachat && !ordrevente)
      {
         EtatOperation[i]=3;
         ordrevente=true;
      }
       else
      {
         EtatOperation[i]=0;
      }
   }
   if (first)
   {
      i=rates_total-200;
      while(i>=0)
      {
         if (EtatOperation[i]==1)
         {
            achatprix = iOpen(NULL, NULL,i);
            achat = i;
         }
         if (EtatOperation[i]==2)
         {
            aretachatprix = iOpen(NULL, NULL,i);
            aretachat = i;
            RectangleCreate(0,"Achat"  + i, 0, Time[achat], achatprix, Time[aretachat], aretachatprix,Lime);
         }
         if (EtatOperation[i]==3)
         {
            venteprix = iOpen(NULL, NULL,i);
            vente = i;
         }
         if (EtatOperation[i]==4)
         {
            aretventeprix = iOpen(NULL, NULL,i);
            aretvente = i;
            RectangleCreate(0,"Vente"  + i, 0, Time[vente], venteprix, Time[aretvente], aretventeprix,Orange);
         }
         i--;
      }
      first=false;
   }
   else
   {
      if (EtatOperation[0]==1)
      {
         achatprix = iOpen(NULL, NULL,0);
         achat = 0;
      }
      else
      {
         achat++;
      }
      if (EtatOperation[0]==2)
      {
         aretachatprix = iOpen(NULL, NULL,0);
         RectangleCreate(0,"Achat"  + rates_total, 0, Time[achat], achatprix, Time[0], aretachatprix,Lime);
      }
      if (EtatOperation[0]==3)
      {
         venteprix = iOpen(NULL, NULL,0);
         vente = 0;
      }
      else
      {
         vente++;
      }
      if (EtatOperation[0]==4)
      {
         aretventeprix = iOpen(NULL, NULL,0);
         RectangleCreate(0,"Vente"  + i, 0, Time[vente], venteprix, Time[0], aretventeprix,Orange);
      }
   }
   /*for (i=rates_total-200; i>=0; i--)
   {
      if (EtatOperation[i]==1)
      {
         Affichage("Achat" + i, "AchatText"  + i, Time[i], iOpen(NULL, NULL,i), "Début achat", Green);
      }
      if (EtatOperation[i]==2)
      {
         Affichage("AretAchat"  + i, "AretAchatText"  + i, Time[i], iOpen(NULL, NULL,i), "Aret achat", Lime);
      }
      if (EtatOperation[i]==3)
      {
          Affichage("Vente"  + i, "VenteText"  + i, Time[i], iOpen(NULL, NULL,i), "Début vente", Red);
      }
      if (EtatOperation[i]==4)
      {
         Affichage("AretVente"  + i, "AretVenteText"  + i, Time[i], iOpen(NULL, NULL,i), "Aret vente", OrangeRed);
      }
      
      
   }*/
   
   //--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void Affichage(string nom, string nom2, datetime time, double niveau, string text, color couleur)
{
   //ObjectDelete(nom);
   //ObjectDelete(nom2);
   ObjectCreate(nom,OBJ_ARROW,0,time,niveau);
   ObjectSet(nom,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(nom, OBJPROP_COLOR, couleur);
   //ObjectCreate(nom2,OBJ_TEXT,0,Time[0],niveau);
   //ObjectSetText(nom2, text, couleur);
}

bool RectangleCreate(const long            chart_ID=0,        // chart's ID
                     const string          name="Rectangle",  // rectangle name
                     const int             sub_window=0,      // subwindow index 
                     datetime              time1=0,           // first point time
                     double                price1=0,          // first point price
                     datetime              time2=0,           // second point time
                     double                price2=0,          // second point price
                     const color           clr=clrRed,        // rectangle color
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines
                     const int             width=1,           // width of rectangle lines
                     const bool            fill=false,        // filling rectangle with color
                     const bool            back=false,        // in the background
                     const bool            selection=true,    // highlight to move
                     const bool            hidden=true,       // hidden in the object list
                     const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeRectangleEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- create a rectangle by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- set rectangle color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the style of rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set width of the rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the rectangle for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check the values of rectangle's anchor points and set default    |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
void ChangeRectangleEmptyPoints(datetime &time1,double &price1,
                                datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, move it 300 points lower than the first one
   if(!price2)
      price2=price1-300*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
  }


int OperationKumo(const string symbol, int timeframe, int shift)
{
   double senkouspana=iIchimoku(symbol,timeframe,9,26,52,MODE_SENKOUSPANA,shift);
   double senkouspanb=iIchimoku(symbol,timeframe,9,26,52,MODE_SENKOUSPANB,shift);
   double barclose = iOpen(symbol, timeframe, shift);
   if (barclose> senkouspana && barclose> senkouspanb)
   {
      return 1;
   }
   else if (barclose< senkouspana && barclose< senkouspanb)
   {
      return 2;
   }
   return 0;
}

int OperationTenkanKijun(const string symbol, int timeframe, int shift)
{
   double tenkansen=iIchimoku(symbol,timeframe,9,26,52,MODE_TENKANSEN,shift);
   double kijunsen=iIchimoku(symbol,timeframe,9,26,52,MODE_KIJUNSEN,shift);
   
   if (tenkansen > kijunsen)
   {
      return 1;
   }
   else if (tenkansen < kijunsen)
   {
      return 3;
   }
   return 2;
}

int OperationBarTenkanKijun(const string symbol, int timeframe, int shift)
{
   
   double tenkansen=iIchimoku(symbol,timeframe,9,26,52,MODE_TENKANSEN,shift);
   double kijunsen=iIchimoku(symbol,timeframe,9,26,52,MODE_KIJUNSEN,shift);
   double barclose = iOpen(symbol, timeframe, shift);
   if (barclose > tenkansen && barclose > kijunsen)
   {
      return 1;
   }
   else if (barclose < tenkansen && barclose < kijunsen)
   {
      return 2;
   }
   return 0;
}
