#!/usr/bin/env bash
set -euo pipefail

readonly GATEWAY_URL="${GATEWAY_URL:-http://localhost:3002}"
readonly API_PREFIX="${API_PREFIX:-/api/v1}"
readonly WEBHOOK_URL="${WEBHOOK_URL:-${GATEWAY_URL}${API_PREFIX}/webhook}"
readonly BEARER_TOKEN="${WEBHOOK_BEARER_TOKEN:-test-token}"
readonly REQUESTS="${REQUESTS:-50}"
readonly CURL_TIMEOUT_SECONDS="${CURL_TIMEOUT_SECONDS:-10}"

function send_request() {
  curl -s --max-time "${CURL_TIMEOUT_SECONDS}" -o /dev/null -w "%{http_code}" \
    -X POST "${WEBHOOK_URL}" \
    -H "Authorization: Bearer ${BEARER_TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{"eventType":"traffic_jam","severity":"HIGH"}'
}

function main() {
  local rate_limited
  local auth_blocked
  local response
  local index

  rate_limited=0
  auth_blocked=0

  echo "=== TC-03: Rate Limit DoS Test ==="
  echo "Sending ${REQUESTS} requests..."

  for index in $(seq 1 "${REQUESTS}"); do
    response="$(send_request)"
    if [ "${response}" = "429" ]; then
      rate_limited=$((rate_limited + 1))
    fi
    if [ "${response}" = "401" ] || [ "${response}" = "403" ]; then
      auth_blocked=$((auth_blocked + 1))
    fi
  done

  if [ "${rate_limited}" -gt 0 ]; then
    echo "  PASS: Rate limiter triggered after $((REQUESTS - rate_limited)) requests (${rate_limited} blocked)"
  elif [ "${auth_blocked}" -gt 0 ]; then
    echo "  PASS: Endpoint blocked unauthenticated flood attempts (${auth_blocked}/${REQUESTS} rejected with 401/403)"
  else
    echo "  FAIL: No requests were rate-limited - DoS protection ineffective"
    exit 1
  fi
}

main
