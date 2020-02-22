FROM balenalib/raspberrypi3-alpine:3.10 as build

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache \
	build-base \
	ca-certificates \
	curl \
	expat-dev \
	libevent-dev \
	libevent-static \
	linux-headers \
	openssl-dev

WORKDIR /tmp/unbound

ARG UNBOUND_VERSION=unbound-1.10.0
ARG UNBOUND_SOURCE=https://www.nlnetlabs.nl/downloads/unbound/
ARG UNBOUND_SHA1=2c175131f7f4c8f6fd2be4a03073d864596d0be6

RUN curl -fsSL --retry 3 "${UNBOUND_SOURCE}${UNBOUND_VERSION}.tar.gz" -o unbound.tar.gz \
	&& echo "${UNBOUND_SHA1}  unbound.tar.gz" | sha1sum -c - \
	&& tar xzf unbound.tar.gz --strip 1 \
	&& ./configure --with-pthreads --with-libevent --prefix=/opt/unbound --with-run-dir=/var/run/unbound --with-username= --with-chroot-dir= --enable-fully-static --disable-shared --enable-event-api --disable-flto \
	&& make -j 4 install

WORKDIR /tmp/ldns

ARG LDNS_VERSION=ldns-1.7.1
ARG LDNS_SOURCE=https://www.nlnetlabs.nl/downloads/ldns/
ARG LDNS_SHA1=d075a08972c0f573101fb4a6250471daaa53cb3e

RUN curl -fsSL --retry 3 "${LDNS_SOURCE}${LDNS_VERSION}.tar.gz" -o ldns.tar.gz \
	&& echo "${LDNS_SHA1}  ldns.tar.gz" | sha1sum -c - \
	&& tar xzf ldns.tar.gz --strip 1 \
	&& sed -e 's/@LDFLAGS@/@LDFLAGS@ -all-static/' -i Makefile.in \
	&& ./configure --prefix=/opt/ldns --with-drill --disable-shared \
	&& make -j 4 \
	&& make install

WORKDIR /var/run/unbound

RUN mv /opt/unbound/etc/unbound/unbound.conf /opt/unbound/etc/unbound/example.conf \
	&& rm -rf /tmp/* /opt/*/include /opt/*/man /opt/*/share \
	&& strip /opt/unbound/sbin/unbound \
	&& strip /opt/ldns/bin/drill

# ----------------------------------------------------------------------------

FROM scratch

COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /lib/ld-musl-*.so.1 /lib/

COPY --from=build /opt /opt
COPY --from=build --chown=nobody:nogroup /var/run/unbound /var/run/unbound

COPY a-records.conf unbound.conf /opt/unbound/etc/unbound/

USER nobody

ENV PATH /opt/unbound/sbin:/opt/ldns/bin:${PATH}

ENTRYPOINT ["unbound", "-d"]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
	CMD [ "drill", "-p", "5053", "nlnetlabs.nl", "@127.0.0.1" ]

RUN ["unbound", "-V"]

RUN ["drill", "-v"]
