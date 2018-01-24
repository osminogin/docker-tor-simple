FROM alpine:edge

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="oc@co.ru" \
    com.microscaling.license="MIT" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Tor network client" \
    org.label-schema.url="https://www.torproject.org" \
    org.label-schema.vcs-url="https://github.com/osminogin/docker-tor-simple.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.docker.cmd="docker run -d --rm --publish 127.0.0.1:9050:9050 --name tor osminogin/tor-simple" \
    org.label-schema.schema-version="1.0"


RUN apk add --no-cache tor && \
    sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc

EXPOSE 9050

VOLUME ["/var/lib/tor"]

USER tor

CMD ["/usr/bin/tor"]
