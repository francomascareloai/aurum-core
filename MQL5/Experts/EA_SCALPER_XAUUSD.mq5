//+------------------------------------------------------------------+
//|                                            EA_SCALPER_XAUUSD.mq5 |
//|                                  EA_SCALPER_XAUUSD - CORE (DEMO) |
//+------------------------------------------------------------------+
#property copyright "Franco"
#property version   "0.1"
#property strict

/*
   CORE (DEMO) EDITION
   -------------------
   This EA is intentionally simplified for study and demonstration.

   Trading restrictions: see ../../../../TRADING_RESTRICTIONS.md

   Notes:
   - No proprietary "edge" logic is included here.
   - This EA is NOT intended for production use.
*/

#include <Trade/Trade.mqh>

input group "=== CORE (DEMO) Settings ==="
input int      InpMagicNumber      = 123456;
input double   InpLots             = 0.01;
input int      InpSlippagePoints   = 30;
input int      InpMaxSpreadPoints  = 40;
input bool     InpAllowTrading     = false; // Safety default: OFF

input group "=== Strategy (DEMO) ==="
input ENUM_TIMEFRAMES InpTf        = PERIOD_M5;
input int      InpFastMaPeriod     = 20;
input int      InpSlowMaPeriod     = 50;
input int      InpMaShift          = 0;
input ENUM_MA_METHOD InpMaMethod   = MODE_EMA;
input ENUM_APPLIED_PRICE InpPrice  = PRICE_CLOSE;

//--- Globals
CTrade g_trade;
int g_fast_ma_handle = INVALID_HANDLE;
int g_slow_ma_handle = INVALID_HANDLE;
datetime g_last_bar_time = 0;

static bool SpreadOk(const string symbol, const int max_spread_points)
{
   const int spread_points = (int)SymbolInfoInteger(symbol, SYMBOL_SPREAD);
   return (spread_points >= 0 && spread_points <= max_spread_points);
}

static bool IsNewBar(const string symbol, const ENUM_TIMEFRAMES tf)
{
   datetime t = iTime(symbol, tf, 0);
   if(t == 0) return false;
   if(t != g_last_bar_time)
   {
      g_last_bar_time = t;
      return true;
   }
   return false;
}

static void CloseAllPositionsForThisEA(const string symbol, const long magic)
{
   // Minimal, explicit: close only positions matching symbol+magic
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      const ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket))
         continue;

      if(PositionGetString(POSITION_SYMBOL) != symbol)
         continue;

      if(PositionGetInteger(POSITION_MAGIC) != magic)
         continue;

      g_trade.PositionClose(ticket);
   }
}

int OnInit()
{
   g_trade.SetExpertMagicNumber(InpMagicNumber);
   g_trade.SetDeviationInPoints(InpSlippagePoints);

   g_fast_ma_handle = iMA(_Symbol, InpTf, InpFastMaPeriod, InpMaShift, InpMaMethod, InpPrice);
   g_slow_ma_handle = iMA(_Symbol, InpTf, InpSlowMaPeriod, InpMaShift, InpMaMethod, InpPrice);

   if(g_fast_ma_handle == INVALID_HANDLE || g_slow_ma_handle == INVALID_HANDLE)
   {
      Print("CORE(DEMO): Failed to create MA handles");
      return INIT_FAILED;
   }

   Print("CORE(DEMO) EA initialized. Trading enabled? ", InpAllowTrading ? "YES" : "NO");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(g_fast_ma_handle != INVALID_HANDLE) IndicatorRelease(g_fast_ma_handle);
   if(g_slow_ma_handle != INVALID_HANDLE) IndicatorRelease(g_slow_ma_handle);

   // Safety: flatten on remove/close
   if(reason == REASON_REMOVE || reason == REASON_CLOSE || reason == REASON_ACCOUNT || reason == REASON_PROGRAM)
      CloseAllPositionsForThisEA(_Symbol, InpMagicNumber);
}

void OnTick()
{
   // Safety default: disabled
   if(!InpAllowTrading) return;

   if(!SpreadOk(_Symbol, InpMaxSpreadPoints)) return;

   if(!IsNewBar(_Symbol, InpTf)) return;

   // Only one position at a time for demo
   for(int i = 0; i < PositionsTotal(); i++)
   {
      const ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket))
         continue;
      if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
         return;
   }

   double fast_buf[2];
   double slow_buf[2];

   if(CopyBuffer(g_fast_ma_handle, 0, 0, 2, fast_buf) != 2) return;
   if(CopyBuffer(g_slow_ma_handle, 0, 0, 2, slow_buf) != 2) return;

   const bool cross_up = (fast_buf[1] <= slow_buf[1]) && (fast_buf[0] > slow_buf[0]);
   const bool cross_dn = (fast_buf[1] >= slow_buf[1]) && (fast_buf[0] < slow_buf[0]);

   if(cross_up)
   {
      g_trade.Buy(InpLots, _Symbol);
   }
   else if(cross_dn)
   {
      g_trade.Sell(InpLots, _Symbol);
   }
}
