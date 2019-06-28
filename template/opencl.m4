#install OpenCL

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN mkdir neo

RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-gmmlib_18.4.0.348_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-igc-core_18.50.1270_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-igc-opencl_18.50.1270_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-opencl_19.01.12103_amd64.deb

RUN cd neo && \
    dpkg -i *.deb && \
    dpkg-deb -x intel-gmmlib_18.4.0.348_amd64.deb /home/build/ && \
    dpkg-deb -x intel-igc-core_18.50.1270_amd64.deb /home/build/ && \
    dpkg-deb -x intel-igc-opencl_18.50.1270_amd64.deb /home/build/ && \
    dpkg-deb -x intel-opencl_19.01.12103_amd64.deb /home/build/
)dnl


#clinfo needs to be installed after build directory is copied over
define(`INSTALL_OPENCL',dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN apt-get update && apt-get install -y clinfo
)dnl
)dnl
