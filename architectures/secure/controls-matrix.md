# Security Controls Matrix (NIST CSF + OWASP + SPTI)

| Control ID | Security Control | NIST CSF Function | OWASP Top 10 Mitigated | SPTI Topic | Status |
|---|---|---|---|---|---|
| C-001 | JWT auth middleware for Socket.io room join | Protect | A01 Broken Access Control, A07 Identification and Authentication Failures | Security Architecture Principles, Data Protection | Implemented |
| C-002 | Bearer-authenticated webhook ingestion | Protect | A07 Identification and Authentication Failures | Security Architecture Principles, Software Security | Implemented |
| C-003 | Rate limiting on webhook endpoint | Protect, Detect | A05 Security Misconfiguration | Risk Management, Availability Engineering | Implemented |
| C-004 | Helmet security headers in gateway | Protect | A05 Security Misconfiguration | Software Security, Defense in Depth | Implemented |
| C-005 | Production-safe exception filter | Protect, Detect | A09 Security Logging and Monitoring Failures | SGSI, Incident Readiness | Implemented |
| C-006 | Dependency CVE scanning (`npm audit`, Snyk) | Identify, Protect | A06 Vulnerable and Outdated Components | Risk Management, Software Security | Implemented |
| C-007 | Secrets detection (GitLeaks, TruffleHog) | Identify, Protect | A02 Cryptographic Failures | Data Protection, SGSI | Implemented |
| C-008 | Falco runtime anomaly detection | Detect, Respond | A09 Security Logging and Monitoring Failures | Continuous Monitoring, Incident Response | Implemented |
| C-009 | Prometheus security alert rules | Detect | A01, A07, A09 | SGSI Monitoring Controls | Implemented |
| C-010 | Loki + Grafana security observability | Detect, Respond | A09 Security Logging and Monitoring Failures | Continuous Monitoring, Forensics | Implemented |
| C-011 | OWASP ZAP DAST in CI and on-demand | Identify, Protect | A01, A03, A05, A09 | Software Security Validation | Implemented |
| C-012 | Formal security test plan and evidence process | Identify, Recover | Cross-cutting | SGSI, Risk Management | Documented |
| C-013 | Secret rotation governance policy | Recover | A02 Cryptographic Failures | Data Protection Governance | Planned |
| C-014 | Incident runbook for compromised container | Respond, Recover | A09 Security Logging and Monitoring Failures | SGSI, Incident Management | Planned |
