#!/usr/bin/env bash
# bootstrap.sh — one-command setup for market_dashboard
# Usage: bash scripts/bootstrap.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if ! command -v make &>/dev/null; then
    echo "Error: 'make' is not installed. Install it and re-run." >&2
    exit 1
fi

exec make setup
