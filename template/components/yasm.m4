include(envs.m4)
HIDE

DECLARE(`YASM_VER',1.3.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`YASM_BUILD_DEPS',`ca-certificates wget tar g++ make')'
)

ifelse(OS_NAME,centos,dnl
`define(`YASM_BUILD_DEPS',`wget tar gcc-c++ make')'
)

define(`BUILD_YASM',
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-YASM_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${YASM_REPO} | tar xz
RUN cd BUILD_HOME/yasm-YASM_VER && \
    # TODO remove the line below whether no other component inside this project requires it.
    # `sed -i "s/) ytasm.*/)/" Makefile.in' && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    make -j $(nproc) && \
    make install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`YASM_BUILD_PROVIDES',`yasm')')

ifelse(OS_NAME,centos,dnl
`define(`YASM_BUILD_PROVIDES',`yasm')')

REG(YASM)

UNHIDE
