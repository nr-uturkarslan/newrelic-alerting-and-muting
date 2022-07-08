#!/bin/bash

accountId="<YOUR_ACCOUNT_ID>"
mutingRuleName="Shut the hell up"
alertConditionId="<YOUR_ALERT_CONDITION_ID>"

# Time Format -> "YYYY-MM-DDThh:mm:ss" (e.g. "2022-07-10T14:00:00")
startTime="<YOUR_START_TIME>"
endTime="<YOUR_END_TIME>"

curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_LICENSE_KEY" \
  --data-binary '{"query":"mutation {\n  alertsMutingRuleCreate(accountId: "'"$accountId"'", rule: {condition: {conditions: {attribute: \"conditionId\", operator: EQUALS, values: \"1571667\"}, operator: AND}, enabled: true, name: \""'"$mutingRuleName"'"\", schedule: {startTime: \"2022-07-10T14:00:00\", endTime: \"2022-07-10T15:00:00\", timeZone: \"Europe/Berlin\"}}) {\n    id\n  }\n}\n", "variables":""}'