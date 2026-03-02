# Market Dashboard

Static stock dashboard with daily auto-refresh via GitHub Actions (Yahoo Finance), hosted on GitHub Pages.

---

## Local Auto-Refresh (WSL) — One-Time Setup

Run this once from the repo root:

```bash
bash scripts/setup_cron.sh
```

This script will:
- Install a cron job to run `build_data.py` weekdays at **5:30 PM** (after market close)
- Configure WSL to **auto-start cron** every time WSL boots (requires `sudo` — you will be prompted)
- Start the cron service immediately

After setup, data refreshes automatically every weekday. No further action needed.

**View the dashboard:**

```bash
cd ~/proj/market_dashboard
python3 -m http.server 8021
```

Open `http://localhost:8021` in your browser.

**Check refresh logs:**

```bash
tail -f ~/proj/market_dashboard/cron.log
```

**Run a manual refresh anytime:**

```bash
cd ~/proj/market_dashboard && source .venv/bin/activate && python3 scripts/build_data.py --out-dir data
```

---

## Build data locally (first time / manual)

```bash
cd ~/proj/market_dashboard
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 scripts/build_data.py --out-dir data
```

This generates: `data/snapshot.json`, `data/events.json`, `data/meta.json`, and `data/charts/*.png`.

---

## Deploy to GitHub Pages

1. Create a new GitHub repository and push this directory's contents to it (or push as the repo root).
2. **Before first deploy** you need initial data. Either:
   - **Recommended:** In the repo go to **Actions** → "Refresh dashboard data" → **Run workflow**. When it finishes, it will commit `data/` to the repo.
   - Or run locally: `python3 scripts/build_data.py --out-dir data`, then `git add data/`, commit and push.
3. In the repo **Settings → Pages**:
   - Set Source to **GitHub Actions** (or "Deploy from a branch").
   - If using a branch: choose branch `main` and folder `/ (root)`.
4. The workflow runs daily at 16:30 US Eastern to refresh data; you can also run it manually from **Actions**.

Site URL: `https://<your-username>.github.io/<repo-name>/`

---

## Project structure

```
market_dashboard/
├── .github/workflows/refresh_data.yml   # Daily data refresh (GitHub Actions)
├── scripts/
│   ├── build_data.py                    # Fetches data, outputs JSON + charts
│   └── setup_cron.sh                   # One-time local WSL cron setup
├── data/                                # Generated (commit for Pages)
│   ├── snapshot.json
│   ├── events.json
│   ├── meta.json
│   └── charts/*.png
├── index.html                           # Static frontend
├── requirements.txt
├── cron.log                             # Local cron output (gitignored)
└── README.md
```

Data: Yahoo Finance (yfinance), economic calendar (investpy). Charts: matplotlib.
