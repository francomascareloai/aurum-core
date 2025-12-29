//+------------------------------------------------------------------+
//|                                           AurumSpreadMonitor.mq5 |
//|                                          Aurum Core (Indicator) |
//+------------------------------------------------------------------+
#property copyright "Franco"
#property version   "0.1"
#property strict

/*
   CORE (DEMO) INDICATOR
   ---------------------
   Educational indicator: plots the *current* spread (in points) and a max threshold.

   Notes:
   - Spread is a live execution cost. Historical spread cannot be reconstructed from bar data.
   - This indicator therefore plots the *current* spread across the visible series.

   Restrictions: see ../../TRADING_RESTRICTIONS.md
*/

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2

#property indicator_label1  "Spread (points)"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

#property indicator_label2  "MaxSpread (points)"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_DOT
#property indicator_width2  1

input group "=== CORE (DEMO) Settings ==="
input int InpMaxSpreadPoints = 40;

double g_spread_buf[];
double g_max_buf[];

int OnInit()
{
   SetIndexBuffer(0, g_spread_buf, INDICATOR_DATA);
   SetIndexBuffer(1, g_max_buf, INDICATOR_DATA);

   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, 0);
   PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, 0);

   IndicatorSetString(INDICATOR_SHORTNAME, "AurumSpreadMonitor (CORE)");
   return(INIT_SUCCEEDED);
}

int OnCalculate(
   const int rates_total,
   const int prev_calculated,
   const datetime& time[],
   const double& open[],
   const double& high[],
   const double& low[],
   const double& close[],
   const long& tick_volume[],
   const long& volume[],
   const int& spread[])
{
   if(rates_total <= 0) return 0;

   const int current_spread_points = (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   const double spread_val = (current_spread_points >= 0) ? (double)current_spread_points : 0.0;
   const double max_val = (InpMaxSpreadPoints >= 0) ? (double)InpMaxSpreadPoints : 0.0;

   int start = prev_calculated;
   if(start < 0) start = 0;
   if(start > rates_total) start = rates_total;

   // Fill from the first not-yet-calculated bar to the end.
   for(int i = start; i < rates_total; i++)
   {
      g_spread_buf[i] = spread_val;
      g_max_buf[i] = max_val;
   }

   return(rates_total);
}
