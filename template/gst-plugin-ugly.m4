# Build the gstremaer plugin ugly set
ARG GST_PLUGIN_UGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GST_VER}.tar.xz

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN  wget -O - ${GST_PLUGIN_UGLY_REPO} | tar xJ; \
     cd gst-plugins-ugly-${GST_VER}; \
     export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig"; \
     ./autogen.sh \
        --prefix=/usr/local \
        --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) \
        --disable-gtk-doc && \
     make -j "$(nproc)" && \
     make install DESTDIR=/home/build && \
     make install
