FROM ubuntu:18.04 as builder

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends golang git bzr build-essential ca-certificates libcups2-dev libavahi-client-dev

RUN git clone --branch "v1.1" --single-branch --depth 1 \
    https://github.com/korylprince/fileenv.git /go/src/github.com/korylprince/fileenv

RUN git clone --branch "master" --single-branch --depth 1 \
    https://github.com/google/cloud-print-connector.git  /go/src/github.com/google/cloud-print-connector

ENV GOPATH=/go

RUN go install github.com/korylprince/fileenv
RUN go get github.com/google/cloud-print-connector/...

FROM ubuntu:18.04

ARG VERSION

COPY --from=builder /go/bin/fileenv /
COPY --from=builder /go/bin/gcp-connector-util /
COPY --from=builder /go/bin/gcp-cups-connector /

COPY gcp-cups-connector.config.json.tmpl /

RUN mkdir -p /cups/etc /cups/spool && \
    ln -s /cups/etc /etc/cups && \
    ln -s /cups/spool /var/spool/cups

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  --no-install-recommends \
    ca-certificates \
    cups=2.2.7-\* \
    cups-filters \
    hplip \
    jq \
    libavahi-client3 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /plugin && \
    cd /plugin && \
    wget https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-$(dpkg-query --showformat='${Version}' --show hplip|cut -d "+" -f1)-plugin.run && \
    sh *-plugin.run --target . --noexec && \
    python3 installPlugin.py && \
    cd / && \
    rm -Rf /plugin

COPY run.sh /

CMD ["/fileenv", "sh", "/run.sh"]
