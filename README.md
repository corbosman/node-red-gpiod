# node-red-gpiod

[![DockerHub Pull](https://img.shields.io/docker/pulls/corbosman/node-red-gpiod.svg)](https://hub.docker.com/r/corbosman/node-red-gpiod/)

__note: this is still in development, feedback is appreciated__

This is a docker image that lets you run [pigpiod](http://abyz.me.uk/rpi/pigpio/pigpiod.html) in a dedicated container on a Raspberry PI. 
Pigpiod is a daemon that lets you control gpio pins over the network, Node-Red provides [dedicated nodes](https://www.npmjs.com/package/node-red-node-pi-gpiod) that make use of this daemon.

## Quick Start

To run this container stand-alone you can start it like this:

```
docker run -d -p 8888:8888 --privileged --name gpiod corbosman/node-red-gpiod:dev
```

The daemon is now listening on port 8888 on localhost. 
Because the daemon needs to access device pins on the Raspberry PI, it is necessary to run the container in privileged mode. 

To stop it:

```
docker stop gpiod
```

This image allows you to pass additional arguments to the daemon. For a list of all available arguments check the [pigpiod](http://abyz.me.uk/rpi/pigpio/pigpiod.html) website.
Simply add arguments after the image name like so:


```
docker run -d -p 8888:8888 --privileged --name gpiod corbosman/node-red-gpiod:dev -n 127.0.0.1 -s 2
```

__note: the options "-g -a 1" are always passed to the daemon"__

## Running through docker-compose

A better way to run this daemon is by creating a container stack with node-red and possibly other containers like mosquitto. A sample docker-compose.yml can be found in the github repository at https://github.com/corbosman/node-red-gpiod.
This allows you to run the pigpiod daemon in a protected network that is only accessible by Node-Red. 

```
version: "3"

services:
  node-red:
    image: nodered/node-red
    volumes:
      - /home/pi/.node-red:/data
    ports:
      - 1880:1880
   
  gpiod:
    image: corbosman/node-red-gpiod:dev
    privileged: true
    restart: unless-stopped
```

This compose file will start up Node-Red and gpiod services, with only the Node-Red service exposed to the outside on port 1880.
To connect to the daemon from the gpiod node in Node-Red, simply use the service name "gpiod" as the hostname, and port 8888. 
