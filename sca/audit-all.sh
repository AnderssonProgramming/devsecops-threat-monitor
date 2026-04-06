#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly LOGIFLOW_ROOT="${LOGIFLOW_ROOT:-${PROJECT_ROOT}/../logiflow-cybersecurity-seminar}"
readonly SERVICES=(gateway realtime automation optimizer)

function resolve_node_command() {
  if command -v node >/dev/null 2>&1; then
    echo "node"
    return 0
  fi

  if command -v node.exe >/dev/null 2>&1; then
    echo "node.exe"
    return 0
  fi

  echo ""
}

function normalize_path_for_node() {
  local input_path="$1"

  # node.exe can't resolve WSL /mnt/* paths directly.
  if [ "${NODE_CMD}" = "node.exe" ] && command -v wslpath >/dev/null 2>&1; then
    wslpath -w "${input_path}"
    return 0
  fi

  echo "${input_path}"
}

readonly NODE_CMD="$(resolve_node_command)"

if [ -z "${NODE_CMD}" ]; then
  echo "[ERROR] Node.js command not found. Install Node.js or ensure node/node.exe is in PATH."
  exit 1
fi

function extract_vulnerability_count() {
  local report_file="$1"
  local level="$2"
  local node_path
  node_path="$(normalize_path_for_node "${report_file}")"

  "${NODE_CMD}" -e "
    const fs = require('fs');
    const filePath = process.argv[1];
    const level = process.argv[2];
    const raw = fs.readFileSync(filePath, 'utf8');
    const json = JSON.parse(raw);
    const value = json?.metadata?.vulnerabilities?.[level] ?? 0;
    process.stdout.write(String(value));
  " "${node_path}" "${level}"
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
