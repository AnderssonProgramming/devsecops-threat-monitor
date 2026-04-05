# IEEE Paper Outline (April 8 Deliverable)

## Abstract (150 words)
LogiFlow is a representative real-time microservices platform for fleet routing where operational continuity and data integrity depend on secure service-to-service communication and resilient monitoring. This work presents a DevSecOps security monitoring layer that compares an intentionally unsecure architecture against a hardened production-aligned architecture. We identify concrete attack surfaces in API, socket, webhook, and container runtime flows, then map risks using STRIDE and OWASP Top 10 (2021). Our contribution includes a full security pipeline integrating SAST (CodeQL, Semgrep), SCA (`npm audit`, Snyk), secrets detection (GitLeaks), container scanning (Trivy), DAST (OWASP ZAP), and runtime anomaly detection (Falco). Observability is implemented with Prometheus, Loki, and Grafana for continuous threat visibility. The evaluation demonstrates measurable reductions in exposure after remediation and provides reusable artifacts for academic and industrial DevSecOps adoption.

## I. Introduction
- SPTI context: security-by-design and continuous monitoring in production systems.
- Motivation: distributed systems increase attack surface and detection latency.
- Scope: LogiFlow backend services and monitoring controls.

## II. Background
- OWASP Top 10 2021 as vulnerability taxonomy.
- NIST Cybersecurity Framework as governance/control structure.
- DevSecOps pipeline principles and shift-left security.
- Runtime threat detection in containerized platforms.

## III. LogiFlow System Description
- Architecture overview and service responsibilities.
- Technology stack (NestJS, Socket.io, n8n, VROOM, Redis, PostgreSQL).
- Identified attack surfaces and trust boundaries.

## IV. Threat Model
- STRIDE methodology and assumptions.
- Threat table and risk scoring formula.
- Prioritization of highest-impact scenarios.

## V. Unsecure vs Secure Architecture Comparison
- Side-by-side vulnerability-to-control mapping.
- Before/after behavior for key exploit paths.
- Before/after ZAP findings summary.

## VI. DevSecOps Pipeline Implementation
- SAST: CodeQL + Semgrep custom rules.
- SCA: npm audit and Snyk policy gate.
- Secrets detection: GitLeaks and TruffleHog.
- Container scanning: Trivy configuration.
- DAST: ZAP baseline/full scans and CI gate.
- Runtime monitoring: Falco custom rules.

## VII. Continuous Monitoring Stack
- Prometheus metrics and alert rules.
- Loki log ingestion strategy.
- Grafana dashboards and alert-driven triage.

## VIII. Evaluation and Results
- Test plan execution results (TC-01 to TC-10).
- ZAP delta findings before vs after hardening.
- Representative Falco alerts and operational response.

## IX. SPTI Course Concepts Mapping
- Formal mapping table from course concepts to implemented artifacts.
- Discussion of SGSI and risk governance integration.

## X. Conclusions and Future Work
- Summary of security posture improvement.
- Remaining gaps and roadmap (secret rotation, SOAR integration).

## References
- OWASP Top 10 (2021)
- NIST Cybersecurity Framework
- Falco Documentation
- OWASP ZAP Documentation
- SPTI Course Materials
