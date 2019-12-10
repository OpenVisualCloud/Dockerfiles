# Build the gstremaer plugin good set
ARG GST_PLUGIN_GOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN  apt-get update && apt-get install -y -q --no-install-recommends libsoup2.4-dev libjpeg-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN  yum install -y -q libsoup-devel libjpeg-devel
)dnl

RUN  wget -O - ${GST_PLUGIN_GOOD_REPO} | tar xJ && \
     cd gst-plugins-good-${GST_VER} && \
     export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
     ./autogen.sh \
        --prefix=/usr/local \
        --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

define(`INSTALL_PKGS_GST_PLUGIN_GOOD',dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,libsoup libjpeg-turbo ,libsoup2.4-1 libjpeg8 libjpeg-turbo8 ))dnl
