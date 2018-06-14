FROM golang:1.10 as builder

RUN git clone --branch "v1.1" --single-branch --depth 1 \
    https://github.com/korylprince/fileenv.git /go/src/github.com/korylprince/fileenv

RUN go install github.com/korylprince/fileenv

FROM ubuntu:18.04

ARG VERSION

COPY --from=builder /go/bin/fileenv /

RUN mkdir -p /cups/etc /cups/spool && \
    ln -s /cups/etc /etc/cups && \
    ln -s /cups/spool /var/spool/cups

RUN apt-get update && apt-get install -y  --no-install-recommends \
    ca-certificates \
    cups=${VERSION}-\* \
    cups-filters \
    hplip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /plugin && \
    cd /plugin && \
    wget https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-$(dpkg-query --showformat='${Version}' --show hplip|cut -d "+" -f1)-plugin.run && \
    sh *-plugin.run --target . --noexec && \
    python3 installPlugin.py && \
    cd / && \
    rm -Rf /plugin

COPY run.sh /

CMD ["/fileenv", "sh", "/run.sh"]
