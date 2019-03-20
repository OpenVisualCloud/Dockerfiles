ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
    RUN apt-get install -y -q --no-install-recommends gtk-doc-tools
)dnl

ifelse(index(DOCKER_IMAGE,centos),-1,,
    RUN yum install -y -q glib2-devel gtk-dock openblas
)dnl

ifelse(index(DOCKER_IMAGE,centos74),-1,,
    RUN yum install -y -q binutils
)dnl


ARG PAHO_VER=1.3.0
ARG PAHO_REPO=https://github.com/eclipse/paho.mqtt.c/archive/v${PAHO_VER}.tar.gz
RUN wget -O - https://github.com/eclipse/paho.mqtt.c/archive/v${PAHO_VER}.tar.gz | tar -xz; \
    cd paho.mqtt.c-${PAHO_VER}; \
    make; \
    make install;

#Install va gstreamer plugins
#Has a dependency on OpenCV, GStreamer
ARG VA_GSTREAMER_PLUGINS_VER=0.3
ARG VA_GSTREAMER_PLUGINS_REPO=https://github.com/opencv/gst-video-analytics/archive/v${VA_GSTREAMER_PLUGINS_VER}.tar.gz
RUN wget -O - ${VA_GSTREAMER_PLUGINS_REPO} | tar xz && \
    cd gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER} && \
    mkdir build && \
    cd build && \
    export CFLAGS="-std=gnu99 -Wno-missing-field-initializers" && \
    export CXXFLAGS="-std=c++11 -Wno-missing-field-initializers" && \
    cmake \
    -DVERSION_PATCH=$(echo "$(git rev-list --count --first-parent HEAD)") \
    -DGIT_INFO=$(echo "git_$(git rev-parse --short HEAD)") \
    -DCMAKE_BUILD_TYPE=Release \
    -DDISABLE_SAMPLES=ON \
    -DDISABLE_VAAPI=ON \
    -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j4
RUN mkdir -p build/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0 && \
    cp -r gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER}/build/intel64/Release/lib/* build/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
RUN mkdir -p /usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0 && \
    cp -r gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER}/build/intel64/Release/lib/* /usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0

define(`INSTALL_PKGS_VA_GST_PLUGINS',
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
    libgtk2.0 libdrm2 libxv1 \
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
    libgtk2.0 libdrm2 libxv1 libpugixml1v5 \
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
    openblas-serial \
)dnl
)dnl

define(`INSTALL_VA_GST_PLUGINS',dnl
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
ENV PKG_CONFIG_PATH=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig
ENV LIBRARY_PATH=${LIBRARY_PATH}:/usr/lib
ENV PATH=${PATH}:/usr/bin
)dnl
