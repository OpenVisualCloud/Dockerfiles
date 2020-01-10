# Fetch FFmpeg source
ARG FFMPEG_VER=n4.2
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz
ARG FFMPEG_1TN_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11625/raw

ARG FFMPEG_PATCHES_RELEASE_VER=0.1
ARG FFMPEG_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${FFMPEG_PATCHES_RELEASE_VER}.tar.gz
ARG FFMPEG_PATCHES_PATH=/home/CDN-${FFMPEG_PATCHES_RELEASE_VER}
RUN wget -O - ${FFMPEG_PATCHES_RELEASE_URL} | tar xz

ifelse(ifelse(index(DOCKER_IMAGE,dev),-1,'false','true'), ifelse(index(DOCKER_IMAGE,analytics),-1,'false','true'),,
ARG FFMPEG_MA_RELEASE_VER=0.4
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=/home/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
RUN wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz
)dnl
define(`FFMPEG_X11',ifelse(index(DOCKER_IMAGE,-dev),-1,ifelse(index(DOCKER_IMAGE,xeon-),-1,ON,OFF),ON))dnl

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libass-dev libfreetype6-dev ifelse(index(DOCKER_IMAGE,xeon-),-1,libvdpau-dev )ifelse(FFMPEG_X11,ON,libsdl2-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev )ifelse(index(DOCKER_IMAGE,-dev),-1,,texinfo )zlib1g-dev libssl-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q libass-devel freetype-devel ifelse(FFMPEG_X11,ON,SDL2-devel libxcb-devel )ifelse(index(DOCKER_IMAGE,xeon-),-1,libvdpau-devel )ifelse(index(DOCKER_IMAGE,-dev),-1,,texinfo )zlib-devel openssl-devel
)dnl

RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
    cd FFmpeg ifelse(index(DOCKER_IMAGE,owt),-1,&& \
    find ${FFMPEG_PATCHES_PATH}/FFmpeg_patches -type f -name '0001*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i) ifelse(ifelse(index(DOCKER_IMAGE,dev),-1,'false','true'), ifelse(index(DOCKER_IMAGE,analytics),-1,'false','true'), && \
    wget -O - ${FFMPEG_1TN_PATCH_REPO} | patch -p1;, && \
    find ${FFMPEG_MA_PATH}/patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;
)dnl

defn(`FFMPEG_SOURCE_SVT_HEVC',`FFMPEG_SOURCE_SVT_AV1',`FFMPEG_SOURCE_TRANSFORM360')dnl
# Compile FFmpeg
RUN cd /home/FFmpeg && \
    export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
    ./configure --prefix="/usr/local" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) ifelse(index(DOCKER_IMAGE,owt),-1,--extra-libs="-lpthread -lm" --enable-defn(`BUILD_LINKAGE') --enable-gpl --enable-libass --enable-libfreetype ifelse(FFMPEG_X11,OFF,--disable-xlib --disable-sdl2) --enable-openssl --enable-nonfree ifelse(index(DOCKER_IMAGE,xeon-),-1,--enable-libdrm --enable-libmfx,--disable-vaapi --disable-hwaccels) ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages) defn(`FFMPEG_CONFIG_FDKAAC',`FFMPEG_CONFIG_MP3LAME',`FFMPEG_CONFIG_OPUS',`FFMPEG_CONFIG_VORBIS',`FFMPEG_CONFIG_VPX',`FFMPEG_CONFIG_X264',`FFMPEG_CONFIG_X265',`FFMPEG_CONFIG_AOM',`FFMPEG_CONFIG_SVT_HEVC',`FFMPEG_CONFIG_SVT_AV1',`FFMPEG_CONFIG_TRANSFORM360',`FFMPEG_CONFIG_DLDT_IE',`FFMPEG_CONFIG_LIBRDKAFKA',`FFMPEG_CONFIG_LIBJSON_C'),--enable-shared --disable-static --disable-libvpx --disable-vaapi --enable-libfreetype defn(`FFMPEG_CONFIG_FDKAAC') --enable-nonfree) && \
    make -j8 && \
    ifelse(index(DOCKER_IMAGE,owt),-1,,make install && )make install DESTDIR="/home/build"

define(`INSTALL_PKGS_FFMPEG',dnl
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,ifelse(FFMPEG_X11,ON,libxv1 libsdl2-2.0-0 libasound2) libxcb-shm0 libxcb-shape0 libxcb-xfixes0 ifelse(index(DOCKER_IMAGE,xeon-),-1,libvdpau1) libnuma1 libass5 libssl1.0.0) dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,ifelse(FFMPEG_X11,ON,libxv1 libxcb-shm0 libxcb-shape0 libxcb-xfixes0 libsdl2-2.0-0 libasound2) ifelse(index(DOCKER_IMAGE,xeon-),-1,libvdpau1) libnuma1 libass9 libssl1.1 libpciaccess0 ) dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,ifelse(FFMPEG_X11,ON,libxcb SDL2) libass numactl ifelse(index(DOCKER_IMAGE,xeon-),-1,libvdpau) ) dnl
)dnl
