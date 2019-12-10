# Build gstremaer plugin for svt

RUN cd SVT-HEVC/gstreamer-plugin && \
    cmake . && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

RUN cd SVT-VP9/gstreamer-plugin && \
    cmake . && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

RUN cd SVT-AV1/gstreamer-plugin && \
    cmake . && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install
