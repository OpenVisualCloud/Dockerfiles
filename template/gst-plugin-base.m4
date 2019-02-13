# Build the gstremaer plugin base
ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ; \
     cd gst-plugins-base-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --libexecdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE') --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug); \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install

define(`INSTALL_PKGS_GST_PLUGIN_BASE',ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,libpng12-0 libxv1 )ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,libpng16-16 libxv1 )ifelse(index(DOCKER_IMAGE,centos),-1,,libpng12 libXv ))dnl
