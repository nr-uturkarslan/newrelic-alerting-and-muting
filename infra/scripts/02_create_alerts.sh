#!/bin/bash

accountId="<YOUR_ACCOUNT_ID>"
alertPolicyName="My Undisputed Alert Policy"
alertConditionName="My Undisputed Alert Condition"
alertConditionId="<YOUR_ALERT_CONDITION_ID>"

# Create alert policy
curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_LICENSE_KEY" \
  --data-binary '{"query":"mutation {\n  alertsPolicyCreate(accountId: "'"$accountId"'", policy: {name: \""'"$alertPolicyName"'"\", incidentPreference: PER_CONDITION}) {\n    id\n    name\n    incidentPreference\n  }\n}\n", "variables":""}'

# Create alert condition
curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_LICENSE_KEY" \
  --data-binary '{"query":"mutation {\n  alertsNrqlConditionStaticCreate(accountId: "'"$accountId"'", policyId: "'"$alertPolicyId"'", condition: {enabled: false, name: \""'"$alertConditionName"'"\", description: null, nrql: {query: \"SELECT count(apm.service.error.count) / count(apm.service.transaction.duration) FROM Metric WHERE (entity.guid = \u0027MzM2ODQ2NXxBUE18QVBQTElDQVRJT058NDU1NzQzNTU5\u0027)\"}, expiration: null, runbookUrl: null, signal: {aggregationDelay: 120, aggregationMethod: EVENT_FLOW, aggregationTimer: null, fillValue: null, aggregationWindow: 60, fillOption: NONE, slideBy: null}, terms: [{operator: BELOW_OR_EQUALS, threshold: 1, priority: CRITICAL, thresholdDuration: 60, thresholdOccurrences: AT_LEAST_ONCE}], violationTimeLimitSeconds: 259200}) {\n    id\n  }\n}\n", "variables":""}'
