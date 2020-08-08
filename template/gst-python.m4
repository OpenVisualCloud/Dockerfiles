
# Build gstreamer python
ARG GST_VER=1.16.2
ARG GST_PYTHON_REPO=https://gstreamer.freedesktop.org/src/gst-python/gst-python-${GST_VER}.tar.xz
RUN wget -O - ${GST_PYTHON_REPO} | tar xJ && \
    cd gst-python-${GST_VER} && \
    ./autogen.sh --prefix=/usr/local --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --libexecdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --with-pygi-overrides-dir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64/python3.6/site-packages,lib/python3/dist-packages)/gi/overrides --disable-dependency-tracking --disable-silent-rules --with-libpython-dir="/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64/,lib/x86_64-linux-gnu/)" PYTHON=/usr/bin/python3 && \
    make -j "$(nproc)" && \
    make install && \
    make install DESTDIR=/home/build

