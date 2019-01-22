FROM ubuntu:18.04 as builder

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends golang git ca-certificates

RUN git clone --branch "v1.1" --single-branch --depth 1 \
    https://github.com/korylprince/fileenv.git /go/src/github.com/korylprince/fileenv

ENV GOPATH=/go

RUN go install github.com/korylprince/fileenv

FROM ubuntu:18.04

ARG VERSION

COPY --from=builder /go/bin/fileenv /

RUN mkdir -p /cups/etc /cups/spool && \
    ln -s /cups/etc /etc/cups && \
    ln -s /cups/spool /var/spool/cups

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  --no-install-recommends \
    ca-certificates \
    cups=2.2.7-\* \
    cups-filters \
    libavahi-client3 && \
    rm -rf /var/lib/apt/lists/*

COPY linux-UFRII-drv-v370-uken-05.tar.gz /

RUN mkdir /install && \
    tar xzf /linux-UFRII-drv-v370-uken-05.tar.gz -C /install && \
    cd install/linux-UFRII-drv-v370-uken && \
    echo "y" | bash ./install.sh && \
    rm -Rf /install /linux-UFRII-drv-v370-uken-05.tar.gz

COPY run.sh /

CMD ["/fileenv", "sh", "/run.sh"]
