# Architecture

## Overview

Market Dashboard is a **static site** — there is no server, no database, and no runtime API calls
from the browser. All market data is pre-computed by a Python script and written to flat JSON files
and PNG charts. The browser reads those files at load time.

This design makes the site fast, free to host (GitHub Pages), and trivially cacheable.

---

## Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│  Data Sources                                                    │
│  Yahoo Finance (yfinance)  +  investpy (economic calendar)       │
└────────────────────────┬─────────────────────────────────────────┘
                         │  HTTP (Python, at build time)
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│  scripts/build_data.py                                           │
│  - Fetches OHLCV data for ~130 ETFs                              │
│  - Computes 1d / 1w / 1m / 3m / 6m / 1y / YTD returns           │
│  - Renders sparkline PNG charts via matplotlib                   │
│  - Writes data/snapshot.json, data/events.json, data/meta.json  │
│  - Writes data/charts/<TICKER>.png                               │
└────────────────────────┬─────────────────────────────────────────┘
                         │  file writes
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│  data/  (gitignored locally; force-committed by CI)              │
│  ├── snapshot.json     # ETF returns + metadata                  │
│  ├── events.json       # Upcoming economic events                │
│  ├── meta.json         # Build timestamp, data freshness         │
│  └── charts/*.png      # Sparkline chart per ticker              │
└────────────────────────┬─────────────────────────────────────────┘
                         │  served as static files
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│  index.html  (vanilla JS + CSS, no build step)                   │
│  - Fetches JSON on load (fetch API)                              │
│  - Renders sortable tables, heat-map cells, chart images         │
│  - Hosted on GitHub Pages                                        │
└──────────────────────────────────────────────────────────────────┘
```

---

## Key Files

| Path | Purpose |
|------|---------|
| `index.html` | Entire frontend — HTML, CSS, JS in one file |
| `scripts/build_data.py` | Data pipeline (fetch → transform → write) |
| `scripts/setup_cron.sh` | One-time local WSL cron installer |
| `scripts/bootstrap.sh` | One-command dev setup (`make setup`) |
| `Makefile` | Developer task runner (setup / refresh / serve / clean) |
| `requirements.txt` | Python dependencies |
| `data/snapshot.json` | Generated: ETF return table |
| `data/events.json` | Generated: economic calendar |
| `data/meta.json` | Generated: build metadata / freshness stamp |
| `data/charts/*.png` | Generated: sparkline charts |
| `.github/workflows/refresh_data.yml` | Daily data refresh on GitHub Actions |
| `.github/workflows/ci.yml` | Smoke-test CI (push / PR) |

---

## Scheduling Options

| Mode | Trigger | How |
|------|---------|-----|
| GitHub Actions (production) | Cron Mon–Fri 16:30 ET | `.github/workflows/refresh_data.yml` |
| Local WSL (dev) | Cron Mon–Fri 17:30 local | `scripts/setup_cron.sh` (one-time setup) |
| Manual | Any time | `make refresh` or workflow_dispatch in Actions UI |

---

## Failure Modes

| Failure | Behaviour | Recovery |
|---------|-----------|----------|
| Yahoo Finance rate-limit / outage | `build_data.py` logs warning, writes partial data or exits non-zero | CI retries once (see `ci.yml`); last good data stays on Pages |
| investpy calendar error | Calendar section skipped; rest of data written | Acceptable degradation (see ADR-004) |
| GitHub Actions outage | No data commit that day | Manual workflow_dispatch when service resumes |
| Stale data displayed | `meta.json` freshness timestamp is shown in UI | User triggers manual refresh |
