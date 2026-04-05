#!/usr/bin/env bash
set -euo pipefail

readonly GATEWAY_URL="${GATEWAY_URL:-http://localhost:3000}"
readonly JWT_TOKEN="${JWT_TOKEN:-invalid.token.here}"
readonly SQLI_PAYLOAD="' OR '1'='1"
readonly NOSQL_PAYLOAD='{"$ne":null}'

function run_sqli_probe() {
  echo "[TEST] SQL injection probe on vehicles endpoint..."
  curl -s -o /tmp/logiflow_sqli_response.txt -w "%{http_code}" \
    -G "${GATEWAY_URL}/api/vehicles" \
    --data-urlencode "search=${SQLI_PAYLOAD}" \
    -H "Authorization: Bearer ${JWT_TOKEN}"
}

function run_nosql_probe() {
  echo "[TEST] NoSQL injection probe on stops endpoint..."
  curl -s -o /tmp/logiflow_nosql_response.txt -w "%{http_code}" \
    -G "${GATEWAY_URL}/api/stops" \
    --data-urlencode "driverId=${NOSQL_PAYLOAD}" \
    -H "Authorization: Bearer ${JWT_TOKEN}"
}

function main() {
  local sqli_status
  local nosql_status

  echo "=== TC-04/TC-10: Injection and Error Disclosure Probes ==="

  sqli_status="$(run_sqli_probe)"
  nosql_status="$(run_nosql_probe)"

  echo "SQLi probe status: ${sqli_status}"
  echo "NoSQL probe status: ${nosql_status}"

  if [ "${sqli_status}" = "500" ] || [ "${nosql_status}" = "500" ]; then
    echo "  WARN: 500 response observed. Verify response body does not expose internals."
  else
    echo "  PASS: Injection probes did not trigger obvious server error responses."
  fi
}

main
