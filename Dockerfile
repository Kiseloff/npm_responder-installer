FROM docker:stable-dind
MAINTAINER Pavol Noha <pavol.noha@gmail.com>

RUN apk add --update git figlet && \
    rm -rf /var/cache/apk/*

WORKDIR /
ADD . /

ARG tag
ENV VERSION=$tag

CMD ["sh", "install.sh"]






docker build --build-arg tag=edge --no-cache --network=host -t installer:0.1 .


docker run -it --rm \
  --name test-installer \
  --volume /var/run/docker.sock:/var/run/docker.sock \
installer:0.1