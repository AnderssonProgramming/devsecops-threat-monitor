# STRIDE Threat Model - LogiFlow

Risk score is calculated as `Likelihood x Impact` on a 1 to 5 scale.

| ID | Asset | Threat | STRIDE Category | Attack Scenario | Likelihood (1-5) | Impact (1-5) | Risk Score |
|---|---|---|---|---|---|---|---|
| TM-01 | Realtime vehicle channels | Unauthorized room join | Spoofing, Information Disclosure | Adversary joins `vehicle:{id}` rooms without JWT and receives fleet coordinates | 5 | 5 | 25 |
| TM-02 | Routing decision pipeline | Fake traffic event injection | Spoofing, Tampering | Forged webhook payloads create fake incidents and reroute vehicles | 4 | 5 | 20 |
| TM-03 | Webhook service availability | Request flood DoS | Denial of Service | Flood of event posts overwhelms mock server and n8n executor | 5 | 4 | 20 |
| TM-04 | Gateway internals | Stack trace disclosure | Information Disclosure | Malformed requests expose stack frames and service paths | 4 | 3 | 12 |
| TM-05 | Secrets and API keys | Secret leakage abuse | Information Disclosure, Repudiation | Long-lived leaked token is reused without rotation traceability | 3 | 4 | 12 |
| TM-06 | Vehicle and dispatcher roles | Privilege misuse via JWT tampering | Elevation of Privilege | Modified token claims attempt unauthorized admin actions | 3 | 5 | 15 |
| TM-07 | PostgreSQL data integrity | Injection attempt against API filters | Tampering | Crafted payloads target unsafe query composition in route endpoints | 3 | 5 | 15 |
| TM-08 | Container runtime | Malicious process execution | Elevation of Privilege | Compromised service spawns shell/curl for persistence and lateral movement | 4 | 5 | 20 |
| TM-09 | Audit trail quality | Log suppression | Repudiation | Attacker disables/redirects logs to hide traces of intrusion | 3 | 4 | 12 |
| TM-10 | Redis event bus | Unauthorized pub/sub access | Tampering, Information Disclosure | Misconfigured Redis auth allows injecting or reading event streams | 3 | 4 | 12 |
| TM-11 | CI supply chain | Vulnerable dependency exploitation | Tampering | High/Critical dependency CVE exploited in exposed service path | 4 | 4 | 16 |
| TM-12 | Dispatcher operations | Mass rerouting abuse | Denial of Service, Tampering | Orchestrated event spam creates repeated reroute loops and dispatch paralysis | 4 | 4 | 16 |

## Risk Prioritization

| Priority | Risk Score Range | Required Action |
|---|---|---|
| P1 | 20-25 | Immediate mitigation before production demo |
| P2 | 15-19 | Mitigate in current sprint |
| P3 | 10-14 | Mitigate with validated compensating controls |
| P4 | 1-9 | Monitor and document residual risk |

## SPTI Coverage

- Risk Management: quantitative scoring and prioritization process.
- Security Architecture Principles: trust boundary analysis between external clients and internal services.
- SGSI: threat register can be integrated with incident and treatment workflows.
