# Fetch transform360
ARG TRANSFORM360_VER=280ccf7
ARG TRANSFORM360_REPO=https://github.com/facebook/transform360

ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libopencv-dev
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime; \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libopencv-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q opencv-devel
)dnl
RUN git clone ${TRANSFORM360_REPO} && \
    cd transform360/Transform360 && \
    git checkout ${TRANSFORM360_VER} && \
    sed -i "s/STATIC//" CMakeLists.txt && \
    sed -i "s/DESTINATION lib/DESTINATION \${LIB_INSTALL_DIR}/g" CMakeLists.txt;
define(`FFMPEG_SOURCE_TRANSFORM360',dnl
# Build transform360
RUN cd /home/transform360/Transform360 && \
    cmake -DBUILD_SHARED_LIBS=ifelse(BUILD_LINKAGE,shared,ON,OFF) -DCMAKE_INSTALL_PREFIX=/usr/local -DLIB_INSTALL_DIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) . && \
    make -j8 && \
    make install DESTDIR="/home/build" && \
    make install

# Patch FFmpeg source for transform360
RUN cd /home/FFmpeg/libavfilter && \
    cp /home/transform360/Transform360/vf_transform360.c . && \
    sed -i "s/transform360\/VideoFrameTransformHandler.h/Transform360\/Library\/VideoFrameTransformHandler.h/" vf_transform360.c && \
    sed -i "s/transform360\/VideoFrameTransformHelper.h/Transform360\/Library\/VideoFrameTransformHelper.h/" vf_transform360.c && \
    sed -i "s/.*multimedia filters.*/extern AVFilter ff_vf_transform360;/" allfilters.c; \
    sed -i "s/.*video filters.*/OBJS-\$(CONFIG_TRANSFORM360_FILTER) += vf_transform360.o/" Makefile;

)dnl
define(`FFMPEG_CONFIG_TRANSFORM360',--extra-libs="-lTransform360 -lstdc++ ifelse(BUILD_LINKAGE,static,$(pkg-config --libs opencv))" )dnl
define(`INSTALL_PKGS_TRANSFORM360',ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,opencv glib2 ,libopencv-imgproc3.2 ),libopencv-imgproc2.4v5 ))dnl
