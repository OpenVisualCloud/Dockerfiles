# Build OpenSSL for QAT
ARG QAT_OPENSSL_VER=OpenSSL_1_1_1
ARG QAT_OPENSSL_REPO=https://github.com/openssl/openssl/archive/${QAT_OPENSSL_VER}.tar.gz

RUN wget -O - ${QAT_OPENSSL_REPO} | tar xz && mv openssl-${QAT_OPENSSL_VER} openssl; \
    cd openssl; \
    ./config --prefix=/opt/openssl --openssldir=/opt/openssl -Wl,-rpath,\${LIBRPATH}; \
    make -j8; \
    make install DESTDIR=/home/build; \
ifelse(index(DOCKER_IMAGE,-dev),-1,,dnl
    rm -rf /home/build/opt/openssl/share/doc; \
    rm -rf /home/build/opt/openssl/share/man; \
)dnl
    make install; 

