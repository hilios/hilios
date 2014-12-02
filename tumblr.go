package tumblr

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/user"
	"regexp"
)

var conf map[string]interface{}

var path = regexp.MustCompile("/t(/.*)$")

// Load the JSON configuration from file system and export to conf variable.
// The `TUMBLR_CONFIG` enviroment variable allows to change the configuration
// path uppon execution, defaults to `~/.tumblr`.
func init() {
	var confPath string = os.Getenv("TUMBLR_CONFIG")
	// Use default configuration path
	if confPath == "" {
		usr, _ := user.Current()
		confPath = fmt.Sprintf("%s/.tumblr", usr.HomeDir)
	}
	// Read the file
	file, err := ioutil.ReadFile(confPath)
	// Panic if couldn't read the conf file
	if err != nil {
		panic(err)
	}
	// Decode JSON to conf var
	if err := json.Unmarshal(file, &conf); err != nil {
		panic(err)
	}
}

// Acts like a proxy server to Tumblr API to fetchs its results to the reponse.
// Uses the URL path after /t/ prefix to dispatch the request.
func ProxyHandler(w http.ResponseWriter, r *http.Request) {
	// Parse the API url
	p := path.FindStringSubmatch(r.URL.Path)
	url := fmt.Sprintf("http://api.tumblr.com%s", p[1])
	// Creates a new request
	t, _ := http.NewRequest(r.Method, url, nil)
	// Inject the API key to the url
	t.URL.RawQuery = fmt.Sprintf("api_key=%s&%s",
		conf["consumer_key"], t.URL.RawQuery)
	// Print a log
	log.Println(t.URL.String())
	// Do the request
	c := http.Client{}
	res, err := c.Do(t)
	// Complain if request couldn't be made
	if err != nil {
		http.Error(w, err.Error(), 400)
	}
	// Close the body eventually
	defer res.Body.Close()
	// Read the body
	body, err := ioutil.ReadAll(res.Body)
	// Complain if cannot read response body
	if err != nil {
		http.Error(w, err.Error(), 403)
	}
	// Dump body to the response
	io.WriteString(w, string(body))
}
