ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
    RUN apt-get install -y -q --no-install-recommends gtk-doc-tools uuid-dev python-gi-dev python3-dev libtool-bin
)dnl

ifelse(index(DOCKER_IMAGE,centos),-1,,
    RUN yum install -y -q glib2-devel gtk-dock openblas uuid-devel python3 python36-gobject-devel python3-devel
)dnl

ifelse(index(DOCKER_IMAGE,centos74),-1,,
    RUN yum install -y -q binutils uuid-devel
)dnl

ARG PAHO_INSTALL=true
ARG PAHO_VER=1.3.0
ARG PAHO_REPO=https://github.com/eclipse/paho.mqtt.c/archive/v${PAHO_VER}.tar.gz
RUN if [ "$PAHO_INSTALL" = "true" ] ; then \
        wget -O - ${PAHO_REPO} | tar -xz && \
        cd paho.mqtt.c-${PAHO_VER} && \
        make && \
        make install && \
        cp build/output/libpaho-mqtt3c.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/ && \
        cp build/output/libpaho-mqtt3cs.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/ && \
        cp build/output/libpaho-mqtt3a.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/ && \
        cp build/output/libpaho-mqtt3as.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/ && \
        cp build/output/paho_c_version /home/build/usr/local/bin/ && \
        cp build/output/samples/paho_c_pub /home/build/usr/local/bin/ && \
        cp build/output/samples/paho_c_sub /home/build/usr/local/bin/ && \
        cp build/output/samples/paho_cs_pub /home/build/usr/local/bin/ && \
        cp build/output/samples/paho_cs_sub /home/build/usr/local/bin/ && \
        chmod 644 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3c.so.1.0 && \
        chmod 644 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3cs.so.1.0 && \
        chmod 644 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3a.so.1.0 && \
        chmod 644 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3as.so.1.0 && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3c.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3c.so.1 && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3cs.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3cs.so.1 && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3a.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3a.so.1 && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3as.so.1.0 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3as.so.1 && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3c.so.1 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3c.so && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3cs.so.1 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3cs.so && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3a.so.1 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3a.so && \
        ln /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3as.so.1 /home/build/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/libpaho-mqtt3as.so && \
        cp src/MQTTAsync.h /home/build/usr/local/include/ && \
        cp src/MQTTClient.h /home/build/usr/local/include/ && \
        cp src/MQTTClientPersistence.h /home/build/usr/local/include/ && \
        cp src/MQTTProperties.h /home/build/usr/local/include/ && \
        cp src/MQTTReasonCodes.h /home/build/usr/local/include/ && \
        cp src/MQTTSubscribeOpts.h /home/build/usr/local/include/; \
    else \
        echo "PAHO install disabled"; \
    fi

ifelse(RDKAFKA_INSTALLED,true,,dnl
include(librdkafka.m4)
)

#Install va gstreamer plugins from source
ARG VA_GSTREAMER_PLUGINS_VER=v1.0.0 
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
    -DVERSION_PATCH=$(echo "$(git rev-list --count --first-parent HEAD)") \
    -DGIT_INFO=$(echo "git_$(git rev-parse --short HEAD)") \
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

# Build gstreamer python
ARG GST_VER=1.16.0
ARG GST_PYTHON_REPO=https://gstreamer.freedesktop.org/src/gst-python/gst-python-${GST_VER}.tar.xz
RUN wget -O - ${GST_PYTHON_REPO} | tar xJ && \
    cd gst-python-${GST_VER} && \
    ./autogen.sh --prefix=/usr/local --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --with-pygi-overrides-dir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64/python3.6/site-packages,lib/python3/dist-packages)/gi/overrides --disable-dependency-tracking --disable-silent-rules --with-libpython-dir="/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64/,lib/x86_64-linux-gnu/)" PYTHON=/usr/bin/python3 && \
    make -j $(nproc) && \
    make install && \
    make install DESTDIR=/home/build

ifelse(index(DOCKER_IMAGE,centos),-1,,
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/lib64/girepository-1.0/:/usr/local/lib64/girepository-1.0/)dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/local/lib/x86_64-linux-gnu/girepository-1.0/)dnl

define(`INSTALL_PKGS_VA_GST_PLUGINS',
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
    libgtk2.0 libdrm2 libxv1 uuid python3-numpy python3-gi python3-gi-cairo python3-dev \
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
    libgtk2.0 libdrm2 libxv1 libpugixml1v5 uuid python3-numpy python3-gi python3-gi-cairo python3-dev \
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
    openblas-serial uuid python3 python36-gobject python3-devel python36-gobject-devel python36-gobject-base boost-regex \
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
