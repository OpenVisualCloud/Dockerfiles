
include(begin.m4)
include(ubuntu.m4)
include(ispc.m4)
include(embree.m4)
include(oiio.m4)
include(ospray-mpi.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for ospray-oiio-mpi OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(runtime,build)dnl


