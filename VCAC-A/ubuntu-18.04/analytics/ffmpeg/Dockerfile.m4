include(begin.m4)
include(ubuntu.m4)
include(cmake.m4)
include(libogg.m4)
include(libvorbis.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libopus.m4)
include(libvpx.m4)
include(libx264.m4)
include(libx265.m4)
include(meson.m4)
include(dav1d.m4)
include(gmmlib.m4)
include(libva2.m4)
include(opencl.m4)
include(media-driver.m4)
include(msdk.m4)
include(openvino.binary.m4)
include(libjsonc.m4)
include(librdkafka.m4)
include(opencv.m4)
include(ffmpeg.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for FFMPEG OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
UPGRADE_UBUNTU_COMPONENTS()
INSTALL_ALL(runtime,build)dnl

