#!/bin/bash

accountId="<YOUR_ACCOUNT_ID>"
alertConditionId="<YOUR_ALERT_CONDITION_ID>"

# Disable alert condition
curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_LICENSE_KEY" \
  --data-binary '{"query":"mutation {\n  alertsNrqlConditionStaticUpdate(accountId: "'"$accountId"'", condition: {enabled: false}, id: "'"$alertConditionId"'") {\n    id\n  }\n}\n", "variables":""}'

# Delete muting rule
