#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly LOGIFLOW_ROOT="${LOGIFLOW_ROOT:-${PROJECT_ROOT}/../logiflow-cybersecurity-seminar}"
readonly SERVICES=(gateway realtime automation optimizer)

if [ ! -d "${LOGIFLOW_ROOT}/services" ]; then
  echo "[ERROR] LogiFlow services directory not found: ${LOGIFLOW_ROOT}/services"
  echo "Set LOGIFLOW_ROOT to your LogiFlow repository path."
  exit 1
fi

for service in "${SERVICES[@]}"; do
  SERVICE_PATH="${LOGIFLOW_ROOT}/services/${service}"
  OUTPUT_FILE="${SCRIPT_DIR}/audit-${service}.json"

  echo "[SCA] Auditing ${service}..."
  pushd "${SERVICE_PATH}" > /dev/null
  npm ci
  npm audit --audit-level=high --json > "${OUTPUT_FILE}" || true
  popd > /dev/null

  CRITICAL_COUNT=$(jq -r '.metadata.vulnerabilities.critical // 0' "${OUTPUT_FILE}")
  HIGH_COUNT=$(jq -r '.metadata.vulnerabilities.high // 0' "${OUTPUT_FILE}")
  echo "[SCA] ${service}: critical=${CRITICAL_COUNT}, high=${HIGH_COUNT}"
done

echo "[SCA] Completed audit for all services. Reports are in ${SCRIPT_DIR}."
