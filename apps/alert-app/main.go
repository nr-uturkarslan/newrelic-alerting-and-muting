package main

import (
	"github.com/gin-gonic/gin"
)

const PORT string = ":8080"

func main() {

	nrapp := createNewRelicAgent()

	router := gin.Default()
	createHandlers(router, nrapp)
	router.Run(PORT)
}
