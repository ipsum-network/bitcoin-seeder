# compiles and runs ipsum-seeder
#
# build the container:
#   docker build -t ipsumnetwork/ipsum-seeder .
#
# run the dns node:
#   docker run --name ips-seeder --restart=always -d --net bridge -p IP:53:53 -p IP:53:53/udp -v /seeder:/var/lib/ipsum-seeder  ipsumnetwork/ipsum-seeder
#
# if you want to poke around in the container:
#   docker run -ti --rm --entrypoint /bin/sh ipsumnetwork/ipsum-seeder -c /bin/sh
#
# and don't forget on the host:
#
#   ufw allow 53
#
# related resources:
#
#   https://github.com/sipa/bitcoin-seeder/blob/master/README
#   https://help.ubuntu.com/community/UFW
#   http://docs.docker.io/installation/ubuntulinux/#docker-and-ufw
FROM alpine:3.3

RUN mkdir -p /app/bin /app/src /var/lib/ipsum-seeder

WORKDIR /app/src

ADD . /app/src

RUN apk --no-cache add --virtual build_deps    \
      boost-dev                                \
      gcc                                      \
      git                                      \
      g++                                      \
      libc-dev                                 \
      make                                     \
      openssl-dev                           && \
      apk add --update bash                 && \
    make                                    && \
    mv /app/src/dnsseed /app/bin/dnsseed    && \
    rm -rf /app/src                         && \
    apk --purge del build_deps

RUN apk --no-cache add    \
      libgcc              \
      libstdc++

WORKDIR /var/lib/ipsum-seeder
VOLUME /var/lib/ipsum-seeder

EXPOSE 53/udp

ENTRYPOINT ["/app/bin/dnsseed"]

CMD ["-h", "dnsseed.ipsum.network", \
     "-n", "seed.ipsum.network", \
     "-m", "admin@ipsum.network", \
     "-p", "53"]