
include(begin.m4)
include(ubuntu.m4)
include(ispc.m4)
include(embree.m4)
include(ospray.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image ospray OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
UPGRADE_UBUNTU_COMPONENTS()
INSTALL_ALL(runtime,build)dnl


