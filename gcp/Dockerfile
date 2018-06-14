FROM golang:1.10-alpine as builder

ARG VERSION

RUN apk add --no-cache git bzr build-base avahi-dev cups-dev ca-certificates

RUN git clone --branch "v1.1" --single-branch --depth 1 \
    https://github.com/korylprince/fileenv.git /go/src/github.com/korylprince/fileenv

RUN git clone --branch "$VERSION" --single-branch --depth 1 \
    https://github.com/google/cloud-print-connector.git  /go/src/github.com/google/cloud-print-connector

RUN go install github.com/korylprince/fileenv
RUN go get github.com/google/cloud-print-connector/...

FROM alpine:3.7

RUN apk add --no-cache ca-certificates jq cups-libs avahi-libs

COPY --from=builder /go/bin/fileenv /
COPY --from=builder /go/bin/gcp-connector-util /
COPY --from=builder /go/bin/gcp-cups-connector /

COPY gcp-cups-connector.config.json.tmpl /

COPY run.sh /

CMD ["/fileenv", "sh", "/run.sh"]
