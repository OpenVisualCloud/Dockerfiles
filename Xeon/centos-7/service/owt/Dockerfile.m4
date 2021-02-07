

include(begin.m4)
include(openssl.m4)
include(svt-hevc.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libvpx.m4)
include(opencv.m4)
include(ffmpeg.m4)
include(gst-core.m4)
include(gst-plugins-base.m4)
include(gst-plugins-good.m4)
include(gst-plugins-bad.m4)
include(gst-gva.m4)
include(owt.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION as build
include(centos-repo.m4)
INSTALL_CENTOS_REPO(epel-release centos-release-scl)

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for the OWT service OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_CENTOS_REPO(epel-release)
INSTALL_ALL(runtime,build)

