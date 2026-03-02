# Contributing

Thanks for your interest in improving Market Dashboard.

## Getting started

```bash
git clone https://github.com/<your-fork>/market_dashboard
cd market_dashboard
bash scripts/bootstrap.sh   # sets up venv and fetches initial data
make serve                  # http://localhost:8021
```

## Running a data refresh

```bash
make refresh
```

## Opening issues

- Use GitHub Issues for bug reports, feature requests, and questions.
- Check [docs/ROADMAP.md](docs/ROADMAP.md) before opening a feature request — it may already be planned.
- For bugs, include: OS, Python version, output of `make refresh`, and the contents of `data/meta.json`.

## Code style

- Python: follow PEP 8. Keep functions short and single-purpose.
- HTML/CSS/JS: vanilla only — no frameworks, no build step.
- Use 4-space indentation, LF line endings, UTF-8 encoding (enforced by `.editorconfig`).
- Do not commit generated `data/` files — they are gitignored and produced by CI.
