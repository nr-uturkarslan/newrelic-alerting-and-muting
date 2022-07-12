#!/bin/bash

### Set variables ###

# Account
accountId="YOUR_ACCOUNT_ID"

# Alert policy
alertPolicyName='My Undisputed Alert Policy'

# Alert condition
alertConditionName="My Undisputed Alert Condition"
incidentPreference="PER_CONDITION"

# Notification channel
notificationChannelName="My Undisputed Notification Channel"
notificationChannelEmail="YOUR_NOTIFICATION_EMAIL"

####################
### Alert policy ###
####################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsPolicyCreate(accountId: '$accountId', policy: {incidentPreference: '$incidentPreference', name: \"'$alertPolicyName'\"}) {\n    id\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

# Create alert policy
alertPolicyId=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq -r .data.alertsPolicyCreate.id)

echo "Alert policy ID: $alertPolicyId"
#########

#######################
### Alert condition ###
#######################

# Set NerdGraph query
nrqlQuery="FROM Transaction SELECT count(*) WHERE appName = \u0027alert-app\u0027 AND (http.statusCode = 400 OR http.statusCode = 500)"
query='{"query":"mutation {\n  alertsNrqlConditionStaticCreate(accountId: '$accountId', policyId: '$alertPolicyId', condition: {enabled: true, name: \"'$alertConditionName'\", description: null, nrql: {query: \"'$nrqlQuery'\"}, expiration: null, runbookUrl: null, signal: {aggregationDelay: 120, aggregationMethod: EVENT_FLOW, aggregationTimer: null, fillValue: null, aggregationWindow: 60, fillOption: NONE, slideBy: null}, terms: [{operator: ABOVE, threshold: 1, priority: CRITICAL, thresholdDuration: 300, thresholdOccurrences: AT_LEAST_ONCE}], violationTimeLimitSeconds: 259200}) {\n    id\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

# Create alert condition
alertConditionId=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq -r .data.alertsNrqlConditionStaticCreate.id)

echo "Alert condition ID: $alertConditionId"
#########

############################
### Notification channel ###
############################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsNotificationChannelCreate(accountId: '$accountId', notificationChannel: {email: {emails: \"'$notificationChannelEmail'\", name: \"'$notificationChannelName'\", includeJson: true}}) {\n    error {\n      description\n      errorType\n    }\n    notificationChannel {\n      ... on AlertsEmailNotificationChannel {\n        id\n        name\n        config {\n          emails\n        }\n      }\n    }\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

# Create notification channel
notificationChannelId=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq -r .data.alertsNotificationChannelCreate.notificationChannel.id)

echo "Notification channel ID: $notificationChannelId"
#########

#########################
### Channel to Policy ###
#########################

# Set NerdGraph query
query='{"query":"mutation {\n  alertsNotificationChannelsAddToPolicy(policyId: '$alertPolicyId', accountId: '$accountId', notificationChannelIds: '$notificationChannelId') {\n    errors {\n      description\n      errorType\n    }\n    policyId\n  }\n}\n", "variables":""}'

# Clear the additional spaces
query=$(echo $query | sed 's/    /  /g')

errors=$(curl https://api.eu.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key: $NEWRELIC_API_KEY" \
  --data-binary "$query" \
  | jq .data.alertsNotificationChannelsAddToPolicy.errors)

echo $errors
#########
