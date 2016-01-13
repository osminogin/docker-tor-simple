# docker-tor-simple

Simple docker container for Tor anonymity software. 

It works well as a single container (expose port 9050) or in conjunction 
with other containers (like `nginx` and `osminogin/php-fpm`) for organizing 
complex hidden services in the Tor network.

## Setup

This container is ready for access to the Tor network without any additional 
configuration (use SOCKSv5 port 9050).

### Hidden service

#### Example

```yaml
# docker-compose.yml
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
