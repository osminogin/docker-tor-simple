# docker-tor-simple

[![](https://img.shields.io/badge/Tor%20version-0.4.2.5-green.svg)](https://github.com/torproject/tor/releases) [![](https://img.shields.io/docker/build/osminogin/tor-simple.svg)](https://hub.docker.com/r/osminogin/tor-simple/builds/) [![](https://images.microbadger.com/badges/image/osminogin/tor-simple.svg)](https://microbadger.com/images/osminogin/tor-simple) [![](https://img.shields.io/docker/stars/osminogin/tor-simple.svg)](https://hub.docker.com/r/osminogin/tor-simple)  [![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

**Smallest minimal docker container for Tor network proxy daemon.**

Suitable for relay, exit node or hidden service modes with SOCKS5 proxy enabled. It works well as a single self-contained container or in cooperation with other containers (like `nginx` and `osminogin/php-fpm`) for organizing complex hidden services on the Tor network.

The image is based on great [Alpine Linux](https://alpinelinux.org/) distribution so it is has extremely low size (about 6 MB).

Service uses latest available version of [Tor package](https://pkgs.alpinelinux.org/package/edge/community/x86_64/tor) from [Edge repo](https://wiki.alpinelinux.org/wiki/Edge).

## Tags

``latest``: Latest available Alpine Edge package.

``source``: From sources build (work in progress so if you can be interested - contact me).


## Ports

* `9050` SOCKSv5 (without auth)

## Volumes

* `/var/lib/tor` data dir.


## Getting started

### Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/osminogin/tor-simple/) and is the recommended method of installation.

```bash
docker pull osminogin/tor-simple
```

Alternatively you can build the image yourself.

```bash
export PROJECT_NAME=tor-node   # docker image name
make build DOCKER_IMAGE=$PROJECT_NAME
```


### Quickstart

```bash
export PROJECT_NAME=tor-local   # changing default name
make build DOCKER_IMAGE=$PROJECT_NAME
make run

# or with docker-compose ...
docker-compose up

# or altenativly run docker directly ...
docker run -publish 127.0.0.1:9050:9050 -i $PROJECT_NAME
```

After start Tor proxy available on `localhost:9050`

**Warning**:exclamation::exclamation::exclamation:

Don't bind SOCKSv5 port 9050 to public network addresses if you don't know exactly what you are doing (better bind to localhost as in the example above).


## Advanced usage

You can copy original tor config from container, modify and mount them back inside. Changing the configuration file is required for running Tor as exit node, relay or bridge. For some operation modes you need to expose additional ports (9001, 9030, 9051).

```bash
export DOCKER_IMAGE=osminogin/tor-simple
# Copy config  from running container
docker cp tor:/etc/tor/torrc $HOME/torrc
# ... modify torrc and run again

# Start more complex example with updated config
docker run --rm --name tor \
	--publish 127.0.0.1:9050:9050 \
	--expose 9001 --publish 9001:9001 \ # ORPort
	--expose 9030 --publish 9030:9030 \
	--expose 9051 --publish 9051:9051 \
	--volume $HOME/torrc:/etc/tor/torrc:ro \
	$DOCKER_IMAGE
```

## Unit file for systemd

#### tor.service

```ini
[Unit]
Description=Tor service
Wants=network-online.target
Requires=docker.service
After=docker.service network.target network-online.target

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=10s
ExecStartPre=/usr/bin/docker pull osminogin/tor-simple
ExecStart=/usr/bin/docker run --rm --name tor -p 127.0.0.1:9050:9050 osminogin/tor-simple
ExecStop=/usr/bin/docker stop tor

[Install]
WantedBy=multi-user.target
```


## Examples

Example webserver deployment config with microservice architecture to setup Tor hidden service.


#### docker-compose.yml

```yaml
version: '3.7'
services:

  tor-node:
    image: osminogin/tor-simple
    restart: always
    depends_on:
      - nginx

  nginx:
    image: nginx
    restart: always
    links:
      - drupal:drupalhost
    volumes:
      - /srv/drupal:/srv/www:ro
      - /srv/nginx/nginx.conf:/etc/nginx/nginx.conf:ro

  drupal:
    image: osminogin/php-fpm
    restart: always
    links:
      - mysql:mysqlhost
    volumes:
      - /srv/drupal:/srv/www

mysql:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: changeme
```


## License

See [LICENSE.md](https://github.com/osminogin/docker-tor-simple/blob/master/LICENSE.md)
