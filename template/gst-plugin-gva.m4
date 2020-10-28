ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
    RUN apt-get install -y -q --no-install-recommends gtk-doc-tools uuid-dev python-gi-dev python3-dev libtool-bin
)dnl

ifelse(index(DOCKER_IMAGE,centos),-1,,
    RUN yum install -y -q glib2-devel gtk-dock openblas python3 python36-gobject-devel python3-devel
)dnl

ifelse(index(DOCKER_IMAGE,centos74),-1,,
    RUN yum install -y -q binutils 
)dnl

ARG PAHO_INSTALL=true
include(paho.mqtt.c.m4)

ifelse(RDKAFKA_INSTALLED,true,,dnl
`include(librdkafka.m4)'
)

#Install va gstreamer plugins from source
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,ARG VA_GSTREAMER_PLUGINS_VER=v1.2.1,ARG VA_GSTREAMER_PLUGINS_VER=v1.0.1)
ARG VA_GSTREAMER_PLUGINS_REPO=https://github.com/opencv/gst-video-analytics

RUN git clone ${VA_GSTREAMER_PLUGINS_REPO} && \
    cd gst-video-analytics && \
    git checkout ${VA_GSTREAMER_PLUGINS_VER} && \
    git submodule init && git submodule update && \
    mkdir build && \
    cd build && \
    export CFLAGS="-std=gnu99 -Wno-missing-field-initializers" && \
    export CXXFLAGS="-std=c++11 -Wno-missing-field-initializers" && \
    cmake \
    -DVERSION_PATCH="$(git rev-list --count --first-parent HEAD)" \
    -DGIT_INFO=git_"$(git rev-parse --short HEAD)" \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_PAHO_INSTALLATION=1 \
    -DENABLE_RDKAFKA_INSTALLATION=ifelse(RDKAFKA_INSTALLED,true,1,0) \
    ifelse(index(DOCKER_IMAGE,vcaca),-1,-DHAVE_VAAPI=OFF ,-DHAVE_VAAPI=ON -DENABLE_AVX2=ON -DENABLE_SSE42=ON) \
    -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j4
RUN mkdir -p build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0 && \
    cp -r gst-video-analytics/build/intel64/Release/lib/* build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
RUN mkdir -p /usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0 && \
    cp -r gst-video-analytics/build/intel64/Release/lib/* /usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0

RUN mkdir -p build/opt/intel/dl_streamer/python && \
    cp -r gst-video-analytics/python/* build/opt/intel/dl_streamer/python
RUN mkdir -p /opt/intel/dl_streamer/python && \
    cp -r gst-video-analytics/python/* /opt/intel/dl_streamer/python
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python

include(gst-python.m4)

ifelse(index(DOCKER_IMAGE,centos),-1,,
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/lib64/girepository-1.0/:/usr/local/lib64/girepository-1.0/)dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/local/lib/x86_64-linux-gnu/girepository-1.0/)dnl

define(`INSTALL_PKGS_VA_GST_PLUGINS',
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
    libgtk2.0 libdrm2 libxv1 python3-numpy python3-gi python3-gi-cairo python3-dev \
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
    libgtk2.0 libdrm2 libxv1 libpugixml1v5 python3-numpy python3-gi python3-gi-cairo python3-dev \
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
    openblas-serial python3 python36-gobject python3-devel python36-gobject-devel python36-gobject-base boost-regex \
)dnl
)dnl

define(`INSTALL_VA_GST_PLUGINS',dnl
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
ENV PKG_CONFIG_PATH=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig
ENV LIBRARY_PATH=${LIBRARY_PATH}:/usr/local/lib:/usr/lib
ENV PATH=/usr/bin:${PATH}:/usr/local/bin
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/gstreamer-1.0
ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python
ifelse(index(DOCKER_IMAGE,centos),-1,,
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/lib64/girepository-1.0/:/usr/local/lib64/girepository-1.0/
RUN python3 -m pip install numpy)
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/local/lib/x86_64-linux-gnu/girepository-1.0/)dnl
)dnl
