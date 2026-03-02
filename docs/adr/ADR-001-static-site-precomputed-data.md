# ADR-001: Static site with pre-computed data

**Status:** Accepted

---

## Context

We need a market dashboard that displays daily ETF returns and an economic calendar.
Options considered ranged from a fully dynamic server-side app to a pure static site.

The primary constraint is cost: we want zero hosting cost, minimal operational burden,
and no secrets or API keys exposed in the browser.

## Decision

Build a **static site** (`index.html`) that reads pre-generated JSON files and PNG charts
from the same origin. All data fetching and computation happens at build time inside
`scripts/build_data.py`, which runs on a schedule (GitHub Actions or local cron) and
commits the outputs to the repository.

## Consequences

**Positive:**
- Zero server infrastructure; hosted for free on GitHub Pages.
- No API keys in the browser — all third-party calls happen in Python at build time.
- Simple mental model: the repo is always in a "deployable" state.
- Fast page loads — no client-side API calls, just `fetch()` of local JSON.

**Negative:**
- Data is never fresher than the last build (acceptable for end-of-day use).
- Regenerating data requires running Python, not just editing HTML.
- Binary chart files (PNG) inflate the git history when committed — mitigated by
  ignoring `data/` locally and force-adding only from CI (see `.gitignore` + `refresh_data.yml`).

## Alternatives Considered

| Alternative | Why rejected |
|-------------|-------------|
| Server-side app (Flask/FastAPI) | Requires always-on server, cost, ops overhead |
| Client-side API calls (Yahoo Finance proxy) | Exposes keys; CORS issues; rate limits in browser |
| AWS Lambda / serverless | Additional complexity, cost, and IAM management |
