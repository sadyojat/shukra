package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/ping", pingResponse)
	r.Run()
}

func pingResponse(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "pong",
	})
}

// func handler(w http.ResponseWriter, r *http.Request) {
// 	fmt.Fprint(w, "Hi There ", r.URL.Path[1:])
// }

// func ginHandler(_ http.ResponseWriter, _ *http.Request) {
// 	r := gin.Default()
// 	r.GET("/ping", func(c *gin.Context) {
// 		c.JSON(200, gin.H{
// 			"message": "pong",
// 		})
// 	})
// }
