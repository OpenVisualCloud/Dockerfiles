include(envs.m4)
HIDE

DECLARE(`LIBFDKAAC_VER',0.1.6)

ifelse(OS_NAME,ubuntu,`
define(`LIBFDKAAC_BUILD_DEPS',ca-certificates wget g++ autoconf libtool autotools-dev automake make)
')

ifelse(OS_NAME,centos,`
define(`LIBFDKAAC_BUILD_DEPS',wget gcc-c++ autoconf libtool make automake)
')

define(`BUILD_LIBFDKAAC',`
ARG LIBFDKAAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/v`'LIBFDKAAC_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBFDKAAC_REPO} | tar xz && \
    cd fdk-aac-LIBFDKAAC_VER && \
    ./autogen.sh && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBFDKAAC_BUILD_PROVIDES',libfdk-aac)

REG(LIBFDKAAC)

UNHIDE
