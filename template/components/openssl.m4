include(envs.m4)
HIDE

DECLARE(`OPENSSL_VER',1_1_1h)

ifelse(OS_NAME,ubuntu,`
define(`OPENSSL_BUILD_DEPS',ca-certificates wget tar g++ make libtool autoconf)
')

ifelse(OS_NAME,centos,`
define(`OPENSSL_BUILD_DEPS',wget tar gcc-c++ make libtool autoconf)
')

define(`BUILD_OPENSSL',`
ARG OPENSSL_REPO=https://github.com/openssl/openssl/archive/OpenSSL_`'OPENSSL_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${OPENSSL_REPO} | tar xz && \
    cd openssl-OpenSSL_`'OPENSSL_VER && \
    ./config no-ssl3 shared --prefix=BUILD_PREFIX --openssldir=BUILD_PREFIX -fPIC -Wl,-rpath=BUILD_PREFIX/ssl/lib && \
    make depend && \
    make -s V=0 && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`OPENSSL_BUILD_PROVIDES',openssl)

REG(OPENSSL)

UNHIDE
