FROM docker:stable-dind
MAINTAINER Evgeny Kiselev <ekiselov@gmail.com>

RUN apk add --update git figlet docker-compose && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
COPY . .

ARG tag
ENV VERSION=$tag

CMD ["sh", "install.sh"]

#docker build --build-arg tag=edge --no-cache --network=host -t installer:0.1 .
#
#
#docker run -it --rm \
#  --name temp-app \
#  --volume /var/run/docker.sock:/var/run/docker.sock \
#kiseloff/npm_responder-install:1.0.1