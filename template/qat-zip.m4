# Build QATZip
ARG QATZIP_VER=v1.0.1
ARG QATZIP_REPO=https://github.com/intel/QATzip/archive/${QATZIP_VER}.tar.gz

RUN wget -O - ${QATZIP_REPO} | tar xz && mv QATzip-${QATZIP_VER} QATzip && \
    cd QATzip && \
    ./configure --with-ICP_ROOT=/home/qat-driver --prefix=/opt/qat && \
    make -j8 && \
    mkdir -p /opt/qat/lib && \
    mkdir -p /opt/qat/bin && \
    mkdir -p /opt/qat/include && \
    make install && \
    cp /usr/include/qatzip.h /opt/qat/include;
