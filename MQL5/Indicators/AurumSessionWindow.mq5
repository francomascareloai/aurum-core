//+------------------------------------------------------------------+
//|                                            AurumSessionWindow.mq5|
//|                                          Aurum Core (Indicator) |
//+------------------------------------------------------------------+
#property copyright "Franco"
#property version   "0.1"
#property strict

/*
   CORE (DEMO) INDICATOR
   ---------------------
   Educational indicator: marks a time window on the chart using two vertical lines per day.

   This is a visual tool to help study time-based discipline.

   Notes:
   - Uses the *broker/server* time (TimeCurrent()).
   - In production you would use a robust timezone contract; CORE stays minimal.

   Restrictions: see ../../TRADING_RESTRICTIONS.md
*/

#property indicator_chart_window

input group "=== CORE (DEMO) Settings ==="
input int InpStartHour = 8;   // server time
input int InpStartMin  = 0;
input int InpEndHour   = 17;  // server time
input int InpEndMin    = 0;
input int InpDaysBack  = 10;  // how many days to draw

static string Prefix()
{
   return "AurumSessionWindow_CORE_";
}

static void DrawVLine(const string name, const datetime t, const color c)
{
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_VLINE, 0, t, 0);

   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
}

static datetime DayStart(const datetime t)
{
   MqlDateTime dt;
   TimeToStruct(t, dt);
   dt.hour = 0;
   dt.min = 0;
   dt.sec = 0;
   return StructToTime(dt);
}

static datetime AddMinutes(const datetime t, const int minutes)
{
   return (datetime)((long)t + (long)minutes * 60);
}

int OnInit()
{
   IndicatorSetString(INDICATOR_SHORTNAME, "AurumSessionWindow (CORE)");
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
   const datetime now = TimeCurrent();
   const datetime today0 = DayStart(now);

   const int start_min = InpStartHour * 60 + InpStartMin;
   const int end_min = InpEndHour * 60 + InpEndMin;

   // Defensive clamp for demo.
   const int start_min_clamped = (start_min < 0) ? 0 : ((start_min > 24*60) ? 24*60 : start_min);
   const int end_min_clamped = (end_min < 0) ? 0 : ((end_min > 24*60) ? 24*60 : end_min);

   for(int d = 0; d < InpDaysBack; d++)
   {
      const datetime day = (datetime)((long)today0 - (long)d * 86400);
      const datetime t_start = AddMinutes(day, start_min_clamped);
      const datetime t_end = AddMinutes(day, end_min_clamped);

      const string n1 = Prefix() + IntegerToString(d) + "_start";
      const string n2 = Prefix() + IntegerToString(d) + "_end";

      DrawVLine(n1, t_start, clrDodgerBlue);
      DrawVLine(n2, t_end, clrTomato);
   }

   return rates_total;
}
