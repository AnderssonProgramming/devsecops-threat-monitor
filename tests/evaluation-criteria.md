# Evaluation Criteria - Security Controls Validation

## Scoring Rubric

| Score | Interpretation |
|---|---|
| 0 | Control absent or failed |
| 1 | Control partially implemented, ineffective under test |
| 2 | Control implemented and effective, minor evidence gaps |
| 3 | Control fully implemented, validated, and evidenced |

## Control-by-Control Criteria

| Control | Related Tests | Minimum Passing Score | Evidence Required |
|---|---|---|---|
| JWT protection for API and sockets | TC-01, TC-02, TC-09 | 2 | Test logs + screenshots + config snippet |
| Webhook bearer auth | TC-01, TC-03 | 2 | HTTP status logs + middleware output |
| Rate limiting | TC-03 | 2 | 429 evidence + request counts |
| Secure headers with Helmet | TC-05 | 2 | Header dump (`curl -I`) |
| Safe exception handling | TC-10 | 2 | Sanitized response body samples |
| Dependency and secret scanning | TC-06, TC-07 | 2 | CI artifacts, scan summaries |
| Runtime anomaly detection | TC-08 | 2 | Falco alert in Loki/Grafana |
| DAST continuous checks | TC-04, TC-05 | 2 | ZAP report and parser output |

## Final Grade Threshold

- Demo-ready: average score >= 2.0 and no score of 0 in critical controls.
- Academic excellence target: average score >= 2.5 with complete evidence package.

## SPTI Mapping

- Risk Management: weighted control scoring for prioritization.
- SGSI: traceable evidence and repeatable acceptance criteria.
- Data Protection: explicit validation of confidentiality and integrity controls.
