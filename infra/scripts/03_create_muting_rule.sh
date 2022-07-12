#!/bin/bash

### Set variables ###

# Account
accountId="YOUR_ACCOUNT_ID"

# Alert condition
alertConditionId="YOUR_ALERT_CONDITION_ID"

# Muting Rule
mutingRuleName="Shut the hell up"

# Time Format -> "YYYY-MM-DDThh:mm:ss" (e.g. "2022-07-10T14:00:00")
startTime="YOUR_START_TIME"
endTime="YOUR_END_TIME"
timeZone="YOUR_TIME_ZONE"

###################
### Muting Rule ###
###################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsMutingRuleCreate(accountId: '$accountId', rule: {condition: {conditions: {attribute: \"conditionId\", operator: EQUALS, values: \"'$alertConditionId'\"}, operator: AND}, enabled: true, name: \"'$mutingRuleName'\", schedule: {startTime: \"'$startTime'\", endTime: \"'$endTime'\", timeZone: \"'$timeZone'\"}}) {\n    id\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

mutingRuleId=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq -r .data.alertsMutingRuleCreate.id)

echo $mutingRuleId
#########