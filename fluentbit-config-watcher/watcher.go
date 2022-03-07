package main

import (
	"crypto/sha256"
	"flag"
	"fmt"
	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"
)

var logger = log.NewLogfmtLogger(os.Stdout)
var debug bool

// fluentbit-config-watcher calculates hashes of fluentbit configuration files and
// sends SIGTERM signal to fluentbit when a change is detected
// fluent-bit doesn't implement a configuration reload hence a restart is needed to load the new configurations
// The fluentbit-config-watcher is deployed as a sidecar sharing the same process space
// with the fluentbit container in the pod

func main() {

	flag.BoolVar(&debug, "debug", false, "enable debug logs")
	flag.Parse()

	if debug {
		logger = level.NewFilter(logger, level.AllowDebug())
	} else {
		logger = level.NewFilter(logger, level.AllowInfo())
	}

	logger = log.With(logger, "ts", log.DefaultTimestampUTC)
	level.Debug(logger).Log("msg", "starting")

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	done := make(chan bool, 1)

	go func() {
		sig := <-sigs
		level.Debug(logger).Log("receivedSignal", sig)
		done <- true
	}()

	ready := make(chan bool, 1)
	go waitForFluentbit(ready)

	go func() {
		<-ready
		hash := getSha256()
		for {
			level.Debug(logger).Log("hash", hash)
			if hash != getSha256() {
				pid := getFluentbitPID()
				if pid != nil {
					level.Debug(logger).Log("fluentbitProcessId", pid.Pid)
					if p, err := os.FindProcess(pid.Pid); err != nil {
						level.Error(logger).Log("error", err.Error())
					} else {
						if err := p.Signal(syscall.SIGTERM); err != nil {
							level.Error(logger).Log("error", err.Error())
						} else {
							hash = getSha256()
							level.Info(logger).Log("hash", hash)
						}
					}
				} else {
					level.Debug(logger).Log("msg", "fluentbit not found")
				}
			}
			time.Sleep(time.Second * 5)
		}
	}()

	<-done
	level.Info(logger).Log("msg", "exiting")

}

func getFluentbitPID() *os.Process {

	dir, err := os.ReadDir("/proc")
	if err != nil {
		level.Error(logger).Log("error", err.Error())
		os.Exit(-1)
	}

	for _, f := range dir {
		if f.IsDir() {
			if pid, err := strconv.Atoi(f.Name()); err == nil {
				if content, err := ioutil.ReadFile("/proc/" + f.Name() + "/cmdline"); err != nil {
					level.Debug(logger).Log("error", err.Error())
					continue
				} else {
					if strings.Contains(string(content), "/fluent-bit/bin/fluent-bit") {
						return &os.Process{
							Pid: pid,
						}
					} else {
						level.Debug(logger).Log("cmdline", content)
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
		level.Error(logger).Log("error", err.Error())
	}
	b := strings.Builder{}
	for _, f := range dir {
		if f.IsDir() {
			continue
		}
		h := sha256.New()
		t, err := os.Open("/fluent-bit/etc/" + f.Name())
		if err != nil {
			level.Error(logger).Log("error", err.Error())
			continue
		}
		if _, err := io.Copy(h, t); err != nil {
			level.Error(logger).Log("error", err.Error())
			continue
		}
		t.Close()
		s := fmt.Sprintf("%x", h.Sum(nil))
		level.Debug(logger).Log(f.Name(), fmt.Sprintf("%x", h.Sum(nil)))
		b.Grow(len(s))
		b.WriteString(s)
	}
	return fmt.Sprintf("%x", sha256.Sum256([]byte(b.String())))
}

func waitForFluentbit(ready chan bool) {

	for {
		resp, err := http.Get("http://localhost:2020/api/v1/health")
		if err != nil {
			level.Error(logger).Log("error", err.Error())
		} else {
			if resp.StatusCode == 200 {
				level.Debug(logger).Log("msg", "fluentbit is started")
				ready <- true
				return
			}
		}

		time.Sleep(time.Second * 5)
	}

}
