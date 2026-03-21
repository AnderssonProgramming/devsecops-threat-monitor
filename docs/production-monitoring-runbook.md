# Production Monitoring Runbook (DevSecOps)

## Purpose

This runbook defines a practical approach for continuous monitoring and threat detection in production systems operated with DevSecOps principles.

## Scope

- Production applications and APIs
- CI/CD and artifact promotion events
- Cloud control-plane and identity events
- Container/host runtime signals

## Roles and Ownership

- Detection Owner: maintains detection rules and tuning backlog.
- Incident Commander: coordinates response during active incidents.
- Service Owner: executes remediation in the affected application/service.
- Platform/SRE: supports containment, rollback, and recovery.

## Severity Model

- Sev 1: Active compromise of critical asset or confirmed exfiltration.
- Sev 2: High-confidence malicious activity, limited blast radius.
- Sev 3: Suspicious activity requiring investigation.
- Sev 4: Informational signal or low-risk anomaly.

## Monitoring Baseline Checklist

- Identity logs enabled and retained.
- Application auth/authz logs centralized.
- Infrastructure and runtime events collected.
- Network egress visibility available.
- CI/CD security events available (build provenance, signature checks).
- Time synchronization enforced across systems.

## Alert Triage Workflow

1. Validate alert fidelity.
2. Determine affected assets and business criticality.
3. Enrich with identity, network, and recent deployment context.
4. Classify severity.
5. Escalate to Incident Commander for Sev 1-2.
6. Trigger runbook action and document timeline.

## Initial Response Actions by Scenario

### Credential Abuse

- Invalidate sessions/tokens.
- Force credential reset and MFA re-challenge.
- Review privileged actions performed in time window.

### API Abuse

- Apply temporary rate limits or WAF rule.
- Block offending identities/IP ranges when confidence is high.
- Review anomalous endpoint sequence and payload patterns.

### Container Runtime Compromise

- Isolate workload from network.
- Capture volatile evidence (processes, connections, recent file writes).
- Redeploy from trusted immutable artifact.

### Data Exfiltration

- Restrict outbound channels from affected workload.
- Identify datasets accessed and potential data class.
- Initiate legal/compliance notification workflow if required.

## Evidence Collection Minimum

- Alert metadata and correlation ID
- Relevant logs (identity, app, infra, network)
- Timeline of attacker actions and responder actions
- Hashes/artifact versions/deployment records
- Screenshots or command outputs for critical steps

## Recovery and Hardening

- Restore from known-good state.
- Rotate exposed secrets and keys.
- Patch vulnerable dependency or misconfiguration.
- Add or improve detections for observed attacker technique.
- Create preventive backlog items in sprint planning.

## Post-Incident Review Template

- What happened?
- How was it detected?
- What slowed detection or response?
- Which controls failed or were missing?
- Which engineering changes prevent recurrence?
- Owner and due date for each improvement action

## KPI Dashboard (Weekly)

- MTTD trend
- MTTR trend
- False positive ratio
- Detection coverage by threat scenario
- Number of repeated incidents by root cause

## Continuous Improvement Cadence

- Weekly: detection tuning and noise reduction.
- Bi-weekly: simulation of one threat scenario.
- Monthly: report coverage and KPI progress to stakeholders.
- Quarterly: reassess threat model and telemetry baseline.

## Definition of Done for Monitoring Capability

- Critical assets mapped to telemetry.
- Top threat scenarios have tested detections.
- Sev 1-2 alerts have actionable runbooks.
- KPI dashboard is reviewed regularly.
- Incident learnings are converted into backlog items.
