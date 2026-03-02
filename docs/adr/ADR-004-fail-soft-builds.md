# ADR-004: Fail-soft builds — partial data is better than no data

**Status:** Accepted

---

## Context

`build_data.py` fetches data from two external sources: Yahoo Finance (via `yfinance`)
and investpy (economic calendar). Either source can fail transiently due to rate limits,
API changes, or network issues. A hard failure on one source should not block the other.

## Decision

The build script uses **fail-soft** error handling:

- If fetching a single ticker fails (e.g., 404 or rate-limit), the ticker is skipped
  and a warning is logged. The rest of the ETF table is still written.
- If the entire economic calendar fetch fails, `data/events.json` is written as an
  empty array `[]` and the error is logged. The main snapshot data is unaffected.
- The script exits with code `0` even on partial failures, so CI does not block the
  nightly commit on transient network issues.
- `data/meta.json` includes a `warnings` field listing any skipped tickers or
  failed sections, surfacing issues without breaking the dashboard.

## Consequences

**Positive:**
- The dashboard always shows *something* even when upstream sources are flaky.
- CI does not produce noisy failed runs for transient network issues.
- Missing one ticker does not break the full ETF table.

**Negative:**
- Silent partial failures: if many tickers fail, the dashboard looks "complete" but
  is missing data. The `warnings` field in `meta.json` mitigates this.
- A completely broken build (e.g., bad import) will still exit 0 — we rely on
  smoke-test CI (`ci.yml`) to catch code-level errors before they reach production.

## Alternatives Considered

| Alternative | Why rejected |
|-------------|-------------|
| Hard-fail on any error | One bad ticker or transient outage breaks the entire nightly run |
| Retry every failed ticker | Adds minutes to build time; upstream may still be unavailable |
| Cache last-known-good per ticker | More complex; would need a persistent data store |
