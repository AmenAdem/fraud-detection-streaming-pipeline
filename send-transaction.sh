#!/usr/bin/env bash
set -euo pipefail

HOST=${HOST:-localhost}
PORT=${PORT:-3000}

# Example triggers: amount 10000 or suspicious_user
PAYLOAD=${1:-'{"id":"tx_manual_1","amount":10000,"user":"alice","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}'}

curl -s -X POST "http://${HOST}:${PORT}/transactions" \
  -H 'Content-Type: application/json' \
  -d "${PAYLOAD}" | jq .

