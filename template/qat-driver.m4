# Build the QAT Driver
ARG QAT_DRIVER_VER=1.7.l.4.7.0-00006
ARG QAT_DRIVER_REPO=https://01.org/sites/default/files/downloads/qat${QAT_DRIVER_VER}.tar.gz

RUN mkdir qat-driver && \
    cd qat-driver && \
    wget -O - ${QAT_DRIVER_REPO} | tar xz && \
    KERNEL_SOURCE_ROOT=/home/linux-${QAT_KERNEL_VER} ICP_ROOT=/home/qat-driver ./configure --prefix=/opt/qat && \
    make -j8
