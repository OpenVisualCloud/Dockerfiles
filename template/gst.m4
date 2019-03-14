# Build the gstremaer core
ARG GST_VER=1.14.4
ARG GST_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz

ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libglib2.0-dev autopoint gtk-doc-tools
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
RUN  ln -sf /usr/share/zoneinfo/UTC /etc/localtime; \
     DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libglib2.0-dev autopoint gtk-doc-tools
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN  yum install -y -q glib2-devel-2.56.1 gettext-devel gtk-doc
)dnl
RUN  wget -O - ${GST_REPO} | tar xJ && \
     cd gstreamer-${GST_VER} && \
     ./autogen.sh && \
     ./configure --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --libexecdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE') --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-gst-debug --disable-debug --disable-benchmarks --disable-check) && \
     make -j8 && \
     make install DESTDIR=/home/build && \
     make install
define(`INSTALL_PKGS_GST',ifelse(index(DOCKER_IMAGE,ubuntu),-1,glib2-2.56.1,libglib2.0) )dnl
