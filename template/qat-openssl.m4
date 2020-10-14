# Build OpenSSL for QAT
ARG QAT_OPENSSL_VER=1.1.1h
ARG QAT_OPENSSL_REPO=https://www.openssl.org/source/openssl-${QAT_OPENSSL_VER}.tar.gz

RUN wget -O - ${QAT_OPENSSL_REPO} | tar xz && mv openssl-${QAT_OPENSSL_VER} openssl && \
    cd openssl && \
    ./config --prefix=/opt/openssl --openssldir=/opt/openssl -Wl,-rpath,"\${LIBRPATH}" && \
    make -j8 && \
    make install && \
ifelse(index(DOCKER_IMAGE,-dev),-1,dnl
    rm -rf /opt/openssl/share/doc && \
    rm -rf /opt/openssl/share/man && \
)dnl
    echo
