#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly LOGIFLOW_ROOT="${LOGIFLOW_ROOT:-${PROJECT_ROOT}/../logiflow-cybersecurity-seminar}"
readonly SERVICES=(gateway realtime automation optimizer)

function extract_vulnerability_count() {
  local report_file="$1"
  local level="$2"

  node -e "
    const fs = require('fs');
    const filePath = process.argv[1];
    const level = process.argv[2];
    const raw = fs.readFileSync(filePath, 'utf8');
    const json = JSON.parse(raw);
    const value = json?.metadata?.vulnerabilities?.[level] ?? 0;
    process.stdout.write(String(value));
  " "${report_file}" "${level}"
}

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

  CRITICAL_COUNT="$(extract_vulnerability_count "${OUTPUT_FILE}" "critical")"
  HIGH_COUNT="$(extract_vulnerability_count "${OUTPUT_FILE}" "high")"
  echo "[SCA] ${service}: critical=${CRITICAL_COUNT}, high=${HIGH_COUNT}"
done

echo "[SCA] Completed audit for all services. Reports are in ${SCRIPT_DIR}."
