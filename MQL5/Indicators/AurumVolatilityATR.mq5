//+------------------------------------------------------------------+
//|                                           AurumVolatilityATR.mq5 |
//|                                          Aurum Core (Indicator) |
//+------------------------------------------------------------------+
#property copyright "Franco"
#property version   "0.1"
#property strict

/*
   CORE (DEMO) INDICATOR
   ---------------------
   Educational indicator: plots ATR (Average True Range) as a volatility proxy.

   Notes:
   - ATR helps visualize volatility regimes.
   - This is not a strategy by itself.

   Restrictions: see ../../TRADING_RESTRICTIONS.md
*/

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1

#property indicator_label1  "ATR"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrMediumSeaGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

input group "=== CORE (DEMO) Settings ==="
input int InpAtrPeriod = 14;

double g_atr_buf[];

static double TrueRange(const double high0, const double low0, const double close1)
{
   const double r1 = high0 - low0;
   const double r2 = MathAbs(high0 - close1);
   const double r3 = MathAbs(low0 - close1);
   return MathMax(r1, MathMax(r2, r3));
}

int OnInit()
{
   SetIndexBuffer(0, g_atr_buf, INDICATOR_DATA);
   IndicatorSetString(INDICATOR_SHORTNAME, "AurumVolatilityATR (CORE)");
   return INIT_SUCCEEDED;
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
   const int p = (InpAtrPeriod < 1) ? 1 : InpAtrPeriod;

   // Need at least 2 bars for TR.
   if(rates_total < 2)
   {
      g_atr_buf[0] = 0.0;
      return rates_total;
   }

   // Initialize on first run.
   int start = prev_calculated;
   if(start <= 1)
   {
      g_atr_buf[0] = 0.0;
      g_atr_buf[1] = TrueRange(high[1], low[1], close[0]);
      start = 2;
   }

   // Wilder's smoothing:
   // ATR[i] = (ATR[i-1]*(p-1) + TR[i]) / p
   for(int i = start; i < rates_total; i++)
   {
      const double tr = TrueRange(high[i], low[i], close[i-1]);
      const double prev = g_atr_buf[i-1];
      g_atr_buf[i] = (prev * (p - 1) + tr) / p;
   }

   return rates_total;
}
