# Build DLDT-Inference Engine
ARG DLDT_VER=2020.2
ARG DLDT_REPO=https://github.com/opencv/dldt.git

ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q boost-devel glibc-static glibc-devel libstdc++-static libstdc++-devel libstdc++ libgcc libusbx-devel openblas-devel;
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get -y install libusb-1.0.0-dev python python-pip python-setuptools python-yaml
)dnl

RUN git clone -b ${DLDT_VER} ${DLDT_REPO} && \
    cd dldt && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    cmake ifelse(index(BUILD_LINKAGE,static),-1,,-DBUILD_SHARED_LIBS=OFF) -DCMAKE_INSTALL_PREFIX=/opt/intel/dldt -DLIB_INSTALL_PATH=/opt/intel/dldt -DENABLE_MKL_DNN=ON -DENABLE_CLDNN=ifelse(index(DOCKER_IMAGE,xeon-),-1,ON,OFF) -DENABLE_SAMPLES=OFF -DENABLE_OPENCV=OFF -DENABLE_TESTS=OFF -DENABLE_GNA=OFF -DENABLE_PROFILING_ITT=OFF -DENABLE_SAMPLES_CORE=OFF -DENABLE_SEGMENTATION_TESTS=OFF -DENABLE_OBJECT_DETECTION_TESTS=OFF -DBUILD_TESTS=OFF -DNGRAPH_UNIT_TEST_ENABLE=OFF -DNGRAPH_TEST_UTIL_ENABLE=OFF .. && \
    make -j $(nproc) && \
    rm -rf ../bin/intel64/Release/lib/libgtest* && \
    rm -rf ../bin/intel64/Release/lib/libgmock* && \
    rm -rf ../bin/intel64/Release/lib/libmock* && \
    rm -rf ../bin/intel64/Release/lib/libtest*

ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64

