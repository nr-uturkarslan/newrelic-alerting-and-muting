#!/bin/bash

accountId="YOUR_ACCOUNT_ID"
alertConditionId="YOUR_ALERT_CONDITION_ID"
mutingRuleId="YOUR_MUTING_RULE_ID"

#######################
### Alert Condition ###
#######################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsNrqlConditionStaticUpdate(accountId: '$accountId', condition: {enabled: false}, id: '$alertConditionId') {\n    id\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

# Disable alert condition
enableAlertCondition=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq)

echo "Alert condition with ID [$alertConditionId] is disabled temporarily."
#########

###################
### Muting Rule ###
###################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsMutingRuleDelete(accountId: '$accountId', id: \"'$mutingRuleId'\") {\n    id\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

# Delete muting rule
mutingRuleId=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq -r .data.alertsMutingRuleDelete.id)

echo "Muting rule with ID [$mutingRuleId] is deleted."
#########

#######################
### Alert Condition ###
#######################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsNrqlConditionStaticUpdate(accountId: '$accountId', condition: {enabled: true}, id: '$alertConditionId') {\n    id\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

# Disable alert condition
enableAlertCondition=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq)

echo "Alert condition with ID [$alertConditionId] is enabled back again."
#########
