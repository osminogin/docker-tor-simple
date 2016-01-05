FROM debian:latest
MAINTAINER Vladimir Osintsev <oc@co.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install --no-install-recommends \
	supervisor \
	nginx \
	tor

COPY supervisord.conf /etc/supervisor/conf.d/services.conf

EXPOSE 9050

VOLUME ["/var/lib/tor", "/var/cache/nginx", "/etc/supervisor/conf.d"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/services.conf"]
