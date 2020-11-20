include(envs.m4)
include(yasm.m4)
HIDE

DECLARE(`SVT_AV1_VER',v0.8.5)

include(yasm.m4)

ifelse(OS_NAME,ubuntu,dnl
`define(`SVT_AV1_BUILD_DEPS',`ca-certificates wget tar g++ make cmake git')'
)

ifelse(OS_NAME,centos,dnl
`define(`SVT_AV1_BUILD_DEPS',`wget tar gcc-c++ make git cmake3')'
)

define(`BUILD_SVT_AV1',
ARG SVT_AV1_REPO=https://github.com/AOMediaCodec/SVT-AV1
RUN cd BUILD_HOME && \
    git clone ${SVT_AV1_REPO} -b SVT_AV1_VER --depth 1 && \
    cd SVT-AV1/Build/linux && \
    ifelse(OS_NAME,centos,cmake3,cmake) -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j $(nproc) && \
    sed -i 's/SvtAv1dec/SvtAv1Dec/' SvtAv1Dec.pc && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
)

define(`FFMPEG_PATCH_SVT_AV1_VER',0.8.4)
define(`FFMPEG_PATCH_SVT_AV1',`
ARG FFMPEG_PATCH_SVT_AV1_REPO=https://github.com/AOMediaCodec/SVT-AV1/archive/v`'FFMPEG_PATCH_SVT_AV1_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${FFMPEG_PATCH_SVT_AV1_REPO} | tar xz && \
    cd $1 && \
    patch -p1 < ../SVT-AV1-FFMPEG_PATCH_SVT_AV1_VER/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1.patch || true
')

REG(SVT_AV1)

UNHIDE
