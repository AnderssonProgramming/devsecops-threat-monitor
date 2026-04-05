#!/usr/bin/env bash
set -euo pipefail

readonly GATEWAY_URL="${GATEWAY_URL:-http://localhost:3000}"
readonly WEBHOOK_URL="${WEBHOOK_URL:-http://localhost:3002/webhooks/traffic-event}"
readonly CURL_TIMEOUT_SECONDS="${CURL_TIMEOUT_SECONDS:-10}"

function assert_status_code() {
  local actual_status="$1"
  local expected_status="$2"
  local success_message="$3"
  local failure_message="$4"

  if [ "${actual_status}" = "${expected_status}" ]; then
    echo "  PASS: ${success_message}"
  else
    echo "  FAIL: ${failure_message} (received ${actual_status}, expected ${expected_status})"
    exit 1
  fi
}

function test_protected_route_without_token() {
  echo "[TEST] Accessing protected route without token..."
  local response
  response="$(curl -s --max-time "${CURL_TIMEOUT_SECONDS}" -o /dev/null -w "%{http_code}" "${GATEWAY_URL}/api/vehicles")"
  assert_status_code "${response}" "401" "Returned 401 Unauthorized" "Protected route accepted request without token"
}

function test_protected_route_with_invalid_token() {
  echo "[TEST] Accessing protected route with invalid token..."
  local response
  response="$(curl -s --max-time "${CURL_TIMEOUT_SECONDS}" -o /dev/null -w "%{http_code}" -H "Authorization: Bearer invalid.token.here" "${GATEWAY_URL}/api/vehicles")"
  assert_status_code "${response}" "401" "Invalid token rejected" "Invalid token was not rejected"
}

function test_webhook_without_bearer_token() {
  echo "[TEST] Calling webhook endpoint without bearer token..."
  local response
  response="$(curl -s --max-time "${CURL_TIMEOUT_SECONDS}" -o /dev/null -w "%{http_code}" -X POST "${WEBHOOK_URL}" -H "Content-Type: application/json" -d '{"eventType":"road_closure","severity":"CRITICAL"}')"
  assert_status_code "${response}" "401" "Webhook rejected unauthenticated request" "Webhook accepted request without bearer token"
}

function main() {
  echo "=== TC-01: Authentication Bypass Tests ==="
  test_protected_route_without_token
  test_protected_route_with_invalid_token
  test_webhook_without_bearer_token
  echo "All TC-01 checks passed."
}

main
