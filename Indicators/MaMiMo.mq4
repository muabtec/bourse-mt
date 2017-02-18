//+------------------------------------------------------------------+
//|                                                       MaMiMo.mq4 |
//|                                                          muabtec |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "muabtec"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3       // Number of buffers
#property indicator_color1 Blue     // Color of the 1st line
#property indicator_color2 Red      // Color of the 2nd line

extern int ParaBarres = 25;
extern color ColorMa = Green;
extern color ColorMi = Red;
extern color ColorMo = Blue;


bool reperage=false;
int nombrebarres;
double BufMax[],BufMin[], BufMoy[];
double tabmax[];
double tabmin[];
double tabmoy[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   nombrebarres=iBars(NULL,0);
   //--------------------------------------------------------------------
   SetIndexBuffer(0,BufMax);         // Assigning an array to a buffer
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2,ColorMa);// Line style
//--------------------------------------------------------------------
   SetIndexBuffer(1,BufMin);         // Assigning an array to a buffer
   SetIndexStyle (1,DRAW_LINE,STYLE_SOLID,1,ColorMi);// Line style
//--------------------------------------------------------------------
   SetIndexBuffer(2,BufMoy);         // Assigning an array to a buffer
   SetIndexStyle (2,DRAW_LINE,STYLE_SOLID,3);//,ColorMo);// Line style
//--------------------------------------------------------------------
   ArrayResize(tabmax,ParaBarres);
   ArrayResize(tabmin,ParaBarres);
   ArrayResize(tabmoy,ParaBarres);
   //SetIndexBuffer(0,tabmax);
   //SetIndexBuffer(0,tabmin);
   //SetIndexBuffer(0,tabmoy);
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
   int i,                           // Bar index
       n,                           // Formal parameter
       Counted_bars;                // Number of counted bars
   
//--------------------------------------------------------------------
   //Counted_bars=IndicatorCounted(); // Number of counted bars
   i=Bars-ParaBarres-1;           // Index of the first uncounted
   while(i>=0)                      // Loop for uncounted bars
   {
                           // Nulling at loop beginning
   for(n=i;n<=i+ParaBarres-1;n++) // Loop of summing values
      {
      tabmax[n-i]=iHigh(NULL,0,n);
      tabmin[n-i]=iLow(NULL,0,n);
      tabmoy[n-i]=(tabmax[n-i]+tabmin[n-i])/2;
     }
   BufMax[i]=MaxTab(tabmax);     // Value of 0 buffer on i bar
   BufMin[i]=MinTab(tabmin);     // Value of 1st buffer on i bar
   BufMoy[i]=MoyTab(tabmoy);
   
   i--;                          // Calculating index of the next bar
   }
   /*if (reperage == false){
      ArraySetAsSeries(tabmax,false);
      ArraySetAsSeries(tabmin,false);
      ArraySetAsSeries(tabmoy,false);
      for (int i=0; i<ParaBarres; i++)
      {
         tabmax[i]=High;
         tabmin[i]=Low;
         tabmoy[i]=(High+Low)/2;
      }
      
      nombrebarres = iBars(NULL,0);
      reperage = true;
   }
   if (bars != nombrebarres)
   {
      reperage = false;
   }*/
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

double MaxTab(double& tab[])
{
   
   double maxtab=0;
   for (int j=0; j<ParaBarres; j++)
      maxtab=MathMax(maxtab,tab[j]);
      
   return maxtab;
}

double MinTab(double& tab[])
{
   
   double mintab=99999;
   for (int j=0; j<ParaBarres; j++)
      mintab=MathMin(mintab,tab[j]);
      
   return mintab;
}

double MoyTab(double& tab[])
{
   
   double somme=0;
   for (int j=0; j<ParaBarres; j++)
      somme=somme+tab[j];
   double moyen=somme/ParaBarres;
   return moyen;
}