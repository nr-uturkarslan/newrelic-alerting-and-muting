package main

import (
	"log"
	"os"

	"github.com/newrelic/go-agent/v3/newrelic"
)

func createNewRelicAgent() *newrelic.Application {

	log.Println("Starting New Relic agent...")

	os.Setenv("NEW_RELIC_ENABLED", "true")
	os.Setenv("NEW_RELIC_LICENSE_KEY", os.Getenv("NEWRELIC_LICENSE_KEY"))
	os.Setenv("NEW_RELIC_APP_NAME", "alert-app")
	os.Setenv("NEW_RELIC_DISTRIBUTED_TRACING_ENABLED", "true")
	os.Setenv("NEW_RELIC_LOG", "stdout")

	nrapp, err := newrelic.NewApplication(
		newrelic.ConfigFromEnvironment(),
	)

	if err != nil {
		panic(err)
	}

	log.Println("New Relic agent is started successfully.")
	return nrapp
}
