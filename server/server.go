package server

import "net/http"

const PROD = "prod"

type Config struct {
	Env, Static string
}

func (c *Config) Routes() *http.ServeMux {
	mux := http.NewServeMux()
	// Serve static files if not production environment
	if c.Env != PROD {
		mux.Handle("/", http.FileServer(http.Dir(c.Static)))
	}
	// Proxy Tumblr API
	mux.HandleFunc("/t/", TumblrProxyHandler)

	return mux
}
