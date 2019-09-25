# Build the gstreamer plugin bad set
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz
ARG GST_PLUGIN_BAD_PATCH=https://raw.githubusercontent.com/OpenVisualCloud/Dockerfiles-Resources/master/gstpluginbad.patch

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN  apt-get update && apt-get install -y -q --no-install-recommends libssl-dev librtmp-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN  yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && yum install -y -q openssl-devel librtmp-devel && yum remove -y rpmfusion-free-release
)dnl

RUN  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ && \
     cd gst-plugins-bad-${GST_VER} && \
     wget -O - --no-check-certificate --content-disposition ${GST_PLUGIN_BAD_PATCH} | patch -p1 && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --libexecdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --disable-examples ifelse(index(DOCKER_IMAGE,-dev),-1,--disable-debug) \
        --disable-gtk-doc \ 
        --disable-shm \
        --disable-mxf && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install
define(`INSTALL_PKGS_GST_PLUGIN_BAD',dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,librtmp ))dnl
