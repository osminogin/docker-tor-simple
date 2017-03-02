# docker-tor-simple [![](https://images.microbadger.com/badges/image/osminogin/tor-simple.svg)](https://microbadger.com/images/osminogin/tor-simple)


Simplest minimal docker container for Tor anonymity software. The image is based on great [Alpine Linux](https://alpinelinux.org/) distribution so it is has extremely low size (less than 5 MB).

It works well as a single self-contained container or in cooperation with other containers (like `nginx` and `osminogin/php-fpm`) for organizing complex hidden services on the Tor network.

Star this project on Docker Hub: https://hub.docker.com/r/osminogin/tor-simple/


## Getting started

```bash
docker run -p 127.0.0.1:9050:9050 --name tor osminogin/tor-simple
```


## Ports

* `9050` SOCKSv5 (without auth)


### Examples 

Example webserver deployment config with microservice architecture to setup Tor hidden service. 


#### docker-compose.yml

```yaml
tor-node:
  image: osminogin/tor-simple
  links: 
    - nginx:myservice

nginx:
  image: nginx
  links:
    - drupal:drupalhost
  volumes:
    - /srv/drupal:/srv/www:ro
    - /srv/nginx/nginx.conf:/etc/nginx/nginx.conf:ro

drupal:
  image: osminogin/php-fpm
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

MIT
