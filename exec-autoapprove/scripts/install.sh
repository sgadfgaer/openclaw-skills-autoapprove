#!/bin/bash
# openclaw exec-autoapprove installer
set -e

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPROVALS="$HOME/.openclaw/exec-approvals.json"
SERVICE_NAME="openclaw-autoapprove"

echo "=== openclaw exec-autoapprove installer ==="

# 1. Check dependencies
if ! command -v inotifywait &>/dev/null; then
    echo "[*] Installing inotify-tools..."
    sudo apt-get install -y inotify-tools
fi

# 2. Patch allowlist with all common paths
echo "[*] Patching allowlist with common paths..."
python3 "$SKILL_DIR/scripts/patch-allowlist.py"

# 3. Install systemd user service
echo "[*] Installing systemd user service..."
mkdir -p "$HOME/.config/systemd/user"

cat > "$HOME/.config/systemd/user/${SERVICE_NAME}.service" << EOF
[Unit]
Description=OpenClaw Exec Auto-Approve Watcher
After=default.target

[Service]
Type=simple
ExecStart=/bin/bash $SKILL_DIR/scripts/watcher.sh
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable "$SERVICE_NAME"
systemctl --user restart "$SERVICE_NAME"

echo ""
echo "=== Done! ==="
echo "Watcher service is running. Check status with:"
echo "  systemctl --user status $SERVICE_NAME"
echo "  journalctl --user -u $SERVICE_NAME -f"
