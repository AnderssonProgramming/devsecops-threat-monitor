#!/usr/bin/env bash
set -euo pipefail

readonly LOGIFLOW_GATEWAY_URL="${LOGIFLOW_GATEWAY_URL:-http://localhost:3002/api/v1/health}"
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

  if [ "${docker_cmd}" = "docker.exe" ]; then
    # Prefer Git Bash/Cygwin conversion when available.
    if command -v cygpath >/dev/null 2>&1; then
      cygpath -m "${input_path}"
      return 0
    fi

    # Fallback for WSL shells calling docker.exe.
    if command -v wslpath >/dev/null 2>&1; then
      wslpath -m "${input_path}"
      return 0
    fi
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

echo "[ZAP] Docker command: ${DOCKER_CMD}"
echo "[ZAP] Reports mount path: ${REPORTS_MOUNT_PATH}"

HTML_REPORT="${REPORTS_DIR}/zap-report-${TIMESTAMP}.html"
JSON_REPORT="${REPORTS_DIR}/zap-report-${TIMESTAMP}.json"

"${DOCKER_CMD}" run --rm \
  --user "${ZAP_RUN_USER}" \
  --network host \
  --mount "type=bind,source=${REPORTS_MOUNT_PATH},target=/zap/wrk" \
  "${ZAP_IMAGE}" \
  zap-baseline.py \
    -t "${LOGIFLOW_GATEWAY_URL}" \
    -r "zap-report-${TIMESTAMP}.html" \
    -J "zap-report-${TIMESTAMP}.json" \
    -l WARN \
    -I \
    --auto

if [ ! -f "${HTML_REPORT}" ] || [ ! -f "${JSON_REPORT}" ]; then
  echo "[ZAP] ERROR: Scan did not produce expected report files."
  echo "[ZAP] Expected: ${HTML_REPORT} and ${JSON_REPORT}"
  exit 1
fi

echo "[ZAP] Report saved to ${HTML_REPORT}"
