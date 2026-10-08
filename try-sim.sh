#!/usr/bin/env bash
cd "$(dirname "$0")"
python3 -c "import flask" 2>/dev/null || pip install flask --break-system-packages -q
(sleep 2; xdg-open http://localhost:8080 >/dev/null 2>&1) &
PONLAB_SIM=1 python3 app.py
