# Build open ssl
ARG OPENSSL_BASE_VER="1.0.2"
ARG OPENSSL_VER="1.0.2t"
ARG OPENSSL_REPO=http://www.openssl.org/source/old/${OPENSSL_BASE_VER}/openssl-${OPENSSL_VER}.tar.gz

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${OPENSSL_REPO} | tar xz && \
    cd openssl-${OPENSSL_VER} && \
    ./config no-ssl3 --prefix="/usr/local" -fPIC && \
    make depend && \
    make -s V=0  && \
    ifelse(BUILD_DEV,enabled,make install && ./config no-ssl3 --prefix="/home/build/usr/local" -fPIC && make depend && make -s V=0  && make install,make install)
