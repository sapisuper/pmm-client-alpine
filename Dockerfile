FROM alpine:latest

MAINTAINER Satria Dwi Putra <satria11t2@gmail.com>

ENV MONIT_VERSION=5.25.2

# Compile and install monit
RUN apk add --update make gcc curl zlib-dev libressl-dev musl-dev \
    && cd /tmp \
    && curl -sS https://mmonit.com/monit/dist/monit-${MONIT_VERSION}.tar.gz | gunzip -c - | tar -xf - \
    && cd monit-${MONIT_VERSION} \
    && ./configure --without-pam \
    && make \
    && make install

RUN apk add --update curl bash \
    && cd /tmp \
    && curl -sS https://s3.us-east-2.amazonaws.com/pmm-build-cache/pmm-client/pmm-client-PR-80-8a282a4.tar.gz | gunzip -c - | tar -xf - \
    && cd pmm-client-* \
    && bash ./install

FROM alpine:latest
RUN apk add --update --no-cache bash
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY --from=0 /usr/local/bin/monit /usr/bin/monit
ADD monitrc /etc/monitrc
RUN install -d /etc/monit.d /var/lib/monit /var/lib/monit/eventqueue /run /var/log /etc/init.d

COPY --from=0 /usr/local/percona /usr/local/percona
COPY --from=0 /usr/sbin/pmm-admin /usr/sbin/pmm-admin
ADD service /usr/bin/service
ADD entrypoint.sh /entrypoint.sh

RUN chmod 777 /usr/local/percona
RUN chmod 777 /usr/sbin/pmm-admin
RUN chmod 777 /usr/bin/service
RUN chmod 777 /entrypoint.sh
RUN chmod 700 /etc/monitrc

ENTRYPOINT ["/entrypoint.sh"]
