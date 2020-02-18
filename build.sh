#!/bin/bash
docker build --build-arg tag=$1 -t kiseloff/npm_responder-install:$1 .
