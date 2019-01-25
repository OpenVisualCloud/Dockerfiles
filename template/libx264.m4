# Build x264
ARG X264_VER=stable
ARG X264_REPO=https://github.com/mirror/x264

define(`FFMPEG_CONFIG_X264',--enable-libx264 )dnl
RUN  git clone ${X264_REPO}; \
     cd x264; \
     git checkout ${X264_VER}; \
     ./configure --prefix="/usr" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/lib64,/usr/lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE'); \
     make -j8; \
     make install DESTDIR="/home/build"; \
     make install

