# Fetch SVT-VP9
ARG SVT_VP9_VER=v0.2.1
ARG SVT_VP9_REPO=https://github.com/OpenVisualCloud/SVT-VP9

# hadolint ignore=SC1091
RUN git clone ${SVT_VP9_REPO} && \
    cd SVT-VP9/Build/linux && \
    git checkout ${SVT_VP9_VER} && \
    mkdir -p ../../Bin/Release && \
ifelse(index(DOCKER_IMAGE,centos),-1,,`dnl
  ( source /opt/rh/devtoolset-7/enable && \
')dnl
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install ifelse(index(DOCKER_IMAGE,centos),-1,,`)')

define(`FFMPEG_SOURCE_SVT_VP9',dnl
# Patch FFmpeg source for SVT-VP9
RUN cd /home/FFmpeg; \
    git apply ../SVT-VP9/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-vp9.patch;

)dnl
define(`FFMPEG_CONFIG_SVT_VP9',--enable-libsvtvp9 )dnl
