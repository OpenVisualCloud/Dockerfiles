# Build gstremaer plugin vaapi
ARG GST_PLUGIN_VAAPI_REPO=https://gstreamer.freedesktop.org/src/gstreamer-vaapi//gstreamer-vaapi-${GST_VER}.tar.xz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN  yum install -y -q libXrandr-devel
,dnl
RUN  apt-get update && apt-get install -y -q --no-install-recommends libxrandr-dev
)dnl

RUN  wget -O - ${GST_PLUGIN_VAAPI_REPO} | tar xJ; \
     cd gstreamer-vaapi-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --libexecdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE') --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug); \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install

define(`INSTALL_PKGS_GST_PLUGIN_VAAPI',ifelse(index(DOCKER_IMAGE,ubuntu),-1,libxcb mesa-libGL libXrandr ,libdrm-intel1 libx11-xcb1 libgl1-mesa-glx libxrandr2 ))dnl
define(`INSTALL_GST_PLUGIN_VAAPI',dnl
ENV GST_VAAPI_ALL_DRIVERS=1
)dnl
