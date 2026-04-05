#!/usr/bin/env bash
set -euo pipefail

readonly LOGIFLOW_GATEWAY_URL="${LOGIFLOW_GATEWAY_URL:-http://localhost:3000}"
readonly ZAP_IMAGE="ghcr.io/zaproxy/zaproxy:stable"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPORTS_DIR="${SCRIPT_DIR}/../reports"
readonly TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
readonly ZAP_RUN_USER="${ZAP_RUN_USER:-root}"

function resolve_docker_command() {
  if command -v docker >/dev/null 2>&1; then
    if docker version >/dev/null 2>&1; then
      echo "docker"
      return 0
    fi
  fi

  if command -v docker.exe >/dev/null 2>&1; then
    if docker.exe version >/dev/null 2>&1; then
      echo "docker.exe"
      return 0
    fi
  fi

  echo ""
}

function convert_path_if_needed() {
  local input_path="$1"
  local docker_cmd="$2"

  if [ "${docker_cmd}" = "docker.exe" ] && command -v wslpath >/dev/null 2>&1; then
    wslpath -m "${input_path}"
    return 0
  fi

  echo "${input_path}"
}

mkdir -p "${REPORTS_DIR}"

echo "[ZAP] Starting baseline scan against ${LOGIFLOW_GATEWAY_URL}"

DOCKER_CMD="$(resolve_docker_command)"
if [ -z "${DOCKER_CMD}" ]; then
  echo "[ZAP] ERROR: Docker command not found. Install Docker Desktop and ensure CLI is available."
  exit 1
fi

REPORTS_MOUNT_PATH="$(convert_path_if_needed "${REPORTS_DIR}" "${DOCKER_CMD}")"

"${DOCKER_CMD}" run --rm \
  --user "${ZAP_RUN_USER}" \
  --network host \
  -v "${REPORTS_MOUNT_PATH}:/zap/wrk:rw" \
  "${ZAP_IMAGE}" \
  zap-baseline.py \
    -t "${LOGIFLOW_GATEWAY_URL}" \
    -r "zap-report-${TIMESTAMP}.html" \
    -J "zap-report-${TIMESTAMP}.json" \
    -l WARN \
    -I \
    --auto

echo "[ZAP] Report saved to ${REPORTS_DIR}/zap-report-${TIMESTAMP}.html"
