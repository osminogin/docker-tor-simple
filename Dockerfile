FROM debian:latest
MAINTAINER Vladimir Osintsev <oc@co.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install --no-install-recommends tor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc

EXPOSE 9050

VOLUME "/var/lib/tor"
USER debian-tor
CMD ["/usr/bin/tor"]
