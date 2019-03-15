# Build AOM
ARG AOM_VER=tags/v1.0.0
ARG AOM_REPO=https://aomedia.googlesource.com/aom

define(`FFMPEG_CONFIG_AOM',--enable-libaom )dnl
RUN  git clone ${AOM_REPO} && \
     mkdir aom/aom_build && \
     cd aom/aom_build && \
     git checkout ${AOM_VER} && \
     cmake -DBUILD_SHARED_LIBS=ifelse(BUILD_LINKAGE,shared,ON,OFF) -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/lib64,/usr/lib/x86_64-linux-gnu) .. && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install
