# SPTI Course Concepts Mapping

| SPTI Topic | Implementation in This Project |
|---|---|
| Introduccion a Ciberseguridad | CIA triad analysis of LogiFlow and attack surface mapping in unsecure architecture docs |
| Risk Management | STRIDE threat model, likelihood/impact scoring, and vulnerability prioritization |
| Security Architecture Principles | Defense in depth with JWT, bearer auth, rate limiting, Helmet, and Falco controls |
| Legislacion | GDPR considerations for fleet geolocation data and Colombian Law 1581/2012 awareness for personal data handling |
| SGSI | Security controls matrix, test evidence process, and incident-oriented monitoring strategy |
| Data Protection | Secrets detection, key exposure controls, and recommendations for rotation governance |
| Security in the Data Lifecycle | Data-in-transit controls (HTTPS/WSS), data-at-rest assumptions (PostgreSQL encryption), controlled data access with JWT claims |
| Software Security | SAST (CodeQL + Semgrep), DAST (OWASP ZAP), SCA (npm audit + Snyk), container scan (Trivy), secure coding checks |

## Additional Traceability Notes

- Continuous Monitoring: implemented through Falco, Prometheus, Loki, and Grafana.
- Incident Readiness: alert rules and anomaly dashboards support triage workflows.
- Academic Deliverables: all artifacts are structured for April 6 and April 8 evaluations.
