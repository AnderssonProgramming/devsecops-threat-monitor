# Security Test Plan - LogiFlow Continuous Monitoring (April 6 Deliverable)

## 1. Scope

### Systems Under Test
- LogiFlow Gateway (NestJS)
- Realtime Service (Socket.io + Redis adapter)
- Automation Service (n8n + Express mock server)

### Out of Scope
- LogiFlow frontend applications (`web-admin`, `mobile`)
- VROOM internal optimization algorithm logic

### Test Environment
- Local Docker Compose environment
- Shared network: `logiflow-net`
- Security monitoring sidecar stack from this repository on `logiflow-security-net`

### SPTI Topic Coverage
- Risk Management: prioritization by exploitability and operational impact.
- Software Security: SAST/DAST/SCA and runtime controls.
- SGSI: repeatable evidence collection for each control.

## 2. Test Categories

| ID | Category | Tool | Automated? | Frequency |
|---|---|---|---|---|
| TC-01 | Authentication bypass | curl + custom script | Yes | Every push |
| TC-02 | Socket.io unauthorized join | Node.js script | Yes | Every push |
| TC-03 | Webhook flood (DoS) | Apache Bench / k6 / curl loop | Yes | Nightly |
| TC-04 | SQL injection via API | OWASP ZAP | Yes | Nightly |
| TC-05 | Missing security headers | OWASP ZAP | Yes | Nightly |
| TC-06 | Secrets in codebase | GitLeaks | Yes | Every push |
| TC-07 | Dependency CVEs | npm audit + Snyk | Yes | Every push |
| TC-08 | Container runtime anomaly | Falco manual trigger | Manual | Weekly |
| TC-09 | JWT manipulation | jwt_tool | Manual | Per release |
| TC-10 | Information disclosure via errors | curl error probing | Yes | Every push |

## 3. Evaluation Criteria

| Test ID | Expected Result (Secure) | Observed Result (Unsecure) | Observed Result (Secure) | Pass/Fail Condition | Evidence Location |
|---|---|---|---|---|---|
| TC-01 | Protected endpoints return 401 without valid JWT | Endpoint accepted unauthenticated/invalid token in at least one route | All tested endpoints enforce 401/403 | PASS if unauthorized requests are blocked | `tests/results/tc-01-auth-bypass.log` |
| TC-02 | Socket connection rejected without JWT | Unauthenticated socket joined vehicle room | Socket rejected with authentication error | PASS if no unauthorized room join occurs | `tests/results/tc-02-socket.log` |
| TC-03 | Webhook starts returning 429 after threshold | Unlimited flood accepted | 429 responses observed with stable service health | PASS if limiter blocks flood traffic | `tests/results/tc-03-rate-limit.log` |
| TC-04 | No exploitable SQL injection findings | Potential SQLi indicators in baseline scan | No High SQLi findings | PASS if ZAP reports no High SQLi alerts | `dast/reports/*.json` |
| TC-05 | Security headers present | Missing CSP/HSTS/X-Frame headers | Helmet headers present | PASS if required headers are in response | `tests/results/tc-05-headers.log` |
| TC-06 | No secrets committed | Candidate credentials detected | No verified leaks | PASS if pipeline GitLeaks job passes | GitHub Actions run summary |
| TC-07 | No Critical CVEs in dependencies | High/Critical CVEs reported | Critical CVEs remediated or blocked in pipeline | PASS if critical count is zero | `sca/audit-*.json` |
| TC-08 | Falco emits alert on suspicious runtime behavior | No runtime alerting present | Falco rules triggered and visible in Grafana/Loki | PASS if alert appears in logs/dashboard | `tests/results/tc-08-falco.log` |
| TC-09 | JWT tampering rejected | Weak validation accepted manipulated claims in historical baseline | Manipulated JWT rejected | PASS if forged claims cannot escalate access | `tests/results/tc-09-jwt.log` |
| TC-10 | Error responses sanitized in production | Stack traces/internal paths returned | Generic error responses only | PASS if no internals are exposed | `tests/results/tc-10-errors.log` |

## 4. Test Scripts and Execution

- `tests/penetration/auth-bypass-tests.sh`
- `tests/penetration/socket-injection-tests.js`
- `tests/penetration/rate-limit-tests.sh`
- `tests/penetration/injection-tests.sh`

Recommended execution sequence:
1. Start LogiFlow services.
2. Start security monitoring stack.
3. Run push-frequency tests (TC-01, TC-02, TC-10).
4. Run nightly tests (TC-03, TC-04, TC-05).
5. Execute manual validation tests (TC-08, TC-09).
6. Store logs/screenshots in `tests/results`.
