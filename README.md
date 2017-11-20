# Docker image for Material Point Method
> Krishna Kumar

[![Quay image](https://img.shields.io/badge/quay--image-cbgeo--mpm-ff69b4.svg)](https://quay.io/repository/cbgeo/mpm)
[![Docker hub](https://img.shields.io/badge/docker--hub-cbgeo--mpm-ff69b4.svg)](https://hub.docker.com/r/cbgeo/mpm)
[![Build status](https://api.travis-ci.org/cb-geo/mpm-container.svg)](https://travis-ci.org/cb-geo/mpm-container)
[![](https://images.microbadger.com/badges/image/cbgeo/mpm.svg)](http://microbadger.com/images/cbgeo/mpm)

## Tools
* Dealii

# Using the docker image
* The docker image can be used directly from the Docker Hub or Quay.io
* Pull the docker image `docker pull cbgeo/mpm` or `docker pull quay.io/cbgeo/mpm`
* To launch the `cbgeo/mpm`  docker container, run `docker run -ti cbgeo/mpm:latest /bin/bash` or `docker run -ti quay.io/cbgeo/mpm:latest /bin/bash`

# To login as root
* Launching docker as root user: `docker exec -u 0 -ti <containerid> /bin/bash`

# Creating an image from the docker file
* To build an image from docker file run as root `docker build -t "cbgeo/mpm" /path/to/Dockerfile`
* `docker history` will show you the effect of each command has on the overall size of the file.
