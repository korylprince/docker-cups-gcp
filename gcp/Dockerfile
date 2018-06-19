FROM ubuntu:18.04 as builder

RUN apt-get update
RUN apt-get install -y --no-install-recommends golang git bzr build-essential ca-certificates libcups2-dev libavahi-client-dev

RUN git clone --branch "v1.1" --single-branch --depth 1 \
    https://github.com/korylprince/fileenv.git /go/src/github.com/korylprince/fileenv

RUN git clone --branch "dev" --single-branch --depth 1 \
    https://github.com/korylprince/cloud-print-connector.git  /go/src/github.com/google/cloud-print-connector

ENV GOPATH=/go

RUN go install github.com/korylprince/fileenv
RUN go get github.com/google/cloud-print-connector/...

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates jq libcups2 libavahi-client3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/fileenv /
COPY --from=builder /go/bin/gcp-connector-util /
COPY --from=builder /go/bin/gcp-cups-connector /

COPY gcp-cups-connector.config.json.tmpl /

COPY run.sh /

CMD ["/fileenv", "sh", "/run.sh"]
