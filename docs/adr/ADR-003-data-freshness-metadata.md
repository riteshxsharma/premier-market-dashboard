# ADR-003: Data freshness metadata via meta.json

**Status:** Accepted

---

## Context

Because the dashboard shows pre-computed data, the user cannot tell from the displayed
numbers alone whether the data is current or stale (e.g., if the nightly job failed or
if the user is running against old local data).

## Decision

`build_data.py` writes a `data/meta.json` file alongside the data files. It contains:

```json
{
  "built_at": "2026-03-02T20:31:00+00:00",
  "market_date": "2026-03-02",
  "source": "Yahoo Finance / investpy"
}
```

`index.html` fetches `meta.json` at load time and displays the `built_at` timestamp
in the page header (e.g., "Data as of 2026-03-02 20:31 UTC").

This gives the user immediate visibility into data age without requiring server-side logic.

## Consequences

**Positive:**
- Zero cost: one extra small JSON file.
- Works with the static-site architecture — no server needed.
- Helps users detect stale data (e.g., if CI job failed on a given day).

**Negative:**
- `built_at` reflects build time, not market-data time; if yfinance is lagged, the
  dashboard may show a "fresh" timestamp but slightly old closing prices.
- Requires the frontend to handle the case where `meta.json` is missing (graceful fallback).

## Alternatives Considered

| Alternative | Why rejected |
|-------------|-------------|
| Embed timestamp in `snapshot.json` | Less discoverable; conflates data with metadata |
| Show no timestamp | User can't detect stale data at a glance |
| Server-side staleness check | Requires a server; contradicts ADR-001 |
