package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/newrelic/go-agent/v3/integrations/nrgin"
	"github.com/newrelic/go-agent/v3/newrelic"
)

type requestDto struct {
	Value int `json:"value"`
}

type responseDto struct {
	Message string `json:"message"`
}

func createHandlers(
	router *gin.Engine,
	nrapp *newrelic.Application,
) {

	log.Println("Creating HTTP handlers...")

	router.Use(nrgin.Middleware(nrapp))

	router.GET("/health", healthHandler)
	router.POST("/value", valueHandler)

	log.Println("HTTP handlers are created successfully.")
}

func healthHandler(ginctx *gin.Context) {
	ginctx.JSON(http.StatusOK, gin.H{
		"message": "OK!",
	})
}

func valueHandler(ginctx *gin.Context) {

	log.Println("Processing request...")

	// Parse request body
	requestDto, err := parseRequestBody(ginctx)
	if err != nil {
		return
	}

	switch requestDto.Value {

	// Bad Request
	case http.StatusBadRequest:
		ginctx.JSON(http.StatusBadRequest, responseDto{
			Message: "400: Bad Request",
		})

	// Internal Server Error
	case http.StatusInternalServerError:
		ginctx.JSON(http.StatusInternalServerError, responseDto{
			Message: "500: Internal Server Error",
		})

	// OK
	default:
		ginctx.JSON(http.StatusOK, responseDto{
			Message: "200: OK",
		})
	}

	log.Println("Request is processed successfully.")
}

func parseRequestBody(
	ginctx *gin.Context,
) (
	*requestDto,
	error,
) {

	// Parse request body
	var requestDto requestDto
	err := ginctx.BindJSON(&requestDto)

	// Log error if occurs
	if err != nil {

		log.Println("Request body could not be parsed.")

		responseDto := responseDto{
			Message: "400 -> Bad Request",
		}

		ginctx.JSON(http.StatusBadRequest, responseDto)

		return nil, err
	}

	return &requestDto, nil
}
