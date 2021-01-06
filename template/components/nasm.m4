include(envs.m4)
HIDE

DECLARE(`NASM_VER',2.15.05)

ifelse(OS_NAME,ubuntu,`
define(`NASM_BUILD_DEPS',ca-certificates wget tar g++ make bzip2)
')

ifelse(OS_NAME,centos,`
define(`NASM_BUILD_DEPS',wget tar gcc-c++ make bzip2)
')

define(`BUILD_NASM',`
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/NASM_VER/nasm-NASM_VER.tar.bz2
RUN cd BUILD_HOME && \
    wget -O - ${NASM_REPO} | tar xj && \
    cd nasm-NASM_VER && \
    ./autogen.sh && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
     make -j$(nproc) && \
     make install
')

define(`NASM_BUILD_PROVIDES',nasm)

REG(NASM)

UNHIDE
