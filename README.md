# docker-tor-simple

Simple docker container for Tor anonymity software. 

It works well as a single container (expose port 9050) or in conjunction 
with other containers (like *nginx* and *osminogin/php-fpm*) for organizing 
complex hidden services in the Tor network.

## Setup

This container is ready for access to the Tor network without any additional 
configuration (use SOCKSv5 port 9050).
