# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [0.1.0] — 2026-03-02

### Added
- Initial static dashboard with ~130 ETFs across US equities, sectors, factors,
  international markets, commodities, crypto, and fixed income.
- Sortable return table (1d / 1w / 1m / 3m / 6m / 1y / YTD) with heat-map coloring.
- Sparkline PNG charts (6-month price history) per ticker via matplotlib.
- Economic calendar section (investpy).
- Data freshness timestamp via `data/meta.json`.
- GitHub Actions workflow for daily data refresh (Mon–Fri 16:30 ET).
- Local WSL cron setup script (`scripts/setup_cron.sh`).
- `Makefile` with `setup` / `refresh` / `serve` / `clean` targets.
- `scripts/bootstrap.sh` one-command setup wrapper.
- Architecture documentation (`docs/ARCHITECTURE.md`).
- Architecture Decision Records (ADR-001 through ADR-004).
- CI smoke-test workflow (`.github/workflows/ci.yml`).
- `data/` gitignored locally; CI uses `git add -f data/` for GitHub Pages.
- MIT license, CONTRIBUTING guide, `.editorconfig`, `CODEOWNERS`, `ROADMAP.md`.
