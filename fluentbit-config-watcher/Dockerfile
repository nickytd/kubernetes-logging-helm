FROM golang:1.17 as golang

ADD . $GOPATH/src/fluentbit-config-watcher/

WORKDIR $GOPATH/src/fluentbit-config-watcher/
RUN go mod tidy && go build -o fluentbit-config-watcher .

FROM busybox:stable-glibc
COPY --from=golang /go/src/fluentbit-config-watcher/fluentbit-config-watcher /
ENTRYPOINT ["/fluentbit-config-watcher"]
