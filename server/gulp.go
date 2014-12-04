package server

import (
	"os"
	"os/exec"
	"os/signal"
)

func gulp(cwd string) {
	p := os.Getpid()
	// Register Gulp Cmd and bind stdout and stderr
	cmd := exec.Command("gulp", "--cwd", cwd)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stdout
	// Capture Ctrl+C and stop CPU profiler
	k := make(chan os.Signal, 1)
	signal.Notify(k, os.Interrupt, os.Kill)
	// Start the command
	if err := cmd.Start(); err != nil {
		panic(err)
	}
	// Wait for the kill signal in another thread
	go func(kill chan os.Signal) {
		for {
			// Release the signal after the function
			defer signal.Stop(kill)
			// Wait for it
			<-kill
			cmd.Process.Signal(os.Kill)
			// Kill main thread as well
			main, _ := os.FindProcess(p)
			main.Signal(os.Kill)
		}
	}(k)
}
