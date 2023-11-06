FROM alpine:edge

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="osintsev@gmail.com" \
    org.label-schema.license="MIT" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Tor network client (daemon)" \
    org.label-schema.description="Tor network client (daemon) with simple usage" \
    org.label-schema.url="https://www.torproject.org" \
    org.label-schema.vcs-url="https://github.com/osminogin/docker-tor-simple" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.usage="https://github.com/osminogin/docker-tor-simple#getting-started" \
    org.label-schema.docker.cmd="docker run -d --rm --publish 127.0.0.1:9050:9050 --name tor osminogin/tor-simple" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.version=$VERSION

RUN apk add --no-cache curl tor && \
    sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc

EXPOSE 9050

HEALTHCHECK --interval=60s --timeout=15s --start-period=20s \
    CMD curl -x socks5h://127.0.0.1:9050 'https://check.torproject.org/api/ip' | grep -qm1 -E '"IsTor"\s*:\s*true'

VOLUME ["/var/lib/tor"]

USER tor

CMD ["tor"]
