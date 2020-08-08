# Build gstremaer plugin vaapi
ARG GST_PLUGIN_VAAPI_REPO=https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-${GST_VER}.tar.xz

# https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi/merge_requests/45
ARG GST_PLUGIN_VAAPI_PATCH_VER=v1.0.0
ARG GST_PLUGIN_VAAPI_REPO_VIDEO_ANALYTICS=https://github.com/opencv/gst-video-analytics.git

ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN  yum install -y -q libXrandr-devel
,dnl
RUN  apt-get update && apt-get install -y -q --no-install-recommends libxrandr-dev libegl1-mesa-dev autopoint bison flex libudev-dev	&& \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*
)dnl

RUN  wget -O - ${GST_PLUGIN_VAAPI_REPO} | tar xJ && \
     cd gstreamer-vaapi-${GST_VER} && \
     git clone ${GST_PLUGIN_VAAPI_REPO_VIDEO_ANALYTICS} && \
     cd gst-video-analytics && git checkout ${GST_PLUGIN_VAAPI_PATCH_VER} && \
     cd .. && \
     git apply gst-video-analytics/patches/gstreamer-vaapi/vasurface_qdata.patch && \
     rm -fr gst-video-analytics && \
     export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
     ./autogen.sh \
        --prefix=/usr/local \
        --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples \
        --disable-gtk-doc ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) && \
     make -j "$(nproc)" && \
     make install DESTDIR=/home/build && \
     make install

define(`INSTALL_PKGS_GST_PLUGIN_VAAPI',ifelse(index(DOCKER_IMAGE,ubuntu),-1,libxcb mesa-libGL libXrandr ,libdrm-intel1 libudev1 libx11-xcb1 libgl1-mesa-glx libxrandr2 libglib2.0-0 ))dnl
define(`INSTALL_GST_PLUGIN_VAAPI',dnl
ENV GST_VAAPI_ALL_DRIVERS=1
ENV DISPLAY=:0.0
)dnl
