package server

import (
	"log"
	"os"
	"os/exec"
)

// Start the gulp command concurrently to main thread.
func gulp(cwd string) {
	log.Println("Staring Gulp...")
	// Register Gulp Cmd and bind stdout and stderr
	cmd := exec.Command("gulp", "--cwd", cwd)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stdout
	// Start the command
	if err := cmd.Start(); err != nil {
		panic(err)
	}
}
