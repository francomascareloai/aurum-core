# PREMIUM note

This repository (**Aurum Core**) is published for **study, analysis, and demonstration only**.

## Why CORE is minimal

CORE intentionally contains only a small, auditable demo EA so that:

- The public code remains easy to review and learn from.
- We avoid redistributing datasets or operational infrastructure.
- Proprietary production logic and research stay private.

## What exists in PREMIUM (sanitized overview)

The private **PREMIUM** repository (`aurum-pro`) is the production codebase.

At a high level, PREMIUM typically contains modules such as:

- **Strategy layer**: multiple strategy variants, routing/selection, state management.
- **Execution layer**: execution adapters, costs/latency models, and operational wiring.
- **Risk & compliance**: drawdown tracking, prop-firm constraints, and safety gates.
- **Backtesting & optimization**: batch runners, parameter search, walk-forward validation, stress testing, overfit controls.
- **Operational tooling**: monitoring, runbooks, deployment/incident procedures.
- **ML experiments (optional)**: feature pipelines and model artifacts where applicable.

CORE does not include these production components.

## Where to read next

- Restrictions: `TRADING_RESTRICTIONS.md`
- Data policy: `DATA_SOURCES.md`
- Demo EA source: `MQL5/Experts/AurumCore.mq5`
