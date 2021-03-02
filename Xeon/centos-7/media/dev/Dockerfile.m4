
include(begin.m4)
include(centos-repo.m4)
include(libogg.m4)
include(libvorbis.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libopus.m4)
include(libvpx.m4)
include(libaom.m4)
include(libx264.m4)
include(libx265.m4)
include(dav1d.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
include(svt-vp9.m4)
include(gst-core.m4)
include(gst-plugins-base.m4)
include(gst-plugins-good.m4)
include(gst-plugins-bad.m4)
include(gst-plugins-ugly.m4)
include(gst-libav.m4)
include(gst-svt.m4)
include(ffmpeg.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

INSTALL_CENTOS_REPO(epel-release centos-release-scl)
INSTALL_CENTOS_RPMFUSION_REPO(7)

BUILD_ALL()dnl
define(`CLEANUP_CC',no)dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the image for FFMPEG and Gstreamer application for media development on OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

INSTALL_CENTOS_REPO(epel-release)
INSTALL_CENTOS_RPMFUSION_REPO(7)

# Install
INSTALL_ALL(devel,build)dnl
