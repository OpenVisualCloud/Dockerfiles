# Build the gstremaer plugin base
ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libxv-dev libvisual-0.4-dev libtheora-dev libglib2.0-dev libasound2-dev libcdparanoia-dev libgl1-mesa-dev libpango1.0-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN  yum install -y -q libXv-devel libvisual-devel libtheora-devel glib2-devel alsa-lib-devel cdparanoia-devel mesa-libGL-devel pango-devel
)dnl

RUN  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ && \
     cd gst-plugins-base-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-introspection \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

define(`INSTALL_PKGS_GST_PLUGIN_BASE',dnl
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,libpng12-0 libxv1 libvisual-0.4-0 libgl1-mesa-glx libpango-1.0-0 libtheora0 libcdparanoia0 libasound2 )dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,libpng16-16 libxv1 libvisual-0.4-0 libgl1-mesa-glx libpango-1.0-0 libtheora0 libcdparanoia0 libasound2 )dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,libpng12 libXv libvisual mesa-libGL pango glib2 alsa-lib ))dnl
