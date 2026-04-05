#!/usr/bin/env bash
set -euo pipefail

readonly LOGIFLOW_GATEWAY_URL="${LOGIFLOW_GATEWAY_URL:-http://localhost:3000}"
readonly ZAP_IMAGE="ghcr.io/zaproxy/zaproxy:stable"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPORTS_DIR="${SCRIPT_DIR}/../reports"
readonly ZAP_CONFIG_DIR="${SCRIPT_DIR}/../zap"
readonly TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "${REPORTS_DIR}"

echo "[ZAP] Starting baseline scan against ${LOGIFLOW_GATEWAY_URL}"

docker run --rm \
  --network host \
  -v "${REPORTS_DIR}:/zap/wrk:rw" \
  -v "${ZAP_CONFIG_DIR}:/zap/config:ro" \
  "${ZAP_IMAGE}" \
  zap-baseline.py \
    -t "${LOGIFLOW_GATEWAY_URL}" \
    -c /zap/config/zap-baseline.yaml \
    -r "zap-report-${TIMESTAMP}.html" \
    -J "zap-report-${TIMESTAMP}.json" \
    -l WARN \
    --auto

echo "[ZAP] Report saved to ${REPORTS_DIR}/zap-report-${TIMESTAMP}.html"
