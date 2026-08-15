#!/usr/bin/env bash
set -euo pipefail

cd /workspace

if [[ ! -x backend/.venv/bin/uvicorn ]]; then
  echo "Backend dependencies are missing. Run install first." >&2
  exit 1
fi

PORT="${BACKEND_PORT:-8000}"
HEALTH_URL="http://127.0.0.1:${PORT}/health"
PID_FILE="/tmp/cursor-copilot-backend.pid"

if [[ -f "${PID_FILE}" ]] && kill -0 "$(cat "${PID_FILE}")" 2>/dev/null; then
  if curl --fail --silent "${HEALTH_URL}" >/dev/null; then
    echo "Backend already running on port ${PORT}."
    exit 0
  fi
  kill "$(cat "${PID_FILE}")" 2>/dev/null || true
  rm -f "${PID_FILE}"
fi

backend/.venv/bin/uvicorn app.main:app --app-dir backend --host 127.0.0.1 --port "${PORT}" >/tmp/cursor-copilot-backend.log 2>&1 &
echo $! > "${PID_FILE}"

for _ in $(seq 1 30); do
  if curl --fail --silent "${HEALTH_URL}" >/dev/null; then
    echo "Backend ready on port ${PORT}."
    exit 0
  fi
  sleep 1
done

echo "Backend failed to become ready. Recent logs:" >&2
tail -n 50 /tmp/cursor-copilot-backend.log >&2 || true
exit 1
