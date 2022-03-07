package main

import (
	"crypto/sha256"
	"fmt"
	"github.com/go-kit/kit/log"
	"io"
	"io/ioutil"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"
)

var logger = log.NewLogfmtLogger(os.Stdout)


// fluentbit-config-watcher calculates hashes of fluentbit configuration files and
// sends SIGTERM signal to fluentbit when a change is detected
// fluent-bit doesn't implement a configuration reload hence a restart is needed to load the new configurations
// The fluentbit-config-watcher is deployed as a sidecar sharing the same process space
// with the fluentbit container in the pod

func main() {

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	done := make(chan bool, 1)

	go func() {
		sig := <-sigs
		logger.Log("receivedSignal", sig)
		done <- true
	}()

	go func() {
		var hash = "notset"
		for {
			logger.Log("hash", hash)
			if hash != getSha256() {
				pid := getFluentbitPID()
				if pid != nil {
					logger.Log("fluentbitProcessId", pid.Pid)
					if p, err := os.FindProcess(pid.Pid); err != nil {
						logger.Log("error", err.Error())
					} else {
						if err := p.Signal(syscall.SIGTERM); err != nil {
							logger.Log("error", err.Error())
						} else {
							hash = getSha256()
						}
					}
				} else {
					logger.Log("msg", "fluentbit not found")
				}
			}
			time.Sleep(time.Second * 5)
		}
	}()

	<-done
	logger.Log("exiting")

}

func getFluentbitPID() *os.Process {

	dir, err := os.ReadDir("/proc")
	if err != nil {
		logger.Log("error", err.Error())
		os.Exit(-1)
	}

	for _, f := range dir {
		if f.IsDir() {
			if pid, err := strconv.Atoi(f.Name()); err == nil {
				if content, err := ioutil.ReadFile("/proc/" + f.Name() + "/cmdline"); err != nil {
					logger.Log("error", err.Error())
					continue
				} else {
					if strings.Contains(string(content), "/fluent-bit/bin/fluent-bit") {
						return &os.Process{
							Pid: pid,
						}
					} else {
						logger.Log("cmdline", content)
					}
				}
			}
		}
	}
	return nil
}

func getSha256() string {
	dir, err := os.ReadDir("/fluent-bit/etc/")
	if err != nil {
		logger.Log("error", err.Error())
	}
	b := strings.Builder{}
	for _, f := range dir {
		if f.IsDir() {
			continue
		}
		h := sha256.New()
		t, err := os.Open("/fluent-bit/etc/" + f.Name())
		if err != nil {
			logger.Log("error", err.Error())
			continue
		}
		if _, err := io.Copy(h, t); err != nil {
			logger.Log("error", err.Error())
			continue
		}
		t.Close()
		s := fmt.Sprintf("%x", h.Sum(nil))
		logger.Log(f.Name(), fmt.Sprintf("%x", h.Sum(nil)))
		b.Grow(len(s))
		b.WriteString(s)
	}
	return fmt.Sprintf("%x", sha256.Sum256([]byte(b.String())))
}
