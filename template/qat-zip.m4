# Build QATZip
ARG QATZIP_VER=v1.0.1
ARG QATZIP_REPO=https://github.com/intel/QATzip/archive/${QATZIP_VER}.tar.gz

RUN wget -O - ${QATZIP_REPO} | tar xz && \
    cd QATzip* && \
    ./configure --with-ICP_ROOT=/opt/intel/QAT --prefix=/opt/intel/qat-zip && \
    make -j8 && \
    make install && \
    (cd /opt/intel/qat-zip/lib64 && ln -s libqatzip.so libqatzip.so.1) && \
    tar cf - /opt/intel/qat-zip | (cd /home/build; tar xf -)
