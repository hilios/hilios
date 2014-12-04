package server

import "net/http"

const PROD = "prod"

type Config struct {
	Env, Static string
}

func (c *Config) Routes() *http.ServeMux {
	mux := http.NewServeMux()
	// Setup development environment
	if c.Env != PROD {
		// Serve static files
		mux.Handle("/", http.FileServer(http.Dir(c.Static)))
		// Start gulp
		gulp(c.Static)
	}
	// Proxy Tumblr API
	mux.HandleFunc("/t/", TumblrProxyHandler)

	return mux
}
