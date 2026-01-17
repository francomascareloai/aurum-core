# Aurum Core

Public **CORE** repository for study, analysis, and demonstration.

## Origin story (why this exists)

This project started as a practical, hands-on effort: reviewing and testing many “robots” and approaches to understand what is real vs. noise in live markets.

Over time, the production system evolved into something much larger than a public demo:

- It accumulated operational tooling, validation workflows, and safety constraints.
- It incorporated research and implementation details that are not appropriate to publish in full.
- It became “operationally sensitive” (easy to misuse or misrepresent if copied without context).

That is why the project is now split:

- **CORE (this repo):** a minimal, auditable demo for learning.
- **PREMIUM (private):** the production codebase and operational stack.

If you’re here to learn, CORE is intentionally kept small and readable.

## What this is

- A simplified **MQL5 demo EA** intended for educational purposes.
- A public snapshot that intentionally excludes proprietary production components.

## What this is NOT

- Not a production trading system.
- Not allowed for live/funded trading.
- Not allowed for broker-connected paper trading or any setup that mirrors live execution.

See:
- `TRADING_RESTRICTIONS.md`
- `DATA_SOURCES.md`

## Support development (PC/infra goal: US$ 3,000)

If you want to support development (new PC/infra + dedicated time), you can:

- GitHub Sponsors: https://github.com/sponsors/francomascareloai
- Telegram (private automation / partnerships): @francomascareloai

Support tiers are intended for educational content and engineering Q&A — not signals, not performance claims.

## How to read this repo

Start with these files (in order):

1) `TRADING_RESTRICTIONS.md` — non-negotiable usage restrictions.
2) `DATA_SOURCES.md` — dataset policy (no redistribution).
3) `MQL5/Experts/AurumCore.mq5` — the entire demo EA source.
4) `MQL5/Indicators/` — educational indicators (spread, session windows, volatility).
5) `docs/PREMIUM_NOTE.md` — sanitized overview of what exists privately.

## Quickstart (study/demo)

1) Open `MQL5/Experts/AurumCore.mq5` in MetaEditor.
2) Compile.
3) Attach the EA to a chart.
4) Keep `InpAllowTrading=false` by default.
   - If you want to observe order mechanics, do it **only** in a simulated environment (e.g., MT5 Strategy Tester) that does **not** connect to a broker or route orders. See `TRADING_RESTRICTIONS.md`.

Safety notes:
- This EA **closes its own positions on remove/close** (see `OnDeinit`).
- Uses `MagicNumber` to avoid touching other trades.

## What the demo EA actually implements

`AurumCore.mq5` intentionally keeps the logic minimal:

- Spread filter: blocks entries when spread exceeds `InpMaxSpreadPoints`.
- New-bar execution: evaluates signals only on a new bar for `InpTf`.
- Simple signal: EMA cross (`InpFastMaPeriod` vs `InpSlowMaPeriod`).
- Single-position rule: at most one position per symbol+magic.

This is meant to be understandable and auditable in one sitting.

## Educational indicators (MQL5)

CORE also ships small indicators that help visualize execution constraints and market conditions (without exposing any proprietary strategy logic):

- `MQL5/Indicators/AurumSpreadMonitor.mq5` — plots *current* spread (points) + a max threshold.
- `MQL5/Indicators/AurumSessionWindow.mq5` — draws a daily time window with vertical lines (server time).
- `MQL5/Indicators/AurumVolatilityATR.mq5` — plots ATR as a volatility proxy.

## Feature matrix (CORE vs PREMIUM)

Legend:
- ✅ = included
- ❌ = not included
- ⚠️ = partial / simplified demo

