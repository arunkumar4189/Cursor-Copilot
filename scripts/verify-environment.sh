#!/usr/bin/env bash
set -euo pipefail

cd /workspace

./.cursor/scripts/install.sh
./.cursor/scripts/install.sh

./.cursor/scripts/start.sh

curl --fail --silent http://127.0.0.1:8000/health | grep -q '"status":"ok"'
curl --fail --silent http://127.0.0.1:8000/v1/status | grep -q 'cursor-copilot-backend'

backend/.venv/bin/python -m compileall backend/app

echo "Environment verification passed."
