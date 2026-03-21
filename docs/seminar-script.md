# Seminar Script: Continuous Monitoring and Threat Detection in Production

## Session Metadata

- Course: IT Security and Privacy (SPTI)
- Topic: DevSecOps Continuous Monitoring and Threat Detection in Production
- Target duration: 20-25 minutes
- Audience: Undergraduate IT/Security students

## Speaking Plan (Suggested Timing)

### 1) Opening (2 minutes)

"DevSecOps is often reduced to static scans in CI. But attackers do not care about our pipeline. They attack production. This seminar explains how to detect and respond continuously, not occasionally."

Main message:

- Security must operate as a production capability.
- Monitoring quality determines incident impact.

### 2) Core Problem (3 minutes)

Explain typical failure pattern:

- Teams deploy quickly but detect slowly.
- Data exists but is fragmented.
- Alerts are noisy and ignored.
- Incidents repeat because lessons are not fed back into development.

Key sentence:

"If we only prevent and never detect, we are blind when prevention fails."

### 3) DevSecOps Detection Loop (4 minutes)

Walk through the lifecycle:

1. Secure design and shift-left controls.
2. Runtime telemetry collection in production.
3. Detection and triage.
4. Containment and response.
5. Post-incident learning and engineering improvements.

Key sentence:

"A mature DevSecOps team closes the loop between code and incidents."

### 4) High-Value Threat Scenarios (5 minutes)

Present 4 scenarios with one practical signal each:

1. Credential abuse:
- Signal: impossible-travel login + privilege change within short time window.

2. API abuse:
- Signal: burst of failed token validations + unusual endpoint access pattern.

3. Container compromise:
- Signal: unexpected shell process inside application container.

4. Data exfiltration:
- Signal: unusual outbound transfer volume to rare destination.

For each scenario:

- Telemetry source
- Detection rule idea
- First response action

### 5) Metrics That Matter (4 minutes)

Introduce measurable outcomes:

- MTTD (Mean Time to Detect)
- MTTR (Mean Time to Respond/Recover)
- False positive rate
- Detection coverage by scenario
- Recurrence of same incident class

Key sentence:

"Without metrics, monitoring is activity; with metrics, monitoring becomes capability."

### 6) 30-60-90 Day Plan (4 minutes)

- 30 days: telemetry baseline, ownership, critical detections.
- 60 days: tuning and incident runbooks.
- 90 days: automation and continuous validation.

Close with:

"The objective is not perfect security in 90 days. The objective is reliable progress and reduced attacker dwell time."

### 7) Closing (2-3 minutes)

Final idea:

- Prevention reduces probability.
- Detection and response reduce impact.
- DevSecOps requires both in a continuous feedback loop.

Ask the audience:

"If an incident starts right now in production, do we know who detects it, how fast, and what happens next?"

## Optional Q&A Prompts

- Which telemetry source gives the fastest security value in your environment?
- How do you prioritize detection rules with limited team capacity?
- When should security response be automated versus manual?

## Delivery Tips

- Use one real example per section.
- Prefer concrete signals over abstract definitions.
- Keep vendor names secondary; emphasize architecture and process.
- End with measurable next steps, not generic recommendations.
