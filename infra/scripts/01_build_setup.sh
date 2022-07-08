#!/bin/bash

buildAndRunAlertApp() {

  echo "Building Docker image for alert app..."  
  docker build \
    --tag $appName \
    "../../apps/alert-app"
  echo -e "Docker image for alert app is build successfully.\n"

  # Run Docker image of alert app
  echo "Starting Docker image for alert app..."
  docker run \
    -d \
    --rm \
    --name $appName \
    -e NEWRELIC_LICENSE_KEY=$NEWRELIC_LICENSE_KEY \
    -p 8080:8080 \
    $appName
    echo -e "Docker image for alert app is running successfully.\n"
}

checkAppReadiness() {
  echo "Checking if app is up and running..."
  while true
  do  

    # Check health endpoint
    isAppReady=$(curl -X GET http://localhost:8080/health \
      2> /dev/null \
      | jq .message)

    if [[ isAppReady == "OK" ]]; then
      echo -e "Ready!\n"
      break
    else
      echo "Not ready!"
    fi

    # Wait 2 seconds in between every check
    sleep 2
  done
}

makeRestCall() {

  local value=$1

  echo -e "---\n"

  curl -X POST "http://localhost:8080/value" \
    -i \
    -H "Content-Type: application/json" \
    -d \
    '{
        "value": "'"${value}"'"
    }'

  echo -e "\n"
  sleep 2
}

# Set variables
appName="alert-app"

buildAndRunAlertApp

checkAppReadiness

while true
do
  # 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200

  # 400
  makeRestCall 400

  # 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200
  makeRestCall 200

  # 500
  makeRestCall 500
done
