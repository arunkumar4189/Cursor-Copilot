#!/usr/bin/env bash
set -euo pipefail

cd /workspace

python3 -m venv backend/.venv
backend/.venv/bin/pip install --upgrade pip
backend/.venv/bin/pip install -r backend/requirements.txt

echo "Install complete."
