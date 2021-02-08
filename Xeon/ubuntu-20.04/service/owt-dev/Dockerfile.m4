
include(begin.m4)
include(openssl.m4)
include(svt-hevc.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libvpx.m4)
include(libx264.m4)
include(opencv.m4)
include(ffmpeg.m4)
include(gst-core.m4)
include(owt-gst-base.m4)
include(owt-gst-good.m4)
include(owt-gst-bad.m4)
include(owt-gst-ugly.m4)
include(gst-libav.m4)
include(owt-gst-gva.m4)
include(owt.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION as build

BUILD_ALL()dnl
define(`CLEANUP_CC',no)dnl
CLEANUP(devel)dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the development image for the OWT service OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(devel,build)dnl

