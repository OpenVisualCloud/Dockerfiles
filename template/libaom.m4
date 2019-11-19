# Build AOM
ARG AOM_VER=b6f1767eedbaddeb1ff5aa409a710ef61078640e
ARG AOM_REPO=https://aomedia.googlesource.com/aom

define(`FFMPEG_CONFIG_AOM',--enable-libaom )dnl
RUN  git clone ${AOM_REPO} && \
     mkdir aom/aom_build && \
     cd aom/aom_build && \
     git checkout ${AOM_VER} && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX="/usr/local" -DCMAKE_INSTALL_LIBDIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) .. && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install