| Area | CORE (public demo) | PREMIUM (private production) |
|---|---:|---:|
| MQL5 EA source | ✅ | ✅ |
| Educational indicators (spread/session/ATR) | ✅ | ✅ |
| Minimal demo strategy (EMA cross) | ✅ | ❌ |
| Multi-strategy routing/selection | ❌ | ✅ |
| Advanced confluence / proprietary logic | ❌ | ✅ |
| News-aware gating / calendar | ❌ | ✅ |
| Risk management (prop-firm constraints, DD/HWM) | ❌ | ✅ |
| Time-gates / session rules | ❌ | ✅ |
| Slippage/commission/latency modeling | ❌ | ✅ |
| Backtesting engine + runners | ❌ | ✅ |
| Parameter search / optimization | ❌ | ✅ |
| Walk-forward analysis (WFA) | ❌ | ✅ |
| Stress testing / robustness checks | ❌ | ✅ |
| Overfit controls / validation tooling | ❌ | ✅ |
| ML experiments/models (optional) | ❌ | ✅ |
| Datasets redistributed | ❌ | ❌ |
| Live trading allowed | ❌ | ✅ *(private only, with ops controls)* |

Notes:
- CORE is intentionally constrained so the public code stays reviewable and does not ship operational “go-live” capability.
- PREMIUM details, datasets, and operational infra are intentionally private.

## Contributing / requests

This repo is intentionally narrow-scope. Contributions that fit well:

- New **educational indicators** (visualization, overlays, regime/volatility tools).
- Bugfixes and clarity improvements for CORE files.

Contributions that will not be accepted:

- Anything that enables broker-connected paper/live trading.
- Anything that attempts to bypass `TRADING_RESTRICTIONS.md`.
- Proprietary strategy logic from the PREMIUM system.

If you want to request an indicator (MQL5): open an issue with:

- Instrument (e.g., XAUUSD), timeframe, and example screenshots.
- What you want to visualize (not “the strategy”), plus acceptance criteria.

## Custom work (indicators / automation)

## Contact (preferred: Telegram)

- **Telegram (preferred):** check my Telegram in my GitHub profile / contact details.
- **Repo requests:** please open a GitHub Issue using the templates (recommended so requirements stay written).
- **Private / commercial:** for custom development, partnerships, or investor conversations, reach out on Telegram.

Notes:

- I don’t provide real-time support; async is best.
- No promises of profitability; discussions focus on engineering, risk, and testability.

From time to time, I also take on **custom development** (paid/private) such as:

- MQL5 indicators tailored to your workflow
- Automation of a **manual strategy you already trade**, based on your written rules

Important:

- Requests must be **well-specified** (inputs, outputs, constraints, test cases).
- Anything involving **broker-connected execution** or **live trading** is handled privately and is out of scope for this public CORE repository.
- No guarantees of profitability; engineering work focuses on correctness, safety, and testability.

To start: open an issue describing what you want built and what “done” means (recommended). If it’s private/commercial, you can also reach out on Telegram.

## Glossary (quick)

- **EA (Expert Advisor):** automated trading program for MetaTrader.
- **CORE:** public demo/study repository with minimal logic.
- **PREMIUM:** private production repository (full system + ops).
- **MagicNumber:** identifier used to tag orders/positions belonging to this EA.
- **Spread:** difference between bid and ask (cost); CORE can block entries above a limit.
- **Slippage:** difference between expected and actual fill price due to execution conditions.
- **Commission:** per-trade fee model (broker/venue dependent).
- **Latency:** execution delay that impacts fills and performance.
- **Tick vs Bar:** tick = every price update; bar = aggregated candle over a timeframe.
- **Timeframe (TF):** candle period (e.g., M5).
- **DD (Drawdown):** peak-to-trough equity decline.
- **HWM (High-Water Mark):** highest equity point used by some trailing DD rules.
- **WFA (Walk-Forward Analysis):** validate performance across rolling in-sample/out-of-sample windows.
- **Overfitting:** strategy fits historical noise and fails out-of-sample.
- **Prop firm constraints:** risk rules imposed by evaluation/funded accounts.
- **News gating:** reducing or blocking trading around scheduled high-impact news.

## Contents

- `MQL5/Experts/AurumCore.mq5` — demo EA source
- `MQL5/Indicators/` — educational indicators

## Notes

- Python/Nautilus layer is kept private (PREMIUM).
- No market data is redistributed in this repository.

## Contact (preferred: Telegram)

- Telegram: @francomascareloai
