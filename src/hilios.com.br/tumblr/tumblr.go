package tumblr

import (
	"fmt"
	// "github.com/golang/oauth2"
	"io/ioutil"
	"net/http"
	"regexp"
)

var path = regexp.MustCompile("^/tumblr(/.*)$")

type tumblrRequest struct {
	ApiKey string
	Method string
}

func ProxyHandler(w http.ResponseWriter, r *http.Request) {
	// Parse the API url
	p := path.FindStringSubmatch(r.URL.Path)
	url := "http://api.tumblr.com" + p[1]

	// Creates a new request
	t, _ := http.NewRequest(r.Method, url, nil)

	t.Header.Add("api_key", "")
	// Do the request
	c := http.Client{}
	res, err := c.Do(t)

	if err != nil {
		http.Error(w, err.Error(), 403)
	}

	defer res.Body.Close()

	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		http.Error(w, err.Error(), 403)
	}

	fmt.Fprint(w, string(body))
	// io.WriteString(w, string(body))
}
