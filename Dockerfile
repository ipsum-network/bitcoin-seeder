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