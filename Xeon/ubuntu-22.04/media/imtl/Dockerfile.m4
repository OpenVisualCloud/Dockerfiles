
include(begin.m4)
include(ubuntu.m4)
include(dpdk.m4)
include(imtl.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for IMTL OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
UPGRADE_UBUNTU_COMPONENTS()
INSTALL_ALL(runtime,build)dnl
HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1