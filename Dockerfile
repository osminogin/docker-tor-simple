FROM debian:latest
MAINTAINER Vladimir Osintsev <oc@co.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install --no-install-recommends tor
RUN sed -i "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc

EXPOSE 9050

VOLUME "/var/lib/tor"
CMD "/usr/bin/tor"
