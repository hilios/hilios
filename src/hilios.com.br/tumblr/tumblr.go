package tumblr

import (
	"fmt"
	"log"
	"io"
	"io/ioutil"
	"net/http"
	"regexp"
)

var path = regexp.MustCompile("^/tumblr(/.*)$")

const ApiKey string = ""

func ProxyHandler(w http.ResponseWriter, r *http.Request) {
	// Parse the API url
	p := path.FindStringSubmatch(r.URL.Path)
	url := fmt.Sprintf("http://api.tumblr.com%s", p[1])
	// Creates a new request
	t, _ := http.NewRequest(r.Method, url, nil)
	// Inject the API key to the url
	t.URL.RawQuery = fmt.Sprintf("api_key=%s&%s", ApiKey, t.URL.RawQuery)
	// Print a log
	log.Println(t.URL.String());
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
	// Dump the body to Request
	io.WriteString(w, string(body))
}
