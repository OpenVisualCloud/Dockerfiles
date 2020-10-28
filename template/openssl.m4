# Build open ssl
ARG OPENSSL_VER="1.1.1h"
ARG OPENSSL_REPO=http://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz
ARG BUILD_PREFIX=/usr/local/ssl
ARG BUILD_DESTDIR=/home/build

RUN wget -O - ${OPENSSL_REPO} | tar xz && \
    cd openssl-${OPENSSL_VER} && \
    ./config no-ssl3 --prefix=${BUILD_PREFIX} --openssldir=${BUILD_PREFIX} -Wl,-rpath=${BUILD_PREFIX}/lib -fPIC && \
    make depend && \
    make -s V=0  && \
    ifelse(BUILD_DEV,enabled,make install &&  ./config no-ssl3 --prefix=${BUILD_DESTDIR}/${BUILD_PREFIX} --openssldir=${BUILD_DESTDIR}/${BUILD_PREFIX} -Wl`,'-rpath=${BUILD_DESTDIR}/${BUILD_PREFIX}/lib -fPIC && make depend && make -s V=0  && make install,make install)
