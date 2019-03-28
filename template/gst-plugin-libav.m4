# Build gst-libav
ARG GST_PLUGIN_LIBAV_REPO=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${GST_VER}.tar.xz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends zlib1g-dev libssl-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q zlib-devel openssl-devel
)dnl

RUN wget -O - ${GST_PLUGIN_LIBAV_REPO} | tar xJ && \
    cd gst-libav-${GST_VER} && \
    ./autogen.sh \
        --prefix="/usr" \
        --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/lib64,/usr/lib/x86_64-linux-gnu) \
        --enable-defn(`BUILD_LINKAGE') \
        --enable-gpl \
        --disable-gtk-doc && \
    make -j $(nproc) && \
    make install DESTDIR=/home/build && \
    make install

define(`INSTALL_PKGS_FFMPEG',ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,libnuma1 libssl1.0.0 )ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,libnuma1 libssl1.1 )ifelse(index(DOCKER_IMAGE,centos),-1,,numactl openssl ))dnl
