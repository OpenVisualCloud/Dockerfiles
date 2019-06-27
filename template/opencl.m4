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

ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum groups install -y "Development Tools"
RUN yum install -y centos-release-scl epel-release
RUN yum install -y devtoolset-4-gcc-c++ ninja-build

RUN cd gmmlib && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DARCH=64 .. && \
    make -j8

RUN mkdir build_igc && \
    cd build_igc && \
    git clone https://github.com/intel/intel-graphics-compiler igc && \
    git clone https://github.com/intel/llvm-patches llvm_patches && \
    git clone -b master https://github.com/llvm-mirror/llvm llvm_source && \
    cd llvm_source && \
    git checkout 541ca56bcf2 && \
    cd .. && \
    git clone -b master https://github.com/llvm-mirror/clang llvm_source/tools/clang && \
    git clone -b master https://github.com/intel/opencl-clang llvm_source/projects/opencl-clang && \
    git clone -b master https://github.com/KhronosGroup/SPIRV-LLVM-Translator llvm_source/projects/llvm-spirv && \
    cd llvm_source/tools/clang && \
    git checkout 203bf9fe94 && \
    cd ../../projects/llvm-spirv && \
    git checkout 365675f && \
    cd ../opencl-clang && \
    git checkout faa242c && \
    cd ../../../llvm_patches && \
    git checkout cac8d77 && \
    cd ../igc && \
    git checkout 8cb64241

RUN export CXX=/opt/rh/devtoolset-7/root/usr/bin/g++ && \
    export CC=/opt/rh/devtoolset-7/root/usr/bin/gcc && \
    cd build_igc && \
    mkdir build && \
    cd build && \
    cmake -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=true ../igc/IGC && \
    make -j8 && \
    make install

RUN mkdir build_compute_runtime && \
    git clone https://github.com/intel/compute-runtime neo && \
    cd neo && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_TYPE=Release -DCMAKE_BUILD_TYPE=Release .. && \
    make -j8
)dnl


#clinfo needs to be installed after build directory is copied over
define(`INSTALL_OPENCL',dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN apt-get update && apt-get install -y clinfo
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q dnf dnf-plugins-core yum-plugin-copr
RUN yum copr enable -y arturh/intel-opencl
RUN yum install -y -q intel-opencl
RUN yum install -y epel-release
RUN yum install -y ocl-icd libgomp
RUN ln -s /usr/lib64/libOpenCL.so.1 /usr/lib/libOpenCL.so
)dnl
)dnl
