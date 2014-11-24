package main

import (
	"fmt"
	"hilios.com.br/tumblr"
	"net/http"
)

func indexHanlder(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "hilios.com.br")
}

func main() {
	http.HandleFunc("/", indexHanlder)
	http.HandleFunc("/tumblr/", tumblr.ProxyHandler)
	http.ListenAndServe(":8000", nil)
}
