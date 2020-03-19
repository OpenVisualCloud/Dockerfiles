# Build libusb
ARG LIBUSB_VER=v1.0.22
ARG LIBUSB_REPO=https://github.com/libusb/libusb/archive/${LIBUSB_VER}.tar.gz

RUN wget -O - ${LIBUSB_REPO} | tar xz && \
    cd libusb* && \
    ./autogen.sh enable_udev=no && \
    make -j $(nproc) && \
    cp ./libusb/.libs/libusb-1.0.so /lib/x86_64-linux-gnu/libusb-1.0.so.0
