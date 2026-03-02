# Roadmap

Planned improvements, grouped by milestone. Labels are suggested GitHub issue labels.

---

## Labels

| Label | Meaning |
|-------|---------|
| `enhancement` | New feature or improvement |
| `bug` | Something is broken |
| `dx` | Developer experience (tooling, docs, CI) |
| `data` | Data sourcing, freshness, accuracy |
| `ui` | Frontend / visual changes |
| `infra` | CI/CD, hosting, automation |
| `good first issue` | Small, well-scoped, beginner-friendly |

---

## Milestone 1 — Reliability (v0.2)

Focus: make the nightly data pipeline robust and observable.

### Issue 1: Add per-ticker retry with exponential back-off
**Labels:** `enhancement`, `data`
Currently a failed ticker fetch is silently skipped. Add up to 3 retries with
back-off so transient rate-limits are recovered automatically.

### Issue 2: Surface build warnings in the dashboard UI
**Labels:** `enhancement`, `ui`, `data`
`data/meta.json` already has a `warnings` field. Display a collapsible warning
banner in the dashboard when any tickers were skipped or sections failed.

### Issue 3: Alert on stale data (>24h old)
**Labels:** `enhancement`, `ui`
Highlight the freshness timestamp in red if `built_at` is more than 24 hours ago,
so the user immediately knows the nightly job failed.

### Issue 4: Validate JSON schema in CI
**Labels:** `dx`, `infra`
Add a post-build step in `ci.yml` that validates `snapshot.json`, `events.json`,
and `meta.json` against simple JSON schemas (jsonschema library) to catch data
contract regressions.

---

## Milestone 2 — UX Polish (v0.3)

Focus: make the dashboard more useful day-to-day.

### Issue 5: Persist column sort preference in localStorage
**Labels:** `enhancement`, `ui`, `good first issue`
Remember the user's last sort column and direction across page loads using
`localStorage`, so the dashboard opens in the user's preferred view.

### Issue 6: Add a "watchlist" filter
**Labels:** `enhancement`, `ui`
Allow users to pin a subset of tickers to a "watchlist" view at the top of the
table, stored in `localStorage`.

### Issue 7: Mobile-responsive layout
**Labels:** `enhancement`, `ui`
The table overflows on mobile. Implement a responsive layout that collapses less
important return columns on small screens.

### Issue 8: Dark mode toggle
**Labels:** `enhancement`, `ui`, `good first issue`
Add a dark/light mode toggle, respecting `prefers-color-scheme` by default and
storing the user's manual override in `localStorage`.

---

## Milestone 3 — Data Expansion (v0.4)

Focus: add more data sources and views.

### Issue 9: Add individual stock lookup
**Labels:** `enhancement`, `data`, `ui`
Allow the user to type any ticker symbol and fetch its return data on-demand,
without adding it to the nightly build list.

### Issue 10: Relative strength heatmap view
**Labels:** `enhancement`, `ui`
Add a calendar-style heatmap showing sector ETF returns across the past 12 months,
similar to a seasonal heatmap, to identify patterns.

### Issue 11: Add 52-week high/low proximity column
**Labels:** `enhancement`, `data`
Show each ETF's current price as a percentage of its 52-week high/low, giving a
quick read on momentum vs. mean-reversion opportunity.

### Issue 12: Support additional data sources (FRED, Quandl)
**Labels:** `enhancement`, `data`
Add macroeconomic indicators (e.g., yield curve, credit spreads) from FRED's
free API alongside the existing yfinance data.
