# Market Dashboard

A static ETF market dashboard with daily auto-refresh via GitHub Actions, hosted on GitHub Pages.
No server, no database, no API keys in the browser.

---

## What it is

A single-page dashboard that shows:

- **ETF return table** — ~130 ETFs across US equities, sectors, factors, international, commodities,
  crypto, and fixed income. Sortable by 1d / 1w / 1m / 3m / 6m / 1y / YTD return with heat-map coloring.
- **Sparkline charts** — 6-month price chart per ticker.
- **Economic calendar** — upcoming macro events with consensus and prior readings.
- **Data freshness stamp** — timestamp of the last successful build shown in the header.

## Who it's for

Active investors and traders who want a quick daily overview of cross-asset momentum and sector
rotation without paying for a Bloomberg terminal or wiring up a live-data API.

---

## Quickstart

```bash
git clone https://github.com/<your-username>/market_dashboard
cd market_dashboard
bash scripts/bootstrap.sh   # one command: creates venv, installs deps, fetches data
make serve                  # open http://localhost:8021
```

Or step by step:

```bash
make setup     # create .venv, pip install, first data fetch
make serve     # serve at http://localhost:8021
make refresh   # re-fetch data any time
make clean     # delete generated data (keeps data/.gitkeep)
make help      # list all targets
```

---

## Local auto-refresh (WSL)

Run once to install a weekday cron job that refreshes data at 17:30 local time:

```bash
bash scripts/setup_cron.sh
```

Check logs:

```bash
tail -f cron.log
```

---

## Repo structure

```
market_dashboard/
├── index.html                              # Static frontend (HTML + CSS + JS)
├── Makefile                                # Developer task runner
├── requirements.txt                        # Python dependencies
├── scripts/
│   ├── build_data.py                       # Data pipeline: fetch → transform → write
│   ├── bootstrap.sh                        # One-command setup wrapper
│   └── setup_cron.sh                       # One-time WSL cron installer
├── data/                                   # Generated (gitignored; CI force-adds)
│   ├── snapshot.json                       #   ETF returns
│   ├── events.json                         #   Economic calendar
│   ├── meta.json                           #   Build timestamp / freshness
│   └── charts/<TICKER>.png                 #   Sparkline charts
├── docs/
│   ├── ARCHITECTURE.md                     # System design overview
│   ├── ROADMAP.md                          # Planned improvements
│   └── adr/                               # Architecture Decision Records
│       ├── ADR-001-static-site-precomputed-data.md
│       ├── ADR-002-scheduling-local-cron.md
│       ├── ADR-003-data-freshness-metadata.md
│       └── ADR-004-fail-soft-builds.md
├── .github/workflows/
│   ├── refresh_data.yml                    # Daily data refresh (Mon–Fri 16:30 ET)
│   └── ci.yml                             # Smoke-test CI (push / PR)
└── .gitignore
```

---

## Architecture decisions

Key decisions are captured as ADRs in `docs/adr/`:

| ADR | Decision |
|-----|---------|
| [ADR-001](docs/adr/ADR-001-static-site-precomputed-data.md) | Static site + pre-computed data (no server) |
| [ADR-002](docs/adr/ADR-002-scheduling-local-cron.md) | Two-tier scheduling: GitHub Actions + local cron |
| [ADR-003](docs/adr/ADR-003-data-freshness-metadata.md) | `meta.json` for data freshness visibility |
| [ADR-004](docs/adr/ADR-004-fail-soft-builds.md) | Fail-soft builds — partial data over no data |

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full system design.

---

## Screenshot

_TODO: add screenshot_

---

## Roadmap

See [docs/ROADMAP.md](docs/ROADMAP.md) for planned improvements and milestones.

---

## Data sources

- **Prices / returns:** [yfinance](https://github.com/ranaroussi/yfinance) (Yahoo Finance)
- **Economic calendar:** [investpy](https://github.com/alvarob96/investpy)
- **Charts:** [matplotlib](https://matplotlib.org/)
