# Build DLDT-Inference Engine
ARG DLDT_VER=2018_R5
ARG DLDT_REPO=https://github.com/opencv/dldt.git
ARG DLDT_C_API_REPO=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/thirdparty/0001-Add-inference-engine-C-API.patch

ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q boost-devel glibc-static glibc-devel libstdc++-static libstdc++-devel libstdc++ libgcc libusbx-devel openblas-devel;
)dnl

RUN git clone -b ${DLDT_VER} ${DLDT_REPO} && \
    cd dldt && \
    git submodule init && \
    git submodule update --recursive && \
    cd inference-engine && \
    wget -O - ${DLDT_C_API_REPO} | patch -p2 && \
    mkdir build && \
    cd build && \
    cmake ifelse(index(BUILD_LINKAGE,static),-1,,-DBUILD_SHARED_LIBS=OFF) -DCMAKE_INSTALL_PREFIX=/opt/intel/dldt -DLIB_INSTALL_PATH=/opt/intel/dldt -DENABLE_MKL_DNN=ON -DENABLE_CLDNN=ifelse(index(DOCKER_IMAGE,xeon-),-1,ON,OFF) -DENABLE_SAMPLE_CORE=OFF  .. && \
    make -j $(nproc) && \
    rm -rf ../bin/intel64/Release/lib/libgtest* && \
    rm -rf ../bin/intel64/Release/lib/libgmock* && \
    rm -rf ../bin/intel64/Release/lib/libmock* && \
    rm -rf ../bin/intel64/Release/lib/libtest*

ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
    ARG libdir=/opt/intel/dldt/inference-engine/lib/ubuntu_16.04/intel64
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
    ARG libdir=/opt/intel/dldt/inference-engine/lib/ubuntu_18.04/intel64
    #RUN find dldt/inference-engine/cmake/share/ -type f | xargs sed -i 's/16.04/18.04/g'
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
    ARG libdir=/opt/intel/dldt/inference-engine/lib/centos_7.4/intel64
)dnl

RUN mkdir -p /opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
    mkdir -p ${libdir} && \
    cp -r dldt/inference-engine/bin/intel64/Release/lib/* ${libdir} && \
    mkdir -p /opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
    mkdir -p /opt/intel/dldt/inference-engine/share && \
    cp -r dldt/inference-engine/build/share/* /opt/intel/dldt/inference-engine/share/ && \
    mkdir -p /opt/intel/dldt/inference-engine/external/omp/lib && \
    cp -r dldt/inference-engine/temp/omp/lib/* /opt/intel/dldt/inference-engine/external/omp/lib/

RUN mkdir -p build/opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* build/opt/intel/dldt/inference-engine/include && \
    mkdir -p build${libdir} && \
    cp -r dldt/inference-engine/bin/intel64/Release/lib/* build${libdir} && \
    mkdir -p build/opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* build/opt/intel/dldt/inference-engine/src/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/share && \
    cp -r dldt/inference-engine/build/share/* build/opt/intel/dldt/inference-engine/share/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/external/omp/lib && \
    cp -r dldt/inference-engine/temp/omp/lib/* build/opt/intel/dldt/inference-engine/external/omp/lib/

RUN for p in /opt/intel/dldt/inference-engine /home/build/opt/intel/dldt/inference-engine; do \
        mkdir -p "${libdir}/pkgconfig" && \
        pc="${libdir}/pkgconfig/dldt.pc" && \
        echo "prefix=/opt" > "$pc" && \
        echo "libdir=${libdir}" >> "$pc" && \
        echo "includedir=/opt/intel/dldt/inference-engine/include" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Name: DLDT" >> "$pc" && \
        echo "Description: Intel Deep Learning Deployment Toolkit" >> "$pc" && \
        echo "Version: 5.0" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Libs: -L\${libdir} -linference_engine -linference_engine_c_wrapper" >> "$pc" && \
        echo "Cflags: -I\${includedir}" >> "$pc"; \
    done;
define(`FFMPEG_CONFIG_DLDT_IE',--enable-libinference_engine )dnl

ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/omp/lib:${libdir}

#install Model Optimizer in the DLDT for Dev
ifelse(index(DOCKER_IMAGE,-dev),-1,,
ARG PYTHON_TRUSTED_HOST
ARG PYTHON_TRUSTED_INDEX_URL
#install MO dependencies
ifelse(index(DOCKER_IMAGE,ubuntu),-1,
RUN yum install -y python36
RUN yum install -y python36-devel
RUN yum install -y python36-setuptools
RUN easy_install-3.6 pip
,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends python3-dev python3-pip python3-setuptools python3-wheel
)dnl
#RUN pip3 install numpy scipy
RUN git clone https://github.com/google/protobuf.git && \
    cd protobuf && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    make install DESTDIR=/home/build
#RUN apt-get update && apt-get install -y sudo
#installing dependency libs to mo_libs directory to avoid issues with updates to Python version
RUN cd dldt/model-optimizer && \
if [ "x$PYTHON_TRUSTED_HOST" = "x" ] ; \
then pip3 install --target=/home/build/mo_libs -r requirements.txt && \
pip3 install -r requirements.txt; \
else pip3 install --target=/home/build/mo_libs -r requirements.txt -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install -r requirements.txt -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST; \
fi

#Copy over Model Optimizer to same directory as Inference Engine
RUN cp -r dldt/model-optimizer /opt/intel/dldt/model-optimizer
RUN cp -r dldt/model-optimizer /home/build/opt/intel/dldt/model-optimizer
)dnl

define(`INSTALL_PKGS_MO',ifelse(index(DOCKER_IMAGE,ubuntu),-1,python36 , python3 ))dnl

define(`INSTALL_MO',dnl
ifelse(index(DOCKER_IMAGE,dev),-1,,
ENV PYTHONPATH=${PYTHONPATH}:/mo_libs
)dnl
)dnl

define(`INSTALL_IE',dnl
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
ARG libdir=/opt/intel/dldt/inference-engine/lib/ubuntu_16.04/intel64
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
ARG libdir=/opt/intel/dldt/inference-engine/lib/ubuntu_18.04/intel64
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
ARG libdir=/opt/intel/dldt/inference-engine/lib/centos_7.4/intel64
)dnl
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
)dnl