RUN mkdir -p /opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/ie_bridges/c/include/* /opt/intel/dldt/inference-engine/include && \
    mkdir -p ${libdir} && \
    cp -r dldt/bin/intel64/Release/lib/* ${libdir} && \
    mkdir -p /opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
    mkdir -p /opt/intel/dldt/inference-engine/share && \
    cp -r dldt/build/share/* /opt/intel/dldt/inference-engine/share/ && \
    mkdir -p /opt/intel/dldt/inference-engine/external/ && \
    cp -r dldt/inference-engine/temp/tbb /opt/intel/dldt/inference-engine/external/

RUN mkdir -p build/opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* build/opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/ie_bridges/c/include/* build/opt/intel/dldt/inference-engine/include && \
    mkdir -p build${libdir} && \
    cp -r dldt/bin/intel64/Release/lib/* build${libdir} && \
    mkdir -p build/opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* build/opt/intel/dldt/inference-engine/src/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/share && \
    cp -r dldt/build/share/* build/opt/intel/dldt/inference-engine/share/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/external/ && \
    cp -r dldt/inference-engine/temp/tbb build/opt/intel/dldt/inference-engine/external/

RUN for p in /usr /home/build/usr /opt/intel/dldt/inference-engine /home/build/opt/intel/dldt/inference-engine; do \
        pkgconfiglibdir="$p/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)" && \
        mkdir -p "${pkgconfiglibdir}/pkgconfig" && \
        pc="${pkgconfiglibdir}/pkgconfig/dldt.pc" && \
        echo "prefix=/opt" > "$pc" && \
        echo "libdir=${libdir}" >> "$pc" && \
        echo "includedir=/opt/intel/dldt/inference-engine/include" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Name: DLDT" >> "$pc" && \
        echo "Description: Intel Deep Learning Deployment Toolkit" >> "$pc" && \
        echo "Version: 5.0" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Libs: -L\${libdir} -linference_engine" >> "$pc" && \
        echo "Cflags: -I\${includedir}" >> "$pc"; \
    done;

ARG local_lib_path="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib)"
ENV PKG_CONFIG_PATH=${local_lib_path}/pkgconfig:$PKG_CONFIG_PATH
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}

define(`FFMPEG_EXTRA_CFLAGS_IE',-I/opt/intel/dldt/inference-engine/include )dnl
define(`FFMPEG_EXTRA_LDFLAGS_IE',-L/opt/intel/dldt/inference-engine/lib/intel64 )dnl
define(`FFMPEG_CONFIG_DLDT_IE',--enable-libinference_engine_c_api )dnl

#install Model Optimizer in the DLDT for Dev
ifelse(index(DOCKER_IMAGE,-dev),-1,,
ARG PYTHON_TRUSTED_HOST
ARG PYTHON_TRUSTED_INDEX_URL

#installing dependency libs to mo_libs directory to avoid issues with updates to Python version
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y python3-devel
)dnl
RUN cd dldt/model-optimizer && \
if [ "x$PYTHON_TRUSTED_HOST" = "x" ] ; \
ifelse(index(DOCKER_IMAGE,1604),-1,
then pip3 install --target=/home/build/mo_libs -r requirements.txt && \
pip3 install -r requirements.txt; \
else pip3 install --target=/home/build/mo_libs -r requirements.txt -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install -r requirements.txt -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST; \
fi
,dnl
then pip3 install -U pip && \
pip3 install --target=/home/build/mo_libs -U futures && \
pip3 install --target=/home/build/mo_libs --upgrade setuptools && \
pip3 install --target=/home/build/mo_libs -r requirements.txt && \
pip3 install -U futures && \
pip3 install --upgrade setuptools && \
pip3 install -r requirements.txt; \
else pip3 install -U pip -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install --target=/home/build/mo_libs -U futures -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install --target=/home/build/mo_libs --upgrade setuptools -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install --target=/home/build/mo_libs -r requirements.txt -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install -U futures -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install --upgrade setuptools -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST && \
pip3 install -r requirements.txt -i $PYTHON_TRUSTED_INDEX_URL --trusted-host $PYTHON_TRUSTED_HOST; \
fi
)dnl

#Copy over Model Optimizer to same directory as Inference Engine
RUN cp -r dldt/model-optimizer /opt/intel/dldt/model-optimizer
RUN cp -r dldt/model-optimizer /home/build/opt/intel/dldt/model-optimizer
)dnl

ifelse(index(DOCKER_IMAGE,-dev),-1,,
#install OpenVINO tools in the DLDT for Dev
RUN cd dldt/tools && \
    python3 -m pip install -r benchmark/requirements.txt

#Copy over Openvino tools to same directory as Inference Engine
RUN cp -r dldt/tools /opt/intel/dldt/tools
RUN cp -r dldt/tools /home/build/opt/intel/dldt/tools

#install model downloader for dev images
ARG OPEN_MODEL_ZOO_VER=2020.1
ARG OPEN_MODEL_ZOO_REPO=https://github.com/opencv/open_model_zoo/archive/${OPEN_MODEL_ZOO_VER}.tar.gz
RUN wget -O - ${OPEN_MODEL_ZOO_REPO} | tar xz && \
    mkdir -p /opt/intel/dldt/open_model_zoo && \
    cp -r open_model_zoo-${OPEN_MODEL_ZOO_VER}/* /opt/intel/dldt/open_model_zoo/. && \
    mkdir -p /home/build/opt/intel/dldt/open_model_zoo && \
    cp -r open_model_zoo-${OPEN_MODEL_ZOO_VER}/* /home/build/opt/intel/dldt/open_model_zoo/. && \
    python3 -m pip install pyyaml 
)dnl
define(`INSTALL_MO',dnl
ifelse(index(DOCKER_IMAGE,dev),-1,,
ENV PYTHONPATH=${PYTHONPATH}:/mo_libs
)dnl
)dnl

define(`INSTALL_IE',dnl
ARG local_lib_path="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib)"
ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64
ENV PKG_CONFIG_PATH=${local_lib_path}/pkgconfig:$PKG_CONFIG_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ifelse(index(DOCKER_IMAGE,-dev),-1,,dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q python3-pip;
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get -y install python3-pip
)dnl
RUN python3 -m pip install pyyaml
)dnl
)dnl
