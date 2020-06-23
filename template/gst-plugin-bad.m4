# Build the gstreamer plugin bad set
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz
ARG GST_PATCHES_RELEASE_VER=v0.1
ARG GST_PATCHES_RELEASE_URL=https://github.com/VCDP/gstreamer-patch/archive/${GST_PATCHES_RELEASE_VER}.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${GST_PATCHES_RELEASE_URL} | tar xz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN  apt-get update && apt-get install -y -q --no-install-recommends libssl-dev librtmp-dev	&& \
     apt-get clean	&& \
     rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN  yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && yum install -y -q openssl-devel librtmp-devel && yum remove -y rpmfusion-free-release
)dnl

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ && \
     cd gst-plugins-bad-${GST_VER} && \
     export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
     find /home/gstreamer-patch-${GST_PATCHES_RELEASE_VER#*v}/ -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i && \
     ./autogen.sh \
        --prefix=/usr/local \
        --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) \
        --disable-gtk-doc \ 
        --disable-shm \
        --disable-mxf && \
     make -j "$(nproc)" && \
     make install DESTDIR=/home/build && \
     make install
define(`INSTALL_PKGS_GST_PLUGIN_BAD',dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,librtmp ))dnl
