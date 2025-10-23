# Builder image
FROM docker.io/alpine as BUILDER

ARG LITESTREAM_VERSION="0.5.2"

RUN apk add --no-cache curl jq tar

RUN curl -L https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM_VERSION}/litestream-${LITESTREAM_VERSION}-linux-amd64.tar.gz -o litestream.tar.gz && tar xzvf litestream.tar.gz
# Main image
FROM docker.io/louislam/uptime-kuma as KUMA

ARG UPTIME_KUMA_PORT=3001
WORKDIR /app
RUN mkdir -p /app/data

COPY --from=BUILDER /litestream /usr/local/bin/litestream
COPY litestream.yml /etc/litestream.yml
COPY run.sh /usr/local/bin/run.sh

EXPOSE ${UPTIME_KUMA_PORT}

CMD [ "/usr/local/bin/run.sh" ]
