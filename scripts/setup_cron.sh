#!/usr/bin/env bash
# setup_cron.sh — one-time setup for local WSL auto-refresh
# Run from repo root: bash scripts/setup_cron.sh

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV="$REPO_DIR/.venv"
SCRIPT="$REPO_DIR/scripts/build_data.py"
LOG="$REPO_DIR/cron.log"
CRON_JOB="30 17 * * 1-5 cd $REPO_DIR && source $VENV/bin/activate && python3 $SCRIPT --out-dir data >> $LOG 2>&1"

echo ""
echo "=== Market Dashboard — Cron Setup ==="
echo "Repo : $REPO_DIR"
echo "Venv : $VENV"
echo "Log  : $LOG"
echo ""

# --- Sanity checks ---
if [ ! -d "$VENV" ]; then
    echo "ERROR: .venv not found at $VENV"
    echo "Create it first: python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

if [ ! -f "$SCRIPT" ]; then
    echo "ERROR: build_data.py not found at $SCRIPT"
    exit 1
fi

# --- Install cron job (idempotent) ---
EXISTING=$(crontab -l 2>/dev/null || true)
if echo "$EXISTING" | grep -qF "build_data.py"; then
    echo "Cron job already installed. Replacing with updated version..."
    NEW_CRONTAB=$(echo "$EXISTING" | grep -v "build_data.py")
else
    NEW_CRONTAB="$EXISTING"
fi

printf "%s\n%s\n" "$NEW_CRONTAB" "$CRON_JOB" | crontab -
echo "Cron job installed: weekdays at 5:30 PM"

# --- Configure WSL to auto-start cron on boot ---
WSL_CONF="/etc/wsl.conf"
BOOT_LINE="command = service cron start"

if grep -q "^command = service cron start" "$WSL_CONF" 2>/dev/null; then
    echo "WSL boot config already set."
else
    echo ""
    echo "Configuring WSL to auto-start cron on boot (requires sudo)..."
    if ! grep -q "^\[boot\]" "$WSL_CONF" 2>/dev/null; then
        echo -e "\n[boot]\n$BOOT_LINE" | sudo tee -a "$WSL_CONF" > /dev/null
    else
        sudo sed -i "/^\[boot\]/a $BOOT_LINE" "$WSL_CONF"
    fi
    echo "WSL boot config updated: $WSL_CONF"
fi

# --- Start cron service now ---
echo ""
echo "Starting cron service..."
if sudo service cron start 2>/dev/null; then
    echo "Cron service running."
else
    echo "Cron may already be running — OK."
fi

# --- Verify ---
echo ""
echo "=== Installed cron jobs ==="
crontab -l
echo ""
echo "Done. Data will refresh weekdays at 5:30 PM."
echo "Check logs anytime: tail -f $LOG"
echo ""
