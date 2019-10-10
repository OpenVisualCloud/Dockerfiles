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

RUN yum install -y devtoolset-6-gcc devtoolset-6-gcc-c++ opencl-headers
ARG CLANG_VERSION=4.0.1

RUN source /opt/rh/devtoolset-6/enable && \
    wget http://releases.llvm.org/${CLANG_VERSION}/llvm-${CLANG_VERSION}.src.tar.xz && \
    wget http://releases.llvm.org/${CLANG_VERSION}/cfe-${CLANG_VERSION}.src.tar.xz && \
    wget http://releases.llvm.org/${CLANG_VERSION}/clang-tools-extra-${CLANG_VERSION}.src.tar.xz && \
    wget http://releases.llvm.org/${CLANG_VERSION}/compiler-rt-${CLANG_VERSION}.src.tar.xz && \
    xz -d llvm-${CLANG_VERSION}.src.tar.xz && \
    tar xvf llvm-${CLANG_VERSION}.src.tar && \
    xz -d cfe-${CLANG_VERSION}.src.tar.xz && \
    tar xvf cfe-${CLANG_VERSION}.src.tar && \
    xz -d clang-tools-extra-${CLANG_VERSION}.src.tar.xz && \
    tar xvf clang-tools-extra-${CLANG_VERSION}.src.tar && \
    xz -d compiler-rt-${CLANG_VERSION}.src.tar.xz && \
    tar xvf compiler-rt-${CLANG_VERSION}.src.tar && \
    cd llvm-${CLANG_VERSION}.src && \
    mv ../cfe-${CLANG_VERSION}.src tools/clang && \
    mv ../clang-tools-extra-${CLANG_VERSION}.src tools/clang/extra && \
    mv ../compiler-rt-${CLANG_VERSION}.src projects/compiler-rt && \
    mkdir build && \
    cd build && \
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=On .. && \
    make -j$(nproc)  && \
    make install

#install OpenCL
RUN yum install -y centos-release-scl epel-release

RUN yum -y -q install yum install libcxx
RUN yum -y -q install yum install libcxx-devel devtoolset-4-gcc-c++ devtoolset-4-gcc

RUN cd gmmlib && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DARCH=64 .. && \
    make -j$(nproc)

RUN mkdir build_igc && \
    cd build_igc && \
    git clone https://github.com/intel/intel-graphics-compiler igc && \
    cd igc && \
    git checkout de3d1de && \
    cd .. && \

    git clone https://github.com/intel/llvm-patches llvm_patches && \
    cd llvm_patches && \
    git checkout 96d382b && \
    cd .. && \

    git clone -b release_40 https://github.com/llvm-mirror/llvm llvm_source && \
    git clone -b release_40 https://github.com/llvm-mirror/clang clang_source && \

    git clone -b master https://github.com/intel/opencl-clang common_clang && \
    cd common_clang && \
    git checkout 8248120 && \
    cd .. && \

    git clone https://github.com/KhronosGroup/OpenCL-Headers opencl_headers && \
    cd opencl_headers && \
    git checkout f039db6

RUN cd build_igc && \
    mkdir build && \
    cd build && \
    scl enable devtoolset-4 "cmake -DIGC_OPTION__OUTPUT_DIR=../igc-install/Release -DCMAKE_BUILD_TYPE=Release -DIGC_OPTION__ARCHITECTURE_TARGET=Linux64 ../igc/IGC" | tee cmake_output.log && \
    yum install -y rpm rpm-libs rpm-build rpm-build-libs && \
    scl enable devtoolset-4 "make -j$(nproc) package" | tee make_output.log && \
    rpm -ivh intel-igc-core-0.1-0.x86_64.rpm intel-igc-media-0.1-0.x86_64.rpm intel-igc-opencl-devel-0.1-0.x86_64.rpm intel-igc-opencl-0.1-0.x86_64.rpm && \
    ldconfig

RUN git clone https://github.com/intel/compute-runtime neo && \
    cd neo && \
    git checkout 18.41.11649 && \
    mkdir build && \
    cd build && \
    scl enable devtoolset-4 "PKG_CONFIG_PATH=/usr/lib/pkgconfig/ cmake -DCMAKE_BUILD_TYPE=Release .." && \
    scl enable devtoolset-4 "make -j$(nproc) package" && \
    rpm -ivh intel-opencl-18.41-0.x86_64-igdrcl.rpm 

RUN yum install -y ocl-icd-devel
)dnl

#clinfo needs to be installed after build directory is copied over
define(`INSTALL_OPENCL',dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN apt-get update && apt-get install -y clinfo
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
COPY --from=build /home/neo/build/intel-opencl-18.41-0.x86_64-igdrcl.rpm /home/
RUN rpm -ivh intel-opencl-18.41-0.x86_64-igdrcl.rpm && \
    yum install -y epel-release && \
    yum install -y ocl-icd-devel
)dnl
)dnl
