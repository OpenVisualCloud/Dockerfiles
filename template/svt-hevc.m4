# Fetch SVT-HEVC
ARG SVT_HEVC_VER=v1.4.1
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

ifelse(index(DOCKER_IMAGE,ubuntu),-1,
RUN yum install -y -q patch centos-release-scl && \
    yum install -y -q devtoolset-7

)dnl
RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
ifelse(index(DOCKER_IMAGE,centos),-1,,`dnl
    ( source /opt/rh/devtoolset-7/enable && \
')dnl
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install ifelse(index(DOCKER_IMAGE,centos),-1,,`)')

define(`FFMPEG_SOURCE_SVT_HEVC',dnl
# Patch FFmpeg source for SVT-HEVC
RUN cd /home/FFmpeg && \
    patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

)dnl
define(`FFMPEG_CONFIG_SVT_HEVC',--enable-libsvthevc )dnl
