# load qat
ADD qat.tar.gz /home/build/
RUN mkdir -p /opt/intel /home/build/opt/intel && \
    ln -s /home/build/opt/intel/QAT /opt/intel/QAT

define(`INSTALL_QAT',dnl
# setup the qat group
ARG QAT_GID_VER
RUN groupadd -g ${QAT_GID_VER} qat
)dnl
