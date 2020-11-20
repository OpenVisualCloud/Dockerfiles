divert(-1)
define(`OS_NAME',centos)
define(`OS_VERSION',8)

include(centos-repo.m4)
include(libogg.m4)
include(libvorbis.m4)
#ifelse(defn(`BUILD_MP3LAME'),`ON',`include(libmp3lame.m4)')
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libopus.m4)
include(libvpx.m4)
include(libx264.m4)
include(libx265.m4)
#include(dav1d.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
#include(svt-vp9.m4)
include(ffmpeg.m4)
divert(0)
PREAMBLE
FROM OS_NAME:OS_VERSION AS build

INSTALL_CENTOS_REPO(epel-release)
ENABLE_CENTOS_REPO(PowerTools)
INSTALL_CENTOS_RPMFUSION_REPO(OS_VERSION)
INSTALL_CENTOS_OKEY_REPO(OS_VERSION)

BUILD_ALL()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for FFMPEG CentOS 7"
LABEL Vendor="Intel Corporation"
WORKDIR /home

INSTALL_CENTOS_REPO(epel-release)
ENABLE_CENTOS_REPO(PowerTools)
INSTALL_CENTOS_RPMFUSION_REPO(OS_VERSION)
INSTALL_CENTOS_OKEY_REPO(OS_VERSION)

# Install
INSTALL_ALL(runtime,build)

