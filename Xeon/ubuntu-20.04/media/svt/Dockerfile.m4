
include(begin.m4)
include(ubuntu.m4)
include(libaom.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM openvisualcloud/xeon-ubuntu2004-media-ffmpeg:BUILD_VERSION
LABEL Description="This is the showcase image for SVT OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
UPGRADE_UBUNTU_COMPONENTS()
INSTALL_ALL(runtime,build)dnl
HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1