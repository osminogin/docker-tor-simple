FROM alpine:latest
LABEL maintainer="oc@co.ru"

RUN apk add --no-cache tor && \
    sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc

EXPOSE 9050

VOLUME ["/var/lib/tor"]
VOLUME ["/etc/tor/torrc"]

USER tor

CMD ["/usr/bin/tor"]
