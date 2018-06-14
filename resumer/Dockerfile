FROM golang:1.10-alpine as builder

RUN apk add --no-cache git

RUN git clone --branch "v1.0" --single-branch --depth 1 \
    https://github.com/korylprince/run-every.git /go/src/github.com/korylprince/run-every

RUN go install github.com/korylprince/run-every

FROM alpine:3.7

COPY --from=builder /go/bin/run-every /

RUN apk add --no-cache cups-client

COPY resume.sh /

CMD ["/run-every", "1m", "/resume.sh"]
