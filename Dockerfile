FROM debian:latest
MAINTAINER Vladimir Osintsev <oc@co.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install \
	tor

EXPOSE 9050
VOLUME ["/etc/tor/torrc", "/var/lib/tor"]

CMD /usr/bin/tor
