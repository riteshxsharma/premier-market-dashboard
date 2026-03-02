# ADR-002: Two-tier scheduling (GitHub Actions + local cron)

**Status:** Accepted

---

## Context

The dashboard data must be refreshed daily after US market close (~16:00 ET).
We need a scheduling mechanism that is reliable for the deployed site (GitHub Pages)
and convenient for local development.

## Decision

Use **two independent schedulers**:

1. **GitHub Actions** (`refresh_data.yml`) — runs Mon–Fri at 16:30 ET (20:30 UTC),
   commits the generated `data/` back to the repository, which GitHub Pages then serves.
   This is the production path.

2. **Local WSL cron** (`scripts/setup_cron.sh`) — runs Mon–Fri at 17:30 local time,
   writes data into the local working tree. This is the developer convenience path.
   The script configures `/etc/wsl.conf` to auto-start cron on WSL boot.

The two schedulers are fully independent; each writes to its own location (repo vs. local).

## Consequences

**Positive:**
- The deployed GitHub Pages site refreshes automatically without any developer action.
- Local development has up-to-date data without a manual `make refresh`.
- Neither scheduler depends on the other; if one fails the other still works.

**Negative:**
- Two moving parts to maintain and document.
- WSL cron is fragile (WSL restart, sleep/hibernate can cause missed runs).
- GitHub Actions free tier has usage limits (acceptable at 5 runs/week).

## Alternatives Considered

| Alternative | Why rejected |
|-------------|-------------|
| Only GitHub Actions | Local data always stale unless manually refreshed |
| Only local cron pushing to GitHub | Requires developer machine to be on at ~16:30 every weekday |
| External cron service (cron-job.org) | Additional account/dependency; harder to audit |
