#!/bin/bash
docker build --build-arg tag=$1 -t kiseloff/npm_responder-install:$1 .

docker run -it \
  --name temp-app \
  --volume /var/run/docker.sock:/var/run/docker.sock \
kiseloff/npm_responder-install:1.0.1