#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function parseArguments(argv) {
  const inputPath = argv[2];
  if (inputPath) {
    return path.resolve(process.cwd(), inputPath);
  }
  return null;
}

function findLatestZapReport(reportsDir) {
  const files = fs
    .readdirSync(reportsDir)
    .filter((fileName) => fileName.startsWith('zap-report-') && fileName.endsWith('.json'))
    .sort()
    .reverse();

  if (files.length === 0) {
    throw new Error(`No ZAP JSON reports found in ${reportsDir}`);
  }

  return path.join(reportsDir, files[0]);
}

function normalizeRisk(risk) {
  const value = String(risk ?? '').toLowerCase();
  if (value === 'high') return 'High';
  if (value === 'medium') return 'Medium';
  if (value === 'low') return 'Low';
  return 'Informational';
}

function collectAlerts(reportJson) {
  const grouped = {
    High: [],
    Medium: [],
    Low: [],
    Informational: []
  };

  const sites = reportJson.site || [];
  for (const site of sites) {
    const alerts = site.alerts || [];
    for (const alert of alerts) {
      const risk = normalizeRisk(alert.riskdesc || alert.riskcode || alert.risk);
      grouped[risk].push({
        name: alert.alert || 'Unknown alert',
        instances: Array.isArray(alert.instances) ? alert.instances.length : 0,
        confidence: alert.confidence || 'Unknown'
      });
    }
  }

  return grouped;
}

function toMarkdownTable(groupedAlerts) {
  const rows = [
    '| Risk Level | Alert Name | Instances | Confidence |',
    '|---|---|---:|---|'
  ];

  const levels = ['High', 'Medium', 'Low', 'Informational'];
  for (const level of levels) {
    const alerts = groupedAlerts[level];
    if (alerts.length === 0) {
      rows.push(`| ${level} | _None_ | 0 | - |`);
      continue;
    }

    for (const alert of alerts) {
      rows.push(`| ${level} | ${alert.name} | ${alert.instances} | ${alert.confidence} |`);
    }
  }

  return rows.join('\n');
}

function countHighRisk(groupedAlerts) {
  return groupedAlerts.High.length;
}

function main() {
  const reportsDir = path.resolve(__dirname, '../reports');
  let reportPath;

  try {
    reportPath = parseArguments(process.argv) || findLatestZapReport(reportsDir);
  } catch (error) {
    console.error(`[ZAP] ${error.message}`);
    console.error('[ZAP] Run `bash dast/scripts/run-dast.sh` first, then re-run this parser.');
    process.exit(2);
  }

  const reportRaw = fs.readFileSync(reportPath, 'utf8');
  const reportJson = JSON.parse(reportRaw);
  const groupedAlerts = collectAlerts(reportJson);
  const markdown = toMarkdownTable(groupedAlerts);
  const highCount = countHighRisk(groupedAlerts);

  console.log('# OWASP ZAP Summary');
  console.log(`\nReport: ${reportPath}\n`);
  console.log(markdown);

  if (highCount > 0) {
    console.error(`\nHigh risk alerts detected: ${highCount}`);
    process.exit(1);
  }

  console.log('\nNo High risk alerts detected.');
}

main();
