
include(begin.m4)
include(centos-repo.m4)
include(nginx-flv.m4)
include(nginx-upload.m4)
include(nginx.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

INSTALL_CENTOS_REPO(epel-release)
ENABLE_CENTOS_REPO(PowerTools)
INSTALL_CENTOS_RPMFUSION_REPO(OS_VERSION)
INSTALL_CENTOS_OKEY_REPO(OS_VERSION)
INSTALL_CENTOS_RAVEN_RELEASE_REPO(OS_VERSION)

BUILD_ALL()dnl
CLEANUP()dnl

FROM openvisualcloud/xeon-centos8-media-ffmpeg:latest
LABEL Description="This is the base image for NGINX+RTMP OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

INSTALL_CENTOS_REPO(epel-release)
ENABLE_CENTOS_REPO(PowerTools)
INSTALL_CENTOS_RPMFUSION_REPO(OS_VERSION)
INSTALL_CENTOS_OKEY_REPO(OS_VERSION)
INSTALL_CENTOS_RAVEN_RELEASE_REPO(OS_VERSION)

# Install
INSTALL_ALL(runtime,build)

