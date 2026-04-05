# Unsecure Architecture - LogiFlow Attack Surface

This document describes the vulnerable baseline architecture used to demonstrate real-world risks in a production-like distributed system. Each finding is mapped to OWASP Top 10 (2021), STRIDE, and an estimated CVSS v3.1 base score.

## Vulnerability Register

| ID | Vulnerability | Location in LogiFlow | Attack Vector | OWASP Top 10 | STRIDE | CVSS (Estimated) | Severity |
|---|---|---|---|---|---|---|---|
| V-001 | Unauthenticated Socket.io rooms | logiflow/services/realtime/src/rooms.js | Any socket client emits `join:vehicle` without JWT and subscribes to live vehicle telemetry | A01:2021 Broken Access Control | Spoofing, Information Disclosure | 9.1 | Critical |
| V-002 | n8n webhook without authentication | logiflow/services/automation/n8n/workflows/traffic-event-trigger.json | Attacker discovers webhook URL and sends forged traffic events to manipulate routing | A07:2021 Identification and Authentication Failures | Spoofing, Tampering | 8.2 | High |
| V-003 | Missing rate limiting on webhook endpoint | logiflow/services/automation/mock-server/index.js | Request flood against `POST /webhooks/traffic-event` exhausts automation/optimizer resources | A05:2021 Security Misconfiguration | Denial of Service | 7.5 | High |
| V-004 | Secrets in environment variables without rotation policy | Multiple `.env.example` files | Flat long-lived secrets (`TELEGRAM_BOT_TOKEN`, `ANTHROPIC_API_KEY`, `GOOGLE_MAPS_API_KEY`, `JWT_SECRET`) with no rotation/audit trail | A02:2021 Cryptographic Failures | Information Disclosure, Repudiation | 6.5 | Medium |
| V-005 | Missing security headers on NestJS gateway | logiflow/services/gateway/src/main.ts | Browser-delivered responses lack key hardening headers; increases clickjacking and client-side abuse exposure | A05:2021 Security Misconfiguration | Tampering, Information Disclosure | 6.1 | Medium |
| V-006 | Verbose error responses in production | logiflow/services/gateway/src | Unhandled exceptions leak stack traces and internal paths that accelerate exploit chaining | A09:2021 Security Logging and Monitoring Failures | Information Disclosure | 5.9 | Medium |
| V-007 | Outdated dependencies with known CVEs | package.json files across services | Exploitation of known vulnerable transitive dependencies discovered via `npm audit` | A06:2021 Vulnerable and Outdated Components | Tampering, Elevation of Privilege | 6.8 | Medium |
| V-008 | No runtime anomaly detection on containers | Runtime platform (all containers) | Malicious command execution/persistence inside compromised containers remains undetected | A09:2021 Security Logging and Monitoring Failures | Elevation of Privilege, Repudiation | 8.0 | High |

## Vulnerability Details

### V-001 - Unauthenticated Socket.io Rooms
- Location: `logiflow/services/realtime/src/rooms.js`
- Problem: Room subscription flow trusts client input before authentication.
- Exploit path: attacker connects with no token and subscribes to predictable room pattern (`vehicle:{id}`).
- Impact: unauthorized exposure of near real-time fleet coordinates and route updates.

### V-002 - n8n Webhook Without Authentication
- Location: `logiflow/services/automation/n8n/workflows/traffic-event-trigger.json`
- Problem: automation flow forwards events without bearer protection.
- Exploit path: attacker forges webhook payloads to trigger fake incidents.
- Impact: operational disruption, rerouting chaos, and loss of dispatch integrity.

### V-003 - Missing Rate Limiting on Webhook Endpoint
- Location: `logiflow/services/automation/mock-server/index.js`
- Problem: no per-IP or token throttling.
- Exploit path: high-volume POST flood to webhook endpoint.
- Impact: degraded service, queue saturation, potential downtime in traffic automation and optimizer pipelines.

### V-004 - Unrotated Flat Secrets in Environment Variables
- Location: service-level environment templates and deployment settings.
- Problem: static secrets with no lifecycle policy.
- Exploit path: accidental leak in logs/screenshots or compromised CI runner.
- Impact: long-lived account compromise and difficult incident containment.

### V-005 - Missing Security Headers in NestJS Gateway
- Location: `logiflow/services/gateway/src/main.ts`
- Problem: Helmet not applied; lacks common hardening headers.
- Exploit path: weaker browser-side protections for API consumers or admin interfaces.
- Impact: increased exposure to clickjacking and content injection contexts.

### V-006 - Verbose Error Responses
- Location: `logiflow/services/gateway/src`
- Problem: default exception responses reveal internals.
- Exploit path: crafted malformed requests trigger stack trace disclosure.
- Impact: attackers gain internal package names, paths, and implementation hints.

### V-007 - Vulnerable/Outdated Dependencies
- Location: all service manifests.
- Problem: known CVEs remain reachable through direct or transitive dependencies.
- Exploit path: exploit public vulnerability signatures against exposed routes/processes.
- Impact: remote code execution, denial of service, or information leakage depending on package.

### V-008 - No Runtime Anomaly Detection
- Location: container runtime.
- Problem: absence of syscall-level detection and behavioral alerts.
- Exploit path: attacker lands in container and executes suspicious binaries/commands.
- Impact: delayed detection, larger blast radius, and poor forensic readiness.

## Course Context (SPTI)

This unsecure baseline is intentionally aligned with SPTI topics:
- Risk Management: concrete risk scoring and prioritization.
- Security Architecture Principles: demonstration of weak trust boundaries.
- SGSI: evidence of control gaps and monitoring deficiencies.
- Data Protection: explicit exposure paths for operational geolocation data.
