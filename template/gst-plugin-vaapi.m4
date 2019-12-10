# Build gstremaer plugin vaapi
ARG GST_PLUGIN_VAAPI_REPO=https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-${GST_VER}.tar.xz

# https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi/merge_requests/45
ARG GST_PLUGIN_VAAPI_REPO_DISPLAY_LOCK_PATCH_HASH=b219f6095f3014041896714dd88e7d90ee3d72dd
ARG GST_PLUGIN_VAAPI_REPO_GIT=https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi.git

ifelse(index(DOCKER_IMAGE,ubuntu),-1,dnl
RUN  yum install -y -q libXrandr-devel
,dnl
RUN  apt-get update && apt-get install -y -q --no-install-recommends libxrandr-dev libegl1-mesa-dev autopoint bison flex libudev-dev
)dnl

#RUN  git clone https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi.git -b 1.14 --depth 10 && \
#     cd gstreamer-vaapi && git reset --hard ${GST_PLUGIN_VAAPI_REPO_DISPLAY_LOCK_PATCH_HASH} && \
RUN  wget -O - ${GST_PLUGIN_VAAPI_REPO} | tar xJ && \
     cd gstreamer-vaapi-${GST_VER} && \
     export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
     ./autogen.sh \
        --prefix=/usr/local \
        --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples \
        --disable-gtk-doc ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

define(`INSTALL_PKGS_GST_PLUGIN_VAAPI',ifelse(index(DOCKER_IMAGE,ubuntu),-1,libxcb mesa-libGL libXrandr ,libdrm-intel1 libudev1 libx11-xcb1 libgl1-mesa-glx libxrandr2 libglib2.0-0 ))dnl
define(`INSTALL_GST_PLUGIN_VAAPI',dnl
ENV GST_VAAPI_ALL_DRIVERS=1
ENV DISPLAY=:0.0
)dnl
