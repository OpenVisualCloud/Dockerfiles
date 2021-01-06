include(envs.m4)
include(yasm.m4)
HIDE

DECLARE(`SVT_HEVC_VER',v1.5.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`SVT_HEVC_BUILD_DEPS',`ca-certificates wget tar g++ make cmake git')'
)

ifelse(OS_NAME,centos,dnl
`define(`SVT_HEVC_BUILD_DEPS',`wget tar gcc-c++ make git cmake3')'
)

include(yasm.m4)

define(`BUILD_SVT_HEVC',
ARG SVT_HEVC_REPO=https://github.com/OpenVisualCloud/SVT-HEVC
RUN cd BUILD_HOME && \
    git clone ${SVT_HEVC_REPO}
RUN cd BUILD_HOME/SVT-HEVC/Build/linux && \
    git checkout SVT_HEVC_VER && \
    ifelse(OS_NAME,centos,cmake3,cmake) -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j $(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
)

define(`FFMPEG_PATCH_SVT_HEVC',`
RUN cd $1 && \
    patch -p1 < BUILD_HOME/SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch || true
')

REG(SVT_HEVC)

UNHIDE
