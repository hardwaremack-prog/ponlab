#!/usr/bin/env bash
# PON Lab installer for Raspberry Pi OS (Bookworm or newer)
# Usage:  cd ponlab && sudo ./install.sh
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
USER_NAME="${SUDO_USER:-pi}"

echo "Installing packages..."
apt-get update -qq
apt-get install -y -qq python3-flask python3-gpiozero python3-lgpio

echo "Creating service..."
cat > /etc/systemd/system/ponlab.service <<EOF
[Unit]
Description=PON Lab outage simulator
After=network-online.target

[Service]
User=${USER_NAME}
WorkingDirectory=${DIR}
ExecStart=/usr/bin/python3 ${DIR}/app.py
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

usermod -aG gpio "${USER_NAME}" || true
systemctl daemon-reload
systemctl enable --now ponlab.service

IP=$(hostname -I | awk '{print $1}')
echo
echo "PON Lab is running:  http://${IP}:8080"
echo "Logs:   journalctl -u ponlab -f"
echo "Config: ${DIR}/config.json  (then: sudo systemctl restart ponlab)"
