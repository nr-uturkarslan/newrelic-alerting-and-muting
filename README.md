# Introduction

This repository is dedicated to mute and unmute alert notification channels programmatically when the notification endpoints on which the alerts are configured are getting under maintenance.

## Prerequisites

- New Relic API Key
- Docker
- curl
- jq
- sed

# Setup

## 1. Build test environment

In order to demonstrate how alerts are managed, a custom app is being deployed. This app is a simple GO app which acts as a server.

This server exposes 3 endpoints where they are returning 200, 400 and 500, respectively.

In order to trigger these endpoints, a simulator is created which is making HTTP calls every 2 seconds to each of these endpoints.

The script which deploys what's mentioned above is `01_build_setup.sh`.

## 2. Create alert and notification channel

After having the custom app deployed and after the simulator starts to trigger the app, the alert policy and condition can be created.

The alert policy is intentionally declared with flag `PER_CONDITION_AND_TARGET` so that a notification is sent every time an incident occurs.

The alert condition has following the NRQL query `FROM Transaction SELECT count(*) WHERE appName = 'alert-app' AND (http.statusCode = 400 OR http.statusCode = 500)` and is configured to go off every time an incident occurs.

The notification channel is chosen to be email for the sake of simplicity. This channel is then binded to the alert policy.

The script which deploys what's mentioned above is `02_create_alerts.sh`.

In order to see that the alert is working, you can wait about 5 minutes.

## 3. Create muting rule

Every step until this point represents a typical application deployment with some monitoring/alerting.

Now, it's time to consider the maintenance of the notification endpoint. Shortly said, the notification endpoint will not be available for a while.

The underlying logic within New Relic's alerting a notification channel is (at the time of this writing) as follows:
- The alert gets triggered.
- The alert triggers the notification channel.
- The notification channel tries to send the alert to the notification endpoint.
- If it fails, it tries to send it again after some time.
- After failing for a while, it snoozes itself for 2 hours.
- Even though the notification endpoint start to run again, the New Relic backend does not try to send anything.
- So the alerts are getting triggered meanwhile, but no notification is sent.

In order to send those notifications, the muting rule is introduced. With muting rule, the alert gets triggered and can be seen as an incident in the UI but it does not send any notification. So the New Relic backend does not enter the snoozing period.

This muting rule has to be created manually before the maintenance starts. The script for that is `03_create_muting_rule.sh`.

## 4. Reset alerts and delete muting rule

The maintainer knows when the maintenance starts and ends. So, the persona who has created the rule before the maintenance start, should reset the configuration back to normal when it ends.

In order to get all the notifications which are muted during the maintenance:
1. the alert condition should be disabled
2. the muting rule should be deleted
3. the alert condition should be enabled back again

Thereby, the issues which are generated during the maintenance are automatically closed and after the re-enablement of the alert condition, the issue will go off again when the incident occurs.

Since there are no snoozing or muting rule anymore, the notification channel gets the alert notification.
