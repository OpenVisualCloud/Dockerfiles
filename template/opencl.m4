#install OpenCL

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN mkdir neo

RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/20.52.18783/intel-gmmlib_20.3.2_amd64.deb
RUN cd neo && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.5884/intel-igc-core_1.0.5884_amd64.deb
RUN cd neo && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.5884/intel-igc-opencl_1.0.5884_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/20.52.18783/intel-opencl_20.52.18783_amd64.deb

RUN cd neo && \
    dpkg -i ./*.deb && \
    dpkg-deb -x intel-gmmlib_20.3.2_amd64.deb /home/build/ && \
    dpkg-deb -x intel-igc-core_1.0.5884_amd64.deb /home/build/ && \
    dpkg-deb -x intel-igc-opencl_1.0.5884_amd64.deb /home/build/ && \
    dpkg-deb -x intel-opencl_20.52.18783_amd64.deb /home/build/
)dnl

ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q dnf dnf-plugins-core
RUN yum install -y yum-plugin-copr
RUN yum copr enable -y jdanecki/intel-opencl
RUN yum install -y intel-opencl
RUN yum install -y ocl-icd libgomp
)dnl

#clinfo needs to be installed after build directory is copied over
define(`INSTALL_OPENCL',dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN apt-get update && apt-get install -y --no-install-recommends clinfo && \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q dnf dnf-plugins-core yum-plugin-copr
RUN yum copr enable -y jdanecki/intel-opencl
RUN yum install -y intel-opencl
RUN yum install -y ocl-icd libgomp
RUN ln -s /usr/lib64/libOpenCL.so.1 /usr/lib/libOpenCL.so
)dnl
)dnl
