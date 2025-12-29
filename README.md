# Aurum Core

Public **CORE** repository for study, analysis, and demonstration.

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

## Quickstart (study/demo)

1) Open `MQL5/Experts/AurumCore.mq5` in MetaEditor.
2) Compile.
3) Attach the EA to a chart.
4) Keep `InpAllowTrading=false` by default.
   - If you want to observe order flow mechanics in a local sandbox, you can toggle it to `true`.

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

## Feature matrix (CORE vs PREMIUM)

Legend:
- ✅ = included
- ❌ = not included
- ⚠️ = partial / simplified demo

| Area | CORE (public demo) | PREMIUM (private production) |
|---|---:|---:|
| MQL5 EA source | ✅ | ✅ |
| Minimal demo strategy (EMA cross) | ✅ | ❌ |
| Multi-strategy routing/selection | ❌ | ✅ |
| Advanced confluence/SMC-style logic | ❌ | ✅ |
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
| Live trading allowed | ❌ | ✅ *(subject to your private ops + compliance)* |

Notes:
- CORE is intentionally constrained so the public code stays reviewable and does not ship operational “go-live” capability.
- PREMIUM details, datasets, and operational infra are intentionally private.

## CORE vs PREMIUM (high-level)

This repository (**CORE**) is the public demo/study layer.

The full production system (**PREMIUM**, private) includes components such as:

- Advanced strategy logic, routing/selection, and execution modeling
- Risk management + prop-firm compliance enforcement
- Backtesting/optimization infrastructure (WFA, stress, overfit controls)
- Operational tooling (monitoring, configs, incident playbooks)
- ML experiments/models (where applicable)

See `docs/PREMIUM_NOTE.md` for a sanitized overview.

## Contents

- `MQL5/Experts/AurumCore.mq5` — demo EA source

## Notes

- Python/Nautilus layer is kept private (PREMIUM).
- No market data is redistributed in this repository.
