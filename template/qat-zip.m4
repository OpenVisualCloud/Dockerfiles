# Build QATZip
ARG QATZIP_VER=v1.0.1
ARG QATZIP_REPO=https://github.com/intel/QATzip/archive/${QATZIP_VER}.tar.gz

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${QATZIP_REPO} | tar xz && \
    cd QATzip* && \
    /bin/bash ./configure LDFLAGS="-Wl,-rpath=/opt/intel/QAT/build" --with-ICP_ROOT=/opt/intel/QAT --prefix=/opt/intel/QATzip && \
    make -j8 && \
    make install && \
    (cd /opt/intel/QATzip/lib64 && ln -s libqatzip.so libqatzip.so.1) && \
ifelse(index(DOCKER_IMAGE,-dev),-1,dnl
    rm -rf /opt/intel/QATzip/share/man && \
)dnl
    tar cf - /opt/intel/QATzip | (cd /home/build; tar xf -)
