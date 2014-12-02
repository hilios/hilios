package main

import (
	"hilios/server"
	"net/http"
	"os"
)

const STATIC_PATH = "./static"

func main() {
	s := &server.Config{
		Env:    os.Getenv("ENV"),
		Static: STATIC_PATH,
	}

	http.ListenAndServe(":8000", s.Routes())
}
