FROM docker:stable-dind
MAINTAINER Evgeny Kiselev <ekiselov@gmail.com>

RUN apk add --update git figlet docker-compose && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
COPY . .

ARG tag
ENV VERSION=$tag

CMD ["sh", "install.sh"]
